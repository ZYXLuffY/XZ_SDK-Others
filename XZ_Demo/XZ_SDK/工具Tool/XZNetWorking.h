
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import "AFHTTPSessionManager.h"
#import "MBProgressHUD.h"
#import "UIViewController+XZ.h"
#import "XZListManager.h"

#define Tmbj_Token      @"tmbj-token"


//返回码描述
typedef NS_ENUM(NSInteger, QTZNetwork_ReturnCode) {
    QTZNetwork_ReturnCodeSuccess = 0,///< 成功
    QTZNetwork_ReturnCodeFailure = 1,/**< 失败 */
    QTZNetwork_ReturnCodeNotAddedCar = 10001,///< 没有添加车辆
    QTZNetwork_ReturnCodeParmaWrong = 10002,///< 参数错误
    QTZNetwork_ReturnCodeLoginTimeOut = 10003,///< 登录超时
    QTZNetwork_ReturnCodeLoginConflict = 10004,///< 已在其他设备登录
    QTZNetwork_ReturnCodeParmaCanNotEmpty = 10005,///< 参数不能为空
    QTZNetwork_ReturnCodeOnlyQTZUser = 10010,///< 亲，擎天助智能终端用户才可以参与活动哦！
    QTZNetwork_ReturnCodeActivityEnd = 10011,///< 亲，活动已结束，下次早点来哦~
    QTZNetwork_ReturnCodeAlreadyInActivity = 10012,///< 亲，您已参与过此次活动。
    QTZNetwork_ReturnCodeVerifyFirst = 10013,///< 请先审核行驶证，再参与签到活动。
    QTZNetwork_ReturnCodeUnbundlingFailure = 10014,///< 盒子解绑失败
    QTZNetwork_ReturnCodeNotGPSInfo = 10015,///< 无GPS定位
    QTZNetwork_ReturnCodeNeedToUpdate = 10016,///< 请到APPStore升级
    QTZNetwork_ReturnCodeTokenWrong = 10017,///< 非法请求，token不合法 Session错误
};



@interface XZNetWorking : NSObject

typedef void(^AFMfailBlock)(NSURLSessionDataTask *task, NSError *error);


/**
 *  加封的网络请求
 *
 *  @param API     API
 *  @param param     构建请求的单表
 *  @param vc      当前ViewController 用于网络请求失败时显示HUD
 *  @param Manager AF
 *  @param Suc     反正是网络请求成功了
 *  @param Fai     反正是失败了
 */
+(void)API:(NSString*)API Param:(NSDictionary*)param Vc:(UIViewController*)vc AF:(AFHTTPSessionManager *)Manager Suc:(void(^)(NSDictionary *Res))Suc Fai:(AFMfailBlock)Fai;
+(void)API:(NSString*)API Param:(NSDictionary*)param Vc:(UIViewController*)vc AF:(AFHTTPSessionManager *)Manager Suc:(void(^)(NSDictionary *Res))Suc;


/** 上传图片 传vc显示进度的HUD 或自己回调进度 */
+(void)uploadImg:(UIImage *)Loadimg AF:(AFHTTPSessionManager *)Manager VCPro:(UIViewController*)vc Pro:(void(^)(float Some,float All))progress Suc:(void(^)(NSDictionary *whether,NSString *path))success fail:(void(^)())failure;

/**  滚回到登录界面  （登录 冲突 超时 提示下线） */
+ (void)GameOver:(QTZNetwork_ReturnCode)code noti:(NSString*)noti;

/** 微信登录 */
+(void)WeChatLogin:(NSString *)code result:(void(^)(NSDictionary *GetDic))result failure:(void(^)())failure;

/** 后台刷新token refreshToken */
+ (void)refreshTokenInBackground;
    
/** 擎天助检查更新 */
+ (void)QTZAppUpdate;

@end
