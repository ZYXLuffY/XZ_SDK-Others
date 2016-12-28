

#import "QTZ_HeadScrEffetView.h"
#import "XZUtility.h"
//#import "MWPhotoBrowser.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"

NSString *const QTZ_HeadScrEffetViewContentOffset = @"contentOffset";

@interface QTZ_HeadScrEffetView ()
{
    CGFloat headHeight;/**< self高度 */
    UIView *Ve_bar;
    UIImageView *Img_head;/**< 固定显示第一张 */
    
//    NSMutableArray <MWPhoto* > *Arr_Browser;/**< 图片浏览的 */
        NSMutableArray *Arr_Browser;/**< 图片浏览的 */
}

@property (nonatomic,strong) UILabel *La_ImgCount;/**<  图片数量 eg.1/5*/
@property (nonatomic,strong) XZxibButton *Btn_goBack;/**<  返回按钮*/
@property (nonatomic,weak,readonly) UITableView *quote_Tv;/**< 引用 */
@end

@implementation QTZ_HeadScrEffetView

-(void)dealloc{
    JIE1;
}

- (void)willMoveToSuperview:(UIView *)newSuperview{
    [super willMoveToSuperview:newSuperview];
    if (newSuperview == nil) {
        [self.superview removeObserver:self forKeyPath:QTZ_HeadScrEffetViewContentOffset];
    }
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:QTZ_HeadScrEffetViewContentOffset]) {//效果
        CGFloat Y = _quote_Tv.contentOffset.y + _quote_Tv.contentInset.top;
        if (Y < 0) {
            Ve_bar.alpha = 0;
            Img_head.frame = CGRectMake((ScreenWidth - (ScreenWidth - Y))/2,Y , ScreenWidth - Y, headHeight - Y);
        }else{
            Img_head.frame =  CGRectMake(0,Y - Y/3, ScreenWidth, headHeight);
            CGFloat alpha = ((Y)/(headHeight - Ve_bar.height));
            if (alpha > 1) { alpha = 1;}
            Ve_bar.alpha = alpha*1;
        }
    }
}

- (instancetype)initWithHeadHeight:(CGFloat)heigt table:(UITableView*)table{
    self = [super initWithFrame:CGRectMake(0, -heigt, ScreenWidth, heigt)];
    _quote_Tv = table;
    [_quote_Tv addObserver:self forKeyPath:QTZ_HeadScrEffetViewContentOffset options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    
    [self addSubview:(Img_head = [[UIImageView alloc]init])];
    
    
    Ve_bar = [table.superVC customNavBarView];
    Ve_bar.alpha = 0;
    [table.superVC.view addSubview:Ve_bar];
    table.superVC.Ve_XZBar = Ve_bar;
    
    [self addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(Ve_headhandleAction)]];
    
    [self resetSelfImgHeight:heigt];
    
    return self;
}

- (void)resetSelfImgHeight:(CGFloat)height{
    BOOL resetOffSet = (headHeight == - _quote_Tv.contentOffset.y);
    headHeight = height;
    _quote_Tv.contentInset = UIEdgeInsetsMake(headHeight, 0, 50, 0);
    self.frame = CGRectMake(0, -headHeight, ScreenWidth, headHeight);
    Img_head.frame = CGRectMake(0, 0, ScreenWidth, headHeight);
    _Ve_des.frame = CGRectMake(0, self.height - _Ve_des.height, self.width, _Ve_des.height);
    if (_La_shopType.text.length) {
        _Ve_des.frame = CGRectMake(0, self.height - _Ve_des.height, self.width, _Ve_des.height);
    }

    [_quote_Tv reloadData];
    if (resetOffSet) {
        [_quote_Tv setContentOffset:CGPointMake(0, -headHeight) animated:NO];
    }
}

- (void)goBackClick{
    [_quote_Tv.superVC.Nav popViewControllerAnimated:YES];
    [_quote_Tv.superVC XZ_navPopBtnClick];
}

#pragma mark - 图片浏览的

- (void)sendMWPhotoBrowserUrlArr:(NSArray*)urlArr{
    [self Btn_goBack];
    
    if (urlArr.count == 0) {
        Img_head.image = [UIImage imageNamed:@"banner_placeholder"];
        CGSize size = [Img_head.image XZ_scaleToWidth:ScreenWidth];//按照等比设置 高度
        [self resetSelfImgHeight:size.height];
        return;
    }
    
    self.La_ImgCount.text = [NSString stringWithFormat:@"1/%d",(int)urlArr.count];
    Arr_Browser = [NSMutableArray array];
//    [urlArr enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
//        if ([obj isKindOfClass:[NSString class]]) {
//            [Arr_Browser addObject:[MWPhoto photoWithURL:((NSString*)obj).url]];
//        }else{
//            
//            [Arr_Browser addObject:[MWPhoto photoWithURL:((NSString*)[obj valueForKey:@"img"]).url]];
//        }
//    }];
//    
//    //    UIImage *image = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:Arr_Browser.firstObject.photoURL.absoluteString];
//    
//    ////有图片 取第一张显示就好 Arr_Browser.firstObject.photoURL
//    [Img_head sd_setImageWithURL:Arr_Browser.firstObject.photoURL placeholderImage:[UIImage imageNamed:@"banner_placeholder"] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
//        if (image) {
//            CGSize size = [image XZ_scaleToWidth:ScreenWidth];//按照等比设置 高度
//            [self resetSelfImgHeight:size.height];
//        }
//    }];
    
}

/**< 商家支持标签*/
- (void)sendShop_CridictsTags:(NSArray*)urlArr
{
    _Ve_des.frame = CGRectMake(0, self.height - 62, self.width, 62);
    self.La_shopType.y = self.La_des.bottom + 4;
    self.La_shopType.width = [[self.La_shopType.text addStr:@"    "] __W__:12 H:18];
    for (int i = 0; i< urlArr.count; i++) {
        UIImageView *img = [[UIImageView alloc] initWithFrame:CGRectMake((self.La_shopType.right + 6) + (6 + 16)* i , self.La_shopType.y, 16, 16)];
        [img sd_setImageWithURL:[[NSURL alloc]initWithString:VALUEFROM([urlArr[i] valueForKey:@"icon"])]placeholderImage:nil];
        [self.Ve_des addSubview:img];
    }
}

/**< 修改描述 */
- (void)changeProjectName:(NSString*)projectName{
    self.La_des.text  = projectName;
    _La_des.height = [_La_des sizeThatFits:CGSizeMake(_La_des.width, _La_des.height)].height;
    _Ve_des.height = _La_des.height + 20;
    _Ve_des.frame = CGRectMake(0, self.height - _Ve_des.height, self.width, _Ve_des.height);
    _La_des.y = 10;
 
}

- (void)Ve_headhandleAction{
    if (Arr_Browser.count == 0) {
        return;
    }
//    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:(id<MWPhotoBrowserDelegate>)self];
//    [browser setCurrentPhotoIndex:0];
//    [XZApp.window.rootViewController pushVC:browser];
}

//- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
//    return Arr_Browser.count;
//}
//
//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
//    return (index < Arr_Browser.count) ? [Arr_Browser objectAtIndex:index] : nil;
//}

/**<  放在图片哪里的描述*/
- (UIView *)Ve_des {
    if(_Ve_des == nil) {
        [self addSubview:(_Ve_des = [UIView Frame:CGRectMake(0, self.height - 40, self.width, 40) color:kColorRGBA(0, 0, 0, 0.4)])];
    }
    return _Ve_des;
}

/**<  放在图片哪里的描述*/
- (UILabel *)La_des {
    if(_La_des == nil) {
        UILabel *_ = [UILabel Frame:CGRectMake(12, 10, self.width-24, 20) Title:@"" FontS:14 Color:[UIColor whiteColor] Alignment:NSTextAlignmentLeft];
        _.backgroundColor = [UIColor clearColor];
        [self.Ve_des addSubview:(_La_des = _)]; 
    }
    return _La_des;
}

/**<  图片数量 eg.1/5*/
- (UILabel *)La_ImgCount {
    if(_La_ImgCount == nil) {
        UILabel *_ = [UILabel Frame:CGRectMake(ScreenWidth - _Btn_goBack.x - 28, _Btn_goBack.y, 28, 28) Title:@"" FontS:10 Color:[UIColor whiteColor] Alignment:NSTextAlignmentCenter];
        [_ beRound];
        _.backgroundColor = kColorRGBA(0, 0, 0, 0.6);
        [self.superVC.view insertSubview:(_La_ImgCount = _) belowSubview:Ve_bar];
    }
    return _La_ImgCount;
}

/**<  返回按钮*/
- (XZxibButton *)Btn_goBack {
    if(_Btn_goBack == nil) {
//        (14, 36, 28, 28)
        XZxibButton *_ = [XZxibButton Frame:CGRectMake(4.5, 26.5, 28, 28) Title:nil FontS:0 Color:nil radius:0 Target:self action:@selector(goBackClick) Bimg:nil];
        [_ setBackgroundImage:[UIImage imageNamed:@"QTZ_HeadScrEffetViewbackBtn"] forState:UIControlStateNormal];
        _.moreTouchMargin = CGRectMake(14, 20, 50, 25);
        [self.superVC.view insertSubview:(_Btn_goBack = _) belowSubview:Ve_bar];
    }
    return _Btn_goBack;
}

-(UILabel *)La_shopType
{
    if (!_La_shopType){
        UILabel *_ = [UILabel Frame:CGRectMake(12, 0, 0, 18) Title:@"" FontS:12 Color:[UIColor whiteColor] Alignment:NSTextAlignmentCenter];
        _.backgroundColor = kColorBlue;
        [self.Ve_des addSubview:(_La_shopType = _)];
    }
    return _La_shopType;
}

@end
