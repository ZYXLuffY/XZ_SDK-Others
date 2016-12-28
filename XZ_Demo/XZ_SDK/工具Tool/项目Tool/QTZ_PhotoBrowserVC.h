//
//  QTZ_PhotoBrowserVC.h
//  AJPhotoPickerExample
//
//  Created by iOS_XZ on 16/8/15.
//  Copyright © 2016年 AlienJunX. All rights reserved.
//

#import <UIKit/UIKit.h>



@class QTZ_PhotoBrowserVC;
@protocol QTZ_PhotoBrowserDelegate <NSObject>
@optional
/**
 *  删除照片
 *
 *  @param index 索引
 */
- (void)photoBrowser:(QTZ_PhotoBrowserVC *)vc deleteWithIndex:(NSInteger)index;

/**
 *  完成
 *
 *  @param photos 所有照片
 */
- (void)photoBrowser:(QTZ_PhotoBrowserVC *)vc didDonePhotos:(NSArray *)photos;

@end


@interface QTZ_PhotoBrowserVC : UIViewController

@property (nonatomic, weak) id<QTZ_PhotoBrowserDelegate> delegate;

/**
 *  初始化
 *
 *  @param photos 需要显示的照片，可以是ALAsset或者UIImage
 *  @param index  显示第几张 index 防止越界
 *
 */
- (instancetype)initWithPhotos:(NSArray *)photos index:(NSInteger)index;


@end







@protocol QTZ_PhotoZoomingScrollViewDelegate <NSObject>

//单击
- (void)singleTapDetected:(UITouch *)touch;

@end

@interface QTZ_PhotoZoomingScrollView : UIScrollView
@property (weak, nonatomic) id<QTZ_PhotoZoomingScrollViewDelegate> mydelegate;

/**
 *  显示图片
 *
 *  @param image 图片
 */
- (void)setShowImage:(UIImage *)image;

/**
 *  调整尺寸
 */
- (void)setMaxMinZoomScalesForCurrentBounds;

/**
 *  重用，清理资源
 */
- (void)prepareForReuse;

@end


@protocol PhotoTapDetectingImageViewDelegate <NSObject>

- (void)singleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch;

- (void)doubleTapDetected:(UIImageView *)imageView touch:(UITouch *)touch;

@end

@interface QTZ_PhotoTapDetectingImageView : UIImageView

@property (weak, nonatomic) id<PhotoTapDetectingImageViewDelegate> delegate;

@end



@protocol TapDetectingViewDelegate <NSObject>

//单击
- (void)viewSingleTapDetected:(UIView *)view touch:(UITouch *)touch;

//双击
- (void)viewDoubleTapDetected:(UIView *)view touch:(UITouch *)touch;

@end



@interface QTZ_TapDetectingView : UIView

@property (weak, nonatomic) id<TapDetectingViewDelegate> delegate;

@end



