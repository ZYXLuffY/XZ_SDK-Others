//
//  XZTextField.h
//
//  Created by XZ on 15/8/22.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XZTextField : UITextField

@property (nonatomic,assign)  CGRect moreTouchMargin;/** 给予更多的边界 点击范围 按照UIEdgeInsets 用*/
@property (nonatomic,assign) BOOL noTouchInEditing;/**< 编辑的时候不允许点击 覆盖个透明的view */


/** 右边也加placeHolder */
- (void)addRightPlaceHolder:(NSString *)placeHolder;

/** 认为是电话号码 按电话号码的限制输入 */
@property (nonatomic,assign)  BOOL XZTelePhone;

/** 每隔X 分割一个空格 */
@property (nonatomic,assign)  NSUInteger XZDivision;

/** 纯数字形式的输入 */
@property (nonatomic,assign)  BOOL XZNumber;

/** 数字形式的输入 可以有小数点 点后最多两位数 */
@property (nonatomic,assign)  BOOL XZNumber_dot;

/** 限制特殊字符的输入 */
@property (nonatomic,assign)  BOOL XZDisableSpecialChat;

/** 必须是 ASCII字符 */
@property (nonatomic,assign)  BOOL XZMust_ASCII;

/** 必须是 字母和数字 */
@property (nonatomic,assign)  BOOL XZMust_AZ09;

/** 强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) */
@property (nonatomic,assign)  NSUInteger XZMaxCharactersLength;

/** 强制按text.length长度计算限制文本的最大长度 */
@property (nonatomic,assign)  NSUInteger XZMaxTextLength;


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)textFieldDidBeginEditing:(UITextField *)textField;
- (void)textFieldDidEndEditing:(UITextField *)textField;

@end
