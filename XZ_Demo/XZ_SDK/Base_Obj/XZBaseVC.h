//
//  XZBaseVC.h
//  XZ_iOS
//
//  Created by XZ on 15/6/14.
//  Copyright © 2015年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XZUtility.h"
#import "XZNetWorking.h"
#import "UIViewController+XZ.h"


@interface XZBaseVC : UIViewController

@property (nonatomic,strong)  UITableView                   *Tv__;/**< 默认Tv */

-(void)Create__TvRect:(CGRect)rect Style:(UITableViewStyle)style;

@end
