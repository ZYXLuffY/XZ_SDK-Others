//
//  QTZ_ShareView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/3/2.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import <UMSocialCore/UMSocialCore.h>
//#import <UMSocialNetwork/UMSocialNetwork.h>
#import "QTZStatistics.h"


typedef NS_ENUM(NSUInteger, QTZShareViewType) {
    QTZShareViewTypeALL,/**< 5种分享 微信 QQ 好友 圈子  微博*/
    QTZShareViewTypeWXQQ,/**< 微信 QQ 好友 */
};


typedef NS_ENUM(NSUInteger, QTZShareCodeType) {
    QTZShareCodeTypeWXDF,/**< 微信代付 */
    QTZShareCodeTypeQDHD,/**< 签到活动 */
    QTZShareCodeTypeWDZJ,/**< 我的足迹 */
    QTZShareCodeTypeCJBG,/**< 车检报告 */
    QTZShareCodeTypeQMBG,/**< 清码报告 */
    QTZShareCodeTypeACWZ,/**< 爱车位置 */
    QTZShareCodeTypeQTZJS,/**< 擎天助介绍 */
    QTZShareCodeTypeQTZCYQ,/**< 擎天助车友圈 */
};

typedef void(^UMSocialRequestCompletionHandler)();

@interface QTZ_ShareView : UIView

@property (nonatomic, copy) UMSocialRequestCompletionHandler completion;


/**
 *  分享弹出图
 *
 *  @param captureView 传了上面就显示view
 *  @param block       分享成功才回调
 */
+(void)ShareViewType:(QTZShareViewType)viewType codeType:(QTZShareCodeType)codeType captureView:(UIView *)captureView URLParam:(NSDictionary*)URLParam netParam:(NSDictionary*)netParam block:(UMSocialRequestCompletionHandler)block;


/** 分享弹出图 固定顺序 分享成功才回调 */
+(void)ShareTitle:(NSString*)title content:(NSString*)content url:(NSString*)Url type:(QTZShareViewType)type icon:(NSString *)icon captureView:(UIView *)captureView block:(UMSocialRequestCompletionHandler)block;


/** 代付的直接分享到微信 */
+ (void)shareToWeixin:(NSString*)Url title:(NSString*)title content:(NSString*)content;

@end

