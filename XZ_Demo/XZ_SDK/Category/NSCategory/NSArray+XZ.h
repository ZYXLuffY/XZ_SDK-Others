//
//  NSArray+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NSDictionary+XZ.h"

@interface NSArray (XZ)

/** 按 字段 给数组排序 */
-(NSArray*)XZ_sortByKey:(NSString*)key Asc:(BOOL)ascend;

@end


@interface NSMutableArray(SafeAccess)

/** addObject */
-(void)add:(id)obj;


@end




