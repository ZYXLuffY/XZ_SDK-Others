
#import "XZBaseNavtion.h"
#import "XZUtility.h"
#import "AFNetworkReachabilityManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "IQKeyboardManager.h"
#import "XZDebugTool__.h"


@interface XZBaseNavtion ()<UIGestureRecognizerDelegate>
@property (nonatomic,strong) UIButton *Btn_NotNetwork;

@end

@implementation XZBaseNavtion
@synthesize Btn_NotNetwork;

-(void)dealloc{
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self Nav_Style];
    self.view.backgroundColor = [UIColor whiteColor];
    [IQKeyboardManager sharedManager].enable = YES;
    [IQKeyboardManager sharedManager].enableAutoToolbar = NO;

    delay(1, ^{
        [XZDebugTool__ Shared].Btn_touch.alpha =  [XZDebugTool__ Shared].Ve_Main.alpha = 1;
    });
}

#ifdef DEBUG
- (void)motionBegan:(UIEventSubtype)motion withEvent:(UIEvent *)event {
    [XZDebugTool__ Shared].Btn_touch.alpha =  [XZDebugTool__ Shared].Ve_Main.alpha = (fabs(1 - [XZDebugTool__ Shared].Btn_touch.alpha));
}
#endif

#pragma mark -  屏幕旋转的
-(BOOL)shouldAutorotate{
    return YES;
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    NSArray *LandscapeVC = @[@"BXuploadInfoVC_ImgVC",@"MWPhotoBrowser"];
    if ([LandscapeVC containsObject:NSStringFromClass([self.viewControllers.lastObject class])]) {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    return UIInterfaceOrientationMaskPortrait;
}


-(void)Nav_Style{
    self.navigationBar.translucent = NO;
    //    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    //    [[UINavigationBar appearance] setBarTintColor:kColorText];
    //    [[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];
    
    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kColorText,NSFontAttributeName : [UIFont systemFontOfSize:17 weight:UIFontWeightMedium]}];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0.0f,-60.0f) forBarMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0.0f,-60.0f) forBarMetrics:UIBarMetricsCompact];
    //    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(0.0f,-1.0) forBarMetrics:UIBarMetricsDefault];
    
    [self.Nav.navigationBar setBackgroundImage:[UIImage XZ_ColoreImage:[UIColor whiteColor]] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    [self.Nav.navigationBar setShadowImage:[UIImage new]];
    //    [self.Nav.navigationBar setBackgroundImage:nil forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    //    [self.Nav.navigationBar setShadowImage:nil];
    
    [self.Nav.navigationBar setShadowImage:[UIImage XZ_ColoreImage:kColorSeparator]];
    
//    [[UINavigationBar appearance] setBarTintColor:(HexColor(0xf8f7f6))];
//    //    //状态栏 白色背景
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
//    [[UIApplication sharedApplication] setStatusBarHidden:NO];
//    [[UINavigationBar appearance] setBarStyle:UIBarStyleDefault];
//    [[UINavigationBar appearance] setBackgroundImage:[UIImage XZ_ColoreImage:EVGO_Color] forBarMetrics:UIBarMetricsDefault];
//    [[UINavigationBar appearance] setBarTintColor:YF_MainColor];
//    //导航栏 返回键颜色
//    [[UINavigationBar appearance] setTintColor:(HexColor(0x333333))];
//    //导航栏 字体颜色 和 大小
//    [[UINavigationBar appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor],NSFontAttributeName : [UIFont boldSystemFontOfSize:17.5f]}];
//    //导航栏 title位置
//    [[UINavigationBar appearance] setTitleVerticalPositionAdjustment:-1.0f forBarMetrics:UIBarMetricsDefault];
    
    //左右边按钮
    [[UIBarButtonItem appearance] setTitleTextAttributes:@{NSForegroundColorAttributeName: kColorText,NSFontAttributeName : [UIFont systemFontOfSize:13.5f]} forState:UIControlStateNormal];
    //    [[UIBarButtonItem appearance] setTitlePositionAdjustment:UIOffsetMake(0, -4) forBarMetrics:UIBarMetricsDefault];
    
    //导航栏 返回键
    UIImage *backButtonImage = [[[[UIImage imageNamed:@"NavBackBtn"] imageWithColor:kColorText] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] resizableImageWithCapInsets:UIEdgeInsetsMake(0,16,0, 0)];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:backButtonImage forState:UIControlStateNormal barMetrics:UIBarMetricsCompact];
    
}


@end
