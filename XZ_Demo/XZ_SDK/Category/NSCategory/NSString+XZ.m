
#import "NSString+XZ.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSDate+XZ.h"


@implementation NSURL (XZ)

//评上前缀图片地址的
+ (instancetype)BaseImgPath:(NSString*)path{
    if (![path hasPrefix:@"http://"] && ![path hasPrefix:@"http"]) {
        return  [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",@"http://",path]];
    }
    return  [NSURL URLWithString:[NSString stringWithFormat:@"%@",path]];
}

- (NSDictionary *)params{
    return self.query.parameters;
}

@end

@implementation NSString (XZ)

/** 去空格 stringByReplacingOccurrencesOfString:@" " withString:@"" */
- (NSString *)DelSpace{
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}
//去空格
-(NSString *)DelBlank{
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

//时间戳对应的NSDate
-(NSDate *)Date{
    return [NSDate dateWithTimeIntervalSince1970:self.floatValue];
}

static NSDateFormatter *YYYYMMddHHmmss;
//YYYY-MM-dd HH:mm:ss对应的NSDate
-(NSDate *)Date__YMdHMS{
    if (!YYYYMMddHHmmss) {
        YYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [YYYYMMddHHmmss setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    }
    return [YYYYMMddHHmmss dateFromString:self];
}

static NSDateFormatter *YYYYMMdd;
//YYYY-MM-dd 对应的NSDate
-(NSDate *)Date__YMd{
    if (!YYYYMMdd) {
        YYYYMMdd = [[NSDateFormatter alloc] init];
        [YYYYMMdd setDateFormat:@"YYYY-MM-dd"];
    }
    return [YYYYMMdd dateFromString:self];
}

static NSDateFormatter *YYYYMMddDot;
-(NSDate *)Date__YMd_Dot{
    if (!YYYYMMddDot) {
        YYYYMMddDot = [[NSDateFormatter alloc] init];
        [YYYYMMddDot setDateFormat:@"YYYY.MM.dd"];
    }
    return [YYYYMMddDot dateFromString:self];
}

- (NSString*)timeStampToYMD{
    if (self.length == 0) { return self; }
    if ([self hasPrefix:@"20"] && self.length == 0) { return self;}
    return [NSDate dateWithTimeIntervalSince1970:[self floatValue]/1000].XZ_YYYYMMdd__;
}

//转为 Data
-(NSData*)Data{
    return   [self dataUsingEncoding:NSUTF8StringEncoding];
}
//转为 base64string后的Data
-(NSData *)Base64Data{
    return [[NSData alloc] initWithBase64EncodedString:self options:0];
}
// 转为 base64String
-(NSString*)Base64Str{
    return  [[self dataUsingEncoding:NSUTF8StringEncoding] base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
}
//解 base64为Str 解不了就返回原始的数值
-(NSString*)DecodeBase64{
    NSString *WillDecode = [[NSString alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:self options:0] encoding:NSUTF8StringEncoding];
    return (WillDecode.length != 0) ? WillDecode : self;
}
// 解 为字典 if 有
-(NSDictionary*)JsonDic{
    return [NSJSONSerialization  JSONObjectWithData:self.Data options:NSJSONReadingMutableContainers  error:nil];
}
// 解 为数组 if 有
-(NSArray*)JsonArr{
    return [NSJSONSerialization  JSONObjectWithData:self.Data options:NSJSONReadingMutableContainers  error:nil];
}
//按字符串的，逗号分割为数组
- (NSArray *)CombinArr{
    if ([self hasSuffix:@","]) {
        return [[self substringToIndex:self.length - 1] componentsSeparatedByString:@","];
    }
    return [self componentsSeparatedByString:@","];
    
}
//Request
-(NSURLRequest *)Request{
    return [NSURLRequest requestWithURL:self.url];
}

- (NSURL *)url{
    return [NSURL URLWithString:(NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)self, (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]", NULL,kCFStringEncodingUTF8))];
}

#pragma mark -

//适合的高度 默认 systemFontOfSize:font]
-(CGFloat)__H__:(NSInteger)font W:(CGFloat)W{
    return [self boundingRectWithSize:CGSizeMake(W, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size.height;
}

//适合的宽度 默认 systemFontOfSize:font]
-(CGFloat)__W__:(NSInteger)font H:(CGFloat)H{
    return [self boundingRectWithSize:CGSizeMake(MAXFLOAT, H) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:font]} context:nil].size.width;
}

//真实string的Size
- (CGSize)sizeWithFont:(UIFont *)font maxSize:(CGSize)maxSize{
    NSDictionary *attrs = @{NSFontAttributeName : font};
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrs context:nil].size;
}

//是否包含对应字符
- (BOOL)ContainStr:(NSString *)subString{
    return ([self rangeOfString:subString].location == NSNotFound) ? NO : YES;
}
//拼上字符串
- (NSString *)addStr:(NSString *)string{
    if(!string || string.length == 0){return self;}
    return [self stringByAppendingString:string];
}
- (NSString *)addInt:(int )string{
    return [self stringByAppendingString:@(string).stringValue];
}
//32位MD5加密
-(NSString *)MD5{
    const char *cStr = [self UTF8String];
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result copy];
}
//SHA1加密
-(NSString *)SHA1{
    const char *cStr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cStr length:self.length];
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    return [result copy];
}

-(NSString *)F2f{
    return [NSString stringWithFormat:@"%.2f",[self floatValue]];
}

-(UIImage*)XZ_QRcode{//KMQRCode
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    [filter setDefaults];
    
    [filter setValue:[self dataUsingEncoding:NSUTF8StringEncoding] forKey:@"inputMessage"];
    
    CIImage *outputImage = [filter outputImage];
    CIContext *context1 = [CIContext contextWithOptions:nil];
    CGImageRef cgImage = [context1 createCGImage:outputImage fromRect:[outputImage extent]];
    
    UIImage *image = [UIImage imageWithCGImage:cgImage scale:1 orientation:UIImageOrientationUp];
    
    CGImageRelease(cgImage);
    return image;
}


#pragma mark -

//是否中文
-(BOOL)isChinese{
    NSString *match=@"(^[\u4e00-\u9fa5]+$)";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF matches %@", match];
    return [predicate evaluateWithObject:self];
}
//计算字符串长度 1中文2字符
-(int)textLength{
    float number = 0.0;
    for (int index = 0; index < [self length]; index++) {
        NSString *character = [self substringWithRange:NSMakeRange(index, 1)];
        if ([character lengthOfBytesUsingEncoding:NSUTF8StringEncoding] == 3)  {
            number = number + 2;
        }  else {
            number = number + 1;
        }
    }
    return ceil(number);
}
//限制最大显示长度
-(NSString*)LimitMaxTextShow:(NSInteger)limit{
    NSString *Orgin = [self copy];
    for (NSInteger i = Orgin.length; i > 0; i--) {
        NSString *Get = [Orgin substringToIndex:i];
        if (Get.textLength <= limit) {
            return Get;
        }
    }
    return self;
}


//邮箱格式验证
-(BOOL)validateEmail{
    NSString *emailRegex = @"\\b([a-zA-Z0-9%_.+\\-]+)@([a-zA-Z0-9.\\-]+?\\.[a-zA-Z]{2,6})\\b";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

//手机号格式验证
-(BOOL)checkPhoneNumInput{
    NSString *Phoneend = [self stringByReplacingOccurrencesOfString:@" " withString:@""];
    if ([Phoneend hasPrefix:@"1"] && Phoneend.textLength == 11) {
        return YES;
    }
    return NO;
}

//验证是否字母数字码
-(BOOL)is_A_Z_0_9{
    NSCharacterSet *cs;    cs = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"];
    NSRange specialrang =  [self rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//验证是否ASCII码
-(BOOL)isASCII{
    NSCharacterSet *cs;    cs = [NSCharacterSet characterSetWithCharactersInString:@"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"];
    NSRange specialrang =  [self rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//验证是含本方法定义的 “特殊字符”
-(BOOL)isSpecialCharacter{
    NSCharacterSet *set = [NSCharacterSet characterSetWithCharactersInString:@"@／:;（）¥「」!,.?<>£＂、[]{}#%-*+=_\\|~＜＞$€^•'@#$%^&*()_+'\"/"""];
    NSRange specialrang =  [self rangeOfCharacterFromSet:set];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

// 验证是否是数字
-(BOOL)isNumber{
    NSCharacterSet *cs;    cs = [NSCharacterSet characterSetWithCharactersInString:@"0123456789"];
    NSRange specialrang =  [self rangeOfCharacterFromSet:cs];
    if (specialrang.location != NSNotFound) {
        return YES;
    }
    return NO;
}

//去掉 表情符号
-(NSString *)disableEmoji{
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"[^\\u0020-\\u007E\\u00A0-\\u00BE\\u2E80-\\uA4CF\\uF900-\\uFAFF\\uFE30-\\uFE4F\\uFF00-\\uFFEF\\u0080-\\u009F\\u2000-\\u201f\r\n]" options:NSRegularExpressionCaseInsensitive error:nil];
    NSString *modifiedString = [regex stringByReplacingMatchesInString:self options:0 range:NSMakeRange(0, [self length]) withTemplate:@""];
    return modifiedString;
}

//随机字符串
+ (NSString *)RandomStr:(NSInteger)N{
    if (N == 0) {  N = 1;}
    NSString *sourceString = @"你我他她它上下左右东南西北前后人物无";
    NSMutableString *result = [[NSMutableString alloc] init];
    for (int i = 0; i < N; i++){
        [result appendString:[sourceString substringWithRange:NSMakeRange(rand() % [sourceString length], 1)]];
    }
    return result;
}

#pragma mark - 网站地址 转码 解码

-(BOOL)isNetUrl{
    return [[NSPredicate predicateWithFormat:@"SELF MATCHES %@", @"http+:[^\\s]*"] evaluateWithObject:self];
}

/** 参数 */
- (NSMutableDictionary *)parameters{
    
    NSArray *pairs = [self componentsSeparatedByString:@"&"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
    if (pairs.count) {
        NSString *obj1 = [pairs firstObject];
        if (![obj1 ContainStr:@"?"]) {
            return nil;
        }
    }
    for (NSString *pair in pairs) {
        NSArray *kv = [pair componentsSeparatedByString:@"="];
        NSString *key = [kv objectAtIndex:0];
        if ([key rangeOfString:@"?"].location != NSNotFound) {
            key = [key substringFromIndex:[key rangeOfString:@"?"].location + 1];
        }
        NSString *val = [[kv objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [params setObject:val forKey:key];
    }
    return params;
}

+ (NSString *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters{
    NSMutableString *urlString =[NSMutableString stringWithString:baseString];
    
    NSInteger keyIndex = 0;
    for (id key in parameters) {
        if ([urlString containsString:@"?"]) {
            [urlString appendFormat:@"%@%@=%@",keyIndex == 0 ? @"&" : @"&",key,[parameters valueForKey:key]];
        }else{
            [urlString appendFormat:@"%@%@=%@",keyIndex == 0 ? @"?" : @"&",key,[parameters valueForKey:key]];
        }
        keyIndex++;
    }
    
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

@end
