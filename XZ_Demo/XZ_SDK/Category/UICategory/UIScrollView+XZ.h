//
//  UIScrollView+XZ.h
//  BoJueCar.BoJueBusiness_XZ
//
//  Created by XZ on 16/1/5.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZListManager.h"

@interface UIScrollView (XZ)

@property (nonatomic,strong) NSMutableArray *Arr;/**< 基础数据源 */
@property(nonatomic,strong) UIActivityIndicatorView *ActView;/**< act */

/** storyboard 静态tableview 加载 */
- (void)staticLoading;
 /** storyboard 静态tableview 停止加载 */
- (void)staticStopLoading;


/** 如果没有数据 count = 0  显示 图片 文本 */
- (NSInteger)XZ_emptyImgN:(NSString*)imageName title:(NSString*)title count:(NSInteger)row;

/** 网络请求失败时显示的   */
- (UIView*)networkingFailView_Target:(id)target action:(SEL)action;




#pragma mark - 🔵 ====== ====== XZListManager ====== ======  🔵

@property (nonatomic,strong)  XZListManager *ListManager;/**< 列表管理类 */

/** 创建个列表管理的 */
- (void)listAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)Hpage mod:(Class)modclass caChe:(NSString*)caChe suc:(NetSuccess)success fail:(NetFailure)fail;
- (void)listAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)Hpage mod:(Class)modclass superVC:(UIViewController*)superVC caChe:(NSString*)caChe suc:(NetSuccess)success fail:(NetFailure)fail;

/** 列表的头部主动下拉刷新 自带请求结束的停止刷新 并reloadData  Res有值才返回 */
-(void)refreshingPOST:(NSString*)API Param:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask * task, NSError *error))Fai;

@end


