
#import <Foundation/Foundation.h>
//#import <AlipaySDK/AlipaySDK.h>
//#import "Order.h"
@class AFHTTPSessionManager;
//#import "DataSigner.h"
//#import "APAuthV2Info.h"
//#import "CommonUtil.h"
//#import "AFURLSessionManager.h"
//#import "WXApiObject.h"
//#import "WXApi.h"
//
//#define AppScheme @"qtzUser"

typedef void (^XZPaySuccessBlock)(NSString *statusMessage);
typedef void (^XZPayFailedBlock)(int statusCode,NSString *statusMessage);


@interface XZPayService : NSObject
@property (nonatomic,copy) XZPaySuccessBlock PaySucBlock;
@property (nonatomic,copy) XZPayFailedBlock PayFailBlock;
@property (nonatomic,strong)  AFHTTPSessionManager *AFM___;


//+ (instancetype)sharePayEngine;

#pragma mark = 支付宝支付

/** 支付宝支付 传钱 单位圆    订单定义在此类 */
//-(void)AliPay_Money:(NSString *)money sn:(NSString*)sn Dict:(NSDictionary *)AlpayRes PaySuc:(XZPaySuccessBlock)paySuc PayFail:(XZPayFailedBlock)payFail;
//-(void)Alipay__PayRes_AppDelegate_Noti:(NSDictionary*)resdic;/**< AppDelegate通知的 支付宝支付结果 */



#pragma mark = 微信支付

/** 发起微信支付   dict 传服务器构建返回的  */
//-(void)WeiXin__PayDict:(NSDictionary *)dict PaySuc:(XZPaySuccessBlock)paySuc PayFail:(XZPayFailedBlock)payFail;
//-(void)WeiXin__PayRes_AppDelegate_Noti:(BaseResp*)resp;/**< AppDelegate通知的 微信支付结果 */


@end

