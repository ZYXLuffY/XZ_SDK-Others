//
//  UITableViewCell+XZ.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 2016/11/11.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (XZ)

/** cell 对应的 indexpath */
@property(nonatomic,strong,readonly) NSIndexPath *indexPath;
@property (nonatomic,strong,readonly) UITableView *superTableView;/**< cell view 根据nextResponder 获得 当前的TableView */

/** 方便构建方法  返回自己 */
- (instancetype)XZ_reloadCell;

@end


