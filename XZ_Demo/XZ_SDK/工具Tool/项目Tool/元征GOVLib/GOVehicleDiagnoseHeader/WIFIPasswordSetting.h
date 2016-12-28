//
//  WIFIPasswordSetting.h
//
//  Created by launch on 14-4-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

typedef NS_ENUM(NSInteger, WIFIOperationError) {
    WIFIOperationErrorNotMatch,
    WIFIOperationErrorSetFailed,
    WIFIOperationErrorOther
};

typedef NS_ENUM(NSInteger, GOSocketMode) {
    GOSocketModeWIFIManager = 1,  //WIFI模式(WIFI密码名称修改，休眠时间设置)
    GOSocketModeMonitor,          //监控模式(用于实时监控)
};

@interface WIFIPasswordSetting : NSObject

/**
 *  打开WIFI管理的sockect
 *
 *  @param socketMode socket模式
 *  @param success    打开WIFIsocket成功
 *  @param fail       打开WIFIsocket失败
 */
+ (void)openWIFISocketwithMode:(GOSocketMode )socketMode
                       success:(void (^)())success
                          fail:(void (^)())fail;

/**
 *  获取WIFI名称和WIFI密码
 *
 *  @param serial_no  智能终端序列号
 *  @param success    获取成功回调参数，包含WIFI名称和密码等信息
 *  @param fail       获取失败回调参数，包含错误信息
 */
+(void)getWIFINameAndPass:(NSString *)serial_no
                  success:(void (^)(NSDictionary *wifidic))success
                  failure:(void (^)(NSError * error))fail;
/**
 *  修改WIFI名称和密码
 *
 *  @param wifiname   WIFI名称（不少于8个字符）
 *  @param wifiPassw  WIFI密码（不少于8个字符）
 *  @param serial_no  智能终端序列号
 *  @param success    设置成功
 *  @param fail       设置失败回调参数，包含错误信息
 */
+ (void)changeWIFIPasswordAndName:(NSString *)wifiname
                        wifiPassw:(NSString *)wifiPassw
                        serial_no:(NSString *)serial_no
                          success:(void (^)())success
                          failure:(void (^)(NSError * error))fail;
/**
 *  设置WIFI为开放模式（不需要输入密码）
 *
 *  @param serial_no  智能终端序列号
 *  @param success    设置成功
 *  @param fail       设置失败回调参数，包含错误信息
 */
+(void)passwordWithNone:(NSString *)serial_no
                success:(void (^)())success
                failure:(void (^)(NSError * error))fail;

/**
 *  验证接头序列号
 *
 *  @param serial_no  智能终端序列号
 *  @param success    验证成功
 *  @param fail       验证失败回调参数，包含错误信息
 */
+(void)CheckSerialNo:(NSString *)serial_no
             success:(void (^)())success
             failure:(void (^)(NSError * error))fail;

/**
 *  查询接头休眠时间
 *
 *  @param serial_no  智能终端序列号
 *  @param success    获取成功回调参数，包含查询到的接头休眠时间
 *  @param fail       获取失败回调参数，包含错误信息
 */
+(void)QueryConnectorSleepTime:(NSString *)serial_no
                       success:(void (^)(NSInteger time))success
                          fail:(void(^)())fail;

/**
 *  设置接头休眠时间
 *
 *  @param serial_no  智能终端序列号
 *  @paramserial_no  接头休眠时间（分钟）
 *  @param success    设置成功
 *  @param fail       设置失败
 */
+(void)setConnectorSleepTime:(NSString *)serial_no
                      minute:(int )minute
                     success:(void(^)())success
                        fail:(void(^)())fail;

/**
 *  设置通讯监控数据流模式
 */
+ (void)setMonitorCommunicationMode;

/**
 *  获取实时监控数据
 *
 *  @return return value 数组
 */
+ (NSArray *)getNowTimeMonitorDataStream;

/**
 *  关闭sockect
 */
+ (void)closeWIFISocket;


@end

