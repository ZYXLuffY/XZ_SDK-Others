//
//  UILabel+XZ.m
//
//  Created by XZ on 15/10/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "UILabel+XZ.h"

@implementation UILabel (XZ)

+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)color Alignment:(NSTextAlignment)ment{
    UILabel *La = [UILabel Frame:frame Title:title FontS:fonts Color:color];
    La.textAlignment = ment;
    return La;
}

+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)color{
    UILabel *La = [UILabel Frame:frame Title:title Font:[UIFont systemFontOfSize:fonts] Color:color];
    return La;
}

+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title Font:(UIFont*)font Color:(UIColor*)color Alignment:(NSTextAlignment)ment{
    UILabel *La = [UILabel Frame:frame Title:title Font:font Color:color];
    La.textAlignment = ment;
    return La;
}

+(UILabel*)Frame:(CGRect)frame  Title:(NSString*)title Font:(UIFont*)font Color:(UIColor*)color{
    UILabel *La = [[UILabel alloc]initWithFrame:frame];
    La.font = font;
    if (color) {
        La.textColor = color;
    }
    La.text = title;
    La.numberOfLines = 0;
    return La;
}

/** 设置文本 和 字体 */
- (void)setText:(NSString *)text font:(UIFont*)font{
    self.text = text;//[self setText:text];
    self.font = font;//[self setFont:font];
}

/** 全部有行间距的 */
- (void)paragraph:(CGFloat)para{
    [self paragraph:para str:self.text];
}

- (void)paragraph:(CGFloat)para str:(NSString*)str{
    NSMutableAttributedString * attribute = [[NSMutableAttributedString alloc] initWithString:str];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle setLineSpacing:para];
    paragraphStyle.alignment = self.textAlignment;
    [attribute addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, attribute.length)];
    [self setAttributedText:attribute];
}

/** 部分字符串 添加删除线 */
-(void)delLineStr:(NSString*)editStr{
    [self addAttribute:NSStrikethroughStyleAttributeName value:@(NSUnderlinePatternSolid | NSUnderlineStyleSingle) editStr:editStr];
}

/** 修改 部分字符串 字体大小  */
- (void)editFont:(UIFont*)font Str:(NSString*)editStr{
    [self addAttribute:NSFontAttributeName value:font editStr:editStr];
}

- (void)editFont:(UIFont*)font range:(NSRange)range{
    [self addAttribute:NSFontAttributeName value:font range:range];
}

/** 修改 部分字符串 字体颜色  */
- (void)editColor:(UIColor*)color Str:(NSString*)editStr{
    [self addAttribute:NSForegroundColorAttributeName value:color editStr:editStr];
}

- (void)editColor:(UIFont*)color range:(NSRange)range{
    [self addAttribute:NSForegroundColorAttributeName value:color range:range];
}

/** 修改 部分字符串 属性  */
- (void)addAttribute:(NSString *)name value:(id)value editStr:(NSString*)editStr{
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    NSRange range = [self.text rangeOfString:editStr];
    if (range.location == NSNotFound) {
        return;
    }
    
    [attribute addAttribute:name value:value range:range];
    [self setAttributedText:attribute];
}

/** 修改 部分字符串 属性  */
- (void)addAttribute:(NSString *)name value:(id)value range:(NSRange)range{
    if (range.location + range.length > self.text.length) {
        return;
    }
    
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    [attribute addAttribute:name value:value range:range];
    [self setAttributedText:attribute];
}



@end
