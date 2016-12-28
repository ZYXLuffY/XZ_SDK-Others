//
//  QTZ_CarTestMethod.h
//  com.tmbj.qtzUser_JE
//
//  Created by 天牧伯爵ui设计师 on 16/3/7.
//  Copyright © 2016年 JE. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Config.h"
//#import "GOInspectionDiag.h"
//#import "GODiagnoseConfig.h"
//#import "WIFIPasswordSetting.h"


typedef NS_ENUM(NSInteger,CarTestType){
    carTestTypeQuickExame = 0,/**< 快速体检*/
    carTestTypeAllExame, /**< 全车体检*/
    carTestTypeUpdate, /**< 更新配置文件*/
};


typedef void(^startExameAction)();/**< callBackRequestSuccess*/
typedef void(^endExameAction)(NSDictionary *data,NSError *error);

typedef void(^startClearAction)();/**< callBackRequestSuccess*/
typedef void(^endClearAction)(NSDictionary *data,NSError *error);

@interface QTZ_CarTestMethod : NSObject

+ (QTZ_CarTestMethod*)shareInstance;
- (void)cartTetsActionWithStartExameAction:(startExameAction)startAction AndEndExameAction:(endExameAction)endAction CarTestType:(CarTestType)carTestType  ;/**< 体检流程*/

- (void)clearBugWithStartClearAction:(startClearAction)startAction AndEndClearAction:(endClearAction)endAction ClearType:(CarTestType)clearType;/**< 一键清码*/
- (void)cancelExam;/**< 取消体检*/

+ (BOOL)isEobddFileExist;
+ (BOOL)isCarFileExist;

+ (NSString *)getEOBDPth;/**< 获取快速体检配置文件路径*/
+ (NSString *)getCarBrandPth;/**< 获取全车体检配置文件路径*/

//+ (void)postWithURL:(NSString *)url params:(NSDictionary *)params success:(void (^)(id json))success failure:(void (^)(NSError *error))failure;

+ (void)carProFileSaveWith:(NSString *)filePath;/**< 保存车辆配置文件文件目录*/

+ (void)deleteCarProFileAction;/**< 删除车辆配置文件*/

+ (void)POST_API_serverUpdateLoadCarInfo;/**< 更新服务器配置文件*/

@property (nonatomic, copy) void (^stepOneBlock)(BOOL isExsit);/**< 体检第一步回调*/
@property (nonatomic, copy) void (^stepTowBlock)(BOOL isConent);/**< 体检第二步回调*/
@property (nonatomic, copy) void (^stepThreeBlock)(BOOL isOnfired);/**< 体检第三步回调*/
@property (nonatomic, copy) void (^cancelExameBlock)();/**< 取消体检*/
@property (nonatomic, copy) void (^startExameBlock)();/**< 开始体检*/
@property (nonatomic, copy) void (^willConenctDiag)();/**< 即将连接*/
@property (nonatomic, copy) void (^conectDiagFinsh)();/**< 连接成功*/
@property (nonatomic, copy) void (^DiagScanProcess)(NSDictionary *);/**< 正在连接*/

@property (nonatomic, copy) void (^successBlock)(NSDictionary *);/**< 体检成功*/
@property (nonatomic, copy) void (^faileBlock)(NSError *);/**< 体检失败*/
@property (nonatomic, copy) void (^needToDownloadCarProfile)();/**< 需要下载配置文件*/
@property (nonatomic, assign)CarTestType carTsetType;/**< 体检类别*/



@end
