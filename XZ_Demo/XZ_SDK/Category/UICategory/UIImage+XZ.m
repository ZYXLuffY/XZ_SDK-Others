//
//  UIImage+XZ.m
//  XZ_iOS
//
//  Created by XZ on 15/6/15.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import "UIImage+XZ.h"
#import <objc/runtime.h>
#import <AssetsLibrary/AssetsLibrary.h>


static const void *CompleteBlockKey = &CompleteBlockKey;
static const void *FailBlockKey = &FailBlockKey;

@interface UIImage ()

@property (nonatomic,copy)  void(^CompleteBlock)();

@property (nonatomic,copy)  void(^FailBlock)();

@end


@implementation UIImage (XZ)

- (UIImage *)imageWithColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage*newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

/** 截屏吧 截部分视图也行 */
+ (UIImage *)XZ_captureWithView:(UIView *)view{
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, [UIScreen mainScreen].scale);
     UIGraphicsBeginImageContext(CGSizeMake(view.bounds.size.width, view.bounds.size.height));
    //
    //    // IOS7及其后续版本
    //    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
    //        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:
    //                                    [self methodSignatureForSelector:
    //                                     @selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
    //        [invocation setTarget:self];
    //        [invocation setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
    //        CGRect arg2 = view.bounds;
    //        BOOL arg3 = YES;
    //        [invocation setArgument:&arg2 atIndex:2];
    //        [invocation setArgument:&arg3 atIndex:3];
    //        [invocation invoke];
    //    } else { // IOS7之前的版本
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    //    }
    
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return screenshot;
    
    
   

}

- (UIImage *)imageFromImage:(UIImage *)image inRect:(CGRect)rect {
    CGImageRef sourceImageRef = [image CGImage];
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    //    CGImageRelease(sourceImageRef);
    CGImageRelease(newImageRef);
    return newImage;
}

/** 纯色图片 */
+ (UIImage *)XZ_ColoreImage:(UIColor *)color{
    CGSize size = CGSizeMake(1.0f, 1.0f);
    return [self XZ_ColoreImage:color size:size];
}

+ (UIImage *)XZ_ColoreImage:(UIColor *)color size:(CGSize)size{
    CGRect rect=(CGRect){{0.0f,0.0f},size};
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0f);
    CGContextRef context=UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** 按比例 重设图片大小 */
- (UIImage *)XZ_resizeByRate:(CGFloat)rate{
    return [self XZ_resizeByQuality:kCGInterpolationNone rate:rate];
}

/**<  按比例 质量 重设图片大小 */
- (UIImage *)XZ_resizeByQuality:(CGInterpolationQuality)quality rate:(CGFloat)rate{
    UIImage *resized = nil;
    CGFloat width = self.size.width * rate;
    CGFloat height = self.size.height * rate;
    
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetInterpolationQuality(context, quality);
    [self drawInRect:CGRectMake(0, 0, width, height)];
    resized = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resized;
}

- (UIImage *)XZ_limitImgSize{
    return [self XZ_limitImgMaxWH:800];
}

- (UIImage *)XZ_sizeToThum{
    return [self XZ_limitImgMaxWH:150];
}

/** 按最大比例压缩图片 */
- (UIImage *)XZ_limitImgMaxWH:(CGFloat)Max_H_W{
    if (self == nil) {
        return nil;
    }
    CGFloat height = self.size.height;
    CGFloat width = self.size.width;
    if ((MAX(height, width)) < (Max_H_W )) {
        return self;//不需要再改了
    }
    if (MAX(height, width) > Max_H_W) {//超过了限制 按比例压缩长宽
        CGFloat Max = MAX(height, width);
        height = height*(Max_H_W/Max);
        width = width*(Max_H_W/Max);
    }
    UIImage *newimage;
    UIGraphicsBeginImageContext(CGSizeMake((int)width, (int)height));
    [self drawInRect:CGRectMake(0, 0,(int)width,(int)height)];
    newimage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newimage ;
}

//图片要求的最大长宽
- (CGSize)XZ_reSetMaxWH:(CGFloat)WH{
    if (self == nil) {
        return self.size;
    }
    CGFloat height = self.size.height/self.scale;
    CGFloat width = self.size.width/self.scale;
    CGFloat Max_H_W = WH;
    if ((MAX(height, width)) < (Max_H_W )) {
        return self.size;//不需要再改了
    }
    if (MAX(height, width) > Max_H_W) {//超过了限制 按比例压缩长宽
        CGFloat Max = MAX(height, width);
        height = height*(Max_H_W/Max);
        width = width*(Max_H_W/Max);
    }
    return CGSizeMake(width, height);
}

- (CGSize)XZ_scaleToWidth:(CGFloat)MaxWidth{
    return CGSizeMake(MaxWidth, MaxWidth*self.size.height/self.size.width);
}

#pragma mark -

/**
 *  保存到指定相册名字
 */
-(void)XZ_savedToAlbum_AlbumName:(NSString*)AlbumName SucBlack:(void(^)())completeBlock failBlock:(void(^)())failBlock{
    ALAssetsLibrary *ass = [[ALAssetsLibrary alloc]init];
    [ass writeImageToSavedPhotosAlbum:self.CGImage orientation:(ALAssetOrientation)self.imageOrientation completionBlock:^(NSURL *assetURL, NSError *error) {
        __block BOOL albumWasFound = NO;
        ALAssetsLibrary *assetsLibrary = [[ALAssetsLibrary alloc] init];
        //search all photo albums in the library
        [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupAlbum usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
            //判断相册是否存在
            if ([AlbumName compare: [group valueForProperty:ALAssetsGroupPropertyName]]==NSOrderedSame) {
                //存在
                albumWasFound = YES;
                [assetsLibrary assetForURL:assetURL resultBlock:^(ALAsset *asset) {
                    if ([group addAsset: asset]) {
                        completeBlock();
                    }
                } failureBlock:^(NSError *error) {
                    failBlock();
                }];
                return;
            }
            //如果不存在该相册创建
            if (group==nil && albumWasFound==NO){
                __weak ALAssetsLibrary* weakSelf = assetsLibrary;
                //创建相册
                [assetsLibrary addAssetsGroupAlbumWithName:AlbumName resultBlock:^(ALAssetsGroup *group){
                    [weakSelf assetForURL: assetURL
                              resultBlock:^(ALAsset *asset)  {
                                  if ([group addAsset: asset]) {
                                      completeBlock();
                                  }
                              } failureBlock: ^(NSError *error) {
                                  failBlock();
                              }];
                } failureBlock:  ^(NSError *error) {
                    failBlock();
                }];
                return;
            }
        }failureBlock:^(NSError *error) {
            failBlock();
        }];
    }];
    
}


/**
 *  保存相册
 *
 *  @param completeBlock 成功回调
 *  @param completeBlock 出错回调
 */
-(void)XZ_savedToAlbum:(void(^)())completeBlock failBlock:(void(^)())failBlock{
    UIImageWriteToSavedPhotosAlbum(self, self, @selector(image:didFinishSavingWithError:contextInfo:),NULL);
    self.CompleteBlock = completeBlock;
    self.FailBlock = failBlock;
}


- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if(error == nil){
        if(self.CompleteBlock != nil) self.CompleteBlock();
    }else{
        if(self.FailBlock !=nil) self.FailBlock();
    }
}

/*
 *  模拟成员变量
 */
-(void (^)())FailBlock{
    return objc_getAssociatedObject(self, FailBlockKey);
}
-(void)setFailBlock:(void (^)())FailBlock{
    objc_setAssociatedObject(self, FailBlockKey, FailBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
-(void (^)())CompleteBlock{
    return objc_getAssociatedObject(self, CompleteBlockKey);
}

-(void)setCompleteBlock:(void (^)())CompleteBlock{
    objc_setAssociatedObject(self, CompleteBlockKey, CompleteBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


#pragma mark -

/**< 加水印 */
-(UIImage *)XZ_waterWithText:(NSString *)text direction:(Image_WaterDirect)direction fontColor:(UIColor *)fontColor fontPoint:(CGFloat)fontPoint marginXY:(CGPoint)marginXY{
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero,size};
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //绘制图片
    [self drawInRect:rect];
    //绘制文本
    NSDictionary *attr = @{NSFontAttributeName : [UIFont systemFontOfSize:fontPoint],NSForegroundColorAttributeName:fontColor};
    CGRect strRect = [self calWidth:text attr:attr direction:direction rect:rect marginXY:marginXY];
    [text drawInRect:strRect withAttributes:attr];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    return newImage;
}


- (CGRect)calWidth:(NSString *)str attr:(NSDictionary *)attr direction:(Image_WaterDirect)direction rect:(CGRect)rect marginXY:(CGPoint)marginXY{
    CGSize size =  [str sizeWithAttributes:attr];
    CGRect calRect = [self rectWithRect:rect size:size direction:direction marginXY:marginXY];
    return calRect;
}


- (CGRect)rectWithRect:(CGRect)rect size:(CGSize)size direction:(Image_WaterDirect)direction marginXY:(CGPoint)marginXY{
    CGPoint point = CGPointZero;
    //右上
    if(Image_WaterDirectTopRight == direction) point = CGPointMake(rect.size.width - size.width, 0);
    //左下
    if(Image_WaterDirectBottomLeft == direction) point = CGPointMake(0, rect.size.height - size.height);
    //右下
    if(Image_WaterDirectBottomRight == direction) point = CGPointMake(rect.size.width - size.width, rect.size.height - size.height);
    //正中
    if(Image_WaterDirectCenter == direction) point = CGPointMake((rect.size.width - size.width)*.5f, (rect.size.height - size.height)*.5f);
    point.x+=marginXY.x;
    point.y+=marginXY.y;
    CGRect calRect = (CGRect){point,size};
    return calRect;
}



/**
 *  加水印
 */
-(UIImage *)XZ_waterWithWaterImage:(UIImage *)waterImage direction:(Image_WaterDirect)direction waterSize:(CGSize)waterSize  marginXY:(CGPoint)marginXY{
    CGSize size = self.size;
    CGRect rect = (CGRect){CGPointZero,size};
    //新建图片图形上下文
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0f);
    //绘制图片
    [self drawInRect:rect];
    //计算水印的rect
    CGSize waterImageSize = CGSizeEqualToSize(waterSize, CGSizeZero)?waterImage.size:waterSize;
    CGRect calRect = [self rectWithRect:rect size:waterImageSize direction:direction marginXY:marginXY];
    //绘制水印图片
    [waterImage drawInRect:calRect];
    //获取图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    //结束图片图形上下文
    UIGraphicsEndImageContext();
    
    return newImage;
}


- (UIImage *)fixOrientation {
    
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp) return self;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                             CGImageGetBitsPerComponent(self.CGImage), 0,
                                             CGImageGetColorSpace(self.CGImage),
                                             CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}


- (UIImage*)imageRotatedByDegrees:(CGFloat)degrees{
    CGFloat width = CGImageGetWidth(self.CGImage);
    CGFloat height = CGImageGetHeight(self.CGImage);
    
    CGSize rotatedSize;
    
    rotatedSize.width = width;
    rotatedSize.height = height;
    
    UIGraphicsBeginImageContext(rotatedSize);
    CGContextRef bitmap = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(bitmap, rotatedSize.width/2, rotatedSize.height/2);
    CGContextRotateCTM(bitmap, degrees * M_PI / 180);
    CGContextRotateCTM(bitmap, M_PI);
    CGContextScaleCTM(bitmap, -1.0, 1.0);
    CGContextDrawImage(bitmap, CGRectMake(-rotatedSize.width/2, -rotatedSize.height/2, rotatedSize.width, rotatedSize.height), self.CGImage);
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
