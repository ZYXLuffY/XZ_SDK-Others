//
//  GOInspectionDiag.h
//  golo
//
//  Created by Launch Tech Co.,Ltd on 10/27/14.
//  Copyright (c) 2014 LAUNCH. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GODiagnoseCommon.h"

// 体检协议
@protocol GOInspectionDiagDelegate <NSObject>
@optional
- (void)inspectionWillConectDiag;                       // 将与诊断服务建立连接
- (void)inspectioncConectDiagFinsh;                     // 与诊断服务完成建立连接
- (void)inspectionDiagScanProcess:(NSDictionary *)data; // 体检或清码过程中返回进度信息
- (void)inspectionDiagResult:(NSDictionary *)data;      // 体检或清码结束返回相应结果，体检返回故障码和数据流数据，清码返回清除故障码的结果
- (void)inspectionDiagError:(NSError *)error;           // 体检或清码发生错误
@end

// 体检会话类
@interface GOInspectionDiag : NSObject

@property (nonatomic,weak) id<GOInspectionDiagDelegate> delegate;
@property (nonatomic,assign) GOPeripheralType type;

/**
 *  实例化体检对象
 */
+ (GOInspectionDiag *) shareInstance;

/**
 *  体检或清码开始
 *
 *  @TUID 第三方的入口ID，必须是唯一的
 */
- (void)inspectionStart:(NSString *)TUID;

/**
 *  快速体检开始
 *
 *  @param snKey        序列号必传
 *  @param EOBDPth      EOBD文件的存放路径 必传
 */
- (void)inspectionTypeForOBDStart:(NSString *)snKey
                          EOBDPth:(NSString *)EOBDPth;

/**
 *  全车体检开始
 *
 *  @param snKey        序列号必传
 *  @param carBrandPath 车型文件的存放路径  必传
 *  @param EOBDPth      EOBD文件的存放路径 必传
 */
- (void)inspectionTypeForAllStart:(NSString *)snKey
                     carBrandPath:(NSString *)carBrandPath
                          EOBDPth:(NSString *)EOBDPth;
/**
 *  清码开始
 *
 *  @param snKey        序列号必传
 *  @param carBrandPath 车型文件的存放路径（如果没有车型文件传@"" 或者nil）
 *  @param EOBDPth      EOBD文件的存放路径 必传
 */
- (void)oneKeyClearReportHandle:(NSString *)snKey
                   carBrandPath:(NSString *)carBrandPath
                        EOBDPth:(NSString *)EOBDPth;
/**
 *  体检或清码取消
 */
- (void)inspectionCancel;

@end
