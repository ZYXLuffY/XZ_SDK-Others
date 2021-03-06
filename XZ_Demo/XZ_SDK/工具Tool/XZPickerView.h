//
//  XZPickerView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/3/28.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface XZPickerView : UIView

@property (nonatomic,strong) UIPickerView *PickV;

typedef void(^LocationBlock)(NSArray*Three,NSString *MixStr);
@property (nonatomic,copy) LocationBlock LocationBlockCall;
/** 显示 城市选择 */
+(void)ShowLocationPick:(LocationBlock)loca;


typedef void(^CusArrBlock)(NSInteger index,NSString *name);
@property (nonatomic,copy) CusArrBlock CusArrBlockCall;
/** 显示 定义的数组 */
+(void)ShowCustomArr:(NSArray*)arr res:(CusArrBlock)Cus;



typedef void(^DateBlock)(NSDate *date);
@property (nonatomic,copy) DateBlock DateBlockCall;
@property (strong, nonatomic) UIDatePicker *datePicker;

/**  显示 时间选择器 */
+(void)ShowDatePicker:(DateBlock)date;
+(void)ShowDatePicker_YM:(DateBlock)date;/**<  显示 时间选择器 显示 年和月 日遮盖了*/
+(void)ShowDatePicker:(DateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max;
- (instancetype)initWithFrame:(CGRect)frame dateComplete:(DateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max;

@end







@interface XZPickerView_City : XZPickerView
- (instancetype)initWithFrame:(CGRect)frame loca:(LocationBlock)loca;

@property (strong, nonatomic) NSDictionary *pickerDic;
@property (strong, nonatomic) NSArray *provinceArray;
@property (strong, nonatomic) NSArray *cityArray;
@property (strong, nonatomic) NSArray *townArray;
@property (strong, nonatomic) NSArray *selectedArray;

@end
