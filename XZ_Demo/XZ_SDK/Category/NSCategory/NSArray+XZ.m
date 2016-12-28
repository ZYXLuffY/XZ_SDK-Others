
#import "NSArray+XZ.h"
#include <execinfo.h>
#import "NSDictionary+XZ.h"


@implementation NSArray (XZ)

/** 按 字段 给数组排序 */
-(NSArray*)XZ_sortByKey:(NSString*)key Asc:(BOOL)ascend{
    return [self sortedArrayUsingDescriptors:[NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:key ascending:ascend]]];
}


@end


@implementation NSMutableArray (SafeAccess)

-(void)add:(id)obj{
    NSAssert(obj != nil, @"nilwhat");
    if (obj!=nil) {
        [self addObject:obj];
    }
}


@end











