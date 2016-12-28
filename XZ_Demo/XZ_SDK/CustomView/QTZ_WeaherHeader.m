//
//  QTZ_WeaherHeader.m
//  com.tmbj.qtzUser_XZ
//
//  Created by iOS_XZ on 16/5/31.
//  Copyright © 2016年 XZ. All rights reserved.
//
#import "XZUtility.h"
#import "QTZ_WeaherHeader.h"

@interface Weather_Mod : NSObject
@property (nonatomic, copy) NSString *dayPictureUrl;
@property (nonatomic, copy) NSString *dec;
@property (nonatomic, copy) NSString *highTemperature;
@property (nonatomic, copy) NSString *lowTemperature;
@property (nonatomic, copy) NSString *nightPictureUrl;
@property (nonatomic, copy) NSString *nowTemperature;
@property (nonatomic, copy) NSString *weather;
@end
@implementation Weather_Mod

@end

@interface QTZ_WeaherHeader ()
@property (nonatomic, strong) UIView *weatherView;
@property (weak, nonatomic) UIImageView *arrowView;
@property (weak, nonatomic) UIActivityIndicatorView *loadingView;
@property (weak, nonatomic) UILabel *lb1;
@property (weak, nonatomic) UILabel *lb2;
@property (strong, nonatomic) UILabel *lb3;
@property (weak, nonatomic) UILabel *lb4;
@property (weak, nonatomic) UILabel *lb5;

@end

@implementation QTZ_WeaherHeader
{
    Weather_Mod *_weather_Mod;
}

- (void)prepare
{
    [super prepare];
    self.mj_h = 64;
    self.backgroundColor =kColorBackground;
    [self addSubview:self.loadingView];
    [self addSubview:self.arrowView];
    [self addSubview:self.weatherView];
    
}


#pragma mark - 公共方法
- (void)setActivityIndicatorViewStyle:(UIActivityIndicatorViewStyle)activityIndicatorViewStyle{
    
    self.loadingView = nil;
    [self setNeedsLayout];
}

#pragma mark - 重写父类的方法
- (void)placeSubviews{
    [super placeSubviews];
    
    // 箭头的中心点
    CGFloat arrowCenterX = self.mj_w * 0.5;

    CGFloat arrowCenterY = self.mj_h * 0.25;
    CGPoint arrowCenter = CGPointMake(arrowCenterX, arrowCenterY);
    
    // 箭头
    if (self.arrowView.constraints.count == 0) {
        self.arrowView.mj_size = self.arrowView.image.size;
        self.arrowView.center = arrowCenter;
    }
    // 圈圈
    if (self.loadingView.constraints.count == 0) {
        self.loadingView.center = arrowCenter;
    }
    //天气视图
    self.weatherView.mj_y = 30;
}



- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    
    // 根据状态做事情
    if (state == MJRefreshStateIdle) {
        if (oldState == MJRefreshStateRefreshing) {
            self.arrowView.transform = CGAffineTransformIdentity;
            
            [UIView animateWithDuration:MJRefreshSlowAnimationDuration animations:^{
                self.loadingView.alpha = 0.0;
            } completion:^(BOOL finished) {
                // 如果执行完动画发现不是idle状态，就直接返回，进入其他状态
                if (self.state != MJRefreshStateIdle) return;
                
                self.loadingView.alpha = 1.0;
                [self.loadingView stopAnimating];
                self.arrowView.hidden = NO;
            }];
        } else {
            [self.loadingView stopAnimating];
            self.arrowView.hidden = NO;
            [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
                self.arrowView.transform = CGAffineTransformIdentity;
            }];
        }
    } else if (state == MJRefreshStatePulling) {
        [self.loadingView stopAnimating];
        self.arrowView.hidden = NO;
        [UIView animateWithDuration:MJRefreshFastAnimationDuration animations:^{
            self.arrowView.transform = CGAffineTransformMakeRotation(0.000001 - M_PI);
        }];
    } else if (state == MJRefreshStateRefreshing) {
        self.loadingView.alpha = 1.0; // 防止refreshing -> idle的动画完毕动作没有被执行
        [self.loadingView startAnimating];
        self.arrowView.hidden = YES;
    }
}

- (void)setPullingPercent:(CGFloat)pullingPercent
{
    [super setPullingPercent:pullingPercent];
    self.lb1.text = @"洗\n车";
//    self.lb2.text = [XZApp.weather_Mod.dec hasSuffix:@"不"]? @"不宜" :@"宜";
//    NSMutableAttributedString *str1 = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ / %@\n %@",[XZApp.weather_Mod.lowTemperature stringByReplacingOccurrencesOfString:@"℃" withString:@""] ? : @"--",XZApp.weather_Mod.highTemperature ? : @"--" ,XZApp.weather_Mod.weather ? : @"--"]];
    
//    [str1 addAttribute:NSForegroundColorAttributeName value:kColorText range:NSMakeRange(0,str1.length)];
//    [str1 addAttribute:NSFontAttributeName value:[UIFont boldSystemFontOfSize:13] range:NSMakeRange(0, str1.length)];
//    [str1 addAttribute:NSFontAttributeName value:font(11) range:NSMakeRange(str1.length - XZApp.weather_Mod.weather.length, XZApp.weather_Mod.weather.length)];
    
//    self.lb3.attributedText = str1;
    
}

- (UIImageView *)arrowView{
    if (!_arrowView) {
        UIImage *image = [UIImage imageNamed:MJRefreshSrcName(@"arrow.png")] ?: [UIImage imageNamed:MJRefreshFrameworkSrcName(@"arrow.png")];
        UIImageView *arrowView = [[UIImageView alloc] initWithImage:image];
        [self addSubview:_arrowView = arrowView];
    }
    return _arrowView;
}

- (UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

-(UIView *)weatherView
{
    if (!_weatherView) {
        _weatherView = [self weather_HeaderView];
    }
    return _weatherView;
}

- (UIView *)weather_HeaderView{
//    CGFloat width2 = (ScreenWidth -  ScreenWidth *0.3 )* 0.33;
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 40)];
//    view.backgroundColor = kColorBackground;
//    UILabel *lb = [UILabel Frame:CGRectMake(0, view.height *0.2, 20, view.height *0.6) Title:@"|" FontS:11 Color:kColorText Alignment:NSTextAlignmentCenter];
//    lb.font = [UIFont systemFontOfSize:20 weight:-1];
//    lb.centerX = view.centerX;
//    UILabel *lb1 = [UILabel Frame:CGRectMake(CGRectGetMinX(lb.frame) - 20, 0, 20, view.height) Title:@"洗\n车" FontS:11 Color:kColorText Alignment:NSTextAlignmentCenter];
    
//    UILabel *lb2 = [UILabel Frame:CGRectMake(CGRectGetMinX(lb1.frame) - 60, 0, 60, view.height) Title:[XZApp.weather_Mod.dec hasSuffix:@"不"]? @"不宜" :@"宜" FontS:28 Color:kColorText Alignment:NSTextAlignmentRight];
//    
//    UILabel *lb3 = [UILabel Frame:CGRectMake(CGRectGetMaxX(lb.frame), 0, width2, view.height) Title:[NSString stringWithFormat:@"%@ / %@",XZApp.weather_Mod.lowTemperature ? : @"--",XZApp.weather_Mod.highTemperature ? : @"--"] FontS:0 Color:kColorText Alignment:NSTextAlignmentLeft];
    
//    
//    [view addSubview:lb];
//    [view addSubview:lb1];
//    [view addSubview:lb2];
//    [view addSubview:lb3];
//    self.lb1 = lb1;
//    self.lb2 = lb2;
//    self.lb3 = lb3;
    
    return view;
}

@end
