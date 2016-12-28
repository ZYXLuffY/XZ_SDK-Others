//
//  CALayer+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

/** 反转方向 */
typedef NS_ENUM(NSUInteger, AnimRever_Direction) {
    AnimRever_DirectionX = 0,
    AnimRever_DirectionY,
    AnimRever_DirectionZ,
};

@interface CALayer (XZ)


/** 颤抖效果 */
-(CAAnimation *)XZ_Shake;

/** 渐显效果 */
-(CATransition*)XZ_Fade;

/** 渐显效果 效果时间 */
-(CATransition*)XZ_Fade:(CGFloat)time;

/** 缩放效果 */
-(CAKeyframeAnimation *)XZ_transformscale;

/** 简3D动画吧 */
-(CAAnimation *)anim_revers:(AnimRever_Direction)direction duration:(NSTimeInterval)duration isReverse:(BOOL)isReverse repeatCount:(NSUInteger)repeatCount;

@end
