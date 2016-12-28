
#import "QTZ_CarPlateView.h"
#import "XZUtility.h"
#import "XZPutDownMenuView.h"
//#import "Main_1_VC.h"
//#import "Main_2_VC.h"
#import "UIImageView+WebCache.h"
#import "QTZStatistics.h"
//#import "MyLoveCarsTVC.h"
//#import "AddCar_Step1VC.h"

@interface QTZ_CarPlateView (){
    UIImageView *imgArrow;
}

@property (nonatomic,weak) UIViewController *ShowInVC;

@end

@implementation QTZ_CarPlateView

-(void)dealloc{
    JIE1;
}

/** 固定大小 切换完成（网络）回调*/
-(UIView*)initWithVC:(UIViewController*)vc Point:(CGPoint)point ListType:(QTZ_CarPlateType)type done:(BlockChange)done{
    self = [super initWithFrame:CGRectMake(point.x, point.y, 130, 40)];
    if (self) {
        _ShowInPoint = CGPointMake(0, 48);
        _ShowInVC = vc;
        _ListType = type;
        _BL_Change = done;
        
        [self addSubview:(_La_plate = [UILabel Frame:CGRectMake(0, (self.height - 24)/2, self.width, 24) Title:nil FontS:17 Color:kColorText Alignment:NSTextAlignmentCenter])];
        _La_plate.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
        _La_plate.adjustsFontSizeToFitWidth = YES;
        
//        [self addSubview:imgArrow = [UIImageView Frame:CGRectMake(self.width - 15,  (self.height - 7.5)/2, 12, 7.5) image:[[UIImage imageNamed:@"hp_pointDown"] imageWithColor:kColorText]]];
        [self addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(ChangeCarTapGesture)]];
        
        [self RefreshCarList];
    }
    return self;
}

/** 这个要显示的 绑定 或 不绑定 的车辆数组 */
-(NSMutableArray *)CurretnArr_List{
    return nil;
//    return _ListType == QTZ_CarPlateTypeAll ? (XZApp.Main1VCInfo.userCarInfo) : ([XZApp.Main1VCInfo BindingCarList]);
}

#pragma mark - 切换车辆
-(void)ChangeCarTapGesture{
//    If_Return(XZApp.Main1VCInfo == nil);
//    
//    M_userCarInfo *SelCar = [XZApp.Main1VCInfo CurrentSelectCar];
//    if (SelCar == nil) {//添加车辆
//        [self AddCar];
//        return;
//    }
//    if (XZApp.Main1VCInfo.userCarInfo.count == 1 && _ListType == QTZ_CarPlateTypeBindingNotAdd) {
//        return;
//    }
//    if ((_ListType != QTZ_CarPlateTypeAll && [self CurretnArr_List].count <= 1)) {
//        return;
//    }
//    
//    [[QTZStatistics share] nativeBtnClick:menu_ChangeCar_Action];//点击切换车辆时记录
//    
//    [XZPutDownMenuView_CarList ShowIn:_ShowInVC.Nav.view Frame:CGRectMake(_ShowInPoint.x, _ShowInPoint.y, 128, ScreenHeight *0.618) List:[self CurretnArr_List] AddCar:(_ListType == QTZ_CarPlateTypeBindingNotAdd ? NO : YES) Click:^(NSString *str, NSInteger index) {
//        if (index == [self CurretnArr_List].count) {
//            [self AddCar];
//            return ;
//        }
//        If_Return([((M_userCarInfo*)str).Id isEqualToString:SelCar.Id]);
//        _La_plate.text = nil;
//        
//        
//        [XZApp.Main1VCInfo ChangeDefaultCar:((M_userCarInfo*)str).Id];
//        [self RefreshCarList];
//        Block_Exec(_BL_Change);
//        [[Main_1_VC InNav] stack_RefreshAction];
//        //切换车辆
//        [_ShowInVC POST:API_updateDefaultCar Param:@{@"oldCarId" : SelCar.Id,@"carBaseInfo.id" : ((M_userCarInfo*)str).Id} Suc:nil
//                    Fai:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//                        [self RefreshCarList];
//                        [_ShowInVC ShowHUD:XZkNetWorkERROR De:0];
//                    }];
//    }];
}

-(void)RefreshCarList{/**< 刷新下显示咯 */
//    if (XZApp.Main1VCInfo == nil) {
//        imgArrow.hidden = YES;
//        return;
//    }
//    M_userCarInfo *SelCar = [XZApp.Main1VCInfo CurrentSelectCar];
//    imgArrow.hidden = (SelCar == nil);
//    if (!SelCar) {//没有车辆
//        _La_plate.text = @"";
//        return;
//    }
//    
//    //显示绑定的 且数量只有一个的 只显示而已
//    BOOL OnlyShowOnce = (_ListType != QTZ_CarPlateTypeAll && [self CurretnArr_List].count <= 1);
//    imgArrow.hidden = OnlyShowOnce;
//    self.userInteractionEnabled = !OnlyShowOnce;
//    
//    //    [_Img sd_setImageWithURL:[NSURL URLWithString:SelCar.iconUrl] placeholderImage:[UIImage imageNamed:@"DefaultcarIcon"]];
//    _La_plate.text = [SelCar plateNumber];
    
}

//添加车辆
-(void)AddCar{
//    If_Return(_ShowInVC == nil);
//    [[_ShowInVC.Nav.viewControllers firstObject] setSelectedIndex:2];//取tabbar
//    [_ShowInVC.Nav setViewControllers:@[[_ShowInVC.Nav.viewControllers firstObject],[MyLoveCarsTVC Vc],[AddCar_Step1VC Vc]] animated:YES];
}

@end
