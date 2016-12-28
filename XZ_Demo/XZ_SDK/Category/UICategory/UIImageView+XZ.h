//
//  UIImageView+XZ.h
//
//
//  Created by XZ on 15/10/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (XZ)

+ (instancetype)Frame:(CGRect)frame imgName:(NSString*)imgName;/**< UIImageView */

+ (instancetype)Frame:(CGRect)frame image:(UIImage*)image;/**< UIImageView */

+ (instancetype)Frame:(CGRect)frame mode:(UIViewContentMode)mode;/**< UIImageView */

/** 加个点击显示 放大图片 */
- (void)tapToshowImg;

@end
