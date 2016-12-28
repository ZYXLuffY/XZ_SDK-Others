//
//  QTZ_ScrollView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by 天牧伯爵ui设计师 on 16/3/22.
//  Copyright © 2016年 XZ. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void(^selectedBlock)(NSInteger index);

@interface QTZ_ScrollView : UIView

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, assign) CGFloat ScrollTime;/**< 滚动时间*/
@property (nonatomic,copy)  selectedBlock selected;/**< 选中操作*/

-(UIView *)initWithFrame:(CGRect)frame dataWith:(NSArray *)datas selectedAction:(selectedBlock)selected;
-(void)reloadDataWithData:(NSArray *)datas;

@end
