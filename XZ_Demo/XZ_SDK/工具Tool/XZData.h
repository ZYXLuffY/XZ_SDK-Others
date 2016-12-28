
/*******************************************************************************************/
//默认的table
#define T_XZdbDefaultT                    @"T_XZdbDefaultT"
#define Table_DEBUG                       @"Table_DEBUG"//强制缓存网络数据
/*******************************************************************************************/




#import <Foundation/Foundation.h>
#import "FMDB.h"
#import "AppDelegate.h"


@interface XZdbObj : NSObject

@property (copy, nonatomic)     NSString *Id;/**< 主键Id */
@property (strong, nonatomic)   id Obj;
@property (strong, nonatomic)   NSDate *Date;/**< 上次save的时间 */

@end

#define XZdb       [XZData shareData]
#define XZdbQu     [XZdb dbQueue]

@interface XZData : NSObject

+ (instancetype)shareData;

@property (strong, nonatomic) FMDatabaseQueue * dbQueue;
/** 关闭数据库 用于用户退出登录后 */
- (void)dbclose;

/** 在已创建在沙盒中的.db文件上 添加表*/
-(void)CreateTable:(NSString *)tableName;

/** 整存 对应table里的主键id */
-(void)Save:(id)obj Id:(NSString *)Id Table:(NSString *)tableName;
-(void)Save:(id)obj Id:(NSString *)Id;/**< 整存 对应table里的主键id 默认表：T_XZdbDefaultT*/

/** 根据id取  */
-(id)Get:(NSString *)Id Table:(NSString *)tableName;
-(id)Get:(NSString *)Id;/**< 根据id取  默认表：T_XZdbDefaultT*/

/** 根据id取XZdbObj  默认表：T_XZdbDefaultT*/
-(XZdbObj*)GetXZObj:(NSString *)Id Table:(NSString *)tableName;
-(XZdbObj*)GetXZObj:(NSString *)Id;/**< 根据id取XZdbObj  默认表：T_XZdbDefaultT*/

/** 获取该表所有*/
-(NSMutableArray*)AllObj:(NSString *)tableName;
-(NSMutableArray*)AllXZObj:(NSString *)tableName;


/** 删除 */
-(void)Delete:(NSString *)Id T_Name:(NSString *)tableName;
-(void)Delete:(NSString *)Id;/**< 删除 默认表：T_XZdbDefaultT*/

/** 清空表 */
- (void)clearTable:(NSString *)tableName;






@end
