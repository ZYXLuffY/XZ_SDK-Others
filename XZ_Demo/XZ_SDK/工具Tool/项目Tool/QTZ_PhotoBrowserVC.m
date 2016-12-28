//
//  QTZ_PhotoBrowserVC.m
//  AJPhotoPickerExample
//
//  Created by iOS_XZ on 16/8/15.
//  Copyright © 2016年 AlienJunX. All rights reserved.
//

#import "QTZ_PhotoBrowserVC.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface QTZ_PhotoBrowserVC ()<UIScrollViewDelegate,UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *photos;/**<照片流*/
@property (nonatomic, assign) NSUInteger   currentPageIndex;/**<当前页 */
@property (nonatomic, strong) NSMutableSet *visiblePhotoViews;
@property (nonatomic, strong) NSMutableSet *reusablePhotoViews;


@property (nonatomic, strong) UIScrollView *photoScrollView;
@property (nonatomic, strong) UIView *navBar;
@property (nonatomic, strong) UILabel *titleLabel;


@end

@implementation QTZ_PhotoBrowserVC

- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)index {
    self = [super init];
    if (self) {
        _currentPageIndex = index;
        if (index < 0)_currentPageIndex = 0;
        if (index > photos.count-1)_currentPageIndex = photos.count - 1;
        [self.photos addObjectsFromArray:photos];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.view.clipsToBounds = YES;
    
    [self setupUI];
    [self showPhotos];
    
    //显示指定索引
    _photoScrollView.contentOffset = CGPointMake(_currentPageIndex * _photoScrollView.bounds.size.width, 0);
}


- (void)setupUI{
    
    
    [self.view addSubview:self.photoScrollView];
    
    //infoBar
    UIView *topView = [UIView new];
    topView.translatesAutoresizingMaskIntoConstraints = NO;
    topView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:topView];
    NSArray *cons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topView(==64)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topView)];
    NSArray *cons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[topView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(topView)];
    [self.view addConstraints:cons1];
    [self.view addConstraints:cons2];
    
    //title
    UILabel *titleLabel = [UILabel new];
    titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    titleLabel.textColor = [UIColor whiteColor];
    titleLabel.font = [UIFont systemFontOfSize:20.0];
    [topView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    NSArray *titleLabelCons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[titleLabel(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(titleLabel)];
    [self.view addConstraints:titleLabelCons1];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:titleLabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:topView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    //done
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.translatesAutoresizingMaskIntoConstraints = NO;
    [btn setTitle:@"完成" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(doneBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:btn];
    NSArray *doneBtnCons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[btn(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    NSArray *doneBtnCons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[btn(==80)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(btn)];
    [topView addConstraints:doneBtnCons1];
    [topView addConstraints:doneBtnCons2];
    
    //delbtn
    UIButton *delBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    delBtn.translatesAutoresizingMaskIntoConstraints = NO;
    [delBtn setTitle:@"删除" forState:UIControlStateNormal];
    [delBtn addTarget:self action:@selector(delBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [topView addSubview:delBtn];
    NSArray *delBtnCons1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-20-[delBtn(==44)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delBtn)];
    NSArray *delBtnCons2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[delBtn(==80)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(delBtn)];
    [topView addConstraints:delBtnCons1];
    [topView addConstraints:delBtnCons2];

}


#pragma mark - lifecycle 循环引用

//开始显示
- (void)showPhotos {
    // 只有一张图片
    if (self.photos.count == 1) {
        [self showPhotoViewAtIndex:0];
        return;
    }
    
    CGRect visibleBounds = _photoScrollView.bounds;
    NSInteger firstIndex = floor((CGRectGetMinX(visibleBounds)) / CGRectGetWidth(visibleBounds));
    NSInteger lastIndex  = floor((CGRectGetMaxX(visibleBounds)-1) / CGRectGetWidth(visibleBounds));
    
    
    if (firstIndex < 0) {
        firstIndex = 0;
    }
    if (firstIndex >= self.photos.count) {
        firstIndex = self.photos.count - 1;
    }
    if (lastIndex < 0){
        lastIndex = 0;
    }
    if (lastIndex >= self.photos.count) {
        lastIndex = self.photos.count - 1;
    }
    
    // 回收不再显示的ImageView
    NSInteger photoViewIndex = 0;
    for (QTZ_PhotoZoomingScrollView *photoView in self.visiblePhotoViews) {
        photoViewIndex = photoView.tag-100;
        if (photoViewIndex < firstIndex || photoViewIndex > lastIndex) {
            [self.reusablePhotoViews addObject:photoView];
            [photoView prepareForReuse];
            [photoView removeFromSuperview];
        }
    }
    
    [self.visiblePhotoViews minusSet:self.reusablePhotoViews];
    while (self.reusablePhotoViews.count > 2) {
        [self.reusablePhotoViews removeObject:[self.reusablePhotoViews anyObject]];
    }
    
    for (NSInteger index = firstIndex; index <= lastIndex; index++) {
        if (![self isShowingPhotoViewAtIndex:index]) {
            [self showPhotoViewAtIndex:index];
        }
    }
}

//显示指定索引的图片
- (void)showPhotoViewAtIndex:(NSInteger)index {
    QTZ_PhotoZoomingScrollView *photoView = [self dequeueReusablePhotoView];
    if (photoView == nil) {
        photoView = [[QTZ_PhotoZoomingScrollView alloc] init];
    }
    
    //显示大小处理
    CGRect bounds = _photoScrollView.bounds;
    CGRect photoViewFrame = bounds;
    photoViewFrame.origin.x = bounds.size.width * index;
    photoView.tag = 100 + index;
    photoView.frame = photoViewFrame;
    
    //显示照片处理
    UIImage *photo = nil;
    id photoObj = self.photos[index];
    if ([photoObj isKindOfClass:[UIImage class]]) {
        photo = photoObj;
    } else if ([photoObj isKindOfClass:[ALAsset class]]) {
        CGImageRef fullScreenImageRef = ((ALAsset *)photoObj).defaultRepresentation.fullScreenImage;
        photo = [UIImage imageWithCGImage:fullScreenImageRef];
    }
    
    //show
    [photoView setShowImage:photo];
    
    [self.visiblePhotoViews addObject:photoView];
    [_photoScrollView addSubview:photoView];
}

//获取可重用的view
- (QTZ_PhotoZoomingScrollView *)dequeueReusablePhotoView {
    QTZ_PhotoZoomingScrollView *photoView = [self.reusablePhotoViews anyObject];
    if (photoView) {
        [self.reusablePhotoViews removeObject:photoView];
    }
    return photoView;
}

//判断是否正在显示
- (BOOL)isShowingPhotoViewAtIndex:(NSInteger)index {
    for (QTZ_PhotoZoomingScrollView* photoView in self.visiblePhotoViews) {
        if ((photoView.tag - 100) == index) {
            return YES;
        }
    }
    return NO;
}

#pragma mark - Action
- (void)doneBtnAction:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:didDonePhotos:)]) {
        [_delegate photoBrowser:self didDonePhotos:self.photos];
    }
}

- (void)delBtnAction:(UIButton *)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除" otherButtonTitles:nil, nil];
    actionSheet.tag = 2;
    [actionSheet showInView:[UIApplication sharedApplication].keyWindow];
    
}

#pragma mark - UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        [self.photos removeObjectAtIndex:_currentPageIndex];
        
        if (_delegate && [_delegate respondsToSelector:@selector(photoBrowser:deleteWithIndex:)]) {
            [_delegate photoBrowser:self deleteWithIndex:_currentPageIndex];
        }
        
        //reload;
        _currentPageIndex --;
        if (_currentPageIndex == -1 && self.photos.count == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            _currentPageIndex = (_currentPageIndex == (-1) ? 0 : _currentPageIndex);
            if (_currentPageIndex == 0) {
                [self showPhotoViewAtIndex:0];
                [self setTitlePageInfo];
            }
            _photoScrollView.contentOffset = CGPointMake(_currentPageIndex * _photoScrollView.bounds.size.width, 0);
            _photoScrollView.contentSize = CGSizeMake(_photoScrollView.bounds.size.width * self.photos.count, 0);
        }
    }
}

#pragma mark - uiscrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self showPhotos];
    int pageNum = floor((_photoScrollView.contentOffset.x - _photoScrollView.frame.size.width / (self.photos.count+2)) / _photoScrollView.frame.size.width) + 1;
    _currentPageIndex = pageNum==self.photos.count?pageNum-1:pageNum;
    [self setTitlePageInfo];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _currentPageIndex = floor((_photoScrollView.contentOffset.x - _photoScrollView.frame.size.width / (self.photos.count+2)) / _photoScrollView.frame.size.width) + 1;
    [self setTitlePageInfo];
}

- (void)setTitlePageInfo {
    NSString *title = [NSString stringWithFormat:@"%d / %d",(int)_currentPageIndex+1,(int)self.photos.count];
    self.titleLabel.text = title;
}

- (void)dealloc {
    [self.photos removeAllObjects];
    [self.reusablePhotoViews removeAllObjects];
    [self.visiblePhotoViews removeAllObjects];
}












- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}



-(NSMutableArray *)photos
{
    if (!_photos) {
        _photos = [NSMutableArray array];
    }
    return _photos;
}

-(NSMutableSet *)visiblePhotoViews
{
    if (!_visiblePhotoViews) {
        _visiblePhotoViews = [[NSMutableSet alloc]init];
    }
    return _visiblePhotoViews;
}
-(NSMutableSet *)reusablePhotoViews
{
    if (!_reusablePhotoViews) {
        _reusablePhotoViews = [[NSMutableSet alloc]init];
    }
    return _reusablePhotoViews;
}

-(UIScrollView *)photoScrollView
{
    if (!_photoScrollView) {
        _photoScrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        _photoScrollView.pagingEnabled = YES;
        _photoScrollView.delegate = self;
        _photoScrollView.showsHorizontalScrollIndicator = NO;
        _photoScrollView.showsVerticalScrollIndicator = NO;
        _photoScrollView.backgroundColor = UIColor.clearColor;
        _photoScrollView.contentSize = CGSizeMake(self.view.frame.size.width * self.photos.count, 0);
    }
    return _photoScrollView;
}


@end



@interface QTZ_PhotoZoomingScrollView()<UIScrollViewDelegate,PhotoTapDetectingImageViewDelegate,TapDetectingViewDelegate>


@property (nonatomic, strong) QTZ_TapDetectingView *tapView;
@property (nonatomic, strong) QTZ_PhotoTapDetectingImageView *photoImageView;


@end

@implementation QTZ_PhotoZoomingScrollView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    self.delegate = self;
    self.showsHorizontalScrollIndicator = false;
    self.showsVerticalScrollIndicator = false;
    self.decelerationRate = UIScrollViewDecelerationRateFast;
    
    // Tap view for background
    _tapView = [[QTZ_TapDetectingView alloc] initWithFrame:self.bounds];
    _tapView.delegate = self;
    _tapView.backgroundColor = UIColor.blackColor;
    [self addSubview:_tapView];
    
    _photoImageView = [[QTZ_PhotoTapDetectingImageView alloc] initWithFrame:CGRectZero];
    _photoImageView.delegate = self;
    _photoImageView.contentMode = UIViewContentModeCenter;
    _photoImageView.backgroundColor = UIColor.blackColor;
    [self addSubview:_photoImageView];
}

#pragma mark - 图片显示
- (void)setShowImage:(UIImage *)image {
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    self.contentSize = CGSizeMake(0, 0);
    
    _photoImageView.image = image;
    self.contentSize = image.size;
    
    [self setMaxMinZoomScalesForCurrentBounds];
    
    [self setNeedsLayout];
}

- (void)prepareForReuse {
    _photoImageView.image = nil;
}


#pragma mark - Rotation

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return UIInterfaceOrientationMaskAll;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    // Perform layout
//    _currentPageIndex = _pageIndexBeforeRotation;
//    
//    // Delay control holding
//    [self hideControlsAfterDelay];
//    
//    // Layout
//    [self layoutVisiblePages];
    
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
//    _rotating = NO;
//    // Ensure nav bar isn't re-displayed
//    if ([self areControlsHidden]) {
//        self.navigationController.navigationBarHidden = NO;
//        self.navigationController.navigationBar.alpha = 0;
//    }
}


#pragma mark - 初始化scrollview放大参数

- (CGFloat)initialZoomScaleWithMinScale {
    CGFloat zoomScale = self.minimumZoomScale;
    if (_photoImageView != nil ) {
        CGSize boundsSize = self.bounds.size;
        CGSize imageSize = _photoImageView.image.size;
        CGFloat boundsAR = boundsSize.width / boundsSize.height;
        CGFloat imageAR = imageSize.width / imageSize.height;
        CGFloat xScale = boundsSize.width / imageSize.width;
        CGFloat yScale = boundsSize.height / imageSize.height;
        if (fabs(boundsAR - imageAR) < 0.17) {
            zoomScale = MAX(xScale, yScale);
            zoomScale = MIN(MAX(self.minimumZoomScale, zoomScale), self.maximumZoomScale);
        }
    }
    return zoomScale;
}

/**
 *  调整尺寸
 */
- (void)setMaxMinZoomScalesForCurrentBounds {
    // Reset
    self.maximumZoomScale = 1;
    self.minimumZoomScale = 1;
    self.zoomScale = 1;
    
    if (_photoImageView.image == nil) {
        return;
    }
    
    // 图片初始位置
    CGSize boundsSize = self.bounds.size;
    CGSize imageSize = _photoImageView.image.size;
    _photoImageView.frame = CGRectMake(0, 0, imageSize.width, imageSize.height);
    
    // 计算最小缩放
    CGFloat xScale = boundsSize.width / imageSize.width;
    CGFloat yScale = boundsSize.height / imageSize.height;
    CGFloat minScale = MIN(xScale, yScale);
    
    // 计算最大缩放
    CGFloat maxScale = 3.0;
    
    // 超出默认不缩放
    if (xScale >= 1 && yScale >= 1) {
        minScale = 1.0;
    }
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = minScale;
    
    self.zoomScale = [self initialZoomScaleWithMinScale];
    if (self.zoomScale != minScale) {
        // Centralise
        self.contentOffset = CGPointMake((imageSize.width * self.zoomScale - boundsSize.width) / 2.0,
                                         (imageSize.height * self.zoomScale - boundsSize.height) / 2.0);
        self.scrollEnabled = false;
    }
    
    // Layout
    [self setNeedsLayout];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize boundsSize = self.bounds.size;
    CGRect frameToCenter = _photoImageView.frame;
    
    if (frameToCenter.size.width < boundsSize.width) {
        frameToCenter.origin.x = floor((boundsSize.width - frameToCenter.size.width) / 2.0);
    } else {
        frameToCenter.origin.x = 0;
    }
    
    // Vertically
    if (frameToCenter.size.height < boundsSize.height) {
        frameToCenter.origin.y = floor((boundsSize.height - frameToCenter.size.height) / 2.0);
    } else {
        frameToCenter.origin.y = 0;
    }
    
    // Center
    if (!CGRectEqualToRect(_photoImageView.frame, frameToCenter)){
        _photoImageView.frame = frameToCenter;
    }
    
    _tapView.frame = self.bounds;
}

#pragma mark - UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return _photoImageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view {
    self.scrollEnabled = true;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView {
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)handleDoubleTap:(CGPoint )touchPoint {
    // Zoom
    if (self.zoomScale != self.minimumZoomScale && self.zoomScale != [self initialZoomScaleWithMinScale]) {
        [self setZoomScale:self.minimumZoomScale animated:YES];
    } else {
        CGFloat newZoomScale = ((self.maximumZoomScale + self.minimumZoomScale) / 2);
        CGFloat xsize = self.bounds.size.width / newZoomScale;
        CGFloat ysize = self.bounds.size.height / newZoomScale;
        [self zoomToRect:CGRectMake(touchPoint.x - xsize/2, touchPoint.y - ysize/2, xsize, ysize) animated:YES];
    }
}

#pragma mark - PhotoTapDetectingImageViewDelegate
- (void)singleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch {
    if (_mydelegate && [_mydelegate respondsToSelector:@selector(singleTapDetected:)]) {
        [_mydelegate singleTapDetected:touch];
    }
}

- (void)doubleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch {
    CGPoint touchPoint = [touch locationInView:imageView];
    [self handleDoubleTap:touchPoint];
}

#pragma mark - TapDetectingViewDelegate
- (void)viewSingleTapDetected:(UIView *)view touch:(UITouch *)touch {
    if (_mydelegate && [_mydelegate respondsToSelector:@selector(singleTapDetected:)]) {
        [_mydelegate singleTapDetected:touch];
    }
}

- (void)viewDoubleTapDetected:(UIView *)view touch:(UITouch *)touch {
    CGFloat touchX = [touch locationInView:view].x;
    CGFloat touchY = [touch locationInView:view].y;
    touchX *= 1/self.zoomScale;
    touchY *= 1/self.zoomScale;
    touchX += self.contentOffset.x;
    touchY += self.contentOffset.y;
    [self handleDoubleTap:CGPointMake(touchX, touchY)];
}

@end


@implementation QTZ_PhotoTapDetectingImageView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(singleTapDetected:touch:)]) {
                [_delegate singleTapDetected:self touch:touch];
            }
        }
            break;
            
        case 2:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(doubleTapDetected:touch:)]) {
                [_delegate doubleTapDetected:self touch:touch];
            }
        }
            break;
    }
}

- (void)dealloc {
    _delegate = nil;
}
@end



@implementation QTZ_TapDetectingView

#pragma mark - init
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.exclusiveTouch = YES;
    }
    return self;
}

#pragma mark - touch
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    UITouch *touch = [touches anyObject];
    NSInteger tapCount = touch.tapCount;
    switch (tapCount) {
        case 1:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(viewSingleTapDetected:touch:)]) {
                [_delegate viewSingleTapDetected:self touch:touch];
            }
        }
            break;
            
        case 2:
        {
            if (_delegate && [_delegate respondsToSelector:@selector(viewDoubleTapDetected:touch:)]) {
                [_delegate viewDoubleTapDetected:self touch:touch];
            }
        }
            break;
    }
}

- (void)dealloc {
    _delegate = nil;
}

@end

