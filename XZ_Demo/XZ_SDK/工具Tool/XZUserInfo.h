//
//  XZUserInfo.h
//  BoJueCar.BoJueBusiness_XZ
//
//  Created by XZ on 16/1/5.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define XZAPP_Lat  (XZApp.APPLocation.coordinate.latitude)
#define XZAPP_Lng  (XZApp.APPLocation.coordinate.longitude)

@interface XZUserInfo : NSObject

@property (nonatomic,copy  ) NSString  *userId;/**< 用户ID */

@property (nonatomic,copy  ) NSString  *openid;/**< 第三方登录后有的 */
@property (nonatomic,copy  ) NSString  *miPushAlias;/**< 小米推送要绑定的 */
@property (nonatomic,copy  ) NSString  *isAddCar;/**< 是否添加过车辆 */

//用户详情接口的
@property (nonatomic,copy  ) NSString  *mobile;/**< 手机号 */
@property (nonatomic,copy  ) NSString  *userIcon;/**< 头像地址 */
@property (nonatomic,copy  ) NSString  *userName;/**< 昵称 */
@property (nonatomic,assign) NSInteger driverYear;/**< 驾龄 */
@property (nonatomic,copy  ) NSString  *sign;/**< 签名 */
@property (nonatomic,assign) NSInteger sex;/**< （1男2女） */


@property (nonatomic,copy  ) NSString  *linkmanTel;/**< 第三方登录后 绑定过的手机 */
@property (nonatomic,copy  ) NSString  *thirdAccount;/**< 自己加的 第三方登录后有的 */

/** 特殊处理 三方登录绑定的mobile字段 */
- (void)resetUserInfo:(NSDictionary*)UserinfoRes;


#pragma mark -

/** 操作要登录的处理  需要登录返回 YES*/
//+(BOOL)UserLoginHandle;

+(void)AutoLogin;/**< 包含自动登录 */
+(void)Login_____User:(NSDictionary*)userDic LoginPassWord:(NSString*)passw;/**< 接口返回的实体 密码 */
+(void)LogOut_____;/**< 退出 */

+(void)ShowGuideView;/**< 显示引导页 */

/**
 *  是否第一次出现的情况
 *
 *  @param version 是否区分版本号 区分版本号每次跟新都触发
 *  @param caseStr @"youstr"
 *  @param imgName 有图片名字默认自动添加
 *
 *  @return 第一次 返回 YES
 */
+ (BOOL)isFirstCaseByVersion:(BOOL)version CaseStr:(NSString*)caseStr imgName:(NSString*)imgName;

@end





