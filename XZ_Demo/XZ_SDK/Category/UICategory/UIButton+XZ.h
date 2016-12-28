//
//  UIButton+XZ.h
//  
//
//  Created by XZ on 15/10/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+WebCache.h"


@interface UIButton (XZ)

/** UIButton */
+(instancetype)Frame:(CGRect)frame Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)titleColor radius:(CGFloat)rad Target:(id)target action:(SEL)action  Bimg:(UIColor*)BColor;

/** 默认 [self setBackgroundImage:[UIImage XZ_ColoreImage:color] forState:UIControlStateNormal]; */
@property (nonatomic,strong) IBInspectable UIColor *BackClickImg;
@property (nonatomic,strong) IBInspectable UIColor *BackClickImg_h;
@property (nonatomic,strong) IBInspectable UIColor *BackClickImg_d;
@property (nonatomic,strong) IBInspectable UIColor *BackClickImg_s;

/** 有select时 保证点击效果 */
-(void)TouchEffect;

/** 倒计时 总秒数 按钮文本后缀 结束时的回调*/
- (void)XZ_countDowns:(NSInteger)timeLine suffix:(NSString *)suffix end:(void(^)())block;


@end
