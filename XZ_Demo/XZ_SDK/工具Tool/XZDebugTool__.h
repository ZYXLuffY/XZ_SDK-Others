//
//  XZDebugTool__.h
//  com.tmbj.qtzUser
//
//  Created by XZ on 16/5/20.
//  Copyright © 2015年 XZ. All rights reserved.
//
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface XZDebugTool__ : NSObject

@property (nonatomic,strong) UIView *Ve_Main;
@property (nonatomic,strong) UIButton *Btn_touch;/**< open close 悬浮小按钮 */;
@property (nonatomic,strong) UIButton *Btn_FLEX;/**< FLEX-Debug 悬浮小按钮 */;
@property (nonatomic,copy  ) NSString  *___test___userId;/**< 测试写死替换用户ID */

/**
 *  添加log
 */
- (void)addDicLog:(NSDictionary*)dic Param:(NSDictionary*)Param API:(NSString*)API;
+ (XZDebugTool__ *)Shared;
- (void)loadDebugView;

@end
