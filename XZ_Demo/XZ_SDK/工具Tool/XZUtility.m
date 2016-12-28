
#import "XZUtility.h"
#import "AppDelegate.h"
#import <CommonCrypto/CommonCryptor.h>
#import <CommonCrypto/CommonDigest.h>
#import "IBActionSheet.h"
#import "SystemConfiguration/SystemConfiguration.h"
#include <netdb.h>
#import <mach/mach_time.h>
#import <AVFoundation/AVFoundation.h>
#import "RSKImageCropper.h"
#import "QTZ_AlertView.h"
#import <CoreFoundation/CoreFoundation.h>


#define ORIGINAL_MAX_WIDTH 640.0f
@implementation XZUtility

/** 代码执行时间 */
void XZUseTime (void(^block)(void)) {
 #ifdef DEBUG
    mach_timebase_info_data_t info;
    if (mach_timebase_info(&info) != KERN_SUCCESS) return;
    uint64_t start = mach_absolute_time ();
    block ();
    uint64_t end = mach_absolute_time ();
    uint64_t elapsed = end - start;
    NSLog(@"⏰ %f",(CGFloat)(elapsed * info.numer / info.denom) / NSEC_PER_SEC);
#endif
}

/** 代码执行时间(循环XXXXX次) */
void Code_RunTime (int times,void(^block)(void)){
    int TureTime = times ? times : 10000;
    XZUseTime( ^{
        for (int i = 0; i < TureTime; i++) {
            block ();
        }
    });
}

/** 延迟执行 */
void delay (float time,void (^block)(void)){
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(),block);
}


//提示框
+ (void)showAlertViewTitle:(NSString *)title Msg:(NSString *)message{
    [XZUtility showAlertViewTitle:title Msg:message completion:nil otherBtns:@[@"确定"]];
}

+ (void)showAlertViewTitle:(NSString *)title Msg:(NSString *)message completion:(void(^)(int index))completionBlock  otherBtns:(NSArray *)otherbtns{
    if ([XZHandleCommon share].isShowAlterView) {return;}
    
    [[[QTZ_AlertView alloc]initWithTitle:title message:message buttonTitles:otherbtns] showWithCompletion:completionBlock];
     [XZHandleCommon share].isShowAlterView = YES;
}

#define x_pi 3.14159265358979324 * 3000.0 / 180.0
/** 高德采用GCJ-02, 百度map sdk 采用的是BD-09 */
+ (CLLocationCoordinate2D)Convert_BD09_To_GCJ02:(CLLocationCoordinate2D)coor{
    double x = coor.longitude - 0.0065, y = coor.latitude - 0.006;
    double z = sqrt(x * x + y * y) - 0.00002 * sin(y * x_pi);
    double theta =atan2(y, x) - 0.000003 * cos(x * x_pi);
    return CLLocationCoordinate2DMake(z * sin(theta),z * cos(theta));
}


+ (NSString *)URLWithBaseString:(NSString *)baseString parameters:(NSDictionary *)parameters{
    NSMutableString *urlString =[NSMutableString string];  
    [urlString appendString:baseString];


    NSInteger keyIndex = 0;
    for (id key in parameters) {
        if(keyIndex ==0) {
            [urlString appendFormat:@"?%@=%@",key,[parameters valueForKey:key]];
            
        }else{
            [urlString appendFormat:@"&%@=%@",key,[parameters valueForKey:key]];
        }
        keyIndex++;
    }
    return [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}
@end


#pragma mark - ==================    XZHandleCommon  AlertView



typedef enum{
    AlertViewUseBlock = 1,
}AlertType;

@interface XZHandleCommon()

@end;

@implementation XZHandleCommon

+ (id)allocWithZone:(struct _NSZone *)zone{
    static XZHandleCommon *instance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
    });

    return instance;
}

+ (instancetype)share{
    return [[self alloc] init];
}

- (void)showAlertView:(NSString *)title Msg:(NSString *)message cancleBtn:(NSString *)cancletitle otherBtn:(NSArray*)arr completionBlock:(indexBtnClickBlock)completionBlock{
    if(_isShowAlterView) {return;}
    _isShowAlterView = YES;
    _alertXZ = [[UIAlertView alloc] initWithTitle:title message:message delegate:self cancelButtonTitle:cancletitle otherButtonTitles: nil];
    for (NSString *btntitle in arr) {
        [_alertXZ addButtonWithTitle:btntitle];
    }
    _alertXZ.tag = AlertViewUseBlock;
    [_alertXZ show];
    _indexblock = completionBlock;
}

-(void)HideAlertView{
    [_alertXZ dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    _isShowAlterView = NO;

    if(_indexblock != nil && alertView.tag == AlertViewUseBlock){
        (_indexblock((int)buttonIndex));
        _indexblock = nil;
    }

}





#pragma mark - 相机获取图片相关

+(XZHandleCommon*)ReadlyToPickRoundImg:(BOOL)round pick:(B_PickImg)block{
    XZHandleCommon *Picker = [XZHandleCommon share];
    Picker.B_PickimgBlock = block;
    Picker.RoundImg = round;
    return Picker;
}

//搞张图片 默认 @"拍照",@"从相册中选择" 返回修改过大小的图片 title 标题 而已 vc    self 是否圆形选择图片？
+(void)CameraPick_Img:(NSString*)title RoundImg:(BOOL)round pick:(B_PickImg)block{
    [XZHandleCommon ReadlyToPickRoundImg:round pick:block];
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XZHandleCommon share] ChoosePhoto:UIImagePickerControllerSourceTypeCamera edit:NO];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XZHandleCommon share] ChoosePhoto:UIImagePickerControllerSourceTypePhotoLibrary edit:NO];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
       [XZHandleCommon share].B_PickimgBlock = nil;
    }]];
    [XZApp.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

+(void)CameraPick_Img:(NSString*)title edited:(BOOL)edited pick:(B_PickImg)block{
    [XZHandleCommon ReadlyToPickRoundImg:NO pick:block];
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XZHandleCommon share] ChoosePhoto:UIImagePickerControllerSourceTypeCamera edit:edited];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"从相册中选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [[XZHandleCommon share] ChoosePhoto:UIImagePickerControllerSourceTypePhotoLibrary edit:edited];
    }]];
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [XZHandleCommon share].B_PickimgBlock = nil;
    }]];
    [XZApp.window.rootViewController presentViewController:alertVC animated:YES completion:nil];
}

+(void)CameraPickImg_Type:(UIImagePickerControllerSourceType)type RoundImg:(BOOL)round edit:(BOOL)edit pick:(B_PickImg)block{
    [[XZHandleCommon ReadlyToPickRoundImg:round pick:block] ChoosePhoto:type edit:edit];
}

//@"拍照",@"从相册中选择"
-(void)ChoosePhoto:(UIImagePickerControllerSourceType)Choosetype edit:(BOOL)edit{
    if(![UIImagePickerController isSourceTypeAvailable:Choosetype]){
        return;
    }
    //如果使用相机的 拍照
    if(Choosetype == UIImagePickerControllerSourceTypeCamera){
        //无可用相机 或 用户设置的权限阻拦
        if (![XZHandleCommon CanUseCamera] || ![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            return;
        }
    }

    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.allowsEditing = self.allowsEdit =  self.RoundImg ? NO : edit;
    picker.delegate = (id<UINavigationControllerDelegate,UIImagePickerControllerDelegate>)self;
    picker.sourceType = Choosetype;
    [XZApp.window.rootViewController presentViewController:picker animated:YES completion:^{
//        [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//如果有必要 前后结束设置 系统状态栏文本的颜色
    }];
}

-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    UIImage *FixImg = [self.allowsEdit ? [info objectForKey:UIImagePickerControllerEditedImage] : [info objectForKey:UIImagePickerControllerOriginalImage] XZ_limitImgSize];
    if (self.RoundImg) {
        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:FixImg cropMode:RSKImageCropModeCircle];
        imageCropVC.delegate = (id<RSKImageCropViewControllerDelegate>)self;
        [picker pushViewController:imageCropVC animated:YES];

        return;
    }
    if (self.B_PickimgBlock) {
        self.B_PickimgBlock(FixImg,picker);
        self.B_PickimgBlock = nil;
    }
    [picker dismissViewControllerAnimated:YES completion:^{ }];
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
//    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];//如果有必要 前后结束设置 系统状态栏文本的颜色
    [picker dismissViewControllerAnimated:YES completion:^{ }];
}
//RSKImageCropViewController 的 回调
- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller{
    [controller.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage{
    if (self.B_PickimgBlock) {
        self.B_PickimgBlock(croppedImage,nil);
        self.B_PickimgBlock = nil;
    }
    [controller dismissViewControllerAnimated:YES completion:^{}];
}


/**
 *  能否使用相机
 */
+(BOOL)CanUseCamera{
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus ==AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if(authStatus == AVAuthorizationStatusDenied){
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"请在设备的设置-隐私-相机 中允许访问相机。"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        return NO;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        return YES;
    }else if(authStatus == AVAuthorizationStatusNotDetermined){
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
        }];
    }else {
        NSLog(@"Unknown authorization status");
    }

    return YES;
}


@end

