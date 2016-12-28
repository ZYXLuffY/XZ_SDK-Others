//
//  NSString+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>



@interface NSURL (XZ)

+(instancetype)BaseImgPath:(NSString*)path;/**< Base评上前缀图片地址的 */
@property (nonatomic, copy, readonly) NSDictionary *params;/**< url参数转字典 */


@end

@interface NSString (XZ)

@property (nonatomic,copy,readonly) NSString *DelBlank;/**< 去空格 stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]]; */
@property (nonatomic,copy,readonly) NSString *DelSpace;/**< 去空格 stringByReplacingOccurrencesOfString:@" " withString:@"" */

@property (nonatomic,copy,readonly) NSURL *url;/**< [NSURL URLWithString:(NSString *)CFB  */

@property (nonatomic,strong,readonly) NSDate *Date;/**<  长时间戳对应的NSDate */
@property (nonatomic,strong,readonly) NSDate *Date__YMd;/**< YYYY-MM-dd 对应的NSDate */
@property (nonatomic,strong,readonly) NSDate *Date__YMd_Dot;/**< YYYY.MM.dd 对应的NSDate */
@property (nonatomic,strong,readonly) NSDate *Date__YMdHMS;/**< YYYY-MM-dd HH:mm:ss对应的NSDate */
@property (nonatomic,copy,readonly) NSString *timeStampToYMD;/**< 字符串时间戳 转到 YYYY-MM-dd格式 这里除1000 */

@property(nonatomic,copy,readonly)  NSData    *Data;/**< 转为 Data */
@property(nonatomic,copy,readonly)  NSData    *Base64Data;/**< 转为 base64string后的Data */
@property(nonatomic,copy,readonly)  NSString  *Base64Str;/**< 转为 base64String */

@property (nonatomic,copy,readonly)   NSString        *DecodeBase64;/**< 解 base64str 为 Str 解不了就返回原始的数值 */
@property (nonatomic,strong,readonly) NSDictionary    *JsonDic;/**<  解 为字典 if 有 */
@property (nonatomic,strong,readonly) NSArray         *JsonArr;/**< 解 为数组 if 有 */

@property (nonatomic,strong,readonly) NSArray *CombinArr;/**< 按字符串的，逗号分割为数组 */
@property (nonatomic,strong,readonly) NSURLRequest *Request;/**< Request */




#pragma mark -

-(CGFloat)__H__:(NSInteger)font W:(CGFloat)W;/**< 适合的高度 默认 font 宽 */
-(CGFloat)__W__:(NSInteger)font H:(CGFloat)H;/**< 适合的宽度 默认 font 高 */
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize;/**< 计算真实文字的Size*/
- (BOOL)ContainStr:(NSString *)subString;/**< 是否包含对应字符 */
- (NSString *)addStr:(NSString *)string;/**< 拼上字符串 */
- (NSString *)addInt:(int )string;/**< 拼上int字符串 */
@property (nonatomic,copy,readonly) NSString *MD5;/**< 32位大写MD5加密 */
@property (nonatomic,copy,readonly) NSString *SHA1;/**< SHA1加密 */
@property (nonatomic,copy,readonly) NSString *F2f;/**< 数字化 保留两位数 [NSString stringWithFormat:@"%.2f",[self floatValue]] */

-(UIImage*)XZ_QRcode;/**< 二维码图片 可以 再用XZ_Resize>>放大一下 */

-(BOOL)isChinese;/**< 是否中文 */
-(int)textLength;/**< 计算字符串长度 1个中文算2 个字符 */
-(NSString*)LimitMaxTextShow:(NSInteger)limit;/**< 限制的最大显示长度字符 */

-(BOOL)validateEmail;/**< 验证邮箱是否合法 */
-(BOOL)checkPhoneNumInput;/**< 验证手机号码合法性 */
-(BOOL)isASCII;/**< 是否ASCII码 */
-(BOOL)is_A_Z_0_9;/**< 验证是否字母数字码 */
-(BOOL)isSpecialCharacter;/**< 是含本方法定义的 “特殊字符” */
-(BOOL)isNumber;/**< 验证是否是数字 */

- (NSString *)disableEmoji;/**< 去掉 表情符号 可能漏了一些 */
+ (NSString *)RandomStr:(NSInteger)length;/**< 随机字符串 */

#pragma mark - 网站地址 转码 解码

@property (nonatomic, assign, readonly) BOOL isNetUrl;/** 是否为链接*/
@property (nonatomic, copy, readonly) NSMutableDictionary *parameters;/**< url参数转字典 */

+ (NSString *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters;/**< 构建参数 */


@end
