
#import "XZBaseScrIndexView.h"

@interface XZBaseScrIndexView ()<UIScrollViewDelegate>
{
    NSMutableArray <UIButton*> *Arr_btns;/**< 按钮 */
    NSMutableArray <UIButton*> *Arr_titleSeeBtns;/**< 视觉差标题Label */
    
    NSArray <NSString*> *Arr_title;/**< 标题 */
    UIScrollView *Scr_title;
    UITableView *currentTable;/**< 当前显示的tableview */
}


@property(nonatomic,strong) UIView *Ve_BotBoard;/**< 滑块 */
@property(nonatomic,strong) UIView *Ve_hide;/**< 视觉差用 */

@property (nonatomic,strong) UIButton *Btn_scrToTop;/**< 显示滑到顶上的按钮 */

@end

@implementation XZBaseScrIndexView

- (void)viewDidLoad {
    [super viewDidLoad];
    _showScrollToTopButton = NO;
    _SliderBoardPer = 0.6;
}

/** 标题 和 自定义view */
-(void)loadTitles:(NSArray*)titles TableViews:(NSArray*)tableViews{
    [self loadTitles:titles TableViews:tableViews VCs:nil key:nil];
}

/**标题 和 自定义VC vc中view的key */
-(void)loadTitles:(NSArray*)titles VCs:(NSArray*)VCs key:(NSString*)key{
    [self loadTitles:titles TableViews:nil VCs:VCs key:key];
}

-(void)loadTitles:(NSArray*)titles TableViews:(NSArray*)tableViews VCs:(NSArray*)VCs key:(NSString*)key{
    Arr_title = titles;
    
    if (tableViews == nil) {
        NSMutableArray *Arr = [NSMutableArray array];
        for (int i = 0; i < Arr_title.count; i++) {
            [Arr addObject:@""];
        }
        _Arr_TVs = Arr;
    }else{
        _Arr_TVs = [tableViews mutableCopy];
    }
    
    [self Setup_XZBaseScrIndexView_UI_VC:VCs key:key];
}

-(void)Setup_XZBaseScrIndexView_UI_VC:(NSArray*)VCs key:(NSString*)key{
    if (_btnWidth == 0 || (ScreenWidth/Arr_title.count > _btnWidth)) {
        _btnWidth = ScreenWidth/Arr_title.count;
    }
    
    if (_baseTintColore == nil) {
        _baseTintColore = kColorText;
        //        _baseTintColore = kColorBlue;
    }
    
    CGFloat TopH = 44;
    //文本的
    UIScrollView *titleScr = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,ScreenWidth,TopH)];
    //    titleScr.pagingEnabled = YES;
    titleScr.scrollsToTop = NO;titleScr.showsHorizontalScrollIndicator = NO;
    titleScr.bounces = NO;
    titleScr.contentSize = CGSizeMake(_btnWidth*Arr_title.count, titleScr.frame.size.height);

//    titleScr.layer.shadowOffset = CGSizeMake(0, 0.8);
//    titleScr.layer.shadowOpacity = 0.2;
//    titleScr.layer.shadowPath = [UIBezierPath bezierPathWithRect:CGRectMake(0, titleScr.height, titleScr.width, 0.7)].CGPath;
//    titleScr.layer.masksToBounds = NO;
    [self.view addSubview:Scr_title = titleScr];
    
    Arr_btns = [NSMutableArray array];
    [Arr_title enumerateObjectsUsingBlock:^(NSString *Title, NSUInteger idx, BOOL * stop) {
        UIButton *JBtn = [UIButton Frame:CGRectMake(idx*_btnWidth, 0, _btnWidth,TopH) Title:Title FontS:14 Color:nil radius:0 Target:self action:@selector(Ve_BotBoard_BtnClick:) Bimg:nil];
        //        [JBtn setTitleColor: (_baseTintColore == kColorText) ? kColorText :kColorTextGray forState:UIControlStateNormal];
        [JBtn setTitleColor: kColorTextGray forState:UIControlStateNormal];
        [JBtn setTitleColor:_baseTintColore forState:UIControlStateHighlighted];
        
        CAShapeLayer *shapeLayer = [UIView XZ_DrawLine:CGPointMake(0, TopH) To:CGPointMake(ScreenWidth, TopH) color:kColorDividing];
        shapeLayer.lineWidth = 0.5;
        
        [Scr_title addSubview:JBtn];
        [self.view.layer addSublayer:shapeLayer];
        
        [Arr_btns addObject:JBtn];
    }];
    
    //滑块
    _Ve_BotBoard = [[UIView alloc]initWithFrame:CGRectMake(0,0, _btnWidth, TopH)];
    _Ve_BotBoard.backgroundColor = [UIColor clearColor];_Ve_BotBoard.layer.masksToBounds = YES;
    
    _Ve_BotBoardLine = [[UIView alloc]initWithFrame:CGRectMake((1-_SliderBoardPer)*_btnWidth/2 , TopH - 3, _btnWidth*_SliderBoardPer, 2)];
    _Ve_BotBoardLine.backgroundColor = _baseTintColore;
    [_Ve_BotBoard addSubview:_Ve_BotBoardLine];
    
    Arr_titleSeeBtns = [NSMutableArray array];
    //视觉差用
    _Ve_hide = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _Ve_BotBoard.width, _Ve_BotBoard.height)];
    [Arr_title enumerateObjectsUsingBlock:^(NSString *Title, NSUInteger idx, BOOL * stop) {
        UIButton *JBtn = [UIButton Frame:CGRectMake(idx*_btnWidth, 0, _btnWidth,TopH) Title:Title FontS:Arr_btns.firstObject.titleLabel.font.pointSize Color:_baseTintColore radius:0 Target:nil action:nil Bimg:nil];
        [_Ve_hide addSubview:JBtn];
        [Arr_titleSeeBtns addObject:JBtn];
    }];
    
    [_Ve_BotBoard addSubview:_Ve_hide];
    [Scr_title addSubview:_Ve_BotBoard];
    
    //下面主要显示的
    UIScrollView *_ = [[UIScrollView alloc]initWithFrame:CGRectMake(0,TopH,ScreenWidth,ScreenHeight- TopH - 64)];
    _.delegate = self; _.pagingEnabled = YES;_.scrollsToTop = NO;
    _.contentSize = CGSizeMake(_.frame.size.width*Arr_title.count, _.frame.size.height);
    _.bounces = NO;
    _.showsHorizontalScrollIndicator = NO;
    [self.view addSubview:_Scr_scroll_ = _];
    
    if (VCs) {
        NSMutableArray *Arrtvs = [NSMutableArray array];
        for (int i = 0; i < VCs.count; i++){
            UIViewController *VC = VCs[i];
            VC.view.frame = CGRectMake(_.frame.size.width *i, 0, _.frame.size.width, _.frame.size.height);
            [_Scr_scroll_ addSubview:VC.view];
            
            [self addChildViewController:VC];
            [VC didMoveToParentViewController:self];
            
            [Arrtvs addObject:[VC valueForKey:key]];
        }
        _Arr_TVs = Arrtvs;
    }else{
        for (int i = 0; i < _Arr_TVs.count; i++){
            UIView *eachV = _Arr_TVs[i];
            if ([eachV isKindOfClass:[UIView class]]) {
                eachV.frame = CGRectMake(_.frame.size.width *i, 0, _.frame.size.width, _.frame.size.height);
                [_Scr_scroll_ addSubview:eachV];
                _Scr_scroll_.backgroundColor = eachV.backgroundColor;
            }
        }
    }
    
    [self.view bringSubviewToFront:Scr_title];
    
    [self SliderToIndex:0 reload:NO];
}

#pragma mark - /** loadTitles..不传view 的 重写改方法 懒加载控件 */
/** loadTitles..不传view 的 重写改方法 懒加载控件 */
- (UITableView*)XZLazyTableViewsAtIndex:(NSInteger)index{
    NSAssert(0, @"子类重写该方法返回view");
    return nil;
}


- (void)changeTitleAt:(NSInteger)index title:(NSString*)title{
    UIButton *btnSee = Arr_titleSeeBtns[index];
    [btnSee setTitle:title forState:UIControlStateNormal];
    
    UIButton *btn = Arr_btns[index];
    [btn setTitle:title forState:UIControlStateNormal];
}


#pragma mark - 头顶滑动的板块
-(void)scrollViewDidScroll:( UIScrollView *)scrollView{
    if (scrollView == _Scr_scroll_) {
        _Ve_hide.x = - (_Ve_BotBoard.x = scrollView.contentOffset.x/(ScreenWidth/(_btnWidth)));
    }
}

//停止滑动时 改变 某按钮的选中状态
-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    [self Ve_BotBoard_BtnClick:[Arr_btns objectAtIndex:((_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width))]];
}
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset NS_AVAILABLE_IOS(5_0){
    [self Ve_BotBoard_BtnClick:[Arr_btns objectAtIndex:((_Scr_scroll_.contentOffset.x / _Scr_scroll_.frame.size.width))]];
}


/** 滑到指定位置  0 1 2 3 4 */
- (void)SliderToIndex:(NSInteger)index reload:(BOOL)reload{
    if (Arr_btns.count > index) {
        [self Ve_BotBoard_BtnClick:Arr_btns[index]];
        if (reload) {
            [((UITableView*)_Arr_TVs[index]).mj_header beginRefreshing];
        }   
    }
    
}
//滑块的按钮点击
-(void)Ve_BotBoard_BtnClick:(UIButton*)sender{
    [self customScrollsToTopBtn];
    if (sender.isSelected) {return;}
    NSInteger where = 0;
    for (int i = 0; i < Arr_btns.count; i++) {//重置按钮状态
        UIButton *Btn = Arr_btns[i];
        if (sender == Btn) { where = i;}
        Btn.selected = NO;
        Btn.userInteractionEnabled = YES;
    }
    sender.selected = YES;
    
    for (UITableView *view in _Arr_TVs) {
        if ([view isKindOfClass:[UITableView class]]) {
            view.scrollsToTop = NO;
        }
    }
    
    UITableView *table = _Arr_TVs[where];
    if (![table isKindOfClass:[UITableView class]]) {
        table = [self XZLazyTableViewsAtIndex:where];
        table.frame = CGRectMake(_Scr_scroll_.frame.size.width *where, 0, _Scr_scroll_.frame.size.width, _Scr_scroll_.frame.size.height);
        [_Scr_scroll_ addSubview:table];
        _Scr_scroll_.backgroundColor = table.backgroundColor;
        [_Arr_TVs replaceObjectAtIndex:where withObject:table];
    }
    table.scrollsToTop = YES;
    
    
    [_Scr_scroll_ scrollRectToVisible:CGRectMake((where)*_Scr_scroll_.frame.size.width,0, _Scr_scroll_.frame.size.width, _Scr_scroll_.frame.size.height) animated:YES];
    [Scr_title scrollRectToVisible:CGRectMake((where)*_btnWidth,0, Scr_title.frame.size.width, Scr_title.frame.size.height) animated:YES];
    
    currentTable = table;
    [self customScrollsToTopBtn];
}

//显示滑到顶上的按钮
- (void)customScrollsToTopBtn{
    if (currentTable == nil || !_showScrollToTopButton) {
        return;
    }
    [UIView animateWithDuration:0.25 animations:^{
        self.Btn_scrToTop.alpha = ((int)currentTable.contentOffset.y == 0) ? 0 : 1;
    }];
}

/**< 显示滑到顶上的按钮 */
- (UIButton *)Btn_scrToTop {
    if(_Btn_scrToTop == nil) {
        XZxibButton *_ = [XZxibButton Frame:CGRectMake(ScreenWidth - 30 - 12, ScreenHeight - 64 - 12 - 30, 30, 30) Title:nil FontS:0 Color:nil radius:0 Target:self action:@selector(Btn_scrToTopClick) Bimg:nil];
        _.alpha = 0;
        _.moreTouchMargin = CGRectMake(30, 20, 12, 12);
        [_ setImage:[UIImage imageNamed:@"ScrollsToTopBtn"] forState:UIControlStateNormal];
        [self.view addSubview:(_Btn_scrToTop = _)];
    }
    return _Btn_scrToTop;
}

- (void)Btn_scrToTopClick{
    [UIView animateWithDuration:0.25 animations:^{
        self.Btn_scrToTop.alpha = 0;
    }];
    [currentTable setContentOffset:CGPointMake(currentTable.contentOffset.x, 0) animated:YES];
}

@end
