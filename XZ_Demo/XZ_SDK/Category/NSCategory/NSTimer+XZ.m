//
//  NSTimer+Blocks.m
//
//  Created by Jiva DeVoe on 1/14/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//

#import "NSTimer+XZ.h"

@implementation NSTimer (XZ)
//而scheduled的初始化方法将以默认mode直接添加到当前的runloop中.
+(NSTimer*)J_RunTimer:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock rep:(BOOL)inRepeats{
    void (^block)() = [inBlock copy];
    id ret = [self scheduledTimerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}
//不用scheduled方式初始化的，需要手动addTimer:forMode: 将timer添加到一个runloop中。   [[NSRunLoop currentRunLoop]addTimer:he forMode:NSDefaultRunLoopMode];
+(NSTimer*)JtimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats{
    void (^block)() = [inBlock copy];
    id ret = [self timerWithTimeInterval:inTimeInterval target:self selector:@selector(jdExecuteSimpleBlock:) userInfo:block repeats:inRepeats];
    return ret;
}

+(void)jdExecuteSimpleBlock:(NSTimer *)inTimer;{
    if([inTimer userInfo]){
        void (^block)() = (void (^)())[inTimer userInfo];
        block();
    }
}

/** 暂停 */
-(void)Pause{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate distantFuture]];
}
/** 继续 */
-(void)GoOn{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate date]];
}
/** X秒后继续 */
- (void)GoOn:(NSTimeInterval)interval{
    if (![self isValid]) {
        return ;
    }
    [self setFireDate:[NSDate dateWithTimeIntervalSinceNow:interval]];
}

@end







