////
////  QTZ_DownLoadView.m
////  com.tmbj.qtzUser_XZ
////
////  Created by 天牧伯爵ui设计师 on 16/3/7.T
////  Copyright © 2016年 XZ. All rights reserved.
////
//#import "XZUtility.h"
//#import "XZNetWorking.h"
//#import "QTZ_DownLoadView.h"
//#import "QTZ_AlertView.h"
//#import "M13ProgressViewBorderedBar.h"
//#import "Config.h"
//#import "GODiagnoseConfig.h"
//
//const static CGFloat AnimateDuration  = 0.25;/**< 动画时间 */
//
//@interface QTZ_DownLoadView ()<GODiagnoseConfigDelegate>
//@property (nonatomic ,copy  ) AFURLSessionManager *downloadOp;   //AFNetworking的下载类
//@property (nonatomic ,strong) M13ProgressViewBorderedBar *borderedBar;
//@property (nonatomic ,strong) CarProfle_Mod *carProfle_Mod;
//@property (nonatomic ,strong) XZButton *downLoadBtn;
//@property (nonatomic ,strong) GODiagnoseConfig *diagnoseConfig;//元征SDK解压类
//@property (nonatomic ,strong) NSString *EOBDZipName;  //EOBD名称
//@property (nonatomic ,strong) NSString *carZipName;   //carOBD名称
//
//@property (nonatomic ,strong) NSString *EOBD_iniName;  //EOBDini名称
//@property (nonatomic ,strong) NSString *car_iniName;   //carOBDini名称
//
//@property (nonatomic ,assign) BOOL isUnzipCarPro;
//@property (nonatomic ,assign) BOOL isUnzipEobd;
//
//@property (nonatomic ,assign) BOOL isConfigDownloadSuccess;
//@property (nonatomic ,assign) BOOL isEOBDDownloadSuccess;
//@property (nonatomic ,assign) BOOL isCarProINIDownloadSuccess;
//@property (nonatomic ,assign) BOOL isCarEOBDINIDownloadSuccess;
//
//@property (nonatomic, copy)   NSString *carId;
//@property (nonatomic, copy)   NSString *deviceId;
//@property (nonatomic, assign) BOOL isUpdate;/**< 是否更新配置文件*/
//
//@end
//
//@implementation QTZ_DownLoadView
//
//-(void)dealloc{
//    JIE1;
//}
//
//+(instancetype)ShareDownLoadViewType:(CarTestType)type CarId:(NSString *)carId DeviceId:(NSString *)deviceId isUpdate:(BOOL)isUpdate
//{
//    return  [[self alloc]initWithFrame:CGRectZero CarTestType:type CarId:carId DeviceId:deviceId isUpdate:isUpdate];
//}
//
//+(instancetype)ShareDownLoadViewType:(CarTestType)type
//{
//    return  [[self alloc]initWithFrame:CGRectZero CarTestType:type CarId:@"" DeviceId:@"" isUpdate:NO];
//}
//
//+(instancetype)ShareDownLoadView
//{
//    return [[self alloc] init];
//}
//
//-(instancetype)initWithFrame:(CGRect)frame CarTestType:(CarTestType)type CarId:(NSString *)carId DeviceId:(NSString *)deviceId isUpdate:(BOOL)isUpdate
//{
//    self= [super initWithFrame:frame];
//    if (self) {
//        self.carTsetType = type;
//        self.carId = carId;
//        self.deviceId = deviceId;
//        self.isUpdate = isUpdate;
//        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        [XZApp.window addSubview:self];
//        [self setupUI];
//    }
//    return self;
//}
//
//-(instancetype)initWithFrame:(CGRect)frame
//{
//    self= [super initWithFrame:frame];
//    if (self) {
//        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
//        [XZApp.window addSubview:self];
//        [self setupUI];
//    }
//    return self;
//}
//
//- (void)setupUI
//{
//    self.backgroundColor = kRGBA(0, 0, 0, 0.7);
//    [self setupContentView];
//    [self ShowView];
//}
//
//- (void)ShowView
//{
//    [self ChangeNavPopGestureEnable:NO];
//    [UIView animateWithDuration:AnimateDuration animations:^{
//        self.alpha = 1;
//    }];
//}
//
//- (void)HideView
//{
//    if (_isUpdate) {
//        [QTZ_CarTestMethod POST_API_serverUpdateLoadCarInfo];
//    }
//    self.diagnoseConfig.delegate = nil;
//    [self ChangeNavPopGestureEnable:YES];
//    [UIView animateWithDuration:AnimateDuration animations:^{
//        self.alpha = 0;
//    } completion:^(BOOL finished) {
//        [self removeFromSuperview];
//    }];
//    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
//    
//    for (NSURLSessionTask *task in _downloadOp.tasks) {[task cancel];}
//}
//
//- (BOOL)checkTheCarProfle_Mod
//{
//    
//    if(self.carTsetType == carTestTypeQuickExame)
//    {
//        if (_carProfle_Mod.eobdParams.cc.length   != 0 &&
//            _carProfle_Mod.eobdParams.versionDetailId.length != 0 &&
//            _carProfle_Mod.eobdParams.sign.length   != 0 ){
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//    else{
//        if (_carProfle_Mod.eobdParams.cc.length   != 0 &&
//            _carProfle_Mod.eobdParams.versionDetailId.length != 0 &&
//            _carProfle_Mod.eobdParams.sign.length   != 0 &&
//            _carProfle_Mod.carParams.cc.length   != 0 &&
//            _carProfle_Mod.carParams.versionDetailId.length != 0 &&
//            _carProfle_Mod.carParams.sign.length   != 0){
//            return YES;
//        }
//        else
//        {
//            return NO;
//        }
//    }
//}
//
//#pragma mark -------车检配置文件下载流程---------
//
//- (void)checkCurrentNetWork
//{
//    WSELF
//    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
//        switch (status) {
//            case AFNetworkReachabilityStatusNotReachable:{
//                [XZUtility showAlertViewTitle:@"温馨提示" Msg:@"当前网络不可用！！"];
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWiFi:{
//                [wself startDownLoad];
//                break;
//            }
//            case AFNetworkReachabilityStatusReachableViaWWAN:{
//                [XZUtility showAlertViewTitle:@"温馨提示" Msg:@"继续下载会产生流量消耗，\n建议连接智能终端WiFi下载" completion:^(int index) {
//                    if (index == 0) {
//                        [wself startDownLoad];
//                    }
//                    if (index){
//                        NSURL*url=[NSURL URLWithString:@"prefs:root=WIFI"];
//                        [[UIApplication sharedApplication] openURL:url];
//                    }
//                } otherBtns:@[@"继续下载",@"链接WiFi"]];
//                break;
//            }
//            default:
//                break;
//        }
//        
//    }];
//    
//    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
//    
//}
//
//
//-(void)startDownLoad:(id)sender
//{
//    [self checkCurrentNetWork];
//}
//
//- (void)startDownLoad
//{
//    WSELF
//    NSDictionary *param = @{@"carBaseInfoId":self.carId,@"deviceId":self.deviceId,@"devicePwd":[XZApp.Main1VCInfo CarWithId:self.carId].devicePassword,@"appId":GOVD_APPID};
//    [_downLoadBtn Loading];
//    [XZNetWorking API:API_downLoadCarInfo Param:param Vc:nil AF:XZApp.window.rootViewController.AFM Suc:^(NSDictionary *Res) {
//        if(Res && ![Res isKindOfClass:[NSNull class]])
//        {
//            wself.carProfle_Mod = [CarProfle_Mod objectWithKeyValues:Res];
//            [wself.downLoadBtn StopLing];
//            //            if (wself.isUpdate) {
//            wself.carProfle_Mod.localData = nil;
//            //            }
//            wself.downLoadBtn.userInteractionEnabled = NO;
//            [wself.downLoadBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//            [wself startDownLoadWith:self.carTsetType];
//        }else{
//            [wself downLoadFail];
//        }
//    } Fai:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [wself downLoadFail];
//    }];
//    
//}
//
//- (void)startDownLoadWith:(CarTestType)type
//{
//    [_downLoadBtn Loading];
//    if (type == carTestTypeQuickExame) {
//        if (_carProfle_Mod.localData != nil) {
//            /**< 自己服务器有的在自己服务器下*/
//            [self DownLoadCarEOBDINI:_carProfle_Mod.localData.fastIniFileUrl];
//        }else{
//            [self DownLoadCarEOBDINI:_carProfle_Mod.dpusysINI.url];
//        }
//        return;
//    }
//    if (_carProfle_Mod.localData != nil) {
//        [self  nowDownLoadCarProINI:_carProfle_Mod.localData.localIniFileUrl];
//    }else{
//        [self  nowDownLoadCarProINI:_carProfle_Mod.dpusysINI.url];
//    }
//    
//}
////根据INI文件的URL开始下载全车体检INI
//-(void)nowDownLoadCarProINI:(NSString *)URL
//{
//    WSELF
//    [self deleteCurrentConfigFile];
//    NSLog(@"全车体检INI == %@",URL);
//    if (URL == _carProfle_Mod.localData.localIniFileUrl) {
//        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//        NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:URL parameters:@{} error:nil];
//        _downloadOp = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        
//        NSURLSessionDownloadTask *downloadTask = [_downloadOp downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//            
//        }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//            wself.car_iniName = response.suggestedFilename;
//            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            if (error.code == NSURLErrorCancelled) {return ;}
//            if (error) {
//                [wself downLoadFail];
//            }else{
//                wself.isCarProINIDownloadSuccess = YES;
//                [wself.downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
//                NSLog(@"\n step_1 💾💾💾\n%@\n%@",PATH_IN_DOCUMENTS_DIR(wself.car_iniName),wself.car_iniName);
//                //开始下载全车体检的配置文件 与通用配置文件
//                if (wself.carProfle_Mod.localData) {
//                    [wself DownLoadCarEOBDINI:wself.carProfle_Mod.localData.fastIniFileUrl];
//                    return ;
//                }
//                [wself DownLoadCarEOBDINI:wself.carProfle_Mod.dpusysINI.url];            }
//        }];
//        
//        [downloadTask resume];
//        return;
//    }
//    
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    NSDictionary *param = @{@"car_type":@"123"};
//    if(_carProfle_Mod.localData.localIniFileUrl.length > 0){
//        param = nil;
//    }
//    [manager GET:URL parameters:param success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObXZct) {
//        
//        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:responseObXZct options:NSJSONReadingMutableContainers error:nil];
//        if ([[receiveDic valueForKey:@"code"] longValue] == 0) {
//            NSString *iniFileContent = [[receiveDic valueForKey:@"data"] valueForKey:@"iniFileContent"];
//            NSString *filePath = Path_Car_dpusysINI;
//            wself.isCarProINIDownloadSuccess = [iniFileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            if (wself.isCarProINIDownloadSuccess) {
//                [wself.downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
//                NSLog(@"\n step_1 💾💾💾\n%@\n%@",Path_Car_dpusysINI,iniFileContent);
//                //开始下载全车体检的配置文件 与通用配置文件
//                if (wself.carProfle_Mod.localData) {
//                    [wself DownLoadCarEOBDINI:wself.carProfle_Mod.localData.fastIniFileUrl];
//                    return ;
//                }
//                [wself DownLoadCarEOBDINI:wself.carProfle_Mod.dpusysINI.url];
//                
//            }
//            else{ [wself downLoadFail];}
//        }
//        else{
//            [wself downLoadFail];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        [wself downLoadFail];
//    }];
//    
//}
//
//- (void)DownLoadCarEOBDINI:(NSString *)URL
//{
//    NSLog(@"快速体检INI == %@",URL);
//    WSELF
//    if (URL == _carProfle_Mod.localData.fastIniFileUrl) {
//        AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//        NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:URL parameters:@{} error:nil];
//        _downloadOp = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        
//        NSURLSessionDownloadTask *downloadTask = [_downloadOp downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//            wself.EOBD_iniName = response.suggestedFilename;
//            NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//            NSLog(@"DownLoadCarEOBDINI == %@  &&& documentsDirectoryURL ===%@",wself.EOBDZipName,[documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);
//            return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//            
//        } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//            if (error.code == NSURLErrorCancelled) {return ;}
//            if (error) {
//                [wself downLoadFail];
//            }else{
//                wself.isCarEOBDINIDownloadSuccess = YES;
//                [wself.downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
//                [wself.borderedBar setProgress:.25 animated:YES];
//                NSLog(@"\n step_1 💾💾💾\n%@\n%@",PATH_IN_DOCUMENTS_DIR(wself.EOBD_iniName),wself.EOBD_iniName);
//                //开始下载全车体检的配置文件 与通用配置文件
//                if (wself.carTsetType == carTestTypeAllExame)
//                {//全车体检流程
//                    if(wself.carProfle_Mod.localData){
//                        [wself downLoadCarOBDConfigFile:_carProfle_Mod.localData.carFileUrl];
//                    }else{
//                        [wself downLoadCarOBDConfigFile:_carProfle_Mod.carParams.url];
//                    }
//                }else{
//                    //开始下载快速体检的配置文件
//                    if(wself.carProfle_Mod.localData.eobdFileUrl.length > 0){
//                        [wself downloadCarEOBDConfigFile:wself.carProfle_Mod.localData.eobdFileUrl];
//                    }else{
//                        [wself downloadCarEOBDConfigFile:wself.carProfle_Mod.eobdParams.url];
//                    }
//                }
//            }
//        }];
//        
//        [downloadTask resume];
//        return;
//    }
//    //根据INI文件的URL开始下载快速体检INI
//    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
//    
//    [manager GET: URL parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObXZct) {
//        NSDictionary *receiveDic = [NSJSONSerialization JSONObjectWithData:responseObXZct options:NSJSONReadingMutableContainers error:nil];
//        if ([[receiveDic valueForKey:@"code"] longValue] == 0) {
//            NSString *iniFileContent = [[receiveDic valueForKey:@"data"] valueForKey:@"iniFileContent"];
//            NSLog(@"_carProfle_Mod.ini == %@",[iniFileContent MD5]);
//            NSString *filePath = PATH_IN_DOCUMENTS_DIR(@"DPUSYS.INI");
//            wself.isCarEOBDINIDownloadSuccess = [iniFileContent writeToFile:filePath atomically:YES encoding:NSUTF8StringEncoding error:nil];
//            //然后开始刷1/8的进度条
//            if (wself.isCarEOBDINIDownloadSuccess) {
//                [_downLoadBtn setTitleColor:[UIColor whiteColor] forState:0];
//                [_borderedBar setProgress:.25 animated:YES];
//                if (wself.carTsetType == carTestTypeAllExame)
//                {
//                    //全车体检流程
//                    if(wself.carProfle_Mod.localData){
//                        [wself downLoadCarOBDConfigFile:_carProfle_Mod.localData.carFileUrl];
//                    }else{
//                        [wself downLoadCarOBDConfigFile:_carProfle_Mod.carParams.url];
//                    }
//                    return ;
//                }
//                //开始下载快速体检的配置文件
//                
//                if(wself.carProfle_Mod.localData.eobdFileUrl.length > 0){
//                    [wself downloadCarEOBDConfigFile:wself.carProfle_Mod.localData.eobdFileUrl];
//                }else{
//                    [wself downloadCarEOBDConfigFile:wself.carProfle_Mod.eobdParams.url];
//                }
//            }
//            else{ [wself downLoadFail];}
//        }
//        else
//        {
//            [wself downLoadFail];
//        }
//    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        NSLog(@"网络 = %@",error);
//        [wself downLoadFail];
//    }];
//    
//}
//
//
////开始下载车辆全车体检，现在是如果没有就返回EOBD通用文件
//-(void)downLoadCarOBDConfigFile:(NSString *)URL
//{
//    NSLog(@"全车体检OBDDDDD == %@",URL);
//    WSELF
//    if (_carProfle_Mod.carParams.cc.length   == 0 || _carProfle_Mod.carParams.versionDetailId.length == 0 || _carProfle_Mod.carParams.sign.length   == 0) {
//        [self downLoadFail];return;
//    }
//    NSDictionary *params = @{@"cc":_carProfle_Mod.carParams.cc,
//                             @"versionDetailId":_carProfle_Mod.carParams.versionDetailId,
//                             @"productSerialNo":_carProfle_Mod.carParams.productSerialNo,
//                             @"sign":_carProfle_Mod.carParams.sign};
//    
//    if (_carProfle_Mod.localData) {
//        params = nil;
//    }
//    ///配置下载信息
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request =[serializer requestWithMethod:@"GET" URLString:URL parameters:params error:nil];
//    if (!_carProfle_Mod.localData) {
//        [request addValue:_carProfle_Mod.carParams.cc forHTTPHeaderField:@"cc"];
//        [request addValue:_carProfle_Mod.carParams.sign forHTTPHeaderField:@"sign"];
//    }
//    
//    _downloadOp = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    NSURLSessionDownloadTask *downloadTask = [_downloadOp downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            [wself.borderedBar setProgress:.25+.5 * downloadProgress.fractionCompleted animated:YES];
//        });
//    }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        wself.carZipName = response.suggestedFilename;
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        if (error.code == NSURLErrorCancelled) {return ;}
//        if (error) {
//            [wself downLoadFail];
//        }else{
//            wself.isConfigDownloadSuccess = YES;
//            [wself.borderedBar setProgress:.75 animated:YES];
//            
//            if(wself.carProfle_Mod.localData.eobdFileUrl.length >0){
//                [wself downloadCarEOBDConfigFile:wself.carProfle_Mod.localData.eobdFileUrl];
//            }else{
//                [wself downloadCarEOBDConfigFile:wself.carProfle_Mod.eobdParams.url];
//            }
//        }
//    }];
//    
//    [downloadTask resume];
//}
//
////下载通用的EOBD文件
//- (void)downloadCarEOBDConfigFile:(NSString *)URL
//{
//    NSLog(@"通用体检EOBDddddd == %@",URL);
//    WSELF
//    if (_carProfle_Mod.eobdParams.cc.length   == 0 || _carProfle_Mod.eobdParams.versionDetailId.length == 0 || _carProfle_Mod.eobdParams.sign.length   == 0) {
//        [self downLoadFail];return;
//    }
//    
//    NSDictionary *params = @{@"cc":_carProfle_Mod.eobdParams.cc,
//                             @"versionDetailId":_carProfle_Mod.eobdParams.versionDetailId,
//                             @"productSerialNo":_carProfle_Mod.eobdParams.productSerialNo,
//                             @"sign":_carProfle_Mod.eobdParams.sign};
//    NSLog(@"%@",params);
//    //配置下载信息
//    if (_carProfle_Mod.localData.eobdFileUrl.length > 0) {
//        params = nil;
//    }
//    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
//    NSMutableURLRequest *request = [serializer requestWithMethod:@"GET" URLString:URL parameters:params error:nil];
//    if (_carProfle_Mod.localData.eobdFileUrl.length == 0) {
//        [request addValue:_carProfle_Mod.eobdParams.cc forHTTPHeaderField:@"cc"];
//        [request addValue:_carProfle_Mod.eobdParams.sign forHTTPHeaderField:@"sign"];
//    }
//    
//    _downloadOp = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//    
//    [_downloadOp setDownloadTaskDidWriteDataBlock:^(NSURLSession * _Nonnull session, NSURLSessionDownloadTask * _Nonnull downloadTask, int64_t bytesWritten, int64_t totalBytesWritten, int64_t totalBytesExpectedToWrite) {
//        NSLog(@"totalBytesExpectedToWrite == %lld",totalBytesExpectedToWrite);
//    }];
//    
//    
//    NSURLSessionDownloadTask *downloadTask = [_downloadOp downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
//        
//        NSLog(@"downloadProgress == %@ ",downloadProgress);
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (wself.carTsetType == carTestTypeQuickExame) {
//                [wself.borderedBar setProgress:.25+.75 * downloadProgress.fractionCompleted animated:YES];
//            }else{
//                [wself.borderedBar setProgress:.75+.25 * downloadProgress.fractionCompleted animated:YES];
//            }
//        });
//    }  destination:^NSURL *(NSURL *targetPath, NSURLResponse *response) {
//        wself.EOBDZipName = response.suggestedFilename;
//        NSURL *documentsDirectoryURL = [[NSFileManager defaultManager] URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:NO error:nil];
//        NSLog(@"通用配置文件%@  &&& documentsDirectoryURL ===%@",wself.EOBDZipName,[documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]]);
//        return [documentsDirectoryURL URLByAppendingPathComponent:[response suggestedFilename]];
//        
//    } completionHandler:^(NSURLResponse *response, NSURL *filePath, NSError *error) {
//        if (error) {
//            [wself downLoadFail];
//        }else{
//            wself.isEOBDDownloadSuccess = YES;
//            [wself.borderedBar setProgress:1 animated:YES];
//            [wself.downLoadBtn setTitle:@"下载完成,正在解压" forState:UIControlStateNormal];
//            [wself performSelector:@selector(downLoadSuccess) withObject:nil afterDelay:1];
//        }
//    }];
//    [downloadTask resume];
//}
//
//
////下载失败
//-(void)downLoadFail
//{
//    [self HideView];
//    if (_carProfle_Mod.localData) {
//        [QTZ_CarTestMethod POST_API_serverUpdateLoadCarInfo];
//    }
//    [QTZ_CarTestMethod deleteCarProFileAction];
//    [XZApp.window.rootViewController ShowHUD:@"下载配置文件失败" De:1.5];
//}
//
////下载完成
//- (void)downLoadSuccess
//{
//    //开始解压
//    [self unZipFiles:self.carTsetType];
//}
//
//- (void)unZipsuccess
//{
//    [self HideView];
//    if (self.carProfileUnZipFilesSuccess) {
//        self.carProfileUnZipFilesSuccess();
//    }
//}
//
//- (void)unZipFaile
//{
//    [self HideView];
//    [XZUtility showAlertViewTitle:@"提示" Msg:@"解压失败"];
//    if (self.carProfileUnZipFilesFail) {
//        self.carProfileUnZipFilesFail();
//    }
//    [QTZ_CarTestMethod POST_API_serverUpdateLoadCarInfo];
//    [QTZ_CarTestMethod deleteCarProFileAction];
//}
//
////初始化一些文件名,文件路径还有元征的解压对象
//#pragma mark--------快速体检及全车体检的配置文件zip解压---------
//- (void)unZipFiles:(CarTestType)type
//{
//    __block BOOL isUnZip_1;
//    __block BOOL isUnZip_2;
//    
//    WSELF
//    NSMutableDictionary *unzipInfoDic = [NSMutableDictionary dictionary];
//    _diagnoseConfig = [[GODiagnoseConfig alloc]init];
//    _diagnoseConfig.delegate = self;
//    if (type == carTestTypeQuickExame)
//    {
//        NSLog(@"PATH_IN_DOCUMENTS_DIR ==%@  Path_dpusysINI ==%@   ",PATH_IN_DOCUMENTS_DIR(_EOBDZipName),Path_dpusysINI);
//        
//        [_diagnoseConfig unZipSingleFiles:_EOBDZipName
//                              zipFilePath:PATH_IN_DOCUMENTS_DIR(_EOBDZipName)
//                           sysINIFilePath:Path_dpusysINI
//                                    snKey:self.deviceId
//                                  success:^(NSString *filePath) {
//                                      NSLog(@"_EOBDZipName filePath  🔵🔵🔵🔵🔵🔵🔵🔵%@",filePath);
//                                      [USDF removeObjectForKey:kSerialNoKey(([NSString stringWithFormat:@"%@%@",self.carId,self.deviceId]))];
//                                      [unzipInfoDic setValue:filePath forKey:CAR_EOBD_SOFT_PATH_KEY];
//                                      [USDF setValue:unzipInfoDic forKey:kSerialNoKey(([NSString stringWithFormat:@"%@%@",self.carId,self.deviceId]))];//这个车的
//                                      [USDF synchronize];
//                                      [wself unZipsuccess];
//                                  }failure:^(NSError *error) {
//                                      NSLog(@"解压错误描素 == %@",error.userInfo);
//                                      [wself unZipFaile];
//                                  }];
//        return;
//    }
//    
//    
//    dispatch_queue_t Que = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
//    dispatch_group_t Group = dispatch_group_create();
//    
//    dispatch_group_enter(Group);
//    dispatch_group_enter(Group);//两次任务
//    dispatch_group_async(Group, Que, ^{
//        [_diagnoseConfig unZipSingleFiles:_EOBDZipName
//                              zipFilePath:PATH_IN_DOCUMENTS_DIR(_EOBDZipName)
//                           sysINIFilePath:_EOBD_iniName.length > 0? PATH_IN_DOCUMENTS_DIR(_EOBD_iniName) :  Path_dpusysINI
//                                    snKey:self.deviceId
//                                  success:^(NSString *filePath) {
//                                      NSLog(@"_EOBDZipName filePath  🔵🔵🔵🔵🔵🔵🔵🔵%@",filePath);
//                                      [unzipInfoDic setValue:filePath forKey:CAR_EOBD_SOFT_PATH_KEY];
//                                      //                                      unzipCarEOBDSoftSuccess = YES;
//                                      isUnZip_1 = YES;
//                                      dispatch_group_leave(Group);
//                                  }failure:^(NSError *error) {
//                                      dispatch_group_leave(Group);
//                                      isUnZip_1 = NO;
//                                  }];
//    });
//    
//    dispatch_group_async(Group, Que, ^{
//        if (_carZipName == nil) {
//            dispatch_group_leave(Group);return ;
//        }
//        [_diagnoseConfig unZipSingleFiles:_carZipName
//                              zipFilePath:PATH_IN_DOCUMENTS_DIR(_carZipName)
//                           sysINIFilePath:_car_iniName.length > 0? PATH_IN_DOCUMENTS_DIR(_car_iniName) :  Path_Car_dpusysINI
//                                    snKey:self.deviceId
//                                  success:^(NSString *filePath) {
//                                      NSLog(@"_carZipName filePath  🔵🔵🔵🔵🔵🔵🔵🔵%@",filePath);
//                                      [unzipInfoDic setValue:filePath forKey:CAR_DIAG_SOFT_PATH_KEY];
//                                      isUnZip_2 = YES;
//                                      dispatch_group_leave(Group);
//                                  }failure:^(NSError *error) {
//                                      isUnZip_2 = NO;
//                                      dispatch_group_leave(Group);
//                                  }];
//    });
//    //两个都解压完
//    dispatch_group_notify(Group, dispatch_get_main_queue(), ^{
//        if (isUnZip_2 && isUnZip_1) {
//            NSLog(@"两个解压完成💚💚💚💚💚💚💚💚💚💚💚");
//            [USDF setValue:unzipInfoDic forKey:kSerialNoKey(([NSString stringWithFormat:@"%@%@",self.carId,self.deviceId]))];//这个车的
//            [USDF synchronize];
//            [wself unZipsuccess];
//            return ;
//        }
//        [wself unZipFaile];
//        
//        
//    });
//}
//
////解压失败时候回调这个函数
//#pragma mark - unzip delegate
//- (void) GODiagConfigUnzipError:(NSError *)error
//{
//    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"解压" message:[error localizedDescription]  delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    [alertView show];
//}
//
////解压进度...暂时没用
//- (void) GODiagConfigUnzipOnProgress:(NSNumber *)progress
//{
//    
//}
//
//- (void) GODiagConfigUnzipOnComplete
//{
//    NSLog(@"GODiagConfigUnzipOnComplete");
//}
//
////删除掉所有下载的配置文件
//- (void)deleteAllDownloadConfigFile{
//    
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSArray *zipFiles = [[[NSFileManager defaultManager] contentsOfDirectoryAtPath:PATH_IN_DOCUMENTS_DIR(@"") error:nil] pathsMatchingExtensions:@[@"ZIP",@"zip"]];
//    for (NSInteger i = 0; i < zipFiles.count; i ++) {
//        [fileManager removeItemAtPath:[PATH_IN_DOCUMENTS_DIR(@"") stringByAppendingString:zipFiles[i]] error:nil];
//    }
//    [fileManager removeItemAtPath:Path_dpusysINI error:nil];
//    [fileManager removeItemAtPath:Path_Car_dpusysINI error:nil];
//}
//
////删掉当前车辆配置文件
//- (void)deleteCurrentConfigFile{
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    NSDictionary *unzipInfoDic = [USDF objectForKey:kSerialNoKey(([NSString stringWithFormat:@"%@%@",_carId,_deviceId]))];
//    [[NSFileManager defaultManager] removeItemAtPath:PATH_IN_DOCUMENTS_DIR((unzipInfoDic[CAR_EOBD_SOFT_PATH_KEY])) error:NULL];
//    [[NSFileManager defaultManager] removeItemAtPath:PATH_IN_DOCUMENTS_DIR((unzipInfoDic[CAR_DIAG_SOFT_PATH_KEY])) error:NULL];
//    [fileManager removeItemAtPath:Path_dpusysINI error:nil];
//    [fileManager removeItemAtPath:Path_Car_dpusysINI error:nil];
//}
//
//-(void)ChangeNavPopGestureEnable:(BOOL)enable{
//    UINavigationController *Nav = (UINavigationController*)XZApp.window.rootViewController;
//    if ([Nav isKindOfClass:[UINavigationController class]]) {
//        Nav.interactivePopGestureRecognizer.enabled = enable;
//    }
//}
//
//
//- (void)setupContentView
//{
//    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0.8 * ScreenWidth, 0.8 * ScreenWidth * 0.56)];
//    contentView.centerX = self.centerX;
//    contentView.centerY = self.centerY;
//    contentView.backgroundColor = kColorWhite;
//    contentView.rad = 8;
//    [self addSubview:contentView];
//    
//    //显示"提示"的lbl
//    UILabel *notice=[[UILabel alloc] initWithFrame:CGRectMake(0, 13,contentView.width,30)];
//    [notice setTextAlignment:NSTextAlignmentCenter];
//    [notice setBackgroundColor:[UIColor clearColor]];
//    [notice setTextColor:kColorText];
//    [notice setText:@"提示"];
//    [contentView addSubview:notice];
//    
//    UILabel *notice1=[[UILabel alloc] initWithFrame:CGRectMake(15, notice.bottom, contentView.width - 30,50)];
//    [notice1 setTextAlignment:NSTextAlignmentCenter];
//    [notice1 setBackgroundColor:[UIColor clearColor]];
//    [notice1 setTextColor:kColorText];
//    [notice1 setFont:[UIFont systemFontOfSize:14.f]];
//    [notice1 setNumberOfLines:2];
//    [notice1 setText:self.carTsetType == carTestTypeUpdate ? @"爱车检测需要配置文件支持,可更新配置文件." : @"爱车检测需要配置文件支持,请下载车辆配置文件."];
//    
//    
//    [contentView addSubview:notice1];
//    
//    _borderedBar = [[M13ProgressViewBorderedBar alloc]initWithFrame:CGRectMake(0, contentView.height - 40, contentView.width, 40)];
//    _borderedBar.progressDirection = M13ProgressViewBorderedBarProgressDirectionLeftToRight;
//    _borderedBar.cornerType = M13ProgressViewBorderedBarCornerTypeSquare;
//    _borderedBar.primaryColor = kColorGreen_cao;
//    _borderedBar.secondaryColor = kColorGreen_cao;
//    _borderedBar.backgroundColor = kColorBlue_deep;
//    _borderedBar.borderWidth = 0;
//    [contentView addSubview:_borderedBar];
//    
//    _downLoadBtn = [[XZButton alloc]initWithFrame:_borderedBar.frame ImgF:CGRectZero TitF:CGRectMake(0, 0, _borderedBar.width, _borderedBar.height)];
//    [contentView addSubview:_downLoadBtn];
//    [_downLoadBtn setTitle:@"下载车辆配置文件" forState:0];
//    _downLoadBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [_downLoadBtn.titleLabel setFont:font(14)];
//    [_downLoadBtn setTitleColor:kColorWhite forState:UIControlStateNormal];
//    _downLoadBtn.backgroundColor = [UIColor clearColor];
//    [_downLoadBtn addTarget:self action:@selector(startDownLoad:) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self addSubview:({
//        UIButton *B = [UIButton Frame:CGRectMake(contentView.right - 33, contentView.y - 50, 50, 50) Title:@"×" FontS:30 Color:nil radius:0 Target:self action:@selector(HideView) Bimg:nil];
//        B.titleLabel.font = [UIFont systemFontOfSize:30 weight:UIFontWeightLight];
//        B;
//    })];
//}
//
//
//
//@end
