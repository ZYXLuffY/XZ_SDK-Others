//
//  QTZ_ScrollView.m
//  com.tmbj.qtzUser_XZ
//
//  Created by 天牧伯爵ui设计师 on 16/3/22.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import "QTZ_ScrollView.h"
#import "XZUtility.h"
#import "UIImageView+WebCache.h"
//#import "M_Main1VCInfo.h"
@interface QTZ_ScrollView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *dataArr;/**< 数据流*/
@property (nonatomic, strong) NSMutableArray *datas;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic, strong) UIView *pageView;
@property (nonatomic, strong) UIView *Tmp_pageView;

@end

@implementation QTZ_ScrollView

-(void)dealloc{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}

-(UIView *)initWithFrame:(CGRect)frame dataWith:(NSMutableArray *)datas selectedAction:(selectedBlock)selected
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selected = selected;
        [self addSubview:self.scrollView];
        [self addSubview:self.pageControl];
    }
    return self;
}

- (void)autoScroll
{
    CGFloat offsetX;
    NSInteger result = (int)self.scrollView.contentOffset.x % (int)self.bounds.size.width;
    NSInteger positionNum = (int)self.scrollView.contentOffset.x / (int)self.bounds.size.width;
    if (result != 0) {
        offsetX = self.bounds.size.width * positionNum + self.bounds.size.width;
    }else
    {
        offsetX = self.scrollView.contentOffset.x + self.bounds.size.width;
    }
    CGPoint offset = CGPointMake(offsetX, 0);
    [self.scrollView setContentOffset:offset animated:YES];
}

- (void)tapAction:(UIGestureRecognizer *) gesture
{
    NSInteger index = gesture.view.tag-101;
    if (self.selected) {
        self.selected(index);
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    int page = (self.scrollView.contentOffset.x + self.bounds.size.width * 0.5) / self.bounds.size.width - 1;
    self.pageView.x = (scrollView.contentOffset.x/ScreenWidth -1)* self.pageView.width;
    
//    NSLog(@" page == %d",page);
    
    CGFloat tmp = scrollView.contentOffset.x - self.scrollView.width * self.datas.count  ;
    CGFloat scale = tmp/scrollView.width;
    if (tmp > 0 && self.datas.count) {
        self.Tmp_pageView.x = 0 ;
        self.Tmp_pageView.width = self.pageView.width * scale;
    }else{
        self.Tmp_pageView.width = self.pageView.width;
        self.Tmp_pageView.x = scrollView.width  + self.pageView.width * (scale +self.datas.count -1);
    }

    self.pageControl.currentPage = page;
    if (self.scrollView.contentOffset.x > self.bounds.size.width * (self.dataArr.count - 1.5)) {
        self.pageControl.currentPage = 0;
    }
    else if (self.scrollView.contentOffset.x < self.bounds.size.width * 0.5)
    {
        self.pageControl.currentPage = self.dataArr.count - 3;
    }
    
    if (self.scrollView.contentOffset.x <= 0) {
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width * (self.dataArr.count - 2), 0);
    }
    else if (self.scrollView.contentOffset.x >= self.bounds.size.width * (self.dataArr.count - 1))
    {
        self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [_timer invalidate];
    _timer = nil;
    
    for (UIImageView *imgView in _scrollView.subviews) {
        imgView.userInteractionEnabled = NO;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    for (UIImageView *imgView in _scrollView.subviews) {
        imgView.userInteractionEnabled = YES;
    }
    [self createTimer];
}

- (void)createTimer
{
//    if(self.adMod.dataList.count){
        self.timer = [NSTimer scheduledTimerWithTimeInterval:4.0f target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
        [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
        self.pageControl.hidden = NO;
//    }
}
//-(void)setAdMod:(PublicUr_AdMod *)adMod
//{
//    _adMod = adMod;
//}

-(void)reloadDataWithData:(NSArray *)datas
{
    [self.datas removeAllObjects];
    self.datas = [NSMutableArray arrayWithArray:datas];
    for (UIView *view in  self.scrollView.subviews) {
        [view removeFromSuperview];
    }
    [_timer invalidate];
    _timer = nil;
    [self setupContent];
}

- (void)setupContent
{
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    imgView.image = [UIImage imageNamed:@"banner_placeholder"];

    if (self.datas.count < 1) {
        [self addSubview: imgView];
        return;
    }
    [imgView removeFromSuperview];
    [self.dataArr removeAllObjects];
    id firstObj = [self.datas firstObject];
    id lastObj = [self.datas lastObject];
    [self.dataArr addObject:lastObj];
    [self.dataArr addObjectsFromArray:self.datas];
    [self.dataArr addObject:firstObj];
    
    for (int i = 0; i < self.dataArr.count; i++) {
        CGFloat imageX = i * self.width;
        CGRect frame = CGRectMake(imageX, 0, self.width, self.scrollView.height);
        UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
//        Banner_Mod *Mod = self.dataArr[i];
//        [imgView sd_setImageWithURL:[NSURL URLWithString:[_adMod.baseUrl addStr:Mod.imageUrl]]placeholderImage:[UIImage imageNamed:@"banner_placeholder"]];
        imgView.contentMode = UIViewContentModeScaleAspectFill;
        imgView.tag = i + 100;
        imgView.userInteractionEnabled = YES;
        imgView.layer.masksToBounds = YES;
        [self.scrollView addSubview:imgView];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [imgView addGestureRecognizer:tap];
        
    }
    //设置轮播器的滚动范围
    self.scrollView.contentSize = CGSizeMake(self.dataArr.count * self.frame.size.width, 0);
    self.scrollView.contentOffset = CGPointMake(self.bounds.size.width, 0);
    self.pageControl.numberOfPages = self.datas.count;
    [self createTimer];
    self.pageView.width = self.datas.count> 1 ? ScreenWidth/self.datas.count : 0;
}



-(UIView *)pageView{
    if (!_pageView) {
        _pageView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 3, 0, 3)];
        _pageView.backgroundColor = kColorYellow;
//        [self addSubview:_pageView];
    }
    return _pageView;
}

-(UIView *)Tmp_pageView{
    if (!_Tmp_pageView) {
        _Tmp_pageView = [[UIView alloc]initWithFrame:CGRectMake(0, self.height - 3, 0, 3)];
        _Tmp_pageView.backgroundColor = kColorYellow;
//        [self addSubview:_Tmp_pageView];
    }
    return _Tmp_pageView;
}


-(NSMutableArray *)datas
{
    if (!_datas) {
        _datas = [NSMutableArray array];
    }
    return _datas;
}
-(NSMutableArray *)dataArr
{
    if (!_dataArr) {
        _dataArr = [NSMutableArray array];
    }
    return _dataArr;
}
-(UIScrollView *)scrollView
{
    if (!_scrollView) {
        /**< 去掉自定的pagecontrol*/
        _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height )];
        _scrollView.scrollEnabled = YES;
        _scrollView.pagingEnabled = YES;
        _scrollView.userInteractionEnabled = YES;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    
    }
    return _scrollView;
}

-(UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, self.height - 60, self.width, 20)];
        _pageControl.currentPageIndicatorTintColor = kColorWhite;
        _pageControl.pageIndicatorTintColor = kColorText99;
        _pageControl.hidden = YES;
    }
    return _pageControl;
}
@end
