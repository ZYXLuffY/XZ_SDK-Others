
#import "UIButton+XZ.h"
#import "NSString+XZ.h"
#import "UIImage+XZ.h"
#import "UIView+XZ.h"
#import "UIColor+XZ.h"
@implementation UIButton (XZ)
@dynamic BackClickImg,BackClickImg_h,BackClickImg_d,BackClickImg_s;

+(instancetype)Frame:(CGRect)frame Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)titleColor radius:(CGFloat)rad Target:(id)target action:(SEL)action  Bimg:(UIColor*)BColor{
    UIButton *_ = [[self alloc]initWithFrame:frame];
    [_ setTitle:title forState:UIControlStateNormal];
    if (fonts != 0) {
    _.titleLabel.font = [UIFont systemFontOfSize:fonts];
    }
    if (titleColor) {
    [_ setTitleColor:titleColor forState:UIControlStateNormal];
    [_ setTitleColor:[titleColor XZ_Abe:1 Alpha:0.6] forState:UIControlStateHighlighted];
    }
    if (rad != 0) {
        _.rad = rad;
    }
    if (target) {
     [_ addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    if (BColor) {
        _.BackClickImg = BColor;
    }
    return _;
}

//默认 [self setBackgroundImage:[UIImage XZ_ColoreImage:color] forState:UIControlStateNormal];
-(void)setBackClickImg:(UIColor *)BackClickImg{
     [self setBackgroundImage:[UIImage XZ_ColoreImage:BackClickImg] forState:UIControlStateNormal];
}
-(void)setBackClickImg_h:(UIColor *)BackClickImg_h{
    [self setBackgroundImage:[UIImage XZ_ColoreImage:BackClickImg_h] forState:UIControlStateHighlighted];
}
-(void)setBackClickImg_d:(UIColor *)BackClickImg_d{
    [self setBackgroundImage:[UIImage XZ_ColoreImage:BackClickImg_d] forState:UIControlStateDisabled];
}

-(void)setBackClickImg_s:(UIColor *)BackClickImg_s{
     [self setBackgroundImage:[UIImage XZ_ColoreImage:BackClickImg_s] forState:UIControlStateSelected];
}

-(void)TouchEffect{
    self.selected = !self.isSelected;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.selected = !self.isSelected;
    });
}

/** 倒计时 总秒数 按钮文本后缀 结束时的回调*/
- (void)XZ_countDowns:(NSInteger)timeLine suffix:(NSString *)suffix end:(void(^)())block{
    __block NSInteger timeOut = timeLine;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t _timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    
    dispatch_source_set_timer(_timer, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0); //每秒执行一次
    
    dispatch_source_set_event_handler(_timer, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ((self.enabled = (timeOut <= 0))) {//倒计时结束，关闭
                dispatch_source_cancel(_timer);
                if (block) {  block();}
            } else {
                [self setTitle:[NSString stringWithFormat:@"%@%@",[NSString stringWithFormat:@"%0.1d", (int)timeOut--],suffix] forState:UIControlStateNormal];
            }
        });
    });
    
    dispatch_resume(_timer);
}

@end
