
#import "QTZ_StarEvaView.h"
#import "XZUtility.h"

@interface QTZ_StarEvaView ()
{
    CGFloat MaxW;
}
@property (nonatomic, strong) UIView *starForView;


@end

#define  Img_W      (36/2)          //星星的宽
#define  Img_H      (36/2)          //星星的高
#define  Img_Sep    (4)            //星星之间的间距
#define  Img_LRSep  (0)         //预留手势的左右间距

@implementation QTZ_StarEvaView
@synthesize starForView;
-(void)dealloc{
    NSLog(@"QTZ_StarEvaView dealloc");
}

+(instancetype)Point:(CGPoint)point addTo:(UIView*)addview numberOfStar:(int)number Block:(TB_Start)block{
    QTZ_StarEvaView *Rate = [[QTZ_StarEvaView alloc]initWithFrame:CGRectMake(point.x, point.y,(Img_W + Img_Sep)*number - Img_Sep + Img_LRSep*2, 50) numberOfStar:number];
    Rate.B_Start = block;
    [addview addSubview:Rate];
    return Rate;
}

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number{
    self = [super initWithFrame:frame];
    [self setupViewStar:5];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self layoutIfNeeded];
    [self setupViewStar:5];
    return self;
}

- (void)setupViewStar:(int)number{
    self.backgroundColor = [UIColor clearColor];
    starForView = [self buidlStarViewWithImageName:@"QTZ_StarEvaView1" numOfStar:_currentStar = number];
    [self addSubview:[self buidlStarViewWithImageName:@"QTZ_StarEvaView2" numOfStar:number]];
    [self addSubview:starForView];
    [self changeStarForegroundViewWithPoint:CGPointMake(self.frame.size.width*0.6 + Img_Sep, 1)];
    
    [self addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)]];
}

- (void)handlePan:(UIPanGestureRecognizer*)recognizer{
    //    NSLog(@"%@",NSStringFromCGPoint([recognizer locationInView:recognizer.view]));
    [self changeStarForegroundViewWithPoint:[recognizer locationInView:recognizer.view]];
}

//重复创建星星
- (UIView *)buidlStarViewWithImageName:(NSString *)imageName numOfStar:(NSInteger)numStar{
    UIView *view = [[UIView alloc] initWithFrame:self.bounds];
    view.clipsToBounds = YES;
    for (int i = 0; i < numStar; i ++) {
        UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:imageName]];
        imageView.frame = CGRectMake(i * (Img_W + Img_Sep) + Img_LRSep,(self.frame.size.height - Img_H)/2, Img_W ,Img_H);
        imageView.contentMode = UIViewContentModeScaleToFill;
        [view addSubview:imageView];
        if (i == numStar - 1) {
            MaxW = imageView.right;
        }
    }
    return view;
}

-(void)ChangeCurrentStar:(CGFloat)star block:(BOOL)block{
    [self changeStarForegroundViewWithPoint:CGPointMake((star*(Img_W + Img_Sep)) + Img_LRSep, 1) ];
}

-(void)setCurrentStar:(CGFloat)currentStar{
    _currentStar = currentStar;
    [self changeStarForegroundViewWithPoint:CGPointMake(currentStar == 0 ? 0 : (currentStar*(Img_W + Img_Sep)) + Img_LRSep, 1)];
}

- (void)changeStarForegroundViewWithPoint:(CGPoint)p{
    CGFloat X = p.x;
    if (X < 0 || X > MaxW) {
        X = (X < 0) ? 0 : MaxW;
    }
//    floor()/floorf()/floorl()函数：向下取整
//    ceil()/ceilf()/ceill()函数：向上取整
    _currentStar = (X/MaxW)*5;

//    starForView.frame = CGRectMake(0, 0,X, self.frame.size.height);
//    Block_Exec(_B_Start,_currentStar);
    
    
//    NSLog(@"Rate = %f",_currentStar);
    //0.5颗星
    CGFloat half = _currentStar - floorf(_currentStar);
    if (half < 0.25) {
        half = 0;
    }else if (half >= 0.25 && half < 0.5){
//        half = 0.5;
        half = 0;
    }else if (half >= 0.5 && half < 0.75){
//        half = 0.5;
        half = 1;
    }else{
        half = 1;
    }
    _currentStar = floorf(_currentStar) + half;
//    NSLog(@"修改 Rate = %f",_currentStar);
    
    starForView.frame = CGRectMake(0, 0,(_currentStar == 0 ? : _currentStar*(Img_W + Img_Sep)) - Img_Sep/2, self.frame.size.height);
    Block_Exec(_B_Start,_currentStar);

}



@end

