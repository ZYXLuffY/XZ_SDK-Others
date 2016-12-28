
#import "NSDate+XZ.h"

@implementation NSDate (XZ)


/** 字符时间戳 */
-(NSString *)timestamp{
    return [@([self timeIntervalSince1970]).stringValue copy];
}

-(long)TimeStamp{
    return [self timeIntervalSince1970];
}

/** 时间成分 */
-(NSDateComponents *)components{
    return [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitWeekday | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:self];
}

/** 两个时间比较 */
+(NSDateComponents *)dateComponents:(NSCalendarUnit)unit fromDate:(NSDate *)fromDate toDate:(NSDate *)toDate{
    return [[NSCalendar currentCalendar] components:unit fromDate:fromDate toDate:toDate options:0];
}

/** 根据年份、月份、日期、小时数、分钟数、秒数返回NSDate */
+ (NSDate *)dateWithYear:(NSUInteger)year Month:(NSUInteger)month Day:(NSUInteger)day Hour:(NSUInteger)hour  Minute:(NSUInteger)minute  Second:(NSUInteger)second{
    NSDateComponents *dateComponents = [[NSCalendar currentCalendar] components:NSCalendarUnitYear | NSCalendarUnitMonth | NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute | NSCalendarUnitSecond fromDate:[NSDate date]];
    dateComponents.year = year;
    dateComponents.month = month;
    dateComponents.day = day;
    dateComponents.hour = hour;
    dateComponents.minute = minute;
    dateComponents.second = second;
    
    return [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
}
/** NSDate对应的年份 */
- (NSInteger)year{
    return [self components].year;
}

/** NSDate对应的月份 */
- (NSInteger)month{
    return [self components].month;
}

/** NSDate对应的日期 多少号 */
- (NSInteger)day{
    return [self components].day;
}

/** NSDate对应的小时数 */
- (NSInteger)hour{
    return [self components].hour;
}

/** NSDate对应的分钟数 */
- (NSInteger)minute{
    return [self components].minute;
}

/** NSDate对应的秒数 */
- (NSInteger)second{
    return [self components].second;
}

/** NSDate对应的星期 */
- (NSInteger)weekday{
    return [self components].weekday;
}

/** 获取当天是当年的第几周 */
- (NSUInteger)weekOfDayInYear{
    return [[NSCalendar currentCalendar] ordinalityOfUnit:NSCalendarUnitWeekOfYear inUnit:NSCalendarUnitYear forDate:self];
}

/** 获取一小时后的时间 */
- (NSDate *)oneHourLater{
    return [NSDate dateWithTimeInterval:3600 sinceDate:self];
}

/** 判断与某一天是否为同一天 */
- (BOOL)sameDayWithDate:(NSDate *)otherDate{
    return  (self.year == otherDate.year && self.month == otherDate.month && self.day == otherDate.day);
}

/** 判断与某一天是否为同一周 */
- (BOOL)sameWeekWithDate:(NSDate *)otherDate{
    return  (self.year == otherDate.year  && self.month == otherDate.month && self.weekOfDayInYear == otherDate.weekOfDayInYear);
}

/** 判断与某一天是否为同一月 */
- (BOOL)sameMonthWithDate:(NSDate *)otherDate{
    return (self.year == otherDate.year && self.month == otherDate.month);
}

- (BOOL)IsLeapYear {
    NSUInteger year = self.year;
    return ((year % 400 == 0) || ((year % 100 != 0) && (year % 4 == 0)));
}

- (BOOL)IsLeapMonth {
    return [[[NSCalendar currentCalendar] components:NSCalendarUnitQuarter fromDate:self] isLeapMonth];
}


/** 多久以前呢 ？ 1分钟内 X分钟前 X天前 */
-(NSString *)XZ_whatTimeAgo{
    if (self == nil) {
        return @"";
    }
    NSTimeInterval  timeInterval = - [self timeIntervalSinceNow];
    long temp = 0; NSString *result;
    if (timeInterval < 60) {result = [NSString stringWithFormat:@"1分钟内"]; }
    else if((temp = timeInterval/60) <60){result = [NSString stringWithFormat:@"%ld分钟前",temp]; }
    else if((temp = temp/60) <24){result = [NSString stringWithFormat:@"%ld小时前",temp];}
    else if((temp = temp/24) <30){result = [NSString stringWithFormat:@"%ld天前",temp]; }
    else if((temp = temp/30) <12){ result = [NSString stringWithFormat:@"%ld个月前",temp]; }
    else{ temp = temp/12;result = [NSString stringWithFormat:@"%ld年前",temp]; }
    return  result;
}

//凌晨(3：00—6：00) 早上(6：00—8：00) 上午(8：00—11：00) 中午(11：00—14：00) 下午(14：00—19：00) 晚上(19：00—24：00)  深夜0：00—3：00) XZ准则
/** 前段时间日期的描述 上午？？ 星期二 下午？？ */
-(NSString *)XZ_whatTimeBefore{
    if (self == nil) {
        return @"";
    }
    NSDate  *yesterday = [[NSDate date] dateByAddingTimeInterval: - (24 * 60 * 60)];
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSUInteger unitFlags = /*NSCalendarUnitYear| NSCalendarUnitMonth | NSCalendarUnitHour |NSCalendarUnitMinute | */NSCalendarUnitDay;
    NSDateComponents *Compareday = [calendar components:unitFlags fromDate:self];
    NSDateComponents *Yesterday = [calendar components:unitFlags fromDate:yesterday];
    NSDateComponents *Today = [calendar components:unitFlags fromDate:[NSDate date]];
    
    NSDateFormatter* F_Mon_Day=[[NSDateFormatter alloc]init];
    [F_Mon_Day setDateFormat:@"MM-dd"];
    NSDateFormatter* F_H_M=[[NSDateFormatter alloc]init];
    [F_H_M setDateFormat:@"HH:mm"];
    NSString *S_H = [[F_H_M stringFromDate:self] substringWithRange:NSMakeRange(0, 2)];
    NSString *S_M = [[F_H_M stringFromDate:self] substringWithRange:NSMakeRange(3, 2)];
    NSString *sunormoon = @"";
    NSInteger Hour = [S_H integerValue];
    
    if (Hour >= 3 && Hour < 6) {
        sunormoon = @"凌晨";
    }else if (Hour >= 6 && Hour < 8){
        sunormoon = @"早上";
    }else if (Hour >= 8 && Hour < 11){
        sunormoon = @"上午";
    }else if (Hour >= 11 && Hour < 14){
        sunormoon = @"中午";
    }else if (Hour >= 14 && Hour < 19){
        sunormoon = @"下午";
    }else if (Hour >= 19 /*&& Hour < 23*/){
        sunormoon = @"晚上";
    }else if (Hour >= 0 && Hour < 3){
        sunormoon = @"深夜";
    }
    
    if (Hour > 12) {
        Hour = Hour - 12;
    }
    
    NSString *Mon_Day= [F_Mon_Day stringFromDate:self];
    NSString *Hou_Min = [NSString stringWithFormat:@"%@ %d:%@",sunormoon,(int)Hour,S_M];
    NSString *Week = [self weekDesChiness];
    NSTimeInterval oldtime= [self timeIntervalSince1970];
    NSTimeInterval nowTime = [[NSDate date] timeIntervalSince1970];
    
    if ([[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:self] year] != [[[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitYear fromDate:[NSDate date]] year]) {
        [F_Mon_Day setDateFormat:@"YYYY-MM-dd"];
        Mon_Day= [F_Mon_Day stringFromDate:self];
        
    }
    
    if ([Today day] == [Compareday day]) {
        return [NSString stringWithFormat:@"%@",Hou_Min];
    }
    
    if ([Yesterday day] == [Compareday day]) {
        return [NSString stringWithFormat:@"昨天  %@",Hou_Min];
    }
    
    if ((nowTime - oldtime)/60/60/24 >= 7){
        return [NSString stringWithFormat:@"%@   %@",Mon_Day,Hou_Min];
    }
    
    if ((nowTime - oldtime)/60/60/24 < 7){
        return [NSString stringWithFormat:@"%@  %@",Week,Hou_Min];
    }
    
    return [NSString stringWithFormat:@"%@   %@",Mon_Day,Hou_Min];
}

/** 今天星期几来着？ */
-(NSString *)weekDesChiness{
    NSDateComponents *componets = [[NSCalendar autoupdatingCurrentCalendar] components:NSCalendarUnitWeekday fromDate:self];
    return [@{@"1" : @"星期日",@"2" : @"星期一",@"3" : @"星期二",@"4" : @"星期三",@"5" : @"星期四",@"6" : @"星期五",@"7" : @"星期六"} objectForKey:@([componets weekday])];
}

/** 差 X 天 后的日期  */
- (NSDate *)dateInDay:(NSInteger)day{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.day = day;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}

/** 差 X 月 后的日期  */
- (NSDate *)dateInMonthDay:(NSInteger)month{
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.month = month;
    return [[NSCalendar currentCalendar] dateByAddingComponents:dateComponents toDate:self options:0];
}


- (NSString *)XZ_YYYYMMddHHmmss{return [[NSDate DateF_YYYYMMddHHmmss] stringFromDate:self];}
- (NSString *)XZ_YYYYMMdd{return [[NSDate DateF_YYYYMMdd] stringFromDate:self];}
- (NSString *)XZ_YYYYMMdd__{return [[NSDate DateF_YYYYMMdd__] stringFromDate:self];}
- (NSString *)XZ_YYYYMM__{  return [[NSDate DateF_YYYYMM__] stringFromDate:self];}
- (NSString *)MMddHHmm{ return [[NSDate DateF_MMddHHmm] stringFromDate:self];}
- (NSString *)XZ_HHmm{  return [[NSDate DateF_HHmm] stringFromDate:self];}
- (NSString *)YYYYMMddHHmmInChinese{return [[NSDate DateF_YYYYMMddHHmmInChinese] stringFromDate:self];}
- (NSString *)MMddHHmmInChinese{ return [[NSDate DateF_MMddHHmmInChinese] stringFromDate:self];}
- (NSString *)YYYYMMddInChinese{  return [[NSDate DateF_YYYYMMddInChinese] stringFromDate:self];}

+ (NSDateFormatter *)DateF_YYYYMMddHHmmss{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)DateF_YYYYMMdd{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmss;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmss) {
        staticDateFormatterWithFormatYYYYMMddHHmmss = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmss setDateFormat:@"yyyy.MM.dd"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmss;
}

+ (NSDateFormatter *)DateF_YYYYMMdd__{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMdd__;
    if (!staticDateFormatterWithFormatYYYYMMdd__) {
        staticDateFormatterWithFormatYYYYMMdd__ = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMdd__ setDateFormat:@"yyyy-MM-dd"];
    }
    
    return staticDateFormatterWithFormatYYYYMMdd__;
}

+ (NSDateFormatter *)DateF_YYYYMM__{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMM__;
    if (!staticDateFormatterWithFormatYYYYMM__) {
        staticDateFormatterWithFormatYYYYMM__ = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMM__ setDateFormat:@"yyyy-MM"];
    }
    
    return staticDateFormatterWithFormatYYYYMM__;
}


+ (NSDateFormatter *)DateF_MMddHHmm{
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmm;
    if (!staticDateFormatterWithFormatMMddHHmm) {
        staticDateFormatterWithFormatMMddHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmm setDateFormat:@"MM-dd HH:mm"];
    }
    
    return staticDateFormatterWithFormatMMddHHmm;
}

+ (NSDateFormatter *)DateF_HHmm{
    static NSDateFormatter *staticDateFormatterWithFormatHHmm;
    if (!staticDateFormatterWithFormatHHmm) {
        staticDateFormatterWithFormatHHmm = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatHHmm setDateFormat:@"HH:mm"];
    }
    
    return staticDateFormatterWithFormatHHmm;
}


+ (NSDateFormatter *)DateF_YYYYMMddHHmmInChinese{
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
    if (!staticDateFormatterWithFormatYYYYMMddHHmmssInChines) {
        staticDateFormatterWithFormatYYYYMMddHHmmssInChines = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddHHmmssInChines setDateFormat:@"yyyy年MM月dd日 HH:mm"];
    }
    
    return staticDateFormatterWithFormatYYYYMMddHHmmssInChines;
}
+ (NSDateFormatter *)DateF_YYYYMMddInChinese{
    
    static NSDateFormatter *staticDateFormatterWithFormatYYYYMMddInChines;
    if (!staticDateFormatterWithFormatYYYYMMddInChines) {
        staticDateFormatterWithFormatYYYYMMddInChines = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatYYYYMMddInChines setDateFormat:@"yyyy年MM月dd日"];
    }
    return staticDateFormatterWithFormatYYYYMMddInChines;
}

+ (NSDateFormatter *)DateF_MMddHHmmInChinese{
    static NSDateFormatter *staticDateFormatterWithFormatMMddHHmmInChinese;
    if (!staticDateFormatterWithFormatMMddHHmmInChinese) {
        staticDateFormatterWithFormatMMddHHmmInChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddHHmmInChinese setDateFormat:@"MM月dd日 HH:mm"];
    }
    
    return staticDateFormatterWithFormatMMddHHmmInChinese;
}

+ (NSDateFormatter *)DateF_MMddInChinese{
    static NSDateFormatter *staticDateFormatterWithFormatMMddInChinese;
    if (!staticDateFormatterWithFormatMMddInChinese) {
        staticDateFormatterWithFormatMMddInChinese = [[NSDateFormatter alloc] init];
        [staticDateFormatterWithFormatMMddInChinese setDateFormat:@"MM月dd日"];
    }
    
    return staticDateFormatterWithFormatMMddInChinese;
}

@end
