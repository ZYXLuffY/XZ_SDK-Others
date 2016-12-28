
#import <UIKit/UIKit.h>
@class OrderListMod_insureConfirmInfo;

typedef NS_ENUM(NSUInteger, QTZ_AlertViewType) {
    QTZ_AlertViewTypeNormal,/**< Normal */
    QTZ_AlertViewTypeMoney,/**< 金额输入的 */
    QTZ_AlertViewTypeMap,/**< 请选择导航地图 */
    QTZ_AlertViewTypeSlider,/**< 灵敏度设置 */
    QTZ_AlertViewTypeMileage,/**< 当前行驶里程 上次保养里程。。*/
    QTZ_AlertViewTypeMustInputMileage,/**< 请输入当前行驶里程 半强制 */
    QTZ_AlertViewTypeInsureInfo,/**< 核保信息 */
};

@interface QTZ_AlertView : UIView
//@interface QTZ_AlertView : UIVisualEffectView

@property (nonatomic,strong) UILabel *La_msg;
@property (nonatomic,strong) UILabel *La_title;


/** @两个按钮纯文本显示（block回调方式） */
- (QTZ_AlertView*)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)otherButtonTitles;

/**  默认 提示 取消 确认 点击了index 1才回调  */
+(void)Msg:(NSString *)message affirm:(void (^)())completeBlock;

/**  默认 输入金额 取消 确认 点击了index 1才回调  */
+(void)MoneyInputMsg:(NSString *)message affirm:(void (^)(NSString *money))completeBlock;

/**  当前行驶里程  上次保养里程 等*/
+(void)MileageInputCurrent:(NSString*)Mileage title:(NSString*)title Affirm:(void (^)(NSString *Mileage))completeBlock;

/**  盒子插入 请输入当前行驶里程 半强制 等*/
+(void)MustInpuMileageInputAffirm:(void (^)(NSString *Mileage))completeBlock current:(NSString*)current;

/** 导航的 */
+(void)MapSelect:(void (^)(NSInteger index))completeBlock;

/** 核保信息 */
+(void)ShowInsureInfo:(OrderListMod_insureConfirmInfo *)insureInfo affirm:(void (^)())completeBlock;

#define ShakeMin   (20)
#define ShakeMax   (500)
/** 灵敏度设置的 点击了index 1才回调*/
+(void)SliderSelectValue:(NSString*)value complete:(void (^)(CGFloat value))completeBlock;


/** 显示弹出框 */
-(void)showWithCompletion:(void (^)(int index))completeBlock;


@end
