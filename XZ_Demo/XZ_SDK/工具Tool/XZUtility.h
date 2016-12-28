
#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "XZData.h"
#import "MBProgressHUD.h"
#import "UIView+XZ.h"
#import "NSString+XZ.h"
#import "XZButton.h"
#import "UIImage+XZ.h"
#import "UIColor+XZ.h"
#import "CALayer+XZ.h"
#import "NSDate+XZ.h"
#import "NSArray+XZ.h"
#import "NSObject+XZ.h"
#import "NSTimer+XZ.h"
#import "UIViewController+XZ.h"
#import "UIControl+BlocksKit.h"
#import "UIButton+XZ.h"
#import "UILabel+XZ.h"
#import "UIScrollView+XZ.h"
#import "UITableViewCell+XZ.h"
#import "UIImageView+XZ.h"
#import "BoJueNetworkAPI.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <MapKit/MapKit.h>


#ifdef DEBUG
//#define NSLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#define NSLog(fmt, ...) NSLog((@"" fmt), ##__VA_ARGS__)
#else
#define NSLog(...)
#endif

#define QTZ_MD5Key @"f4cc399f0effd13c888e310ea2cf5399"
#define QTZ_MD5Method @"!@#$%^&*"

#define JEApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])
#define XZApp ((AppDelegate*)[[UIApplication sharedApplication] delegate])

#define USDF     [NSUserDefaults standardUserDefaults]
#define iOS7       ([[[UIDevice currentDevice]systemVersion]floatValue] >= 7.0)
#define iOS8       ([[[UIDevice currentDevice]systemVersion]floatValue] >= 8.0)
#define iOS9       ([[[UIDevice currentDevice]systemVersion]floatValue] >= 9.0)
#define iOS10      ([[[UIDevice currentDevice]systemVersion]floatValue] >= 10.0)
#define LoweriOS8  ([[[UIDevice currentDevice]systemVersion]floatValue] < 8.0)
#define ScreenHeight               [UIScreen mainScreen].bounds.size.height
#define ScreenWidth                [UIScreen mainScreen].bounds.size.width

#define iPhone4_Screen             (ScreenHeight == 480)//320×480
#define iPhone5_Screen             (ScreenHeight == 568)//320×568 0.5633
#define iPhone6_Screen             (ScreenWidth == 375)//375×667 0.5622
#define iPhone6Plus_Screen         (ScreenWidth == 414)//414x736  0.5625
#define iPhone6_PBigger            (ScreenWidth >= 375)
// iPhone5       320x568，640x1136， @2x
// iPhone6       375x667，750x1334， @2x
// iPhone6 Plus  414x736，1242x2208，@3x
//#if TARGET_IPHONE_SIMULATOR
//#endif

#define Block_Exec(block, ...)    if (block) { block(__VA_ARGS__);};
#define If_Exec(condition, ...)   if (condition) { __VA_ARGS__;};
#define If_Return(condition, ...)   if (condition) { __VA_ARGS__;return;};


#define JIE1           NSLog(@"💙Debug%s-%d- ",  __func__, __LINE__);
#define JIE2(x,y)      NSLog(@"💙Debug-%s\n %d \n%d \n%@\n",  __func__, __LINE__,(x),(y));

#define font(X) ([UIFont systemFontOfSize:X])
#define fontL(X) ([UIFont systemFontOfSize:X weight:UIFontWeightLight])
#define fontM(X) ([UIFont systemFontOfSize:X weight:UIFontWeightMedium])
#define fontB(X) ([UIFont systemFontOfSize:X weight:UIFontWeightBold])

#define SB1(VcIdentifier) ([[UIStoryboard storyboardWithName:@"BoJue_1" bundle:nil] instantiateViewControllerWithIdentifier:(VcIdentifier)])
#define SB2(VcIdentifier) ([[UIStoryboard storyboardWithName:@"BoJue_2" bundle:nil] instantiateViewControllerWithIdentifier:(VcIdentifier)])
#define SB3(VcIdentifier) ([[UIStoryboard storyboardWithName:@"BoJue_3" bundle:nil] instantiateViewControllerWithIdentifier:(VcIdentifier)])
#define SB_VC(storyboardName,VcIdentifier) ([[UIStoryboard storyboardWithName:(storyboardName) bundle:nil] instantiateViewControllerWithIdentifier:(VcIdentifier)])

#define SFM(x)      ([NSString stringWithFormat:@"%@",(x)])


#define LOADIMAGE(file) [UIImage imageWithContentsOfFile:[[NSBundle mainBundle]pathForResource:(file) ofType:@"png"]]

#define kCacheFile(fileName)  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:(fileName)]
#define kDocumentFile(fileName)  [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:(fileName)]


#define WSELF               __weak typeof(self) wself = self;
#define SSELF               __strong __typeof(wself)strongSelf = wself;
#define ISSTR(v) [[v class] isSubclassOfClass:[NSString class]]        //判断当前对象是否一个str对象
#define ISVaildStr(v) v && ISSTR(v) && [v length]>0 && ![v isEqualToString:@"<null>"]    //判断是否是一个合法的字符串
#define VALUEFROM(v) ISVaildStr(v)?v:@""     //如果字符串不合法的是否就返回一个长度为0的字符串


#define     jekPrompt                       @"提示"
#define     jekNetWorkERROR                 @"当前网络不稳定，请检查网络后再试"//网络连接失败


#define kColorDeepBlue  (HexColor(0x007AFF))
#define kColorBlue      (HexColor(0x4DA6F0))//蓝色 0x69B9FC

#define kColorBlue_deep (HexColor(0x007AFF))//深蓝色

#define kColorGreen     (HexColor(0x88c057))//绿色
#define kColorGreen_h   (HexColor(0x7aac4e))

#define kColorGreen_cao (HexColor(0x94D94A))//草绿色

#define kColorOrange    (HexColor(0xeeaf4b))//橙色
#define kColorOrange_h  (HexColor(0xd69d43))

#define kColorYellow     (HexColor(0xFCC45C))//yellow色

#define kColorRed       (HexColor(0xF86B6D))//绯色F86B6D  0xed7161
#define kColorRed_h     (HexColor(0xd56557))


#define kColorBackground (HexColor(0xF2F2F2))//背景(kRGB(242, 242, 242))
#define kColorSeparator  (HexColor(0xDDDDDD))// 分割线

#define kColorWhite      (kRGB(255, 255, 255))//白色

#define kColorDividing  (HexColorA(0xd2d2d2, 0.4))//浅灰色

#define kColorText      (HexColor(0x222222))//文本
#define kColorTextGray  (HexColor(0x666666))
#define kColorText99    (HexColor(0x999999))

#define kColorTextGlod  (HexColor(0x9D8871))//文本金色
#define kColorTextRed   (HexColor(0xFB6B6D))//文本红色


#define kColorRGBA(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:a]

#define kRandomColor [UIColor colorWithRed:arc4random_uniform(255)/255.0 green:arc4random_uniform(255)/255.0 blue:arc4random_uniform(255)/255.0 alpha:1]

#define Tmbj_code     ([[[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"] stringByReplacingOccurrencesOfString:@"." withString:@""])//版本号


#define UserDef_Dic_FristLogin                          @"UserDef_Dic_FristLogin"  //记录是否第一次登录
#define UserDef_AutoUser                                @"UserDef_AutoUser"       //自动登录用

#define UserDef_VoiceName                               @"UserDef_VoiceName"//讯飞播放语音的VoiceName

#define UserDef_AutoLogin                               @"UserDef_AutoLogin"      //是否要自动登录
#define UserDef_AutoUserPassWord                        @"UserDef_AutoUserPassWord"   //登录记录密码的
#define UserDef_Tmbj_Token                              @"UserDef_Tmbj_Token"//单点登录要用的
#define UserDef_refreshTokenTime                        @"UserDef_refreshTokenTime"//上次刷新token时间

#define UserDef_LastLocation                            @"UserDef_LastLocation"//上次定位的城市 和经纬度
#define UserDef_LastLocation_Time                       @"UserDef_LastLocation_Time"//上次定位的城市时间
#define TK_API_maininfo                                 @"TK_API_maininfo"//缓存主页信息的

#define UserDef_Noti_tips                               @"UserDef_Noti_tips"//首次提示
#define UserDef_IsLocationEnable                        @"UserDef_IsLocationEnable"//记录最后一次检查能否定位的

#define AppleStoreID    @"1069758311"
#define kUmengKey @"5660210367e58e10de002890"
#define ktencentAppId @"1104849748"
#define ktencentAppKey @"Tuk56SJr0nDR8K9C"

#define weiBoAppId @"335214109"
#define weiBoAppKey @"96c4c70cb52c0db7f229c77718f8a93e"

//合作身份者id，以2088开头的16位纯数字
#define PartnerID @"2088121851492993"

//微信支付参数
#define kWXAppID          @"wx6538353363ff9439"
#define kweChatAppKey     @"a7d46cb3da58ff098af6cc99a256402f"
#define kweAppSecret      @"5e9e5859f33baefd59c038c01539af4a"

//科大讯飞
#define kKDXFAppId        @"573290dc"
#define bojueWebSide @"http://bojuecar.com"

@interface XZUtility : NSObject


/** 代码执行时间  0为10000次 */
void Code_RunTime (int times,void(^block)(void));
/** 延迟执行 */
void delay (float time,void (^block)(void));

/** 显示警告框  该方法显示 不会显示多个 */
+ (void)showAlertViewTitle:(NSString *)title Msg:(NSString *)message;

/** 显示警告框 内部回调 */
+ (void)showAlertViewTitle:(NSString *)title Msg:(NSString *)message completion:(void(^)(int index))completionBlock  otherBtns:(NSArray *)otherbtns;

/** 高德采用GCJ-02, 百度map sdk 采用的是BD-09 */
+ (CLLocationCoordinate2D)Convert_BD09_To_GCJ02:(CLLocationCoordinate2D)coor;
/**< 根据参数拼接URL*/
+ (NSString *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters;


@end













#pragma mark - XZHandleCommon  AlertView

@interface XZHandleCommon : NSObject
+(instancetype)share;
typedef void(^indexBtnClickBlock)(int index);
@property (nonatomic,copy) indexBtnClickBlock indexblock;

@property (nonatomic,assign) BOOL isShowAlterView;
@property (nonatomic,strong) UIAlertView *alertXZ;

/** 显示警告框 内部回调 */
- (void)showAlertView:(NSString *)title Msg:(NSString *)message cancleBtn:(NSString *)cancletitle otherBtn:(NSArray*)arr completionBlock:(indexBtnClickBlock)completionBlock;
- (void)HideAlertView;/**< 隐藏AlertView */

#pragma mark - 图片相关
typedef void(^B_PickImg)(UIImage *FixedImg,UIImagePickerController *picker);
@property (nonatomic,copy) B_PickImg B_PickimgBlock;
@property (nonatomic,assign) BOOL RoundImg;/**< 剪裁圆形图片 */
@property (nonatomic,assign) BOOL allowsEdit;/**< 可编辑否 */

/** 搞张图片 默认 @"拍照",@"从相册中选择" 返回修改过大小的图片 title 标题而已 vc    self 是否圆形选择图片？ */
+(void)CameraPick_Img:(NSString*)title RoundImg:(BOOL)round pick:(B_PickImg)block;

/** 搞张图片 直接使用相机或相册 */
+(void)CameraPickImg_Type:(UIImagePickerControllerSourceType)type RoundImg:(BOOL)round edit:(BOOL)edit pick:(B_PickImg)block;

/** 搞张图片 @"拍照",@"从相册中选择" 返回原图 title 标题而已 */
+(void)CameraPick_Img:(NSString*)title edited:(BOOL)edited pick:(B_PickImg)block;

/**< 能否使用相机 不能用就alertview提示下 */
+(BOOL)CanUseCamera;


@end



