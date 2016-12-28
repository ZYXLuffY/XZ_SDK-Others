//
//  NSObject+Property.h
//  IOS-Categories
//
//  Created by Jakey on 14/12/20.
//  Copyright (c) 2014年 www.skyfox.org. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (XZ)

@property (nonatomic,assign,readonly) BOOL isArray;/**< 是否真是数组 [self isKindOfClass:[NSArray class]] */
@property (nonatomic,assign,readonly) BOOL isDict;/**< 是否真是字典 [self isKindOfClass:[NSDictionary class]] */

@property (nonatomic,copy,readonly) NSString *JsonStr;/**< 转为 JsonStr */

+ (BOOL)swizzleInstanceMethod:(SEL)originalSel with:(SEL)newSel;
+ (BOOL)swizzleClassMethod:(SEL)originalSel with:(SEL)newSel;


- (NSString*)XZ_DebugDescription;/**< 对应的描述 */

- (NSDictionary *)propertyDictionary;/**< 属性值和列表 */

+ (NSArray *)ClassPropertyList;/**< 属性集合 */

- (void)propertyList_methodList_ivarList;/**< 各种属性 */

+ (BOOL)isNULL_Obj;

@end
