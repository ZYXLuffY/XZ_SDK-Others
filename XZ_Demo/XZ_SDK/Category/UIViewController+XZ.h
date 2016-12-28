//
//  UIViewController+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZNetWorking.h"
#import "UIViewController+XZNavBar.h"
@class MBProgressHUD;

@interface UIViewController (XZ)<CAAnimationDelegate>

#pragma mark - AFHTTPSessionManager

/** AFHTTPSessionManager */
@property (nonatomic,strong)  AFHTTPSessionManager *AFM;
/** 取消关联的AFM的全部网络请求 */
-(void)cancelNetworking;

/** 请求地址 参数 成功回调 */
-(void)POST:(NSString*)API Param:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc;
-(void)POST:(NSString*)API HudParam:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc;/**< show HUD 请求地址 参数 成功回调 */
/** 请求地址 参数 成功回调 失败回调*/
-(void)POST:(NSString*)API Param:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask *task, NSError *error))Fai;
-(void)POST:(NSString*)API HudParam:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask *task, NSError *error))Fai;/** show HUD 请求地址 参数 成功回调 失败回调*/



#pragma mark - HUD

- (MBProgressHUD *)HUD;
- (void)ShowHUD;
/** 显示文本     延迟消失 0 为默认值 */
-(void)ShowHUD:(NSString*)text De:(CGFloat)delay;
/** 显示文本    img -1 不显示图片 1成功 0失败  延迟消失 */
-(void)ShowHUD:(NSString*)text Img:(NSInteger)img De:(CGFloat)delay;
/** HUD转 和 文字 */
-(void)ShowHUDLabelText:(NSString*)text De:(CGFloat)delay;
- (void)hideHud;


#pragma mark - 小方法

/** 验证输入内容不能为空震动提示 becomeFirstResponder  Tf Tv 数组  提示数组 可空  默认为它的placeholder */
-(BOOL)TextinputEmptyError:(NSArray*)VArr E:(NSArray*)EArr;

/** 获取storyboard构建的VC   不重写就默认[[[self class]alloc]init] */
+ (instancetype)Vc;

/** 默认传参方法 */
- (instancetype)sendInfo:(id)info;

/** self.navigationController */
-(UINavigationController*)Nav;

/** 导航控制器 取得对应栈上的vc*/
+ (instancetype)InNav;

/** self.Nav 默认动画 pushViewController:vc animated:YES */
-(void)pushVC:(UIViewController*)vc;

/** showViewController */
+ (void)ShowVC;

/** showViewController  顺便调 sendInfo:  传参 */
+ (void)ShowVC:(id)info;
    
/** showViewController; */
- (void)showVC;



/** 构建 rightBarButtonItem title */
-(void)RightBarBtn:(NSString*)title act:(SEL)selector;
/** 构建 rightBarButtonItem ImageName */
-(void)RightBarBtnImgN:(NSString*)imageN act:(SEL)selector;

-(void)CallTelephone:(NSString*)link;/**< 打个电话 */
-(void)webOpenUrl:(NSString*)link;/**< 打开1个网页 */

@end
