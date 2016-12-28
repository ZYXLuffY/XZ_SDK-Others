//
//  NSDictionary+XZ.h
//  BoJueCar.BoJueBusiness_XZ
//
//  Created by XZ on 16/8/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (XZ)

- (NSDictionary*)addValue:(id)value forKey:(NSString *)key;/**< NSMutableDictionary 添加 返回自己 */

/** 创建 xcode @property (nonatomic, ----- *** */
- (void)XZ_propertyCode:(NSString*)modName;

/** 获得的字符串 NSNull nil 至少返回 @@"" */
- (NSString*)str:(NSString*)key;

/** 将NSDictionary转换成url 参数字符串 */
@property (nonatomic,copy,readonly) NSString *URLQueryString;

    
@end
