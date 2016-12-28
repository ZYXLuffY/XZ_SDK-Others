
#import "XZButton.h"
#import "XZUtility.h"

#pragma mark -  XZxibButton

@interface XZxibButton ()

@property (nonatomic,copy)  NSString *NormalStr;
@property (nonatomic,assign) BOOL NormalEnable;
@property (nonatomic,strong) UIImage *NormalImg;

@end

@implementation XZxibButton


-(UIActivityIndicatorView *)Act_{
    if (_Act_ == nil) {
        [self layoutIfNeeded];
        UIActivityIndicatorView *_ = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        _.origin = CGPointMake((self.width - 20)/2, (self.height - 20)/2);
        _.color = [UIColor blackColor];
        [self addSubview:_Act_ = _];
    }
    return _Act_;
}

-(void)Loading{
    if (self.currentTitle) {
        _NormalStr = self.currentTitle;
    }
    [self setTitle:@"" forState:UIControlStateNormal];
    [self.Act_ startAnimating];
    _NormalEnable = self.enabled;
    self.enabled = NO;
    _NormalImg = [self imageForState:UIControlStateNormal];
    [self setImage:nil forState:UIControlStateNormal];
}

-(void)StopLing{
    self.titleLabel.hidden = NO;
    [self setTitle:_NormalStr forState:UIControlStateNormal];
    [_Act_ stopAnimating];
    self.enabled = _NormalEnable;
    [self setImage:_NormalImg forState:UIControlStateNormal];
}

//添加边界 点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bouds = CGRectMake(self.bounds.origin.x - _moreTouchMargin.origin.x,
                              self.bounds.origin.y - _moreTouchMargin.origin.y,
                              self.bounds.size.width + _moreTouchMargin.size.width + _moreTouchMargin.origin.x,
                              self.bounds.size.height + _moreTouchMargin.size.height + _moreTouchMargin.origin.y);
    BOOL contain = CGRectContainsPoint(bouds,point);
    return contain;
}

@end





#pragma mark - XZButton 图片 文本限定 范围 的BTN

@implementation XZButton

- (instancetype)initWithFrame:(CGRect)frame ImgF:(CGRect)imgf TitF:(CGRect)titf Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)titleColor imageName:(NSString*)imageName Target:(id)target action:(SEL)action{
    self = [super initWithFrame:frame];
    _imgf = imgf;
    _titf = titf;
    
    if (imageName) {
        [self setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
        self.imageView.contentMode = UIViewContentModeScaleAspectFit;//UIViewContentModeCenter UIViewContentModeScaleAspectFit
    }
    
    if (title) {
        [self setTitle:title forState:UIControlStateNormal];
        self.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    if (fonts != 0) {
        self.titleLabel.font = [UIFont systemFontOfSize:fonts];
    }
    
    if (titleColor) {
        [self setTitleColor:(titleColor ? : [UIColor whiteColor]) forState:UIControlStateNormal];
        [self setTitleColor:[(titleColor ? : [UIColor whiteColor]) XZ_Abe:1 Alpha:0.6] forState:UIControlStateHighlighted];
    }
    
    if (target) {
        [self addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame ImgF:(CGRect)imgf TitF:(CGRect)titf{
    self = [self initWithFrame:frame ImgF:imgf TitF:titf Title:nil FontS:15 Color:nil imageName:nil Target:nil action:nil];
    return self;
}

/** 设置文本和图片距离文本的水平位置 UIControlStateNormal*/
- (void)resetTitle:(NSString*)title imgMargin:(CGFloat)margin{
    [self setTitle:title forState:UIControlStateNormal];
    self.imgf = CGRectMake((self.width/2 + [self.currentTitle __W__:self.titleLabel.font.pointSize H:self.height]/2) + margin , self.imgf.origin.y, self.imgf.size.width, self.imgf.size.height);
}

/** 覆盖父类在highlighted时的所有操作 */
- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
}

/** 调整内部ImageView的frame */
- (CGRect)imageRectForContentRect:(CGRect)contentRect{
    return _imgf;
}

/** 调整内部UILabel的frame */
- (CGRect)titleRectForContentRect:(CGRect)contentRect{
    if (!CGRectEqualToRect(_titf, CGRectZero)){
        return _titf;
    }
    return contentRect;
}



@end





@implementation XZScaleButton

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    self.transform = CGAffineTransformScale(self.transform, 0.98, 0.98);
}

-(void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesEnded:touches withEvent:event];
    self.transform = CGAffineTransformIdentity;
}

@end











