//
//  QTZStatistics.h
//  com.tmbj.qtzUser_JE
//
//  Created by JE on 16/8/23.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 
 ⚫️ = 专门按钮点击统计
 🔵 = 分享统计 （点击就算）
 🔴 = 还没搞完
 
 
 --------- 首页              ---友盟统计事件ID---
 进入车险购买                 insIntro
 洗车服务列表                 xiche
 点击美容服务                 meirong
 点击保养服务                 baoyang
 点击维修服务                 weixiu
 点击装潢服务                 zhuanghuang
 点击救援服务                 jiuyuan
 点击保养手册                 BaoYang_TimeLineVC
 
 
 --------- 广告活动
 进入认证行驶证                Jiashi_UploadActivityVC
 进入签到活动                  signInfo
 进入免费救援页                insuranceRescue
 进入购买智能终端页             QTZ_BuyOBDVC
 进入礼品卡页面                QTZgiftCardVC
 进入流量充值活动页             FlowInChargeVC
 
 
 --------- 我的
 点击报险救援                 BaoXianJiuYuanTVC
 点击联系我们                 ContactUsVC
 点击常见问题                 appfaq
 
 
 --------- 爱车
 点击行程足迹                 DriveRecordFootMarkVC
 点击行程足迹---足迹项 ⚫️      DriveRecordFootMarkVC_zuji_Action
 点击车辆报告                 CarReportTVC
 点击爱车位置                 MyCarLocationVC
 点击用车统计                 🔴
 点击实时车况                 CurrentCarConditionVC
 点击一键清码                 CleanFuckingCodeTVC
 点击提醒设置                 OBDVoiceMsgNotifyVC
 点击爱车检测                 CarTestVC
 点击快速体检 ⚫️              catTest_quick_Action
 点击全车体检 ⚫️              catTest_all_Action
 
 
 
 
 --------- 分享 🔵
 擎天助介绍页分享           Statistics_Share_QTZIntro
 车友圈分享                Statistics_Share_QTZCheyouquan
 我的足迹分享               Statistics_Share_footmark
 车检报告分享               Statistics_Share_CarReportDetail
 清码报告分享               Statistics_Share_cleanCodeReport
 爱车位置分享               Statistics_Share_MyCarLocationVC
 好友代付分享               Statistics_Share_wxPayForFriend
 签到活动分享               Statistics_Share_signInfo
 
 ---------  菜单栏
 点击切换车辆 ⚫️            menu_ChangeCar_Action
 
 
 
 
 --------- 结构化数据统计
 事件名称             1             2          3                4              5
 签到领券活动     进入签到活动页 	点击签到	  签到_领券成功	  签到_点击分享     签到_分享成功
 1                   2                    3
 认证行驶证活动	进入认证行驶证活动页	行驶证_点击我要参与     	行驶证上传成功
 
 */

#pragma mark - 部分按钮点击事件 单独统计  专门按钮点击统计 ⚫️
static  NSString *catTest_all_Action   = @"catTest_all_Action";/**< 点击全车体检 */
static  NSString *catTest_quick_Action = @"catTest_quick_Action";/**< 点击快速体检 */
static  NSString *DriveRecordFootMarkVC_zuji_Action = @"DriveRecordFootMarkVC_zuji_Action";/**< 点击行程足迹---足迹项 */
static  NSString *menu_ChangeCar_Action = @"menu_ChangeCar_Action";/**<  点击切换车辆时记录 */

#pragma mark - 分享事件统计 🔵

static  NSString *Statistics_Share_footmark   = @"Statistics_Share_footmark";/**< 我的足迹分享 */
static  NSString *Statistics_Share_CarReportDetail   = @"Statistics_Share_CarReportDetail";/**< 车检报告分享 */
static  NSString *Statistics_Share_cleanCodeReport   = @"Statistics_Share_cleanCodeReport";/**< 清码报告分享 */
static  NSString *Statistics_Share_MyCarLocationVC   = @"Statistics_Share_MyCarLocationVC";/**< 爱车位置分享 */
static  NSString *Statistics_Share_wxPayForFriend   = @"Statistics_Share_wxPayForFriend";/**< 好友代付分享 */
static  NSString *Statistics_Share_signInfo   = @"Statistics_Share_signInfo";/**< 签到活动分享 */
static  NSString *Statistics_Share_QTZIntro   = @"Statistics_Share_QTZIntro";/**< 擎天助介绍页分享 */
static  NSString *Statistics_Share_QTZCheyouquan   = @"Statistics_Share_QTZCheyouquan";/**< 擎天助车友圈 */



/** ---友盟统计结构化事件ID--- */
typedef NS_ENUM(NSUInteger, QTZStructureStatisticsType) {
    QTZStructureStatisticsTypeQiandao,/**< 🔴 签到领券活动 step 1 - 5   1.进入签到活动页 	2.点击签到	  3.签到_领券成功	  4.签到_点击分享     5.签到_分享成功*/
    QTZStructureStatisticsTypeDriveActivity,/**< 认证行驶证活动 step 1 - 3     1.进入认证行驶证活动页	 2.行驶证_点击我要参与     	3.行驶证上传成功 */
    
};

@interface QTZStatistics : NSObject

/** 单例 */
+ (instancetype)share;

/** 部分按钮点击事件⚫️ 或 分享🔵 统计 */
- (void)nativeBtnClick:(NSString*)Statistics;

/** 要进入H5页面 分别比较字符串 统计打点 */
- (void)H5Statistics:(NSString*)urlStr;

/**
 *  友盟 结构化事件统计 每进行一步 调一次
 *
 *  @param type QTZStructureStatisticsType
 *  @param step 最小1开始  进行到哪一步 每个结构化事件步数不一样
 */
- (void)structureStatistics:(QTZStructureStatisticsType)type step:(NSUInteger)step;

@end
