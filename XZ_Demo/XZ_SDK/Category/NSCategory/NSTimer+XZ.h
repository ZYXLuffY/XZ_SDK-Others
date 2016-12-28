//
//  NSTimer+Blocks.h
//
//  Created by Jiva DeVoe on 1/14/11.
//  Copyright 2011 Random Ideas, LLC. All rights reserved.
//
// Copyright (C) 2011 by Random Ideas, LLC
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software andassociated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

// https://github.com/jivadevoe/NSTimer-Blocks

#import <Foundation/Foundation.h>

@interface NSTimer (Blocks)
/** 而scheduled的初始化方法将以默认mode直接添加到当前的runloop中. */
+(NSTimer*)J_RunTimer:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock rep:(BOOL)inRepeats;
/** 不用scheduled方式初始化的，需要手动addTimer:forMode: 将timer添加到一个runloop中。   [[NSRunLoop currentRunLoop]addTimer:he forMode:NSDefaultRunLoopMode]; */
+(NSTimer*)JtimerWithTimeInterval:(NSTimeInterval)inTimeInterval block:(void (^)())inBlock repeats:(BOOL)inRepeats;

/** 暂停 */
- (void)Pause;
/** 继续 */
- (void)GoOn;
/** X秒后继续 */
- (void)GoOn:(NSTimeInterval)interval;


@end
