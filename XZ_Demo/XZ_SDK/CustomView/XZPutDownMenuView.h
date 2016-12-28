//
//  XZPutDownMenuView.h
//  EVGO
//
//  Created by XZ on 15/10/22.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "M_Main1VCInfo.h"

/** 下拉复选框 */
@interface XZPutDownMenuView : UIView

typedef void(^B_Select)(NSString *str,NSInteger index);
@property (nonatomic,copy) B_Select BL_Select;/**< 点击的回调 */
-(instancetype)initWithFrame:(CGRect)frame inView:(UIView*)inview List:(NSArray*)list Click:(B_Select)block PositionUp:(BOOL)PosUP;

/** 默认计算frame */
+(void)ShowIn:(UIView*)view Point:(CGPoint)point List:(NSArray*)list Click:(B_Select)block PositionUp:(BOOL)PosUP;
+(void)ShowIn:(UIView*)view Point:(CGPoint)point List:(NSArray*)list Click:(B_Select)block;

+(void)ShowIn:(UIView*)view Frame:(CGRect)frame List:(NSArray*)list Click:(B_Select)block;
+(void)ShowIn:(UIView*)view Frame:(CGRect)frame List:(NSArray*)list Click:(B_Select)block PositionUp:(BOOL)PosUP;

///** 显示 */
//-(void)ShowView:(CGFloat)height;
///** 隐藏 销毁 */
//-(void)HideView;

@end


@interface XZPutDownMenuView_CarList : XZPutDownMenuView

+(void)ShowIn:(UIView*)view Frame:(CGRect)frame List:(NSArray*)list AddCar:(BOOL)addcar Click:(B_Select)block;

@end

