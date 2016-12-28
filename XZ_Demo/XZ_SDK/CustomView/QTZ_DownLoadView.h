//
//  QTZ_DownLoadView.h
//  com.tmbj.qtzUser_XZ
//
//  Created by 天牧伯爵ui设计师 on 16/3/7.
//  Copyright © 2016年 XZ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QTZ_CarTestMethod.h"

@interface QTZ_DownLoadView : UIView
@property (nonatomic, copy) void (^carProfileUnZipFilesSuccess)();/**< 解压配置文件成功*/
@property (nonatomic, copy) void (^carProfileUnZipFilesFail)();/**< 解压配置文件失败*/
@property (nonatomic, assign)CarTestType carTsetType;/**< 体检类别*/


+(instancetype)ShareDownLoadView;

+(instancetype)ShareDownLoadViewType:(CarTestType)type;

+(instancetype)ShareDownLoadViewType:(CarTestType)type CarId:(NSString *)carId DeviceId:(NSString *)deviceId isUpdate:(BOOL)isUpdate;
/** 显示 */
-(void)ShowView;
/** 隐藏 销毁 */
-(void)HideView;

@end
