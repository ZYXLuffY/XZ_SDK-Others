
#import "XZDebugTool__.h"
#import "AppDelegate.h"
#import "UIView+XZ.h"
#import "XZUtility.h"
#import "UITableView+FDTemplateLayoutCell.h"
#import "XZPutDownMenuView.h"
#import "MJExtension.h"
//#import "UIDevice+YYAdd.h"
#import "QTZ_AlertView.h"


@interface M_XZDebugTool : NSObject
@property (nonatomic,copy) NSString *indexTime;/**< 请求时间 */
@property (nonatomic,copy) NSString *API;/**< 请求地址 */
@property (nonatomic,copy) NSString *param;/**< 请求参数 */
@property (nonatomic,copy) NSString *des;/**< 原始请求结果   */
@end

@implementation M_XZDebugTool

@end

#pragma mark -

@interface XZDebugTool__Cell : UITableViewCell
@property (nonatomic,strong) UILabel  *La_index;/**< 请求时间 1 2 3 4  */
@property (nonatomic,strong) UILabel  *La_API;/**< 请求地址 */
@property (nonatomic,strong) UILabel  *La_param;/**< 请求参数 */
@property (nonatomic,strong) UILabel  *La_des;/**< 显示结果 过多显示。。。。。。。。 */
@property (nonatomic,strong) M_XZDebugTool *Mod;
@end

@implementation XZDebugTool__Cell

-(void)setMod:(M_XZDebugTool *)Mod{
    _Mod = Mod;
    self.La_index.text = Mod.indexTime;
    self.La_API.text = _Mod.API;
    self.La_param.text = _Mod.param;
    self.La_des.text  = _Mod.des;
    
    _La_API.height = [_La_API sizeThatFits:CGSizeMake(_La_API.width, 0)].height;
    _La_param.y = _La_API.bottom + 2 ;
    
    _La_param.height = [_La_param sizeThatFits:CGSizeMake(_La_param.width, 0)].height;
    _La_des.y = _La_param.bottom + 2;
    
    _La_des.height = [_La_des sizeThatFits:CGSizeMake(_La_des.width, 0)].height;
    
}

-(UILabel *)La_index{
    if (_La_index == nil) {
        [self.contentView addSubview:_La_index = [UILabel Frame:CGRectMake(0, 8, self.width, 20) Title:@"" FontS:20 Color:HexColorA(0xDC3023, 1) Alignment:NSTextAlignmentCenter]];
        _La_index.adjustsFontSizeToFitWidth = YES;
    }
    return _La_index;
}

-(UILabel *)La_API{
    if (_La_API == nil) {
        [self.contentView addSubview:_La_API = [UILabel Frame:CGRectMake(8, _La_index.bottom + 8, self.width - 16, 0) Title:@"" FontS:13 Color:HexColor(0xE29C45) Alignment:NSTextAlignmentLeft]];
    }
    return _La_API;
}

-(UILabel *)La_param{
    if (_La_param == nil) {
        [self.contentView addSubview:_La_param = [UILabel Frame:CGRectMake(_La_API.x, _La_API.bottom, _La_API.width, 0) Title:@"" FontS:13 Color:HexColor(0x0C8918) Alignment:NSTextAlignmentLeft]];
    }
    return _La_param;
}

-(UILabel *)La_des{
    if (_La_des == nil) {
        [self.contentView addSubview:_La_des = [UILabel Frame:CGRectMake(8, _La_param.bottom, _La_API.width,0) Title:@"" FontS:11 Color:nil Alignment:NSTextAlignmentLeft]];
    }
    return _La_des;
}

-(CGSize)sizeThatFits:(CGSize)size{
    return CGSizeMake(size.width, 60 + [_La_API sizeThatFits:CGSizeMake(_La_API.width, 0)].height + [_La_param sizeThatFits:CGSizeMake(_La_param.width, 0)].height + [_La_des sizeThatFits:CGSizeMake(_La_des.width, 0)].height);
}

@end



#pragma mark -

@interface XZDebugTool__ ()<UITableViewDelegate,UITableViewDataSource>
{
    UITableView *Tv_1;
    NSInteger startIndex;
}

@property (nonatomic,strong) NSMutableArray *Arr_List;
@property (nonatomic,copy) NSString *Str_BeginTime;

@end

@implementation XZDebugTool__

+ (id)allocWithZone:(struct _NSZone *)zone{
    static XZDebugTool__* sharedManager;
    
#ifdef DEBUG
    static dispatch_once_t onceToken;
//    if ([UIDevice currentDevice].isSimulator) {
//        return nil;
//    }
    dispatch_once(&onceToken, ^{
        
        sharedManager = [super allocWithZone:zone];
        sharedManager.Str_BeginTime = [NSDate date].XZ_YYYYMMddHHmmss;
        sharedManager.Arr_List = [NSMutableArray array];
        [sharedManager setupDatabase];
        [sharedManager loadDebugView];
        //        [[FLEXManager sharedManager] showExplorer];
    });
#endif
    
    return sharedManager;
}

+ (instancetype)Shared{
#ifdef DEBUG
    return [[self alloc] init];
#endif
    return  nil;
}

- (instancetype)init{
    if (self = [super init]) {}
    return self;
}

#pragma mark - 数据库
- (void)setupDatabase{
    [XZdbQu inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"CREATE  TABLE IF NOT EXISTS 'M_XZDebugTool_TimeList' ('time' VARCHAR PRIMARY KEY)"];//时间列表
        [db executeUpdate:@"CREATE  TABLE IF NOT EXISTS 'M_XZDebugTool_data' ('TimeList' VARCHAR,'indexTime' VARCHAR,'API' TEXT,'param' TEXT,'des' TEXT)"];//具体数据
    }];
    //运行一次 添加一个时间
    [XZdbQu inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"REPLACE INTO M_XZDebugTool_TimeList (time) VALUES (?)",self.Str_BeginTime];
    }];
}

- (void)loadDebugView{
    if (XZApp.UserInfo == nil) {_Ve_Main.hidden = YES;return;}
    startIndex = 0;
    
    delay(0.5, ^{
        [XZApp.window addSubview:_Ve_Main = ({
            UIView *_ = [[UIView alloc]initWithFrame:CGRectMake(0, 20, ScreenWidth, ScreenHeight - 20)];
            _.backgroundColor = [UIColor whiteColor];
            _.alpha = 0.9;
            _.layer.masksToBounds = YES;_.hidden = YES;
            _;
        })];
        
        NSArray *arrTitle = @[@"历史记录",[NSString stringWithFormat:@"🔵%@：%@",(XZApp.___test___UserId.length != 0 ? @"测试" : @""),XZApp.UserInfo.userId]];
        [arrTitle enumerateObjectsUsingBlock:^(NSString  *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            UIButton *btn = [UIButton Frame:CGRectMake(idx*(ScreenWidth/arrTitle.count), 0, (ScreenWidth/arrTitle.count), 40) Title:obj FontS:14 Color:HexColorA(0x065279, 1) radius:4 Target:self action:@selector(actionHandle:) Bimg:nil];
            [_Ve_Main addSubview:btn];
        }];
        [_Ve_Main.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(ScreenWidth/2, 10) To:CGPointMake(ScreenWidth/2, 30) color:HexColorA(0x065279, 1)]];
        [_Ve_Main.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(0, 40) To:CGPointMake(ScreenWidth, 40) color:HexColorA(0x065279, 1)]];
        
        [_Ve_Main addSubview:Tv_1 = ({
            UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, 40, _Ve_Main.width, _Ve_Main.height - 40)];
            [_ registerClass:[XZDebugTool__Cell class] forCellReuseIdentifier:@"UITableViewCell"];
            _.delegate = self;_.tableFooterView = [UIView new];
            _.dataSource = self;_.backgroundColor = _Ve_Main.backgroundColor;
            _.separatorColor = [UIColor redColor];
            _;
        })];
        
        [_Btn_touch removeFromSuperview];
        [XZApp.window addSubview:_Btn_touch = ({
            UIButton *btn = [UIButton Frame:CGRectMake(ScreenWidth - 50, 240,50, 50) Title:@"open" FontS:16 Color:nil radius:8 Target:self action:@selector(closeOpen:)  Bimg:HexColor(0xDC3023)];
            [btn addGestureRecognizer:[[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(handlePan:)]];btn;
        })];
        
        [Tv_1 reloadData];
        
    });
}

#pragma mark -
- (void)showHistoryList{
    //时间列表
    __block NSMutableArray  *HistoryArr = [[NSMutableArray alloc]init];
    [XZdbQu inDatabase:^(FMDatabase *db) {
        FMResultSet *rs = [db executeQuery:@"select * from M_XZDebugTool_TimeList"];
        while ([rs next]) {
            [HistoryArr addObject:[rs stringForColumn:@"time"]];
        }
        [rs close];
    }];
    if (HistoryArr.count == 0) {
        return;
    }
    //根据时间查找的历史记录
    [XZPutDownMenuView ShowIn:_Ve_Main Point:CGPointMake(0, 40) List:[[HistoryArr reverseObjectEnumerator] allObjects] Click:^(NSString *time, NSInteger index) {
        [_Arr_List removeAllObjects];
        
        [XZdbQu inDatabase:^(FMDatabase *db) {
            FMResultSet *rs = [db executeQuery:@"select * from M_XZDebugTool_data where TimeList = ?",time];
            while ([rs next]) {
                M_XZDebugTool *mod = [[M_XZDebugTool alloc]init];
                mod.indexTime = [rs stringForColumn:@"indexTime"];
                mod.API = [rs stringForColumn:@"API"];
                mod.param = [rs stringForColumn:@"param"];
                mod.des = [rs stringForColumn:@"des"];
                [_Arr_List addObject:mod];
            }
            [rs close];
            [Tv_1 reloadData];
        }];
        
        [Tv_1 reloadData];
    }];
}


- (void)actionHandle:(UIButton*)sender{
    if ([[sender currentTitle] isEqualToString:@"历史记录"]) { [self showHistoryList];return;}
    
    [XZPutDownMenuView ShowIn:_Ve_Main Point:CGPointMake(ScreenWidth, 40) List:@[@"当前用户",@"请求头",@"清空显示",@"清缓存&闪退"] Click:^(NSString *str, NSInteger index) {
        if (index == 0) {
            [self addDicLog:XZApp.UserInfo.keyValues Param:@{} API:@"当前用户"];
        }else if (index == 1) {
            NSMutableDictionary *header = [XZApp.window.rootViewController.AFM.requestSerializer.HTTPRequestHeaders mutableCopy];
            NSString *deviceinfo = header[@"deviceinfo"];
            [header setValue:deviceinfo.JsonDic forKey:@"deviceinfo"];
            [self addDicLog:header Param:@{} API:@"当前请求头"];
        }else if (index == 2){
            [_Arr_List removeAllObjects];
            [Tv_1 reloadData];
        }else if (index == 3){
            [XZdbQu inDatabase:^(FMDatabase *db) {//删除全部记录
                [db executeUpdate:@"delete from M_XZDebugTool_TimeList"];
                [db executeUpdate:@"delete from M_XZDebugTool_data"];
                [_Arr_List removeAllObjects];
                [Tv_1 reloadData];
            }];
            
            NSDictionary *dic = [USDF dictionaryRepresentation];
            for (id  key in dic) {
                [USDF removeObjectForKey:key];
            }
            [USDF synchronize];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
            NSArray *FileArr = [fileManager contentsOfDirectoryAtPath:documentsDirectory error:NULL];
            for (NSString *filename in FileArr) {
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
            }
            
            [XZApp.window.rootViewController ShowHUDLabelText:@"wait 2s..." De:2];
            delay(2, ^{
                exit(0);
            });
        }
    }];
    
}


#pragma mark      - 添加log
- (void)addDicLog:(NSDictionary*)dic Param:(NSDictionary*)Param API:(NSString*)API{
    if (XZApp.UserInfo == nil) {_Ve_Main.hidden = YES;return;}
    [self setupDatabase];
    
    M_XZDebugTool *mod = [[M_XZDebugTool alloc]init];
    mod.indexTime = [NSString stringWithFormat:@"%@   —— <%@>",[NSDate date].XZ_YYYYMMddHHmmss,@(startIndex).stringValue];startIndex++;
    mod.API = [@"  " addStr:API];
    mod.param = [@"  " addStr:[[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:Param ? : @{} options:0 error:NULL] encoding:NSUTF8StringEncoding]];
    //    mod.des = [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObXZct:dic options:0 error:NULL] encoding:NSUTF8StringEncoding];
    mod.des = dic.JsonStr;
    
    if (mod.des.length > 5000) {
        mod.des = [[mod.des substringToIndex:5000] addStr:@".........................................................................................."];
    }
    
    [_Arr_List addObject:mod];
    if (_Arr_List.count > 20) {
        [_Arr_List removeObjectAtIndex:0];
    }
    
    //数据库插入一条
    [XZdbQu inDatabase:^(FMDatabase *db) {
        [db executeUpdate:@"INSERT INTO M_XZDebugTool_data (TimeList,indexTime,API,param,des) VALUES (?,?,?,?,?)",_Str_BeginTime,mod.indexTime,mod.API,mod.param,mod.des];
    }];
    
    [Tv_1 reloadData];
    [Tv_1 scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:_Arr_List.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}

#pragma mark - UITableView Delegate DataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return [tableView fd_heightForCellWithIdentifier:@"UITableViewCell" cacheByIndexPath:indexPath configuration:^(XZDebugTool__Cell *cell) {
        cell.fd_enforceFrameLayout = YES;
        cell.Mod = _Arr_List[indexPath.row];
    }];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _Arr_List.count;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{return 1;}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    XZDebugTool__Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    if (_Arr_List.count > indexPath.row) {
        cell.Mod = _Arr_List[indexPath.row];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    //    M_XZDebugTool *mod = _Arr_List[indexPath.row];
    //    [[[UIAlertView alloc]initWithTitle:@"" message:mod.des.JsonDic.description delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil] show];
    
}


#pragma makr -
- (void)handlePan:(UIPanGestureRecognizer*)recognizer{
    CGFloat A = recognizer.view.transform.a;
    CGPoint translation = [recognizer translationInView:XZApp.window];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x  * (A > 10 ? (A - 10)*0.8 : 1),recognizer.view.center.y + translation.y  * (A > 10 ? (A - 10)*0.8 : 1));
    [recognizer setTranslation:CGPointZero inView:XZApp.window];
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if (recognizer.view.y > ScreenHeight - recognizer.view.height ) {recognizer.view.y = ScreenHeight - recognizer.view.height;}
            if (recognizer.view.y < 0 ) {recognizer.view.y = 0;}
            if (recognizer.view.x >= (ScreenWidth - recognizer.view.width)/2) {recognizer.view.x = ScreenWidth - recognizer.view.width;}
            if (recognizer.view.x < (ScreenWidth - recognizer.view.width)/2) {recognizer.view.x = 0;}
        }];
    }
}

- (void)closeOpen:(UIButton*)sender{
    sender.selected = !sender.selected;
    [sender setTitle:sender.selected ? @"close" : @"open" forState:UIControlStateNormal];
    _Ve_Main.hidden = !sender.selected;
}



@end
