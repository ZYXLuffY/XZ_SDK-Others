//
//  NSDate+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (XZ)

@property (nonatomic,copy,readonly) NSString *timestamp;/**< 字符串时间戳 */
@property(nonatomic,assign,readonly) long    TimeStamp;/**< 长型时间戳 */
@property (nonatomic,strong,readonly) NSDateComponents *components;/**< 时间成分 */

/** 两个时间比较 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate;

/** 根据年份、月份、日期、小时数、分钟数、秒数返回NSDate */
+ (NSDate *)dateWithYear:(NSUInteger)year Month:(NSUInteger)month Day:(NSUInteger)day Hour:(NSUInteger)hour Minute:(NSUInteger)minute Second:(NSUInteger)second;

@property (nonatomic, readonly) NSInteger year; ///< Year component
@property (nonatomic, readonly) NSInteger month; ///< Month component (1~12)
@property (nonatomic, readonly) NSInteger day; ///< Day component (1~31)
@property (nonatomic, readonly) NSInteger hour; ///< Hour component (0~23)
@property (nonatomic, readonly) NSInteger minute; ///< Minute component (0~59)
@property (nonatomic, readonly) NSInteger second; ///< Second component (0~59)
@property (nonatomic, readonly) NSInteger weekday; ///< Weekday component (1~7, first day is based on user setting)
@property (nonatomic, copy,readonly) NSString *weekDesChiness; ///< 今天星期几来着？
@property (nonatomic, readonly) BOOL IsLeapYear; //是否是闰年
@property (nonatomic, readonly) BOOL IsLeapMonth;//是否是29天的2月
- (NSUInteger)weekOfDayInYear;/**< 获取当天是当年的第几周 */
- (NSDate *)oneHourLater;/**< 获取一小时后的时间 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate;/**< 判断与某一天是否为同一天 */
- (BOOL)sameWeekWithDate:(NSDate *)otherDate;/**< 判断与某一天是否为同一周 */
- (BOOL)sameMonthWithDate:(NSDate *)otherDate;/**< 判断与某一天是否为同一月 */


@property (nonatomic,copy,readonly) NSString *XZ_whatTimeAgo;/**< 多久以前呢 ？ 1分钟内 X分钟前 X天前 */
@property (nonatomic,copy,readonly) NSString *XZ_whatTimeBefore;/**< 前段时间日期的描述 上午？？ 星期二 下午？？ */

- (NSDate *)dateInDay:(NSInteger)day;/**< 差 X 天 后的日期  */
- (NSDate *)dateInMonthDay:(NSInteger)month;/**< 差 X 月 后的日期  */

@property (nonatomic,copy,readonly) NSString *XZ_YYYYMMddHHmmss; /**< YYYY-MM-dd HH:mm:ss */
@property (nonatomic,copy,readonly) NSString *XZ_YYYYMMdd;       /**< YYYY.MM.dd */
@property (nonatomic,copy,readonly) NSString *XZ_YYYYMMdd__;     /**< YYYY-MM-dd */
@property (nonatomic,copy,readonly) NSString *XZ_YYYYMM__;       /**< YYYY-MM */
@property (nonatomic,copy,readonly) NSString *XZ_HHmm;           /**< HH:mm */

@property (nonatomic,copy,readonly) NSString *MMddHHmm; /**< MM-dd HH:mm */
@property (nonatomic,copy,readonly) NSString *YYYYMMddHHmmInChinese; /**< YYYY年MM月dd日 HH:mm */
@property (nonatomic,copy,readonly) NSString *YYYYMMddInChinese; /**< YYYY年MM月dd日 */
@property (nonatomic,copy,readonly) NSString *MMddHHmmInChinese; /**< MM月dd日 HH:mm */



+ (NSDateFormatter *)DateF_YYYYMMddHHmmss;
+ (NSDateFormatter *)DateF_YYYYMMdd;
+ (NSDateFormatter *)DateF_YYYYMMdd__;
+ (NSDateFormatter *)DateF_YYYYMM__;
+ (NSDateFormatter *)DateF_MMddHHmm;
+ (NSDateFormatter *)DateF_HHmm;
+ (NSDateFormatter *)DateF_YYYYMMddHHmmInChinese;
+ (NSDateFormatter *)DateF_MMddHHmmInChinese;
+ (NSDateFormatter *)DateF_MMddInChinese;
+ (NSDateFormatter *)DateF_YYYYMMddInChinese;

@end
