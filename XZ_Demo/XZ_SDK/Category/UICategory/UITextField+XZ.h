//
//  UITextField+XZ.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/7/13.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (extension)

/**
 *  修改textField中的文字
 */
- (void)changetext:(NSString *)text;
- (NSRange) selectedRange;
- (void) setSelectedRange:(NSRange) range;

@end
