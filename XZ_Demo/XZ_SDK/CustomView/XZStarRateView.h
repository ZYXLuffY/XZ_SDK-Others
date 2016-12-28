//
//  XZStarRateView.h
//  EVGO
//
//  Created by XZ on 15/9/14.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XZStarRateView : UIView

typedef void(^TB_Start)(NSInteger star);
@property (nonatomic,copy) TB_Start B_Start;
@property (nonatomic, strong) UIColor *numColor;

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;
    
/**
 *  星星评分
 */
+(instancetype)Point:(CGPoint)point addTo:(UIView*)addview numberOfStar:(int)number Block:(TB_Start)block;
@property (nonatomic,assign) CGFloat currentStar;
@property (nonatomic,assign) BOOL suffixTitle;/**< 后面显示 X.X分 */
-(void)ChangeCurrentStar:(CGFloat)star block:(BOOL)block;/**< 设置当前星星等级 */




@end
