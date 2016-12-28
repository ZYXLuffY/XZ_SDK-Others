//
//  QTZ_KeyboardInputView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/7/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UITextField+XZ.h"

#define QTZ_KeyboardInputViewTF_Km   @" Km"//固定后缀

typedef NS_ENUM(NSUInteger, QTZkeyboarViewType) {
    QTZkeyboarViewTypeNumber = 0,/**< 数字键盘 */
    QTZkeyboarViewTypeDatePicker,/**< 时间选择 */
    QTZkeyboarViewTypeCarAddress,/**< 车牌前缀 */
    QTZkeyboarViewTypeCarPlate,/**< 车牌号码 */
};


@interface QTZ_KeyboardInputView : UIView

@property (strong, nonatomic) UIDatePicker *datePicker;
typedef void(^dateBlock)(NSDate *date);


/** 自定的键盘那个inputview */
- (instancetype)initWithTf:(UITextField*)tf viewH:(CGFloat)Viewheight leftDes:(NSString*)leftDes arrowX:(CGFloat)arrowX type:(QTZkeyboarViewType)type date:(dateBlock)dateBlock;



@end

