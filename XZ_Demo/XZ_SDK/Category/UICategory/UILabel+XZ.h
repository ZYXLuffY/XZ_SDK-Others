//
//  UILabel+XZ.h
//
//  Created by XZ on 15/10/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (XZ)

/** 创建一个 */
+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)color;
+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)color Alignment:(NSTextAlignment)ment;
+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title Font:(UIFont*)font Color:(UIColor*)color;
+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title Font:(UIFont*)font Color:(UIColor*)color Alignment:(NSTextAlignment)ment;


/** 设置文本 和 字体 */
- (void)setText:(NSString *)text font:(UIFont*)font;

/** 全部有行间距的 */
- (void)paragraph:(CGFloat)para;
- (void)paragraph:(CGFloat)para str:(NSString*)str;

/** 部分字符串 添加删除线 */
-(void)delLineStr:(NSString*)editStr;

/** 修改 部分字符串 字体大小  */
- (void)editFont:(UIFont*)font Str:(NSString*)editStr;
- (void)editFont:(UIFont*)font range:(NSRange)range;

/** 修改 部分字符串 字体颜色  */
- (void)editColor:(UIColor*)color Str:(NSString*)editStr;
- (void)editColor:(UIFont*)color range:(NSRange)range;

/** 修改 部分字符串 属性  */
- (void)addAttribute:(NSString *)name value:(id)value editStr:(NSString*)editStr;


@end
