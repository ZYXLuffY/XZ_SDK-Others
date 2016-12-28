
#import "XZShowImg.h"
#import "IBActionSheet.h"
#import "XZUtility.h"

static CGRect oldframe;
static CGRect original;
static UIView *bgv;
static UIImageView  *ImgV_;

@implementation XZShowImg

+(void)showImgFrom:(UIImageView*)view{
    [XZShowImg showImgFrom:view tureImg:nil];
}

+(void)showImgFrom:(UIImageView*)view tureImg:(UIImage*)tureimg {
    [XZShowImg showImgFrom:view tureImg:tureimg showSave:YES];
}


+(void)showImgFrom:(UIImageView*)fview tureImg:(UIImage*)tureimg showSave:(BOOL)save{
    bgv = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    bgv.backgroundColor = kRGBA(0, 0, 0, 0.6);
    UIImage *img = tureimg;
    if (tureimg == nil && [fview isKindOfClass:[UIImageView class]] ) {
        img = fview.image;
    }
    if (img == nil) {return;}
    
    ImgV_ = [[UIImageView alloc]initWithFrame:(oldframe = [fview convertRect:fview.bounds toView:XZApp.window])];
    ImgV_.contentMode = fview.contentMode;
    ImgV_.userInteractionEnabled = YES;
    ImgV_.image = img;
    [bgv addSubview:ImgV_];
    [XZApp.window addSubview:bgv];
    
    UITapGestureRecognizer  *singleTapGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(hideImage)];
    singleTapGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [bgv addGestureRecognizer: singleTapGestureRecognizer];
    
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(handlePinch:)];
    UIPanGestureRecognizer *panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(handlePan:)];
    pinchGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    panGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
    [ImgV_ addGestureRecognizer:pinchGestureRecognizer];
    [ImgV_ addGestureRecognizer:panGestureRecognizer];
    
    
    [UIView animateWithDuration:0.2 animations:^{
        ImgV_.frame = CGRectMake(0,(ScreenHeight - ImgV_.image.size.height*ScreenWidth/ImgV_.image.size.width)/2 , ScreenWidth, ImgV_.image.size.height*ScreenWidth/ImgV_.image.size.width);
        bgv.alpha = 1;
    } completion:nil];
    
    original = ImgV_.frame;
    
    [bgv addGestureRecognizer: [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(imgLongTap:)]];
}

+(void)imgLongTap:(UILongPressGestureRecognizer*)gesture{
    if (ImgV_.image == nil || gesture.state == UIGestureRecognizerStateEnded) {
        return;
    }
    
    [[IBActionSheet alloc]initWithVC:XZApp.window Title:nil index:^(int index) {
        if (index == 0) {
            [ImgV_.image XZ_savedToAlbum_AlbumName:[[NSBundle mainBundle] infoDictionary][@"CFBundleDisplayName"] ? : @""  SucBlack:^{
                [XZApp.window.rootViewController ShowHUD:nil Img:1 De:0.618];
            } failBlock:^{
                [XZApp.window.rootViewController ShowHUD:@"保存失败" Img:0 De:0.618];
            }];
        }
    } Cancel:@"取消" Other:@"保存到手机", nil];
    
}

+(void)hideImage{
    [UIView animateWithDuration:0.25 animations:^{
        //        ImgV_.frame = oldframe;//回到原来的位置
        bgv.alpha = ImgV_.alpha = 0;
    } completion:^(BOOL finished) {
        [bgv removeFromSuperview];
        [ImgV_ removeFromSuperview];
    }];
    
}

#pragma mark - 手势操作

+(void)handlePinch:(UIPinchGestureRecognizer*)recognizer{
    if (recognizer.view.frame.size.width <= ScreenWidth && recognizer.scale < 1) {
        return;
    }
    if (recognizer.view.transform.a <= 15 || recognizer.scale < 1) {
        recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
        recognizer.scale = 1;
    }
    
    if (recognizer.state == UIGestureRecognizerStateEnded || recognizer.state == UIGestureRecognizerStateChanged){
        [UIView animateWithDuration:0.2 animations:^{
            if (recognizer.view.width < original.size.width) {recognizer.view.frame = original;}
            if (recognizer.view.x > 0 ) {recognizer.view.x = 0;}
            if (recognizer.view.right < ScreenWidth) { recognizer.view.right = ScreenWidth;}
            if ((recognizer.view.y < 0 && recognizer.view.height < ScreenHeight) ||(recognizer.view.height > ScreenHeight && recognizer.view.y > 0)   ) { recognizer.view.y = 0;}
            if ((recognizer.view.bottom > ScreenHeight && recognizer.view.height < ScreenHeight) || (recognizer.view.height > ScreenHeight && recognizer.view.bottom < ScreenHeight)) { recognizer.view.bottom = ScreenHeight;}
        }];
    }
}

+(void)handlePan:(UIPanGestureRecognizer*)recognizer{
    CGFloat A = recognizer.view.transform.a;
    CGPoint translation = [recognizer translationInView:XZApp.window];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x  * (A > 10 ? (A - 10)*0.8 : 1),
                                         recognizer.view.center.y + translation.y  * (A > 10 ? (A - 10)*0.8 : 1));
    [recognizer setTranslation:CGPointZero inView:XZApp.window];
    
    if (recognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:0.2 animations:^{
            if (recognizer.view.x > 0 ) {recognizer.view.x = 0;}
            if (recognizer.view.right < ScreenWidth) { recognizer.view.right = ScreenWidth;}
            if ((recognizer.view.y < 0 && recognizer.view.height < ScreenHeight) ||(recognizer.view.height > ScreenHeight && recognizer.view.y > 0)   ) { recognizer.view.y = 0;}
            if ((recognizer.view.bottom > ScreenHeight && recognizer.view.height < ScreenHeight) || (recognizer.view.height > ScreenHeight && recognizer.view.bottom < ScreenHeight)) { recognizer.view.bottom = ScreenHeight;}
        }];
    }
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}


@end
