
#import "UIViewController+XZNavBar.h"
#import "XZUtility.h"
#import <objc/runtime.h>

#pragma mark - 返回控制

@implementation UINavigationController (ShouldPopOnBackButton)

- (BOOL)navigationBar:(UINavigationBar *)navigationBar shouldPopItem:(UINavigationItem*)item {
    if([self.viewControllers count] < [navigationBar.items count]) {
        return YES;
    }
    BOOL shouldPop = YES;
    UIViewController* vc = [self topViewController];
    if([vc respondsToSelector:@selector(XZ_navPopBtnClick)]) {
        shouldPop = [vc XZ_navPopBtnClick];
    }
    
    if(shouldPop) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self popViewControllerAnimated:YES];
        });
    } else {
        for(UIView *subview in [navigationBar subviews]) {
            if(subview.alpha < 1.) {
//                [UIView animateWithDuration:.25 animations:^{
//                    subview.alpha = 1.;
//                }];
            }
        }
    }
    
    return NO;
}


@end

#pragma mark - 🔵 ====== ====== UIViewController ====== ======  🔵


@implementation UIViewController (XZNavBar)

#pragma mark - UITableView 显示完整的CellSeparator线

-(void)setFullcellsep:(BOOL)fullcellsep{
    objc_setAssociatedObject(self, @selector(fullcellsep), @(fullcellsep), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)fullcellsep{
    return [objc_getAssociatedObject(self, _cmd) boolValue];
}

-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    if (!self.fullcellsep) {
        return;
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setPreservesSuperviewLayoutMargins:)]) {
        [cell setPreservesSuperviewLayoutMargins:NO];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma mark - 自定义导航栏

/** 透明的  navigationBar*/
- (void)alpha0Nav:(BOOL)alpha0{
    self.Nav.navigationBar.clipsToBounds = alpha0;
    self.Nav.navigationBar.translucent = alpha0;
    
    //    [self.Nav.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    //    self.Nav.navigationBar.shadowImage = [UIImage new];
    
    //    [[self.Nav.navigationBar subviews] objectAtIndex:0].alpha = 0;
}

static const void *XZLa_TitleKey;

-(void)setXZTitle:(NSString *)XZTitle{
    objc_setAssociatedObject(self, @selector(XZTitle), XZTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    UILabel *la = objc_getAssociatedObject(self, &XZLa_TitleKey);
    la.text = XZTitle;
    if (la == nil) {
        la = [UILabel Frame:CGRectMake(ScreenWidth*0.2, 30, ScreenWidth*0.6, 20) Title:XZTitle FontS:17.5 Color:kColorText Alignment:NSTextAlignmentCenter];
        [self.Ve_XZBar addSubview:la];
        objc_setAssociatedObject(self, &XZLa_TitleKey, la, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

-(NSString *)XZTitle{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setVe_XZBar:(UIView *)Ve_XZBar{
    objc_setAssociatedObject(self, @selector(Ve_XZBar), Ve_XZBar, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIView *)Ve_XZBar{
    return objc_getAssociatedObject(self, _cmd);
}

-(void)setBtn_back:(UIButton *)Btn_back{
    objc_setAssociatedObject(self, @selector(Btn_back), Btn_back, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(UIButton *)Btn_back{
    return objc_getAssociatedObject(self, _cmd);
}

- (void)XZ_CustomNavBar{
    self.fd_prefersNavigationBarHidden = YES;
    UIView *navBar = objc_getAssociatedObject(self, @selector(Ve_XZBar));
    if (navBar != nil) {
        return;
    }
    [self.view addSubview:self.Ve_XZBar = [self customNavBarView]];
}

- (UIView *)customNavBarView{
    UIView *navBar = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 64)];
    navBar.backgroundColor = [UIColor whiteColor];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(0, navBar.height - 0.3)];
    [path addLineToPoint:CGPointMake(navBar.width, navBar.height - 0.3)];
    [path closePath];
    shapeLayer.path = path.CGPath;
    shapeLayer.strokeColor = [kColorTextGray CGColor];
    shapeLayer.fillColor = [[UIColor whiteColor] CGColor];
    shapeLayer.lineWidth = 0.35;
    
    [navBar.layer addSublayer:shapeLayer];//kColorText
    
    [navBar addSubview:self.Btn_back = [self customBackButton]];
    return navBar;
}

- (XZxibButton*)customBackButton{
    XZxibButton *btnBack = [XZxibButton Frame:CGRectMake(8, 30, 16, 21) Title:nil FontS:0 Color:nil radius:0 Target:self action:@selector(customNavBackBtnClick) Bimg:nil];
    btnBack.moreTouchMargin = CGRectMake(8, 30, 80, 20);
    [btnBack setImage:[[UIImage imageNamed:@"NavBackBtn"]imageWithColor:kColorText] forState:UIControlStateNormal];
    [btnBack setImage:[[UIImage imageNamed:@"NavBackBtn_h"]imageWithColor:kColorText] forState:UIControlStateHighlighted];
    return btnBack;
}

#pragma mark - 返回控制

/** 点击了 导航栏返回按钮 取消网络  */
- (BOOL)XZ_navPopBtnClick{
    [self cancelNetworking];
    return YES;
}

- (void)customNavBackBtnClick{
    [self.Nav popViewControllerAnimated:YES];
    [self XZ_navPopBtnClick];
}

- (XZxibButton*)createCustomRightBarBtn:(NSString*)title act:(SEL)selector{
    [self.Ve_XZBar XZ_RemoveClassView:[XZxibButton class]];
    XZxibButton *btnBack = [XZxibButton Frame:CGRectMake(0, 20, 60, 44) Title:title FontS:15 Color:nil radius:0 Target:self action:selector Bimg:nil];
    btnBack.moreTouchMargin = CGRectMake(30, 20, 12, 0);
    btnBack.width = [btnBack sizeThatFits:CGSizeMake(ScreenWidth*0.4, 44)].width;
    btnBack.x = ScreenWidth - btnBack.width - 12;
    return btnBack;
}

/**  构建 rightBarButtonItem title */
-(void)XZ_rightBarBtn:(NSString*)title act:(SEL)selector{
    if (self.Nav.navigationBar.hidden && self.Ve_XZBar) {
        [self.Ve_XZBar addSubview:[self createCustomRightBarBtn:title act:selector]];
        return;
    }
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:selector];
}
/** 构建 rightBarButtonItem 图片名字 */
-(void)XZ_rightBarBtnImgN:(NSString*)imageN act:(SEL)selector{
    if (self.Nav.navigationBar.hidden && self.Ve_XZBar) {
        XZxibButton *btnBack = [self createCustomRightBarBtn:nil act:selector];
        [btnBack setImage:[UIImage imageNamed:imageN] forState:UIControlStateNormal];
        [self.Ve_XZBar addSubview:btnBack];
        return;
    }
    self.navigationItem.rightBarButtonItem  =  [[UIBarButtonItem alloc]initWithImage:[[UIImage imageNamed:imageN] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]  style:UIBarButtonItemStylePlain target:self action:selector];
}


@end
