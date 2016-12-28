
#import "XZData.h"

#ifdef DEBUG
#define debugLog(...)    NSLog(__VA_ARGS__)
#define debugMethod()    NSLog(@"%s", __func__)
#define debugError()     NSLog(@"Error at %s Line:%d", __func__, __LINE__)
#else
#define debugLog(...)
#define debugMethod()
#define debugError()
#endif

#define XZApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define PATH_OF_DOCUMENT    [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]


@implementation XZdbObj

- (NSString *)description {
    return [NSString stringWithFormat:@"id=%@, value=%@, timeStamp=%@", _Id, _Obj, _Date];
}

@end

@implementation XZData

static NSString *const CREATE_TABLE_SQL =
@"CREATE TABLE IF NOT EXISTS %@ ( \
id TEXT NOT NULL, \
json TEXT NOT NULL, \
createdTime TEXT NOT NULL, \
PRIMARY KEY(id)) \
";

static NSString *const UPDATE_ITEM_SQL = @"REPLACE INTO %@ (id, json, createdTime) values (?, ?, ?)";
static NSString *const QUERY_ITEM_SQL = @"SELECT json, createdTime from %@ where id = ? Limit 1";
static NSString *const SELECT_ALL_SQL = @"SELECT * from %@";
static NSString *const CLEAR_ALL_SQL = @"DELETE from %@";
static NSString *const DELETE_ITEM_SQL = @"DELETE from %@ where id = ?";
static NSString *const DELETE_ITEMS_SQL = @"DELETE from %@ where id in ( %@ )";
static NSString *const DELETE_ITEMS_WITH_PREFIX_SQL = @"DELETE from %@ where id like ? ";

+ (id)allocWithZone:(struct _NSZone *)zone{
    static XZData *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });
    return instance;
}

+ (instancetype)shareData{
    return [[self alloc] init];
}

- (instancetype)init {
    if (self = [super init]) {
    [self dbQueue];
    }
    return self;
}

#pragma mark - Create

//根据 用户id 创建属于自己的数据库
-(FMDatabaseQueue*)dbQueue{
    if (_dbQueue == nil) {
//        if (XZApp.UserInfo.userId.length == 0) {
//            return nil;
//        }
//        NSString * dbPath = [PATH_OF_DOCUMENT stringByAppendingPathComponent:[NSString stringWithFormat:@"XZDb_%@.db",XZApp.UserInfo.userId]];
//        _dbQueue = [FMDatabaseQueue databaseQueueWithPath:dbPath];
//        NSLog(@"\n🔵 数据库路径\n%@\n💚",dbPath);
    }
    return _dbQueue;
}

//关闭数据库 用于用户退出登录后
- (void)dbclose {
    [_dbQueue close];
    _dbQueue = nil;
}

/** 在已创建在沙盒中的.db文件上 添加表*/
-(void)CreateTable:(NSString *)tableName{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:(([NSString stringWithFormat:CREATE_TABLE_SQL, tableName]))];
    }];
}

#pragma mark - Save

/** 整存 对应table里的主键id*/
-(void)Save:(id)obj Id:(NSString *)Id Table:(NSString *)tableName{
    if (obj == nil || ![NSJSONSerialization isValidJSONObject:obj] || Id.length == 0) {
        return;
    }
    if (tableName.length == 0) {
        tableName = T_XZdbDefaultT;
    }
    NSError * error;
    NSData * data = [NSJSONSerialization dataWithJSONObject:obj options:0 error:&error];
    if (error) {
        return;
    }
    NSString * jsonString = [[NSString alloc] initWithData:data encoding:(NSUTF8StringEncoding)];
    NSDate * createdTime = [NSDate date];
    NSString * sql = [NSString stringWithFormat:UPDATE_ITEM_SQL, tableName];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        [db executeUpdate:sql, Id, jsonString, createdTime];
    }];

}

/** 整存 对应table里的主键id 默认表：T_XZdbDefaultT*/
-(void)Save:(id)obj Id:(NSString *)Id{
    [self Save:obj Id:Id Table:T_XZdbDefaultT];
}

#pragma mark - Get

/** 根据id取  */
-(id)Get:(NSString *)Id Table:(NSString *)tableName{
    return [self GetXZObj:Id Table:tableName].Obj;
}
-(id)Get:(NSString *)Id{
    return [self Get:Id Table:T_XZdbDefaultT];
}

/** 根据id取XZdbObj  默认表：T_XZdbDefaultT*/
-(XZdbObj*)GetXZObj:(NSString *)Id Table:(NSString *)tableName{
    __block NSString * json = nil;
    __block NSDate * createdTime = nil;
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:[NSString stringWithFormat:QUERY_ITEM_SQL, tableName], Id];
        if ([rs next]) {
            json = [rs stringForColumn:@"json"];
            createdTime = [rs dateForColumn:@"createdTime"];
        }
        [rs close];
    }];
    if (json) {
        NSError * error;
        id result = [NSJSONSerialization JSONObjectWithData:[json dataUsingEncoding:NSUTF8StringEncoding]
                                                    options:(NSJSONReadingMutableContainers) error:&error];
        if (error) {
            return nil;
        }
        XZdbObj *XZObj = [[XZdbObj alloc] init];
        XZObj.Id = Id;
        XZObj.Obj = result;
        XZObj.Date = createdTime;
        return XZObj;
    } else {
        return nil;
    }

}

-(XZdbObj*)GetXZObj:(NSString *)Id{
    return [self GetXZObj:Id Table:T_XZdbDefaultT];
}

/** 获取该表所有*/
-(NSMutableArray*)AllObj:(NSString *)tableName{
    return [self AllItem:tableName XZObj:NO];
}
-(NSMutableArray*)AllXZObj:(NSString *)tableName{
     return [self AllItem:tableName XZObj:YES];
}

- (NSMutableArray *)AllItem:(NSString *)tableName XZObj:(BOOL)XZObj{
    __block NSMutableArray * result = [NSMutableArray array];
    [_dbQueue inDatabase:^(FMDatabase *db) {
        FMResultSet * rs = [db executeQuery:[NSString stringWithFormat:SELECT_ALL_SQL, tableName]];
        while ([rs next]) {
            if (!XZObj) {
                id obXZct = [NSJSONSerialization JSONObjectWithData:[[rs stringForColumn:@"json"] dataUsingEncoding:NSUTF8StringEncoding]
                                                            options:(NSJSONReadingMutableContainers) error:NULL];
                [result addObject:obXZct];
            }else{
                XZdbObj * item = [[XZdbObj alloc] init];
                item.Id = [rs stringForColumn:@"id"];
                item.Obj = [rs stringForColumn:@"json"];
                item.Date = [rs dateForColumn:@"createdTime"];
                [result addObject:item];
            }
        }
        [rs close];
    }];
    return result;
}

-(void)Delete:(NSString *)Id T_Name:(NSString *)tableName{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        debugLog(@"删除 %d",[db executeUpdate:[NSString stringWithFormat:DELETE_ITEM_SQL, tableName], Id]);
    }];
    
}

-(void)Delete:(NSString *)Id{
    [self Delete:Id T_Name:T_XZdbDefaultT];
}

-(void)clearTable:(NSString *)tableName{
    [_dbQueue inDatabase:^(FMDatabase *db) {
        debugLog(@"清除 %d",[db executeUpdate:[NSString stringWithFormat:CLEAR_ALL_SQL, tableName]]);
    }];
}

- (void)deleteObXZctsByIdArray:(NSArray *)obXZctIdArray fromTable:(NSString *)tableName {
    NSMutableString *stringBuilder = [NSMutableString string];
    for (id obXZctId in obXZctIdArray) {
        NSString *item = [NSString stringWithFormat:@" '%@' ", obXZctId];
        if (stringBuilder.length == 0) { [stringBuilder appendString:item];
        } else {
        [stringBuilder appendString:@","]; [stringBuilder appendString:item];
        }
    }
    [_dbQueue inDatabase:^(FMDatabase *db) {
        debugLog(@"删除 %d",[db executeUpdate:[NSString stringWithFormat:DELETE_ITEMS_SQL, tableName, stringBuilder]]);
    }];
}

- (void)deleteObXZctsByIdPrefix:(NSString *)obXZctIdPrefix fromTable:(NSString *)tableName {
    [_dbQueue inDatabase:^(FMDatabase *db) {
        debugLog(@"删除 %d",[db executeUpdate:[NSString stringWithFormat:DELETE_ITEMS_WITH_PREFIX_SQL, tableName], [NSString stringWithFormat:@"%@%%", obXZctIdPrefix]]);
    }];
}




@end
