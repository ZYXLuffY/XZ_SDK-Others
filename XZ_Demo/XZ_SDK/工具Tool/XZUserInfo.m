
#import "XZUserInfo.h"
#import "XZUtility.h"
#import "MJExtension.h"
#import "IQKeyboardManager.h"
#import "XZBaseNavtion.h"
#import "XZNetWorking.h"
#import "XZDebugTool__.h"

@implementation XZUserInfo

#pragma mark - 静态登录相关方法

+(NSDictionary *)replacedKeyFromPropertyName{
    return @{@"userId" : @[@"userId",@"id"]};
}

-(NSString *)userId{
    if (XZApp.___test___UserId.length != 0) {
        return XZApp.___test___UserId;
    }
    //        #warning test to any userId
    //        return @"573";//测试573 测试577 260  584 2087  515 260
    if (XZApp.UserInfo == nil ||  _userId.length == 0 || _userId == nil) {
        return @"";
    }
    return _userId;
}
//防止用户信息接口的字段覆盖为空
-(void)setMiPushAlias:(NSString *)miPushAlias{ if (miPushAlias.length != 0) {  _miPushAlias = miPushAlias; }}
-(void)setOpenid:(NSString *)openid          { if (openid.length != 0)      {  _openid = openid;}}
-(void)setMobile:(NSString *)mobile          { if (mobile.length != 0)      {  _mobile = mobile;}}


- (void)resetUserInfo:(NSDictionary*)UserinfoRes{
    NSMutableDictionary *fixDic = [NSMutableDictionary dictionaryWithDictionary:UserinfoRes];
    if (XZApp.UserInfo.openid.length) {
        [fixDic setObject:[fixDic str:@"mobile"]forKey:@"thirdAccount"];
        [fixDic removeObjectForKey:@"mobile"];//特殊处理 三方登录绑定的mobile字段
    }
    [self setKeyValues:fixDic];
    [USDF setObject:[XZApp.UserInfo keyValues] forKey:UserDef_AutoUser];
    [USDF synchronize];
}

/** 自动登录用的 */
+(void)AutoLogin{
    NSDictionary *userDic = [USDF objectForKey:UserDef_AutoUser];
    if (userDic && userDic.count != 0 && [USDF objectForKey:UserDef_AutoUserPassWord] && [USDF boolForKey:UserDef_AutoLogin]) {//保存过登录过的信息 自动登录
        [self Login_____User:userDic LoginPassWord:nil];
    }
    
    [XZDebugTool__ Shared];
}

/** 登入主页面  包含自动登录 */
+(void)Login_____User:(NSDictionary*)userDic LoginPassWord:(NSString*)passw{
    XZApp.UserInfo ? [XZApp.UserInfo setKeyValues:userDic] : (XZApp.UserInfo = [XZUserInfo objectWithKeyValues:userDic]);
    NSLog(@"\n🐳🐳🐳🐳🐳🐳🐳XZApp.UserInfo🐳🐳🐳🐳🐳🐳🐳\n%@\n",XZApp.UserInfo.XZ_DebugDescription);
    if (passw) {//登录接口记录的APP原生登录信息和登录密码
        [USDF setObject:[XZApp.UserInfo keyValues] forKey:UserDef_AutoUser];
        [USDF setObject:passw forKey:UserDef_AutoUserPassWord];
        [USDF setBool:YES forKey:UserDef_AutoLogin];
        [USDF synchronize];
    }
    
//    [MiPushSDK  setAlias:XZApp.UserInfo.miPushAlias];//针对个人用户推送绑定
    
    [self Setup_DataBase];
    
    UINavigationController *Nav = [[XZBaseNavtion alloc]initWithRootViewController:[[UITableViewController alloc]init]];
    XZApp.window.rootViewController = Nav;//进入视图
    [XZApp.window.layer XZ_Fade];
    
    
    //首次进来 去添加车辆
    if ([XZUserInfo isFirstLogin]) {
        delay(0.25, ^{
            [self ShowGuideView];
        });
        if ([XZApp.UserInfo.isAddCar intValue] != 1) {//去添加车辆
            [[Nav.viewControllers firstObject] setSelectedIndex:0];
//            AddCar_Step1VC *addCarVc = [AddCar_Step1VC Vc];
//            addCarVc.title = @"添加爱车信息";
//            [Nav setViewControllers:@[[Nav.viewControllers firstObject],addCarVc] animated:YES];
        }
    }
    
    [[XZDebugTool__ Shared] loadDebugView];
    
}

/** 是否首次登录 */
+(BOOL)isFirstLogin{
    NSMutableDictionary *Logined_Dic = [NSMutableDictionary dictionaryWithDictionary:[USDF dictionaryForKey:UserDef_Dic_FristLogin]];
    if ([Logined_Dic valueForKey:XZApp.UserInfo.userId] == nil) {
        [Logined_Dic setValue:@"" forKey:XZApp.UserInfo.userId ? : @""];
        [USDF setValue:Logined_Dic forKey:UserDef_Dic_FristLogin];
        [USDF synchronize];
        return YES;
    }
    return NO;
}


#pragma mark - 显示引导页
/** 显示引导页 */
+(void)ShowGuideView{
//    NSString *suffix = @"720";
//    if (iPhone6_Screen) { suffix = @"750";
//    }else if (iPhone6Plus_Screen){ suffix = @"1080"; }
    
//    NSMutableArray *views = [NSMutableArray array];
//    for (int i = 1; i<=4; i++) {
//        [views addObject:[[MYIntroductionPanel alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:nil description:nil image:LOADIMAGE(([NSString stringWithFormat:@"introduction_%d",i]))]];
//    }
//    
//    MYBlurIntroductionView *introductionView = [[MYBlurIntroductionView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
//    [introductionView buildIntroductionWithPanels:views];
//    introductionView.alpha = 0;
//    [XZApp.window addSubview:introductionView];
//    
//    [UIView animateWithDuration:0.25 animations:^{
//        introductionView.alpha = 1;
//    }];
}

/** 登入后有了userid 创建属于这个用户的专属数据库 */
+(void)Setup_DataBase{
#ifdef DEBUG
    [XZdb CreateTable:Table_DEBUG];
#endif
    [XZdb CreateTable:T_XZdbDefaultT]; //各种缓存
}

/** 退出登录 或 被挤下线的 */
+(void)LogOut_____{
//    [MiPushSDK unsetAlias:XZApp.UserInfo.miPushAlias];//必须解绑 针对个人用户 的推送
    
    XZApp.UserInfo = nil;
    XZApp.window.rootViewController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateInitialViewController];
    [XZApp.window.layer XZ_Fade];
    
    //    [USDF removeObjectForKey:UserDef_AutoUserPassWord];// 有的话就显示吧
    [USDF setBool:NO forKey:UserDef_AutoLogin];
    [USDF removeObjectForKey:UserDef_Tmbj_Token];
    [USDF removeObjectForKey:UserDef_refreshTokenTime];
    [USDF synchronize];
    
    [XZdb dbclose];//必须关闭数据库 保证下次可以打开不同用户的
    [[XZDebugTool__ Shared] loadDebugView];
    
}

/** 是否第一次出现的情况  区分版本号否  第一次 返回 YES*/
+ (BOOL)isFirstCaseByVersion:(BOOL)version CaseStr:(NSString*)caseStr imgName:(NSString*)imgName{
    NSMutableArray * notiArr = [NSMutableArray arrayWithArray:[USDF objectForKey:UserDef_Noti_tips]];
    NSString *versionNoti = [NSString stringWithFormat:@"%@_%@_%@",caseStr,XZApp.UserInfo.userId,version ? Tmbj_code : @""];
    if (![notiArr containsObject:versionNoti]) {
        [notiArr addObject:versionNoti];
        [USDF setObject:notiArr forKey:UserDef_Noti_tips];
        [USDF synchronize];
        
        if (imgName) {
            UIImageView *noti = [[UIImageView alloc]initWithFrame:XZApp.window.bounds];
            noti.image = LOADIMAGE(imgName);
            [XZApp.window addSubview:noti];
            [noti tapGesture:^(UIGestureRecognizer *Ges) {
                [Ges.view removeFromSuperview];
            }];
        }
        
        return YES;
    }
    
    return NO;
}

@end
