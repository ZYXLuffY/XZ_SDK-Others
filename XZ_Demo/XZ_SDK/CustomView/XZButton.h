//
//  XZButton.h
//  YiJiaoYu
//
//  Created by XZ on 15/3/3.
//  Copyright (c) 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

#pragma mark - XZxibButton

//IB_DESIGNABLE
@interface XZxibButton : UIButton

@property (nonatomic,assign)  CGRect moreTouchMargin;/**< 给予更多的边界 点击范围 按照UIEdgeInsets 用*/

@property (nonatomic,assign) NSInteger row;/**< 记录info  或tag */
@property (nonatomic,assign) NSInteger section;/**< 记录info  或tag */

@property(nonatomic,strong) UIActivityIndicatorView *Act_;
-(void)Loading;/**< 进度中。。 */
-(void)StopLing;/**< 停止进度 */



@end




@interface XZButton : XZxibButton

@property (nonatomic,assign)  CGRect imgf;/**< 图片在按钮中的位置  UIViewContentModeScaleAspectFit*/
@property (nonatomic,assign)  CGRect titf;/**< 文本在按钮中的位置 */

/** 专门的图片位置 & 文本位置 整体 */
- (instancetype)initWithFrame:(CGRect)frame ImgF:(CGRect)imgf TitF:(CGRect)titf Title:(NSString*)title FontS:(CGFloat)fonts Color:(UIColor*)titleColor imageName:(NSString*)imageName Target:(id)target action:(SEL)action;

- (instancetype)initWithFrame:(CGRect)frame ImgF:(CGRect)imgf TitF:(CGRect)titf;

/** 设置文本和图片距离文本的水平位置 UIControlStateNormal*/
- (void)resetTitle:(NSString*)title imgMargin:(CGFloat)margin;

@end



@interface XZScaleButton : XZButton


@end



