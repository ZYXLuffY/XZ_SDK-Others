
#import "XZPutDownMenuView.h"
#import "XZUtility.h"
#import "UIImageView+WebCache.h"
#define SelColor            (HexColor(0xe5e5e5))//浅灰色
#define TitleColor          (HexColor(0x222222))//字体颜色
#define DEGREES_TO_RADIANS(degrees)  ((3.14159265359 * degrees)/ 180)

const static CGFloat AnimateDuration  = 0.25;/**< 动画时间 */
const static CGFloat TableRowHeight   = 45;/**< 行高 */
const static CGFloat LineW = 0.8;/**< 边框宽 */
const static CGFloat Radius = 3;/**< 倒角 */

@interface XZPutDownMenuView_Cell : UITableViewCell

@property (nonatomic,strong) UILabel *La_;
@end

@implementation XZPutDownMenuView_Cell

-(UILabel *)La_{
    if (!_La_) {
        UILabel *_ = [[UILabel alloc]initWithFrame:CGRectMake(8, 0, self.width, self.height)];
        _.font = [UIFont systemFontOfSize:13];
        _.textColor = TitleColor;
        [self.contentView addSubview:_La_ = _];
    }
    return _La_;
}

@end



@interface XZPutDownMenuView  ()
{
    @public;
    UIView *BackView;
    NSArray *Arr_;
    CGSize arrowSize;/**< 箭头大小 */
    BOOL PositionUp;/**< 展开方向 YES 为向上 */
    UITableView *Tv_;
}

@end

@implementation XZPutDownMenuView

-(void)dealloc{
    NSLog(@"XZPutDownMenuView   dealloc");
}

+(void)ShowIn:(UIView*)view Point:(CGPoint)point List:(NSArray*)list Click:(B_Select)block PositionUp:(BOOL)PosUP{
    CGFloat MaxW = 40;
    for (NSString *Str  in list) {
        MaxW = MAX(MaxW, [Str __W__:13 H:20]);
    }
    
    CGFloat X = (point.x + MaxW + 30 > ScreenWidth) ? (ScreenWidth -  MaxW - 30) : point.x;
    
    XZPutDownMenuView *MenuView = [[self alloc]initWithFrame:CGRectMake(X, point.y, MaxW + 30, ScreenHeight - 64 - 49) inView:view List:list Click:block PositionUp:PosUP];
    [view addSubview:MenuView];
}
    
+(void)ShowIn:(UIView*)view Point:(CGPoint)point List:(NSArray*)list Click:(B_Select)block{
    [self ShowIn:view Point:point List:list Click:block PositionUp:NO];
}

+(void)ShowIn:(UIView*)view Frame:(CGRect)frame List:(NSArray*)list Click:(B_Select)block{
    XZPutDownMenuView *MenuView = [[self alloc]initWithFrame:frame inView:view List:list Click:block PositionUp:NO];
    [view addSubview:MenuView];
}

+(void)ShowIn:(UIView*)view Frame:(CGRect)frame List:(NSArray*)list Click:(B_Select)block PositionUp:(BOOL)PosUP{
    XZPutDownMenuView *MenuView = [[self alloc]initWithFrame:frame inView:view List:list Click:block PositionUp:PosUP];
    [view addSubview:MenuView];
}

-(instancetype)initWithFrame:(CGRect)frame inView:(UIView*)inview List:(NSArray*)list Click:(B_Select)block PositionUp:(BOOL)PosUP{
    self = [super initWithFrame:CGRectMake(CGRectGetMinX(frame), CGRectGetMinY(frame), CGRectGetWidth(frame),0)];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        _BL_Select = block;
        Arr_ = list;

        arrowSize = CGSizeMake(15, 8);//箭头大小
        PositionUp = PosUP;
        
        self.layer.shadowOffset = CGSizeMake(0, 5);
        self.layer.shadowOpacity = 0.5;
        
        //隐藏的点击背景
        BackView = [[UIView alloc]initWithFrame:inview.bounds];
        [inview addSubview:BackView];
        [BackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideView)]];
        
        [self addSubview:Tv_ =({
            UITableView  *table = [[UITableView alloc] initWithFrame:CGRectMake(LineW,(PositionUp ? 0 : arrowSize.height), self.width - LineW*2,0)];
            table.delegate = (id<UITableViewDelegate>)self;
            table.dataSource = (id<UITableViewDataSource>)self;
            table.layer.masksToBounds = YES;
            table.layer.cornerRadius = Radius;
            table.tableFooterView = [UIView new];
            [table registerClass:[XZPutDownMenuView_Cell class] forCellReuseIdentifier:@"XZPutDownMenuView_Cell"];
            table.scrollEnabled = Arr_.count*TableRowHeight > CGRectGetHeight(frame);
            table;
        })];
        
        [self ShowView:MIN(Arr_.count * TableRowHeight + arrowSize.height, CGRectGetHeight(frame))];
    }
    return self;
}
#pragma  mark - 显示 隐藏

-(void)ChangeNavPopGestureEnable:(BOOL)enable{
    UINavigationController *Nav = (UINavigationController*)XZApp.window.rootViewController;
    if ([Nav isKindOfClass:[UINavigationController class]]) {
        Nav.interactivePopGestureRecognizer.enabled = enable;
    }
}
/** 显示 */
-(void)ShowView:(CGFloat)height{
    [self ChangeNavPopGestureEnable:NO];
    self.layer.anchorPoint = CGPointMake(0.5,PositionUp ? 0.5 : 0);
    self.transform = CGAffineTransformMakeScale(0.1, 0.1);
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.transform = CGAffineTransformMakeScale(1, 1);
        self.frame = CGRectMake(self.x, self.y - (PositionUp ? height : 0), self.width, height);
        Tv_.frame = CGRectMake(Tv_.x,Tv_.y, Tv_.width,(height - arrowSize.height*1.5));
    }];
}
/** 隐藏 销毁 */
-(void)HideView{
    [self ChangeNavPopGestureEnable:YES];
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 0;
        self.frame = CGRectMake(self.x,self.y + (PositionUp ? self.height : 0),self.width, 0);
        Tv_.frame = CGRectMake(Tv_.x,0, Tv_.width,0);
         self.transform = CGAffineTransformMakeScale(0.01f, 0.01f);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [BackView removeFromSuperview];
        self.BL_Select = nil;
    }];
}

#pragma mark - UITableView Delegate DataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {return 1;}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath { return TableRowHeight;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return Arr_.count;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZPutDownMenuView_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZPutDownMenuView_Cell" forIndexPath:indexPath];
    cell.La_.text = [Arr_ objectAtIndex:indexPath.row];
    UIView *Selv = [[UIView alloc]initWithFrame:cell.bounds];
    Selv.backgroundColor = SelColor;
    cell.selectedBackgroundView = Selv;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_BL_Select) {
        _BL_Select(Arr_[indexPath.row],indexPath.row);
    }
    [self HideView];
}

/** 显示完整的CellSeparator线 */
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
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

#pragma mark - 画图
- (void)drawRect:(CGRect)rect{
    UIBezierPath *Path = [[UIBezierPath alloc] init];
    CGRect OldFrame = self.frame;
    self.width -= 2*LineW;self.height -= 2*LineW;
    CGFloat PointX = self.width/2;/** 箭头在中间位置 */
    if (PositionUp) {
        [Path moveToPoint:CGPointMake(PointX, self.height)];
        [Path addLineToPoint:CGPointMake(PointX-arrowSize.width*0.5, self.height-arrowSize.height)];
        [Path addLineToPoint:CGPointMake(Radius, self.height-arrowSize.height)];
        [Path addArcWithCenter:CGPointMake(Radius, self.height- arrowSize.height-Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(90.0) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(0, Radius)];
        [Path addArcWithCenter:CGPointMake(Radius, Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270.0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(self.width-Radius, 0)];
        [Path addArcWithCenter:CGPointMake(self.width-Radius, Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(self.width, self.height-arrowSize.height-Radius)];
        [Path addArcWithCenter:CGPointMake(self.width-Radius, self.height-arrowSize.height-Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(PointX+arrowSize.width*0.5 , self.height-arrowSize.height)];
    }else{
        [Path moveToPoint:CGPointMake(PointX, 0)];
        [Path addLineToPoint:CGPointMake(PointX+arrowSize.width*0.5, arrowSize.height)];
        [Path addLineToPoint:CGPointMake(self.width-Radius, arrowSize.height)];
        [Path addArcWithCenter:CGPointMake(self.width-Radius, arrowSize.height+Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(270.0) endAngle:DEGREES_TO_RADIANS(0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(self.width, self.height-Radius)];
        [Path addArcWithCenter:CGPointMake(self.width-Radius, self.height-Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(0) endAngle:DEGREES_TO_RADIANS(90.0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(Radius, self.height)];
        [Path addArcWithCenter:CGPointMake(Radius + LineW, self.height-Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(90) endAngle:DEGREES_TO_RADIANS(180.0) clockwise:YES];
        [Path addLineToPoint:CGPointMake(LineW, arrowSize.height+Radius)];
        [Path addArcWithCenter:CGPointMake(Radius + LineW, arrowSize.height+Radius) radius:Radius startAngle:DEGREES_TO_RADIANS(180.0) endAngle:DEGREES_TO_RADIANS(270) clockwise:YES];
        [Path addLineToPoint:CGPointMake(PointX-arrowSize.width*0.5, arrowSize.height)];
        [Path addLineToPoint:CGPointMake(PointX, 0)];
    }
    self.width = OldFrame.size.width;
    [Path setLineWidth:LineW];
    [SelColor setStroke]; //设置边框颜色
    [[UIColor whiteColor] setFill];
    [Path stroke];
    [Path fill];
}



@end



@interface XZPutDownMenuView_CarList_Cell : UITableViewCell

@property (nonatomic,strong) UILabel *La_;
@property (nonatomic,strong) UIImageView *Img_;

@end

@implementation XZPutDownMenuView_CarList_Cell

-(UIImageView *)Img_{
    if (!_Img_) {
        [self.contentView addSubview:_Img_ = [[UIImageView alloc]initWithFrame:CGRectMake(5, (self.height - 28)/2, 28, 28)]];
    }
    return _Img_;
}

-(UILabel *)La_{
    if (!_La_) {
        [self.contentView addSubview:_La_ = [UILabel Frame:CGRectMake(_Img_.right + 8, 0, self.width - 20, self.height) Title:nil FontS:17 Color:kColorText]];
        _La_.adjustsFontSizeToFitWidth = YES;
    }
    return _La_;
}

@end

@interface XZPutDownMenuView_CarList ()
{
    BOOL ShowAddCar;
}
@end
@implementation XZPutDownMenuView_CarList

+(void)ShowIn:(UIView*)view Frame:(CGRect)frame List:(NSArray*)list AddCar:(BOOL)addcar Click:(B_Select)block{
    XZPutDownMenuView *MenuView = [[self alloc]initWithFrame:frame inView:view List:list Click:block PositionUp:NO AddCar:addcar];
    [view addSubview:MenuView];
}

-(instancetype)initWithFrame:(CGRect)frame inView:(UIView *)inview List:(NSArray *)list Click:(B_Select)block PositionUp:(BOOL)PosUP AddCar:(BOOL)addcar{
    self = [super initWithFrame:frame inView:inview List:list Click:block PositionUp:PosUP];
    if (self) {
        [Tv_ registerClass:[XZPutDownMenuView_CarList_Cell class] forCellReuseIdentifier:@"XZPutDownMenuView_CarList_Cell"];
        ShowAddCar = addcar;
        Tv_.scrollEnabled = (Arr_.count + (addcar ? 1 : 0))*TableRowHeight > CGRectGetHeight(frame);
        [self ShowView:MIN((Arr_.count + (addcar ? 1 : 0))* TableRowHeight + arrowSize.height, CGRectGetHeight(frame))];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { return Arr_.count + (ShowAddCar ? 1 : 0);}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == Arr_.count) {
        Block_Exec(self.BL_Select,@"",indexPath.row);
        [self HideView];
        return;
    }
    if (self.BL_Select) {
        self.BL_Select(Arr_[indexPath.row],indexPath.row);
    }
    [self HideView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    XZPutDownMenuView_CarList_Cell *cell = [tableView dequeueReusableCellWithIdentifier:@"XZPutDownMenuView_CarList_Cell" forIndexPath:indexPath];
    if (indexPath.row == Arr_.count) {
        cell.Img_.image = [UIImage imageNamed:@"ic_input_add"];
        cell.La_.text = @"添加车辆";
        return cell;
    }
//    M_userCarInfo *mod = Arr_[indexPath.row];
//    [cell.Img_   sd_setImageWithURL:[NSURL URLWithString:mod.iconUrl] placeholderImage:[UIImage imageNamed:@"Icon_Bitmap"]];
//    cell.La_.text = mod.plateNumber;
    
    UIView *Selv = [[UIView alloc]initWithFrame:cell.bounds];
    Selv.backgroundColor = SelColor;
    cell.selectedBackgroundView = Selv;
    
    return cell;
}

@end
