//
//  QTZ_StarEvaView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/9/8.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "XZStarRateView.h"

@interface QTZ_StarEvaView : UIView

typedef void(^TB_Start)(NSInteger star);
@property (nonatomic,copy) TB_Start B_Start;

- (id)initWithFrame:(CGRect)frame numberOfStar:(int)number;

/**
 *  星星评分
 */
+(instancetype)Point:(CGPoint)point addTo:(UIView*)addview numberOfStar:(int)number Block:(TB_Start)block;
@property (nonatomic,assign) CGFloat currentStar;
-(void)ChangeCurrentStar:(CGFloat)star block:(BOOL)block;/**< 设置当前星星等级 */




@end
