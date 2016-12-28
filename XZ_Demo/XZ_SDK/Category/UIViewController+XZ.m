
#import "UIViewController+XZ.h"
#import <objc/runtime.h>
#import "MBProgressHUD.h"
#import "AFHTTPSessionManager.h"
#import "XZNetWorking.h"
#import "CALayer+XZ.h"
#import "XZTextView.h"
#import "XZUtility.h"
#import "XZDebugTool__.h"
#import "QTZ_URLBySafariMethod.h"
static const void *HttpRequestHUDKey =   &HttpRequestHUDKey;
static const void *HttpRequestXZAFNKey = &HttpRequestXZAFNKey;

@implementation UIViewController (XZ)

+ (void)load{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        [self swizzleInstanceMethod:@selector(viewDidDisappear:) with:@selector(XZ_viewDidDisappear:)];
    });
}

/**< 该页面都离开栈了 取消网络  */
- (void)XZ_viewDidDisappear:(BOOL)animated{
    [self XZ_viewDidDisappear:animated];
    if (self.Nav == nil) {
        [self cancelNetworking];
    }
}

#pragma mark - AFHTTPSessionManager

-(void)setAFM:(AFHTTPSessionManager *)AFM{
    objc_setAssociatedObject(self, &HttpRequestXZAFNKey, AFM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(AFHTTPSessionManager *)AFM{
    AFHTTPSessionManager *_ = objc_getAssociatedObject(self, &HttpRequestXZAFNKey);
    if (_ == nil) {
        _ = [AFHTTPSessionManager manager];
        _.requestSerializer = [AFHTTPRequestSerializer serializer];
        _.responseSerializer = [AFHTTPResponseSerializer serializer];
        _.requestSerializer.timeoutInterval = 30;//网络超时 时间
        
        [_.requestSerializer setValue:@"ios" forHTTPHeaderField:@"tmbj-cli"];
        [_.requestSerializer setValue:[[NSBundle mainBundle] infoDictionary][@"CFBundleShortVersionString"] forHTTPHeaderField:@"tmbj-ver"];
        [_.requestSerializer setValue:[UIDevice currentDevice].identifierForVendor.UUIDString forHTTPHeaderField:@"tmbj-mobile-code"];
//        if ([UIDevice currentDevice].isSimulator) {//模拟器 每次都变 不乱搞
//            [_.requestSerializer setValue:@"AAAAAAAA-AAAA-AAAA-AAAA-AisSimulator" forHTTPHeaderField:@"tmbj-mobile-code"];
//        }
        
        self.AFM = _;
    }
    
    
    return _;
}


-(void)cancelNetworking{
    AFHTTPSessionManager *af = objc_getAssociatedObject(self, &HttpRequestXZAFNKey);
    if (af) {
        [af.operationQueue cancelAllOperations];
    }
}

/** 请求地址 参数 成功回调*/
-(void)POST:(NSString*)API Param:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc{
    [XZNetWorking API:API Param:param Vc:self AF:self.AFM Suc:Suc Fai:nil];
}
-(void)POST:(NSString*)API HudParam:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc{
    [self ShowHUD];
    [XZNetWorking API:API Param:param Vc:self AF:self.AFM Suc:Suc Fai:nil];
}


/** 请求地址 参数 成功回调 失败回调*/
-(void)POST:(NSString*)API Param:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))Fai{
    [XZNetWorking API:API Param:param Vc:self AF:self.AFM Suc:Suc Fai:Fai];
    
}
-(void)POST:(NSString*)API HudParam:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error))Fai{
    [self ShowHUD];
    [XZNetWorking API:API Param:param Vc:self AF:self.AFM Suc:Suc Fai:Fai];
}


#pragma mark - HUD

- (MBProgressHUD *)HUD{
    return objc_getAssociatedObject(self, HttpRequestHUDKey);
}

- (void)setHUD:(MBProgressHUD *)HUD{
    objc_setAssociatedObject(self, HttpRequestHUDKey, HUD, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(void)ShowHUD{
    [self ShowHUD:nil Touch:NO Img:-1 Delay:-1];
}

-(void)ShowHUD:(NSString*)text De:(CGFloat)delay{
    [self ShowHUD:text Touch:YES Img:-1 Delay:delay];
}

-(void)ShowHUD:(NSString*)text Img:(NSInteger)img De:(CGFloat)delay{
    [self ShowHUD:text Touch:YES Img:img Delay:delay];
}

/** 转 和 文字 */
-(void)ShowHUDLabelText:(NSString*)text De:(CGFloat)delay{
    MBProgressHUD *HUD = [self showInReasonableView];
    HUD.userInteractionEnabled = YES;
    if (iPhone6_PBigger) {
        
    }else{
        HUD.yOffset = - 48.0f;
    }
    HUD.labelText = text;
    if (delay != -1) {
        if (delay == 0) {
            [HUD hide:YES afterDelay:0.618];
        }else{
            [HUD hide:YES afterDelay:delay];
        }
    }
    [self setHUD:HUD];
}

-(void)ShowHUD:(NSString*)text Touch:(BOOL)touch Img:(NSInteger)img Delay:(CGFloat)delay{
    [self.HUD hide:YES];
    MBProgressHUD *HUD = [self showInReasonableView];
    //    if (text && HUD) {
    //
    //    }else{
    //        [self.HUD hide:YES];
    //        HUD = [self showInReasonableView];
    //    }
    
    HUD.userInteractionEnabled = !touch;
    if (iPhone6_PBigger) {
        
    }else{
        HUD.yOffset = - 48.0f;
    }
    
    if (text) {
        HUD.mode = MBProgressHUDModeText;
        (text.length > 10) ? (HUD.detailsLabelText = text) : (HUD.labelText = text);
    }
    if (img == 1 || img == 0) {
        HUD.mode = MBProgressHUDModeCustomView;
        HUD.customView = [[UIImageView alloc] initWithImage:(img) ? ([UIImage imageNamed:@"Checkmark_success_white"]) : ([UIImage imageNamed:@"Checkmark_failure_white"])];
    }
    if (delay != -1) {
        if (delay == 0) {
            [HUD hide:YES afterDelay:1];
        }else{
            [HUD hide:YES afterDelay:delay];
        }
    }
    [self setHUD:HUD];
}

//显示到合理的视图层
- (MBProgressHUD *)showInReasonableView{
    if ([self isKindOfClass:[UITableViewController class]] || [self isKindOfClass:[UICollectionView class]]) {
        return [MBProgressHUD showHUDAddedTo:self.view.superview ? : self.view animated:YES];
    }else  if ([self isKindOfClass:[UINavigationController class]]) {
        return [MBProgressHUD showHUDAddedTo:[[UIApplication sharedApplication].delegate window] animated:YES];
    }else {
        return [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)hideHud{
    [[self HUD] hide:YES];
}

#pragma mark -

//验证输入内容不能为空震动提示 becomeFirstResponder  Tf Tv 数组  提示数组 可空  默认为它的placeholder
-(BOOL)TextinputEmptyError:(NSArray*)VArr E:(NSArray*)EArr{
    __block BOOL Err = NO;
    CGFloat Delay = 1.2;
    [VArr enumerateObjectsUsingBlock:^(UIView   *inputview, NSUInteger idx, BOOL *  stop) {
        if ([inputview isKindOfClass:[UITextField class]]) {
            if (((UITextField*)inputview).text.length == 0) {
                [inputview.layer XZ_Shake];[inputview becomeFirstResponder];
                (EArr && EArr.count >= idx + 1) ? [self ShowHUD:EArr[idx] De:Delay] : [self ShowHUD:((UITextField*)inputview).placeholder De:Delay];
                *stop = YES;Err = YES;return ;
            }
        }else if ([inputview isKindOfClass:[XZTextView class]]){
            if (((XZTextView*)inputview).text.length == 0) {
                [inputview.layer XZ_Shake];[inputview becomeFirstResponder];
                (EArr && EArr.count >= idx + 1) ? [self ShowHUD:EArr[idx] De:Delay] : [self ShowHUD:((XZTextView*)inputview).placeHolder De:Delay];
                *stop = YES;Err = YES;return ;
            }
        }else if([inputview isKindOfClass:[UILabel class]]){
            if (((UILabel*)inputview).text.length == 0) {
                if (EArr && EArr.count >= idx + 1) {
                    [self ShowHUD:EArr[idx] De:Delay];
                }
                *stop = YES;Err = YES;return ;
            }
        }
    }];
    return Err;
}

/** 获取storyboard构建的VC   不重写就默认[[[self class]alloc]init] */
+ (instancetype)Vc{
    return [[[self class]alloc]init];
}

/** 默认传参方法 */
- (instancetype)sendInfo:(id)info{
    return self;
}

/** self.navigationController */
-(UINavigationController *)Nav{
    if ([self isKindOfClass:[UINavigationController class]]) {
        return (UINavigationController *)self;
    }
    UINavigationController *nav = self.navigationController;
    return nav ? nav : self.tabBarController.navigationController;
}

/** 导航控制器 取得对应栈上的vc*/
+ (instancetype)InNav{
    return [XZApp.window.rootViewController findVC:NSStringFromClass(self)];
}

/**  导航控制器 取得对应栈上的vc */
-(UIViewController*)findVC:(NSString*)ClassStr{
    UINavigationController *CurrentNav = (UINavigationController*)([self isKindOfClass:[UINavigationController class]] ? (self) : (self.Nav));
    for (UIViewController *vc in [CurrentNav.viewControllers reverseObjectEnumerator]) {
        if ([vc isKindOfClass:[UITabBarController class]]) {
            UITabBarController   *Tab = (UITabBarController*)vc;
            for (UIViewController *vc in [Tab.viewControllers reverseObjectEnumerator]) {
                if ([vc isKindOfClass:NSClassFromString(ClassStr)]) {
                    return vc;
                }
            }
        }
        if ([vc isKindOfClass:NSClassFromString(ClassStr)]) {
            return vc;
        }
    }
    return nil;
}

/** self.Nav 默认动画 pushViewController:vc animated:YES */
-(void)pushVC:(UIViewController*)vc{
    [self.Nav pushViewController:vc animated:YES];
}

/** showViewController */
+ (void)ShowVC{
    [XZApp.window.rootViewController showViewController:[self Vc] sender:nil];
}

/** showViewController  顺便调 sendInfo:  传参 */
+ (void)ShowVC:(id)info{
    [XZApp.window.rootViewController showViewController:[[self Vc] sendInfo:info] sender:nil];
}

/** showViewController; */
- (void)showVC{
    [XZApp.window.rootViewController showViewController:self sender:nil];
}

/**  构建 rightBarButtonItem title */
-(void)RightBarBtn:(NSString*)title act:(SEL)selector{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
}
/**< 构建 rightBarButtonItem 图片名字 */
-(void)RightBarBtnImgN:(NSString*)imageN act:(SEL)selector{
    self.navigationItem.rightBarButtonItem  =  [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:imageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:selector];
}


/** 打个电话 */
-(void)CallTelephone:(NSString*)link{
    UIWebView *callWebview = [[UIWebView alloc]init];
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",link]];
    if([[UIApplication sharedApplication] canOpenURL:url]){
        [callWebview loadRequest:[NSURLRequest requestWithURL:url]];
        [self.view addSubview:callWebview];
    }else{
        [self ShowHUD:@"这打不了电话 😅" Img:0 De:1.28];
    }
}

/** 打开 个网页 */
-(void)webOpenUrl:(NSString*)link{
    
    if (link.length <= 0) {
        return;
    }
    if ([link hasPrefix:@"tmbj://"]) {
        
        NSString *createLink = [[QTZ_URLBySafariMethod shareManager] receiveUrlBySafari:link];
        if (createLink == nil) {
            return;
        }else{
            link = [createLink copy];
        }
    }
    if ([link hasPrefix:@"http://"] || [link hasPrefix:@"https://"]) {
        
    }
    [[XZDebugTool__ Shared] addDicLog:@{@"链接" : link} Param:@{} API:@"打开个网页"];
    
//    TmbjH5VC *webViewController = [[TmbjH5VC alloc] initWithUrl:[NSString stringWithFormat:@"%@%@",[[link lowercaseString] hasPrefix:@"http"] ? @"" : @"http://",link]];
//    [self.Nav pushViewController:webViewController animated:YES];
    
}

@end

