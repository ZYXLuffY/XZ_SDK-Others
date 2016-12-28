//
//  UIImage+XZ.h
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (XZ)

/** 图片变颜色 */
- (UIImage *)imageWithColor:(UIColor *)color;
    
/** 截屏吧 截部分视图也行 */
+ (UIImage *)XZ_captureWithView:(UIView *)view;
- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect;

/** 纯色图片 */
+(UIImage *)XZ_ColoreImage:(UIColor *)color;
+(UIImage *)XZ_ColoreImage:(UIColor *)color size:(CGSize)size;

/** 按比例 质量 重设图片大小 */
- (UIImage *)XZ_resizeByQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate;
/** 按比例 重设图片大小 */
- (UIImage *)XZ_resizeByRate:(CGFloat)rate;

/** 按固定的最大比例压缩图片 */
- (UIImage *)XZ_limitImgMaxWH:(CGFloat)Max_H_W;
- (UIImage *)XZ_limitImgSize;/**< 限制到 最大长或宽 800像素  */
- (UIImage *)XZ_sizeToThum;/**< 限制到 最大长或宽 150像素 thumbnail（缩略图时 */

/** 图片要求的最大长宽 */
- (CGSize)XZ_reSetMaxWH:(CGFloat)WH;

/** 缩放到图片要求的最大宽 */
- (CGSize)XZ_scaleToWidth:(CGFloat)MaxWidth;

/** 保存到指定相册名字 */
-(void)XZ_savedToAlbum_AlbumName:(NSString*)AlbumName SucBlack:(void(^)())completeBlock failBlock:(void(^)())failBlock;

/** 保存到相册 */
-(void)XZ_savedToAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock;


/** 水印方向 */
typedef enum {
    //左上
    Image_WaterDirectTopLeft = 0,
    //右上
    Image_WaterDirectTopRight,
    //左下
    Image_WaterDirectBottomLeft,
    //右下
    Image_WaterDirectBottomRight,
    //正中
    Image_WaterDirectCenter
    
}Image_WaterDirect;


/** 加水印 */
- (UIImage *)XZ_waterWithText:(NSString *)text direction:(Image_WaterDirect)direction fontColor:(UIColor *)fontColor fontPoint:(CGFloat)fontPoint marginXY:(CGPoint)marginXY;

/**
 *  加水印
 */
-(UIImage *)XZ_waterWithWaterImage:(UIImage *)waterImage direction:(Image_WaterDirect)direction waterSize:(CGSize)waterSize  marginXY:(CGPoint)marginXY;

- (UIImage *)fixOrientation;

- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees;

@end
