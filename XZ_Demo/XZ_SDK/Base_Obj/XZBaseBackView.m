
#import "XZBaseBackView.h"
#import "XZUtility.h"

const static CGFloat AnimateDuration  = 0.25;/**< 动画时间 */

@interface XZBaseBackView ()
{
    UIView *BackView;
}
@end

@implementation XZBaseBackView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    
    [self BaseSetup];
    
    return self;
}

-(void)BaseSetup{
    self.alpha = 0;
    self.backgroundColor = kRGBA(0, 0, 0, 0.5);
    
    //隐藏的点击背景
    BackView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:BackView];
    
//    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
//    effectView.frame = self.bounds;
//    BackView = effectView;
//    [self addSubview:BackView];
    
    [BackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideView)]];
    
    UIView *contentView = [[UIView alloc] initWithFrame:CGRectMake(0,ScreenHeight,ScreenWidth, _contentHeight)];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_V_Content = contentView];
    
    [self ShowView];
}

-(void)ChangeNavPopGestureEnable:(BOOL)enable{
    UINavigationController *Nav = (UINavigationController*)XZApp.window.rootViewController;
    if ([Nav isKindOfClass:[UINavigationController class]]) {
        Nav.interactivePopGestureRecognizer.enabled = enable;
    }
}

/** 显示 */
-(void)ShowView{
    [self ChangeNavPopGestureEnable:NO];
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 1;
        _V_Content.y = _V_Content.y - _contentHeight;
    }];
}

/** 隐藏 销毁 */
-(void)hideView{
    [self ChangeNavPopGestureEnable:YES];
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 0;
        _V_Content.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [BackView removeFromSuperview];
    }];
}

@end
