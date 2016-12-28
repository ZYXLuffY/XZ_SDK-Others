//
//  GODiagnoseCommon.h
//  GOVehicleDiagnose
//
//  Created by allen on 14/12/26.
//  Copyright (c) 2014年 zhengjinbo. All rights reserved.
//

/*NOTE:
1. 此文件对外公开
2. 此文件专门用于定义诊断各个模块使用的常量，类型，宏定义
*/

#ifndef GOVehicleDiagnose_GODiagnose_h
#define GOVehicleDiagnose_GODiagnose_h

#pragma mark - 通讯相关
/*!
 @brief 设备类型
 */
typedef NS_ENUM(NSInteger,GOPeripheralType){
    GOPeripheralTypeBluetooth = 1000, //蓝牙
    GOPeripheralTypeBLE,              //低功耗蓝牙，蓝牙4.0
    GOPeripheralTypeWiFi,             //WIFI
    GOPeripheralTypeNet,              //网络
    GOPeripheralTypeOther             //其他类型设备
};

typedef NS_ENUM(NSInteger, GOBusinessMode) {
    GOBusinessModeInspect = 0,  //体检模式
    GOBusinessModeWIFI,         //WIFI模式
    GOBusinessModeMonitor,      //监控模式
};

#pragma mark - 解压入口参数key
extern const NSString *kGOConfigUnzipParamZipPath;    //必须的参数，诊断配置库压缩包的路径，对应的value类型为 NSString
//extern const NSString *kGOConfigUnzipParamSeriaNo;  //必须的参数，接头序列号，对应的value 类型为 NSString
extern const NSString *kGOConfigUnzipParamTUID;       //必须得参数，外部提供的具有唯一性的id, 类型为NSString
static NSString *DiagnoseDataReadyNotification = @"DiagnoseDataReadyNotification";                    // 实时监控通知名称
static NSString *NowTimeStreamDataDisconnectNotification = @"NowTimeStreamDataDisconnectNotification";// 实时监控通知名称

#pragma mark - 错误相关
#define GOLO_BASE_URL_STR @"http://www.cnlaunch.com/Diag" //error domin
typedef NS_ENUM(NSUInteger, GODiagErrorCode) {
    GODiagErrorCodeNoConnectedDevice,          //没有接头
    GODiagErrorCodeNoLinkWithConnector,        //Wifi或蓝牙未连接
    GODiagErrorCodeNoConfigFile,               //无配置文件
    GODiagErrorCodeNoiDiagLib,                 //无诊断库
    GODiagErrorCodeLinkDiagFail,               //接头与诊断建立连接失败
    GODiagErrorCodeDiagnosis,                  //已有一个诊断正在运行
    GODiagErrorCodeException,                  //诊断过程中，诊断程序内部发生异常
};
#define GOLO_CONFIG_URL_STR @"http://www.cnlaunch.com/Config" //config domin
typedef NS_ENUM(NSUInteger, GOConfigErrorCode) {
    GOConfigErrorCodeParamError,                //参数错误
    GOConfigErrorCodeNoZipFile,                 //没有压缩文件
    GOConfigErrorCodeNoSubZipFile,              //没有子压缩文件
    GOConfigErrorCodeNoDpuSysIni,               //没有DPUSYS.INI文件
    GOConfigErrorCodeNoEOBD2ConfigFile,         //没有EOBD2文件
    GOConfigErrorCodeUnzipFilePathError,        //解压后文件路径格式错误
};

#pragma mark -- 数据解析

#pragma mark -- 体检部分
//诊断返回数据的各个key
extern const NSString *kGODiagMode;               //诊断类型,      对应的value 类型为NSNumber
extern const NSString *kGODiagVersion;            //诊断版本,      对应的value 类型为NSString
extern const NSString *kGODiagFaultCodeCount;     //故障码个数,    对应的value 类型为NSNumber
extern const NSString *kGODiagDataStreamCount;    //数据流个数,    对应的value 类型为NSNumber
extern const NSString *kGODiagFaultCodeList;      //故障码列表,    对应的value 类型为NSArray
extern const NSString *kGODiagDataStreamList;     //数据流列表,    对应的value 类型为NSArray

//故障码列表
extern const NSString *kGODiagFaultCodeSystem;    //故障码所属系统， 对应的value 类型为 NSString
extern const NSString *kGODiagFaultCodeDetail;    //故障码详细描述， 对应的value 类型为 NSArray

//故障码详情
extern const NSString *kGODiagFaultCodeId;        //故障码id,    对应的value 类型为NSString
extern const NSString *kGODiagFaultCodeName;      //故障码名称,   对应的value 类型为NSString
extern const NSString *kGODiagFaultCodeDesc;      //故障码描述，  对应的value 类型为NSString
extern const NSString *kGODiagFaultCodeState;     //故障码状态，  对应的value 类型为NSString

//数据流列表
extern const NSString *kGODiagDataStreamId;       //数据流id,      对应的value 类型为 NSString
extern const NSString *kGODiagDataStreamName;     //数据流名称，    对应的value 类型为 NSString
extern const NSString *kGODiagDataStreamValue;    //数据流值，      对应的value 类型为 NSString
extern const NSString *kGODiagDataStreamUnit;     //数据流单位,     对应的value 类型为 NSString

//进度条
extern const NSString *kGODiagProgressPercentage; //进度条百分比 对应的value 类型为 NSNumber
extern const NSString *kGODiagProgressTitle;      //进度条的标题，对应的value 类型为 NSString
extern const NSString *kGODiagProgressContent;    //进度条的内容，对于的value 类型为 NSString


#pragma mark -- 清码


#pragma mark -- 本地诊断



#pragma mark -- 远程诊断


#endif
