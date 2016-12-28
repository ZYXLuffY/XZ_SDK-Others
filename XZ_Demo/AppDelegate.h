//
//  AppDelegate.h
//  XZ_Demo
//
//  Created by iOS_XZ on 2016/12/23.
//  Copyright © 2016年 iOS_XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "XZUserInfo.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic,copy) NSString   *___test___UserId;/**< 测试🔴 用户id */

@property (nonatomic,strong) XZUserInfo   *UserInfo;/**< 用户信息 */
//@property (nonatomic,strong) M_Main1VCInfo  *Main1VCInfo;/**< 主页信息 */
//@property (nonatomic,strong) Weather_Mod *weather_Mod;/**< 天气信息*/
@property (nonatomic,strong) CLLocation*    APPLocation;/**< 当前经纬度 百度坐标！ */

#pragma mark --- 定位相关字段
@property (nonatomic,copy)   NSString   *APPnowAdress;/**< 当前地址 eg. 深圳 北京*/
@property (nonatomic,copy)   NSString   *administrativeArea;/**< 当前省 eg.广东省 用于添加车辆市计算车牌前缀*/
@property (nonatomic,copy)   NSString   *placeMark_Name;
@property (nonatomic,copy)   NSString   *locality;/**< 当前定位所在城市*/

@property (nonatomic,assign) NSInteger  cityCode;
@property (nonatomic,assign) NSInteger  tmbj_cityCode;
@property (nonatomic,assign) NSInteger  tmbj_cityId;

@property (nonatomic,copy)   NSString   *tmbj_url;
@property (nonatomic,copy)   NSString   *netType;/**< 网络制式 wifi 234G*/


@end

