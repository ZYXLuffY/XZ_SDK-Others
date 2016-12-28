//
//  XZBaseBackView.h
//  test.qtzUser_XZ
//
//  Created by XZ on 16/6/28.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 弹出的背景 */
@interface XZBaseBackView : UIView

@property (nonatomic,assign) CGFloat contentHeight;/**< 主视图从下到上时的 主要视图高度 */
@property (nonatomic,strong) UIView *V_Content;/**< 主视图*/

/** 显示 */
-(void)ShowView;

/** 隐藏 销毁 */
-(void)hideView;

@end
