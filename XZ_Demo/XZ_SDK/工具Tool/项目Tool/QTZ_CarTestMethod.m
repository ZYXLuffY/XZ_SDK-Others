//
//  QTZ_CarTestMethod.m
//  com.tmbj.qtzUser_JE
//
//  Created by 天牧伯爵ui设计师 on 16/3/7.
//  Copyright © 2016年 JE. All rights reserved.
//

#import "QTZ_CarTestMethod.h"
//#import "QTZ_DownLoadView.h"
#import "XZUtility.h"
#import "XZNetWorking.h"
#define Duration 2

@interface QTZ_CarTestMethod ()

@property (nonatomic, copy) startExameAction startAction;
@property (nonatomic, copy) endExameAction endAction;
@property (nonatomic, assign) BOOL isTestAction;/**< 判断是否是清码还是体检操作*/

@end

static QTZ_CarTestMethod *method = nil;
static dispatch_once_t onceToken;

@implementation QTZ_CarTestMethod
{
//    M_DriveAnalysis *Mod_Trajectory;/**< 最新行驶 状态信息 */

}
+(QTZ_CarTestMethod*)shareInstance
{
    dispatch_once(&onceToken, ^
                  {
                      method = [[QTZ_CarTestMethod alloc] init];
                  });
    return method;
}

-(void)cancelExam
{
//    [WIFIPasswordSetting closeWIFISocket];
//    [[GOInspectionDiag shareInstance]inspectionCancel];
//    [GOInspectionDiag shareInstance].delegate = nil;
    if (self.cancelExameBlock) {
        self.cancelExameBlock();
    }
}

#pragma mark ------TestAction-------
-(void)cartTetsActionWithStartExameAction:(startExameAction)startAction AndEndExameAction:(endExameAction)endAction CarTestType:(CarTestType )carTestType
{
    self.startAction = startAction;
    self.endAction = endAction;
    self.carTsetType = carTestType;
    self.isTestAction = YES;
    delay(1, ^{[self examPreStepOne]; });
}

#pragma mark ------clearAction-------
-(void)clearBugWithStartClearAction:(startClearAction)startAction AndEndClearAction:(endClearAction)endAction ClearType:(CarTestType)clearType
{
    self.startAction = startAction;
    self.endAction = endAction;
    self.carTsetType = clearType;
    self.isTestAction = NO;
   [self examPreStepOne];
}

- (void)examPreStepOne
{
    
    if(self.carTsetType == carTestTypeAllExame)
    {
        
        if ([QTZ_CarTestMethod isCarFileExist] &&[QTZ_CarTestMethod isEobddFileExist]) {
            if (self.stepOneBlock) {
                self.stepOneBlock(YES);
            }
            delay(1, ^{[self examPreStepTwo]; });
        }
        else
        {
            if (self.stepOneBlock) {
                self.stepOneBlock(NO);
            }
//            __weak typeof(self)weakSelf =self;
//            QTZ_DownLoadView *view = [QTZ_DownLoadView ShareDownLoadViewType:carTestTypeAllExame CarId:@"" DeviceId:@"" isUpdate:NO];
//            view.carProfileUnZipFilesFail = ^{
//                
//            };
//            view.carProfileUnZipFilesSuccess = ^{
//                [weakSelf examPreStepOne];
//            };
            if (self.needToDownloadCarProfile) {
                self.needToDownloadCarProfile();
            }
        }
        return;
    }
    
    if([QTZ_CarTestMethod isEobddFileExist])
    {
        if (self.stepOneBlock) {
            self.stepOneBlock(YES);
        }
        
        delay(1, ^{[self examPreStepTwo]; });
    }
    else
    {
        
//        __weak typeof(self)weakSelf =self;
//        QTZ_DownLoadView *view = [QTZ_DownLoadView ShareDownLoadViewType:carTestTypeQuickExame CarId:@"" DeviceId:@"" isUpdate:NO];
//        view.carProfileUnZipFilesFail = ^{
//            
//        };
//        view.carProfileUnZipFilesSuccess = ^{
//            [weakSelf examPreStepOne];
//        };
        if (self.stepOneBlock) {
            self.stepOneBlock(NO);
        }
        if (self.needToDownloadCarProfile) {
            self.needToDownloadCarProfile();
        }
    }
}

- (void)examPreStepTwo
{
//    __weak typeof(self)weakSelf =self;
//    [WIFIPasswordSetting openWIFISocketwithMode:GOSocketModeWIFIManager success:^{
//        NSLog(@"成功连接WIFI Socket！！");
//        [WIFIPasswordSetting CheckSerialNo:@"" success:^{
//            if (self.stepTowBlock) {
//                self.stepTowBlock(YES);
//            }
//            if (self.isTestAction) {
//                delay(1, ^{[weakSelf examStepThree]; });
//                return ;
//            }
//            [self nowStartExam];
//        } failure:^(NSError *error) {
//            [WIFIPasswordSetting closeWIFISocket];
//            if (self.stepTowBlock) {
//                self.stepTowBlock(NO);
//            }
//            [XZUtility showAlertViewTitle:@"温馨提示" Msg:@"请打开手机网络连接车载智能终端WiFi" completion:^(int index) {
//                if(index==1){
//                    [[UIApplication sharedApplication] openURL:iOS10 ? [NSURL URLWithString:UIApplicationOpenSettingsURLString] : [NSURL URLWithString:@"prefs:root=WIFI"]];
//                }
//            } otherBtns:@[@"稍后检测",@"设置"]];
//        }];
//    } fail:^{
//        [WIFIPasswordSetting closeWIFISocket];
//        if (self.stepTowBlock) {
//            self.stepTowBlock(NO);
//        }
//        [XZUtility showAlertViewTitle:@"温馨提示" Msg:@"请用手机连接擎天助智能终端WiFi" completion:^(int index) {
//            if(index==1){
//                [[UIApplication sharedApplication] openURL:iOS10 ? [NSURL URLWithString:UIApplicationOpenSettingsURLString] : [NSURL URLWithString:@"prefs:root=WIFI"]];
//            }
//        } otherBtns:@[@"稍后检测",@"设置"]];
//    }];
}

//检查车辆是否点火,并处于停驶状态才能进行体检
-(void)examStepThree
{
    [XZNetWorking API:API_currentTrajectory Param:@{@"carBaseInfoId":@""} Vc:nil AF:JEApp.window.rootViewController.AFM Suc:^(NSDictionary *Res) {
        if(Res)
        {
//            Mod_Trajectory = [M_DriveAnalysis objectWithKeyValues:Res];
            if (/* DISABLES CODE */ (1))
            {
                if(self.stepThreeBlock){
                    self.stepThreeBlock(YES);
                }
                delay(.5, ^{[self nowStartExam]; });
            }
            else if ([@"33" longLongValue]>1){
                if (self.stepThreeBlock) {
                    self.stepThreeBlock(NO);
                }
                [XZUtility showAlertViewTitle:@"提示" Msg:@"为了您的安全，请先停下车辆再进行检测！" completion:nil otherBtns:@[@"知道了"]];
                
            }
            else
            {
                if (self.stepThreeBlock) {
                    self.stepThreeBlock(NO);
                }
#ifdef DEBUG
                BOOL notwarning = YES;
                if (notwarning) {
                    [XZUtility showAlertViewTitle:@"提😱示" Msg:@"为了您的爱车健康，请确认车辆已点火并处于停驶状态" completion:^(int index) {
                        if(index){
                            delay(.5, ^{[self nowStartExam]; });
                        }
                    } otherBtns:@[@"取消",@"test=🤔继续体检"]];
                    return ;
                }
#endif
                [XZUtility showAlertViewTitle:@"提示" Msg:@"为了您的爱车健康，请确认车辆已点火并处于停驶状态"];
            }
        }
    } Fai:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if ((task.error.code != NSURLErrorCancelled)) {[JEApp.window.rootViewController ShowHUD:jekNetWorkERROR De:0];}
        if (self.stepThreeBlock) {
            self.stepThreeBlock(NO);
        }
    }];
    
}
-(void)nowStartExam
{
    NSLog(@"-----nowStartExam-----");
    if (self.startAction) {
        self.startAction();
    }
//    [GOInspectionDiag shareInstance].delegate = self;
    if (self.isTestAction) {
        if (self.carTsetType ==carTestTypeAllExame) {
//            [[GOInspectionDiag shareInstance] inspectionTypeForAllStart:@"" carBrandPath:[QTZ_CarTestMethod getCarBrandPth] EOBDPth:[QTZ_CarTestMethod getEOBDPth]];
            
        }else{
//            [[GOInspectionDiag shareInstance] inspectionTypeForOBDStart:@"" EOBDPth:[QTZ_CarTestMethod getEOBDPth]];
        }
        self.isTestAction = NO;
        return;
    }

    if (self.carTsetType == carTestTypeAllExame) {
//        [[GOInspectionDiag shareInstance] oneKeyClearReportHandle:@""  carBrandPath:@"" EOBDPth:[QTZ_CarTestMethod getEOBDPth]];
    }
    else{
    
//        [[GOInspectionDiag shareInstance] oneKeyClearReportHandle:@""  carBrandPath:@"" EOBDPth:[QTZ_CarTestMethod getEOBDPth]];
    }
}


#pragma mark ------体检Delegate-------

- (void)inspectionWillConectDiag
{
    NSLog(@"正在与诊断服务建立连接中...");
    if (self.willConenctDiag) {
        self.willConenctDiag();
    }
}

- (void)inspectioncConectDiagFinsh
{
    if (self.conectDiagFinsh) {
        self.conectDiagFinsh();
    }
}

- (void)inspectionDiagScanProcess:(NSDictionary *)data
{
    if (self.DiagScanProcess) {
        self.DiagScanProcess(data);
    }
}
//体检成功
- (void)inspectionDiagResult:(NSDictionary *)data
{
    if (self.endAction) {
        self.endAction(data,nil);
    }
    if (self.successBlock) {
        self.successBlock(data);
    }
}
//体检失败
- (void)inspectionDiagError:(NSError *)error
{
//    error.domain
    [self cancelExam];

    if (self.faileBlock) {
        self.faileBlock(error);
    }
    if (self.endAction) {
        self.endAction(nil,error);
    }
    NSInteger code = error.code;
    [JEApp.window.rootViewController ShowHUD:error.localizedDescription Img:0 De:1.5];
    if ([error.localizedDescription isEqualToString:@"缺失车辆诊断文件！"] ||[error.localizedDescription isEqualToString:@"缺失车辆诊断静态库！"] || code == 2 ||code == 3) {
        [QTZ_CarTestMethod POST_API_serverUpdateLoadCarInfo];
    }
}

/**< 更新服务器本地配置文件*/
+ (void)POST_API_serverUpdateLoadCarInfo
{
    [XZNetWorking API:API_serverUpdateLoadCarInfo Param:@{@"deviceId":@""} Vc:nil AF:JEApp.window.rootViewController.AFM Suc:^(NSDictionary *Res) {
    }];
}

+ (BOOL)isEobddFileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isEobdFileExist = [fileManager isExecutableFileAtPath:[self getEOBDPth]];
    NSLog(@"displayNameAtPath-- EobddFilename====%@getEOBDPth ==== %@",[fileManager displayNameAtPath:[self getEOBDPth]],[self getEOBDPth]);

    return isEobdFileExist;
}

+ (BOOL)isCarFileExist
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isCarFileExist = [fileManager fileExistsAtPath:[self getCarBrandPth]];
    NSLog(@"displayNameAtPath-- CarFile%@",[fileManager displayNameAtPath:[self getCarBrandPth]]);
    return isCarFileExist;
}

+(NSString *)getEOBDPth
{
    NSString *str=[NSString stringWithFormat:@"%@%@",@"",@""];
    NSDictionary *unzipInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kSerialNoKey(str)];
    NSLog(@"kSerialNoKey === %@",kSerialNoKey(str));
    NSString *simpleEOBDPath=unzipInfoDic[CAR_EOBD_SOFT_PATH_KEY];
    return simpleEOBDPath.length>0?PATH_IN_DOCUMENTS_DIR(simpleEOBDPath):@"";
}

+(NSString *)getCarBrandPth
{
    NSString *str=[NSString stringWithFormat:@"%@%@",@"",@""];
    NSDictionary *unzipInfoDic = [[NSUserDefaults standardUserDefaults] objectForKey:kSerialNoKey(str)];
    NSString *simplecarPath=unzipInfoDic[CAR_DIAG_SOFT_PATH_KEY];
    return simplecarPath.length>0?PATH_IN_DOCUMENTS_DIR(simplecarPath):@"";
}

+ (void)carProFileSaveWith:(NSString *)filePath
{
    NSMutableDictionary *unzipInfoDic = [NSMutableDictionary dictionary];
    [unzipInfoDic setValue:filePath forKey:CAR_EOBD_SOFT_PATH_KEY];
    //将解压的信息缓存
    NSString *carIdAndsnKey=[NSString stringWithFormat:@"%@%@",@"",@""];
    [[NSUserDefaults standardUserDefaults] setValue:unzipInfoDic forKey:kSerialNoKey(carIdAndsnKey)];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)deleteCarProFileAction
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *zipFiles = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATH_IN_DOCUMENTS_DIR(@"") error:nil] pathsMatchingExtensions:@[@"ZIP",@"zip"]];
    for (NSInteger i = 0; i < zipFiles.count; i ++) {
        [fileManager removeItemAtPath:[PATH_IN_DOCUMENTS_DIR(@"") stringByAppendingString:zipFiles[i]] error:nil];
    }
    [fileManager removeItemAtPath:Path_dpusysINI error:nil];
    [fileManager removeItemAtPath:Path_Car_dpusysINI error:nil];
    NSDictionary *unzipInfoDic = [USDF objectForKey:kSerialNoKey(([NSString stringWithFormat:@"%@%@",@"",@""]))];
    [fileManager removeItemAtPath:PATH_IN_DOCUMENTS_DIR((unzipInfoDic[CAR_EOBD_SOFT_PATH_KEY])) error:NULL];
    [fileManager removeItemAtPath:PATH_IN_DOCUMENTS_DIR((unzipInfoDic[CAR_DIAG_SOFT_PATH_KEY])) error:NULL];

}

@end
