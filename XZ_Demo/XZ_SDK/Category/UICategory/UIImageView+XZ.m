
#import "UIImageView+XZ.h"
#import "NSString+XZ.h"
#import "UIImageView+WebCache.h"
#import "UIView+XZ.h"
#import "XZShowImg.h"

@implementation UIImageView (XZ)

+ (instancetype)Frame:(CGRect)frame imgName:(NSString*)imgName{
    UIImageView *_ = [[UIImageView alloc]initWithImage:[UIImage imageNamed:imgName]];
    _.frame = frame;
    return _;
}

+ (instancetype)Frame:(CGRect)frame image:(UIImage*)image{
    UIImageView *_ = [[UIImageView alloc]initWithImage:image];
    _.frame = frame;
    return _;
}

+ (instancetype)Frame:(CGRect)frame mode:(UIViewContentMode)mode{
    UIImageView *_ = [[UIImageView alloc]initWithFrame:frame];
    _.contentMode = mode;
    //    [_ setContentScaleFactor:[[UIScreen mainScreen] scale]];
    //    _.contentMode = UIViewContentModeScaleAspectFill;
    //    _.clipsToBounds  = YES;
    return _;
}


/** 加个点击显示 放大图片 */
- (void)tapToshowImg{
    [self tapGesture:^(UIGestureRecognizer *Ges) {
        [XZShowImg showImgFrom:(UIImageView*)Ges.view];
    }];
}

@end
