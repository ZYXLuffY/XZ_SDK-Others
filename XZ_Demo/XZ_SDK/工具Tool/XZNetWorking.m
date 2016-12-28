
#import "XZNetWorking.h"
#import "AFNetworking.h"
#import "XZUtility.h"
#import "XZDebugTool__.h"
#import "QTZ_AlertView.h"

static BOOL         NetShowAct          = YES;/**< 头顶信息栏目的转圈圈 */
static NSUInteger   AllNetOperations = 0;//所有请求中的数量 为零时 停止转动
//static BOOL         refreshingToken      = NO;/**< 刷新token中 */

@implementation XZNetWorking

+(void)API:(NSString*)API Param:(NSDictionary*)param Vc:(UIViewController*)vc  AF:(AFHTTPSessionManager *)Manager Suc:(void(^)(NSDictionary *Res))Suc{
    [XZNetWorking API:API Param:param Vc:vc AF:Manager Suc:Suc Fai:nil];
}

+(void)API:(NSString*)API Param:(NSDictionary*)param Vc:(UIViewController*)vc AF:(AFHTTPSessionManager *)Manager Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))Fai{
    
    API = [NSString stringWithFormat:@"%@%@",BoJue_BASEHTTP,API];
    
    //#if 0       //DEBUG缓存全开 取消网络
    //#ifdef DEBUG
    //    [XZNetWorking HandleNetworkRes:[XZdb Get:@{@"API" : API,@"dic" : param}.JsonStr.MD5 Table:Table_DEBUG] Op:nil Param:param Vc:vc Suc:Suc];
    //#endif
    //    return;
    //#endif
    
    if (Manager == nil) {
        Manager = XZApp.window.rootViewController.AFM;
    }
    
    [Manager.requestSerializer setValue:[USDF stringForKey:UserDef_Tmbj_Token] ? : @"" forHTTPHeaderField:Tmbj_Token];//保证每次刷新token
    
    if (NetShowAct) {[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; AllNetOperations++;}
    
    [Manager POST:API parameters:param progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (NetShowAct) {if (!--AllNetOperations) { [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;}}
        [vc.HUD removeFromSuperview];
        if (task.error.code == NSURLErrorCancelled) {
            return ;
        }
        
        //  登录 刷新 接口 缓存@"tmbj-token" 账户退出的时候删除
        if ([API rangeOfString:API_login].location != NSNotFound || [API rangeOfString:API_weixinLogin].location != NSNotFound || [API rangeOfString:API_refreshToken].location != NSNotFound) {
            NSArray *cookies = [NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse*)task.response allHeaderFields] forURL:[NSURL URLWithString:API]];
            for (NSHTTPCookie *cookie in cookies) {
                if ([cookie.name isEqualToString:Tmbj_Token]) {
                    [[XZDebugTool__ Shared] addDicLog:@{} Param:@{@"Tmbj_Token" : cookie.value} API:@"======  登录获得的Token  ======"];
                    [USDF setValue:cookie.value forKey:UserDef_Tmbj_Token];
                    [USDF removeObjectForKey:UserDef_refreshTokenTime];
                    [USDF synchronize];break;
                }
            }
        }
        
        NSDictionary *NetRes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        [XZNetWorking CreatePostUrl:API Param:param error:nil];//打印下请求的参数
        [XZNetWorking HandleNetworkRes:NetRes Op:task Param:param Vc:vc Suc:Suc];
        
#if 1       //DEBUG缓存
#ifdef DEBUG
        [[XZDebugTool__ Shared] addDicLog:NetRes Param:param API:API];
        //        [XZdb Save:NetRes Id:@{@"API" : API,@"dic" : param ? param : @{}}.JsonStr.MD5 Table:Table_DEBUG];
#endif
#endif
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [XZNetWorking CreatePostUrl:API Param:param error:error];
        if (NetShowAct) {if (!--AllNetOperations) { [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; }}
        if (Fai) {  Fai(task,error);return;}//有自己的处理方式 返回了
        if (task.error.code == NSURLErrorCancelled) {
            
        }else{
            [vc.HUD removeFromSuperview];
            if (vc) {
                ([XZApp.window.rootViewController ShowHUD:@"网路异常" Img:-1 De:1.5]);
            }
        }
    }];
    
}

#pragma mark - 处理网络请求的字典
+(void)HandleNetworkRes:(NSDictionary*)NetRes Op:(NSURLSessionDataTask *)operation Param:(NSDictionary*)param Vc:(UIViewController*)vc Suc:(void(^)(NSDictionary *Res))Suc{
    NSDictionary *data = NetRes[@"data"];
    QTZNetwork_ReturnCode code = [[NetRes str:@"code"] integerValue];
    
    if (code != QTZNetwork_ReturnCodeSuccess || data == nil) {//反正不是成功
        NSLog("\n%@\n❌❌❌❌",[NSString stringWithFormat:@"%@",NetRes]);
        //要下线
        if ([@[@(QTZNetwork_ReturnCodeTokenWrong),@(QTZNetwork_ReturnCodeLoginTimeOut),@(QTZNetwork_ReturnCodeLoginConflict)] containsObject:@(code)] && XZApp != nil){
            [vc.AFM.operationQueue cancelAllOperations];
            [XZNetWorking GameOver:code noti:[NetRes str:@"massage"]];
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            Block_Exec(Suc,nil);//失败 返回 nil
        });
        
        NSString *message = [NetRes str:@"massage"];
        //没GPS的提示
        if (code == QTZNetwork_ReturnCodeNotGPSInfo) {
            [[[QTZ_AlertView alloc]initWithTitle:nil message:message.length ? message : @"请开启GPS\n查看附近服务商家" buttonTitles:@[@"取消",@"开启"]] showWithCompletion:^(int index) {
                if (index == 1) {
                    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iOS10 ? UIApplicationOpenSettingsURLString : @"prefs:root=LOCATION_SERVICES"]];
                }
            }];
            return;
        }
        //强制升级
        else if (code == QTZNetwork_ReturnCodeNeedToUpdate) {
            [XZNetWorking needToUpdate:message];return;
        }
        
        if (vc) {
            [XZApp.window.rootViewController ShowHUD:message.length == 0 ? ([NSString stringWithFormat:@"服务器繁忙!"]) : message Img:-1 De:2];
        }
        
        return;
    }
    
    if ([data isKindOfClass:[NSNull class]] || ([data isKindOfClass:[NSNumber class]] && [((NSNumber*)data) integerValue] == 0)) {
        data = nil;
    }
    
    Block_Exec(Suc,((data == nil) ? @{} : data));//成功返回 不是nil
}


#pragma mark - 构建错误内容 请求内容

+(void)CreatePostUrl:(NSString*)baseUrl Param:(NSDictionary*)param error:(NSError *)error{
#ifdef DEBUG
    NSLog(@"🌏 \n\n%@\n%@\n\n",baseUrl,param.JsonStr);
    if (error) { NSLog(@"\n\n%@\n\n%@\n%@\n❌❌❌❌",baseUrl,[error userInfo][@"NSErrorFailingURLKey"],[error userInfo][@"NSLocalizedDescription"]); }
#endif
}


/**  滚回到登录界面  （登录 冲突 超时 提示下线） */
+ (void)GameOver:(QTZNetwork_ReturnCode)code noti:(NSString*)noti{
    [XZApp.window.rootViewController.AFM.operationQueue cancelAllOperations];
//    NSString *Psw = [USDF valueForKey:UserDef_AutoUserPassWord];
//    BOOL isopenid = XZApp.UserInfo.openid.length != 0 ? YES : NO;
    
    if (code == QTZNetwork_ReturnCodeLoginConflict) {
        [[XZHandleCommon share] showAlertView:@"" Msg:noti cancleBtn:@"确定" otherBtn:@[@"重新登录"] completionBlock:^(int index) {
            if (index != 1) { return ;}
//            LoginVC *vc = [[(UINavigationController*)XZApp.window.rootViewController viewControllers] firstObject];
//            if (isopenid) {
//                [vc WeiXinLogin:nil];return;
//            }
//            vc.Tf_Psw.text = Psw;
//            [vc LoginClick:nil];
        }];
    }else{
        [USDF removeObjectForKey:UserDef_AutoUserPassWord];
    }
    
}


#pragma mark -  上传流  Data

+(void)uploadImg:(UIImage *)Loadimg AF:(AFHTTPSessionManager *)Manager VCPro:(UIViewController*)vc Pro:(void(^)(float Some,float All))progress Suc:(void(^)(NSDictionary *whether,NSString *path))success fail:(void(^)())failure{
    Manager.requestSerializer.timeoutInterval = 60;
    if (NetShowAct) {[UIApplication sharedApplication].networkActivityIndicatorVisible = YES; AllNetOperations++;}
    
    NSString *base64Str = [UIImageJPEGRepresentation(Loadimg,0.6) base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    NSData *data = [[NSString stringWithFormat:@"imgStr=%@&userId=%@",base64Str,/*XZApp.UserInfo.userId ? : */@"system"] dataUsingEncoding:NSUTF8StringEncoding];
    
    NSMutableURLRequest *request = [[AFHTTPRequestSerializer serializer] multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",BoJue_BASEHTTP,API_uploadImg] parameters:nil constructingBodyWithBlock:nil error:nil];
    [request setHTTPBody:data];
    
    Manager = [[AFHTTPSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionUploadTask *uploadTask = [Manager uploadTaskWithStreamedRequest:request progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount,uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, NSDictionary *Get, NSError * _Nullable error) {
        if (NetShowAct) {if (!--AllNetOperations) { [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;}}
        if (error) {
            Block_Exec(failure);
        }
        NSString *path = @"";
        NSDictionary *Conent = Get[@"data"];
        if ([Conent isKindOfClass:[NSDictionary class]]) {
            path = Conent[@"url"] ? : @"";
        }
        
        if (![Conent isKindOfClass:[NSDictionary class]] || Conent[@"url"] == nil) {
            if (failure) {
                failure();
            }else{
                [vc ShowHUD:@"服务器繁忙" Img:0 De:1];
            }
            return ;
        }
        success(Get,path);
    }];
    
    [uploadTask resume];
    
}



#pragma mark - 微信登陆

+(void)WeChatLogin:(NSString *)code result:(void(^)(NSDictionary *GetDic))result failure:(void(^)())failure{
    NSString *api  = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",
                      kWXAppID,
                      kweAppSecret,
                      code];
    
    [XZApp.window.rootViewController.AFM GET:api parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *GetDic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSString *api2 = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid=%@&grant_type=refresh_token&refresh_token=%@",
                          kWXAppID,
                          GetDic[@"refresh_token"]];
        
        [XZApp.window.rootViewController.AFM GET:api2  parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            NSDictionary *GetDic2 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
            NSString *api3 = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@",GetDic2[@"access_token"],GetDic2[@"openid"]];
            
            [XZApp.window.rootViewController.AFM GET:api3 parameters:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                NSDictionary *GetDic3 = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
                result(GetDic3);
                
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                failure();
            }];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            failure();
        }];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        failure();
    }];
    
}

/** 后台刷新token refreshToken */
+ (void)refreshTokenInBackground{
//    if (XZApp.UserInfo == nil || refreshingToken || AllNetOperations != 0) {  return; }
//    //没其他请求 && 超过7/2天了 刷新一下token
//    NSDate *lastTime = [USDF valueForKey:UserDef_refreshTokenTime];
//    
//    if (lastTime == nil || [[NSDate date] timeIntervalSinceDate:lastTime] > 24*60*60*3.5) {
//        refreshingToken = YES;//怕网络慢的 调几次的会出问题
//        [XZNetWorking API:API_refreshToken Param:@{} Vc:nil AF:XZApp.window.rootViewController.AFM Suc:^(NSDictionary *Res) {
//            if (XZApp.UserInfo) {
//                [USDF setValue:[NSDate date] forKey:UserDef_refreshTokenTime];
//                [USDF synchronize];
//            }
//            refreshingToken = NO;
//        } Fai:nil];
//    }
    
}

/** 擎天助检查更新 */
+ (void)QTZAppUpdate{
//    if (XZApp.UserInfo == nil) {
//        return;
//    }
    
    [XZApp.window.rootViewController.AFM POST:[NSString stringWithFormat:@"%@%@",BoJue_BASEHTTP,API_updateApp] parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *NetRes = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        NSDictionary *Res = NetRes[@"data"];
        if ([Res isKindOfClass:[NSNull class]] || ![Res isKindOfClass:[NSDictionary class]] || Res == nil) {
            return ;
        }
//        if ([Tmbj_code integerValue] < [[Res str:@"versionCode"] integerValue]) {
//            if ([[Res str:@"updateType"]integerValue] == 1) {//强制升级
//                [XZNetWorking needToUpdate:[Res str:@"versionMsg"]];
//            }
//        }
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        delay(2, ^{
            [self QTZAppUpdate];
        });
    }];
}

/** 需要更新 */
+ (void)needToUpdate:(NSString*)msg{
    [[[QTZ_AlertView alloc]initWithTitle:@"升级提示" message:msg buttonTitles:@[@"取消",@"前往更新"]] showWithCompletion:^(int index) {
        if (index == 1) {
//            [[UIApplication sharedApplication] openURL:[NSString stringWithFormat:@"itms-apps://itunes.apple.com/app/id%@",AppleStoreID].url];
        }
    }];
    
    [XZApp.window.rootViewController.AFM.operationQueue cancelAllOperations];
}

@end
