//
//  QTZ_CarPlateView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by XZ on 16/2/23.
//  Copyright © 2016年 XZ. All rights reserved.
//
typedef void(^BlockChange)();
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, QTZ_CarPlateType) {
    QTZ_CarPlateTypeAll,/**< 显示全部车辆 */
    QTZ_CarPlateTypeBinding,/**< 显示绑定过的车辆 */
    QTZ_CarPlateTypeBindingNotAdd,/**< 显示绑定过的车辆 不显示添加车辆*/
};

@interface QTZ_CarPlateView : UIView

//@property (nonatomic,strong) UIImageView *Img;/**< 车标 */
@property (nonatomic,strong) UILabel *La_plate;/**< 车牌号 */
@property (nonatomic,assign) QTZ_CarPlateType ListType;
@property (nonatomic,assign) CGPoint ShowInPoint;/**< 显示的位置 */
@property (nonatomic,copy)  BlockChange BL_Change;/**< 更换完毕 */
//@property (nonatomic,copy) void (^Block_ChangeRes)(NSDictionary *Res);/**< 切换的结果 */

-(UIView*)initWithVC:(UIViewController*)vc Point:(CGPoint)point ListType:(QTZ_CarPlateType)type done:(BlockChange)done;/**< 固定大小 切换完成（网络）回调*/
-(void)RefreshCarList;/**< 刷新下显示咯 */

@end
