//
//  CALayer+XZ.m
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "CALayer+XZ.h"

@implementation CALayer (XZ)


/** 颤抖效果 */
-(CAAnimation *)XZ_Shake{
    CAKeyframeAnimation *shake = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    shake.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeTranslation(-5.0f, 0.0f, 0.0f)], [NSValue valueWithCATransform3D:CATransform3DMakeTranslation(5.0f, 0.0f, 0.0f)]];
    shake.autoreverses = YES;
    shake.repeatCount = 2.0f;
    shake.duration = 0.07f;
    [self addAnimation:shake forKey:nil];
    return shake;
}

/** 渐显效果 */
-(CATransition*)XZ_Fade{
    return [self XZ_Fade:0.4];
}

/** 渐显效果 效果时间 */
-(CATransition*)XZ_Fade:(CGFloat)time{
    CATransition *animation = [CATransition animation];
    [animation setDuration:time];
    [animation setType: kCATransitionFade];
    [animation setSubtype: kCATransitionFromRight];
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault]];
    [self addAnimation:animation forKey:nil];
    return animation;
}

/** 缩放效果 */
-(CAKeyframeAnimation *)XZ_transformscale{
    CAKeyframeAnimation *transformscale = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    transformscale.values = @[@(0),@(0.5),@(1.08)];
    transformscale.keyTimes = @[@(0.0),@(0.2),@(0.3)];
    transformscale.calculationMode = kCAAnimationLinear;
    [self addAnimation:transformscale forKey:nil];
    return transformscale;
}

/** 简3D动画吧 */
-(CAAnimation *)anim_revers:(AnimRever_Direction)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount{
    NSString *key = @"reversAnim";
    if([self animationForKey:key]!=nil){
        [self removeAnimationForKey:key];
    }
    NSString *directionStr = nil;
    if(AnimRever_DirectionX == direction)directionStr=@"x";
    if(AnimRever_DirectionY == direction)directionStr=@"y";
    if(AnimRever_DirectionZ == direction)directionStr=@"z";
    //创建普通动画
    CABasicAnimation *reversAnim = [CABasicAnimation animationWithKeyPath:[NSString stringWithFormat:@"transform.rotation.%@",directionStr]];
    reversAnim.fromValue=@(0);//起点值
    reversAnim.toValue = @(M_PI_2);//终点值
    reversAnim.duration = duration;//时长
    reversAnim.autoreverses = isReverse;//自动反转
    reversAnim.removedOnCompletion = YES;//完成删除
    reversAnim.repeatCount = repeatCount; //重复次数
    [self addAnimation:reversAnim forKey:key];
    
    
    return reversAnim;
}

//+ (instancetype)createMaskLayerWithView:(UIView *)view{
//    CGFloat viewWidth = CGRectGetWidth(view.frame);
//    CGFloat viewHeight = CGRectGetHeight(view.frame);
//    CGFloat rightSpace = 10.;
//    CGFloat topSpace = 15.;
//    CGPoint point1 = CGPointMake(0, 0);
//    CGPoint point2 = CGPointMake(viewWidth-rightSpace, 0);
//    CGPoint point3 = CGPointMake(viewWidth-rightSpace, topSpace);
//    CGPoint point4 = CGPointMake(viewWidth, topSpace + 5.);
//    CGPoint point5 = CGPointMake(viewWidth-rightSpace, topSpace+10.);
//    CGPoint point6 = CGPointMake(viewWidth-rightSpace, viewHeight);
//    CGPoint point7 = CGPointMake(0, viewHeight);
//    UIBezierPath *path = [UIBezierPath bezierPath];
//    [path moveToPoint:point1];
//    [path addLineToPoint:point2];
//    [path addLineToPoint:point3];
//    [path addLineToPoint:point4];
//    [path addLineToPoint:point5];
//    [path addLineToPoint:point6];
//    [path addLineToPoint:point7];
//    [path closePath];
//    CAShapeLayer *layer = [CAShapeLayer layer];
//    layer.path = path.CGPath;
//    return layer;
//}


@end
