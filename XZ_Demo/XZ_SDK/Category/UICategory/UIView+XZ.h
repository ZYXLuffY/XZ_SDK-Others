//
//  UIView+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+XZ.h"

@interface UIView (XZ)

+ (instancetype)Frame:(CGRect)frame color:(UIColor*)color;/**< UIView */

@property (nonatomic,assign) CGPoint origin;
@property (nonatomic,assign) CGSize size;
@property (nonatomic,assign) CGFloat height;
@property (nonatomic,assign) CGFloat width;
@property (nonatomic,assign) CGFloat x;
@property (nonatomic,assign) CGFloat y;
@property (nonatomic,assign) CGFloat bottom;
@property (nonatomic,assign) CGFloat right;
@property (nonatomic,assign) CGFloat centerY;
@property (nonatomic,assign) CGFloat centerX;

@property (nonatomic,assign) IBInspectable CGFloat   bor;    /**< 边框宽 */
@property (nonatomic,strong) IBInspectable UIColor  *borCol; /**< 边框颜色 */
@property (nonatomic,assign) IBInspectable CGFloat rad;/**< 倒角 */
@property (nonatomic,assign) IBInspectable BOOL beRound;/**< 变圆 */

- (void)addShdow;/**< 下边线加阴影 */
-(void)border:(UIColor *)color width:(CGFloat)width;/**< 添加边框 */
-(void)XZ_Debug:(UIColor *)color width:(CGFloat)width;/**< Debug添加边框 */
-(void)XZ_RemoveClassView:(Class)classV;/**< 移除对应的view */

- (instancetype)setTag_:(NSInteger)tag;/**< setTag & return self */
- (UILabel *)labelWithTag:(NSInteger)tag;/**< viewWithTag */
- (UIButton *)buttonWithTag:(NSInteger)tag;/**< viewWithTag */
- (UIImageView *)ImageViewWithTag:(NSInteger)tag;/**< viewWithTag */

@property (nonatomic,strong,readonly) UIViewController *superVC;/**< view 根据nextResponder 获得 所在的viewcontroler */

+(CAShapeLayer *)XZ_DrawLine:(CGPoint)points To:(CGPoint)pointe color:(UIColor*)color;/**< 画线 */
+(CAShapeLayer *)XZ_drawRect:(CGRect)rect Radius:(CGFloat)redius color:(UIColor*)color;/**< 画框框线 */
- (void)XZ_addSquareDottedLine:(NSArray*)lineDashPattern Radius:(CGFloat)Radius;/**< 添加虚线 */

#pragma mark - 手势

typedef void (^GestureActionBlock)(UIGestureRecognizer *Ges);
- (void)tapGesture:(GestureActionBlock)block;/**< 单点击手势 */
- (void)longPressGestrue:(GestureActionBlock)block;/**< 长按手势 */

/** 获取屏幕比例*/
+(CGFloat)getScaleHeight;
+(CGFloat)getScaleWidth;


@end







