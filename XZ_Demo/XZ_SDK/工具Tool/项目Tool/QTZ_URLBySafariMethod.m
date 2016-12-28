//
//  QTZ_URLBySafariMethod.m
//  com.tmbj.qtzUser_JE
//
//  Created by iOS_XZ on 16/6/28.
//  Copyright © 2016年 JE. All rights reserved.
//

#import "QTZ_URLBySafariMethod.h"

#import "XZUtility.h"
#import "XZDebugTool__.h"
//#import "Main_1_VC.h"
//#import "Main_3_VC.h"
//#import "TmbjH5VC.h"
//#import "FlowInChargeTVC.h"
//#import "M1_keepHankBookVC.h"
//#import "M1_keepCarInfoTVC.h"
//#import "M3_orderDetailTVC.h"
//#import "QTZ_BuyOBDVC.h"
//#import "M3_AllorderTVC.h"
//#import "Jiashi_UploadActivityVC.h"
static QTZ_URLBySafariMethod *method = nil;
static dispatch_once_t onceToken;

@interface QTZ_URLBySafariMethod ()
@property (nonatomic, copy) NSString *urlStr;/**< 需要跳转webView的url*/
@property (nonatomic, copy) NSString *methodName;
@property (nonatomic, assign) BOOL isByJava;
@property (nonatomic, strong) NSMutableDictionary *dataParam;
@end

@implementation QTZ_URLBySafariMethod
+ (instancetype)shareManager{
    dispatch_once(&onceToken, ^{
        method = [[QTZ_URLBySafariMethod alloc] init];
        method.dataParam = [NSMutableDictionary dictionary];
    });
    return method;
}

- (instancetype)init {
    self = [super init];
    if (!self) return nil;
    return self;
}

- (void)receiveUrlByJava:(NSString *)url{
    if ([url hasPrefix:@"tmbj"]) {
        _isByJava = YES;
        [self receiveUrlBySafari:url];
    }
    if ([url hasPrefix:@"http"]) {
        [XZApp.window.rootViewController webOpenUrl:url];
    }
}

-(NSString*)receiveUrlBySafari:(NSString *)url
{
    if (XZApp.APPnowAdress.length <= 0) {
        XZApp.tmbj_url = nil;
        return nil;
    }
    _urlStr = nil;
    _methodName = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(toPushAction)name:@"toPushAction"object:nil];
    NSArray *arr = [url componentsSeparatedByString:@"="];
    self.dataParam = url.parameters;
    if(arr.count >= 2)
    {
        NSArray *DetailArr = [[arr objectAtIndex:1] componentsSeparatedByString:@"&"];
        NSString *method = [DetailArr firstObject];
        _methodName = method;
        [self.dataParam setValue:method forKey:@"method"];
    }
    
    if (_urlStr != nil) {
        return _urlStr;//实际是跳转到网页
    }
    
    [self toPushAction];//实际是跳转到原生
    return nil;
}

- (void)toPushAction
{
    
//    if ((XZApp.UserInfo == nil || XZApp.UserInfo.userId <= 0 )) {
//        XZApp.tmbj_url = nil;
//        return;
//    }
//    
//    
//    [[JEDebugTool__ Shared] addDicLog:@{@"方法名" :VALUEFROM(_methodName) } Param:@{} API:@"_methodName"];
//    
//    UINavigationController *MainNav = ((UINavigationController*)XZApp.window.rootViewController);
//    
//    if ([ServiceTypes containsObject:_methodName]) {
//        if (!_isByJava) {
//            [MainNav popToRootViewControllerAnimated:NO];
//        }
//        [[Main_1_VC InNav] CarService_ActionBy:[ServiceTypes indexOfObject:_methodName]];
//    }
//    else if ([_methodName isEqualToString:@"getGoodsList"]) {
//        [MainNav pushVC:SB1(@"擎天助礼品卡")];
//    }
//    else if ([_methodName isEqualToString:@"payImmediately"] || [_methodName isEqualToString:@"publishComments"]) {//完成服务的外链 马上支付的外链 跳到订单详情
//        [MainNav pushVC:[[M3_orderDetailTVC Vc] sendOrderNo:[_dataParam str:@"orderNo"]]];//订单详情
//    }
//    else if ([_methodName isEqualToString:@"flowRecharge"]) {
//        FlowInChargeTVC *vc = [FlowInChargeTVC Vc];
//        if (self.dataParam) {
//            vc.diviceId = [self.dataParam valueForKey:@"deviceId"];
//            vc.plateNumber_ByMsgList = [self.dataParam str:@"plateNumber"];
//            vc.activityId = [self.dataParam str:@"activityId"];
//        }
//        [MainNav pushVC:vc];
//    }
//    
//    else if ([_methodName isEqualToString:@"maintenanceProgram"]) {
//        M1_keepHankBookVC * vc = SB1(@"保养计划");
//        vc.CarId_ByMsgList = [self.dataParam str:@"carId"];
//        [MainNav pushVC:vc];
//    }
//    
//    else if ([_methodName isEqualToString:@"updateMaintenance"]) {
//        M1_keepCarInfoTVC *vc = SB1(@"养车信息");
//        vc.CarId_ByMsgList = [self.dataParam str:@"carId"];
//        [MainNav pushVC:vc];
//    }
//#pragma mark -------2.0新家外边链接跳转-------
//    /**< 上传行驶证*/
//    else if ([_methodName isEqualToString:@"drivingLicense"] || [_methodName isEqualToString:@"authenticationFailure"]) {
//        Jiashi_UploadActivityVC *vc = SB1(@"认证行驶证上传");
//        vc.carId = [self.dataParam str:@"carId"];
//        [MainNav pushVC:vc];
//    }
//    /**< 购买盒子VC*/
//    else if ([_methodName isEqualToString:@"buyOBD"]){
//        [MainNav pushVC: SB1( @"实物确认订单")];
//    }
//    /**< 限时活动*/
//    else if ([_methodName isEqualToString:@"limitAction"]){
//        [MainNav pushVC:[[TmbjH5VC alloc] initWithUrl: [NSString URLWithBaseString:[NSString stringWithFormat:@"%@%@/indexHot",BoJue_BASEHTTP_Web,API_H5] parameters:self.dataParam]]];
//    }
//    /**< 首单免费*/
//    else if ([_methodName isEqualToString:@"shouDanFree"]){
//        if([_urlStr containsString: @"tmbj://"]){
//            _urlStr = [_urlStr stringByReplacingOccurrencesOfString:@"tmbj://" withString:@"http://"];
//        }
//        [MainNav pushVC:[[TmbjH5VC alloc] initWithUrl:_urlStr]];
//    }
//    else if ([_methodName isEqualToString:@"buyInsurance"]){
//        [MainNav pushVC:[[TmbjH5VC alloc] initWithUrl_NoCarId:[NSString URLWithBaseString:[NSString stringWithFormat:@"%@%@/insIntro",BoJue_BASEHTTP_Web,API_H5] parameters:self.dataParam]]];
//    }
//    else if ([_methodName isEqualToString:@"orderOfAll"] || [_methodName isEqualToString:@"orderOfShop"] || [_methodName isEqualToString:@"orderOfInsurance"]){
//        [MainNav pushVC:[[M3_AllorderTVC Vc] sendOrderType:@"" status:@"" title:@"全部订单"]];
//    }
//    else if ([_methodName isEqualToString:@"OBDInfo"]){
//        [MainNav pushVC:[[TmbjH5VC alloc] initWithType:TmbjH5Type_qtzInstro]];
//    }
//    _methodName = nil;
//    XZApp.tmbj_url = nil;
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


@end
