//
//  UIViewController+XZNavBar.h
//  BoJueCar.BoJueBusiness_XZ
//
//  Created by XZ on 16/8/22.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class XZxibButton;

@protocol BackButtonHandlerProtocol <NSObject>

@optional
-(BOOL)XZ_navPopBtnClick;/** 处理返回键 按钮事件 返回NO 先🈲立刻返回咯 */
@end

@interface UIViewController (ShouldPopOnBackButton)

@end




@interface UIViewController (XZNavBar)<BackButtonHandlerProtocol>


@property (nonatomic,copy)  NSString *XZTitle;/**< title */
@property (nonatomic,strong)  UIView *Ve_XZBar;/**< navBar */
@property (nonatomic,strong)  UIButton *Btn_back;/**< 返回按钮 */

/**显示完整的CellSeparator线 */
@property (nonatomic,assign) BOOL fullcellsep;

- (void)alpha0Nav:(BOOL)alpha0;/**< 透明的  navigationBar*/

/** 自定义导航栏  */
- (void)XZ_CustomNavBar;
- (UIView *)customNavBarView;/**< 模仿系统导航 */
- (XZxibButton*)customBackButton;/**< 模仿系统导航栏按钮 */
/** 构建 rightBarButtonItem title */
-(void)XZ_rightBarBtn:(NSString*)title act:(SEL)selector;
-(void)XZ_rightBarBtnImgN:(NSString*)imageN act:(SEL)selector;/**< 构建 rightBarButtonItem ImageName */



@end
