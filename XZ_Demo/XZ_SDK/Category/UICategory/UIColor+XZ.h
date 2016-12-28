//
//  UIColor+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kRGB(r,g,b)         [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1]
#define kRGBA(r,g,b,a)      [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:(a)]
#define HexColor(X)         [UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:1.0]
#define HexColorA(X,A)      [UIColor colorWithRed:((float)((X & 0xFF0000) >> 16))/255.0 green:((float)((X & 0xFF00) >> 8))/255.0 blue:((float)(X & 0xFF))/255.0 alpha:A]

@interface UIColor (XZ)

/** 该颜色色差后的颜色 eg. 差别0.618 透明0.9 */
-(UIColor *)XZ_Abe:(CGFloat)abe Alpha:(CGFloat)Alpha;

/** 渐变 */
+(UIColor*)XZ_gradientFromColor:(UIColor*)c1 toColor:(UIColor*)c2 withHeight:(int)height;

+ (instancetype)colorWithHexString:(NSString *)hexStr;

@end
