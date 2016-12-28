//
//  QTZ_HeadScrEffetView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/8/30.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QTZ_HeadScrEffetView : UIView

@property (nonatomic,strong) UIView *Ve_des;/**<  放在图片哪里的描述*/
@property (nonatomic,strong) UILabel *La_des;/**<  放在图片哪里的描述*/
@property (nonatomic,strong) UILabel *La_shopType;/**<  商家服务类型*/
/** 里面放图片地址 可点击 查看N张图片 模型 .img 或 字符串*/
- (void)sendMWPhotoBrowserUrlArr:(NSArray*)urlArr;

- (instancetype)initWithHeadHeight:(CGFloat)heigt table:(UITableView*)table;

/** 可支持的服类型的标签Url*/
- (void)sendShop_CridictsTags:(NSArray*)urlArr;

/** 修改描述 */
- (void)changeProjectName:(NSString*)projectName;

@end
