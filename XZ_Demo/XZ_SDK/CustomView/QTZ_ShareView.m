
#import "QTZ_ShareView.h"
#import "XZUtility.h"
#import "XZButton.h"
#import <QuartzCore/QuartzCore.h>
//#import "WXApi.h"
#import "QTZ_AlertView.h"
//#import "TencentOpenAPI/QQApiInterface.h"
//#import <TencentOpenAPI/TencentOAuth.h>
//#import "WeiboSDK.h"
#import "XZDebugTool__.h"

const static CGFloat AnimateDuration  = 0.25;/**< 动画时间 */
#define contentHeight   174

@interface QTZ_ShareView (){
    UIView *BackView;
    
    UIView *V_Content;
    
    NSString *_title;
    NSString *_content;
    NSString *_Url;
    NSString *_icon;
    
    UIView *Ve_shareCaptureView;
    QTZShareViewType _shareType;
}
@end

@implementation QTZ_ShareView

-(void)dealloc{
    JIE1;
}

+(void)ShareViewType:(QTZShareViewType)viewType codeType:(QTZShareCodeType)codeType captureView:(UIView *)captureView URLParam:(NSDictionary*)URLParam netParam:(NSDictionary*)netParam block:(UMSocialRequestCompletionHandler)block{
    NSString *shareCode = @{@(QTZShareCodeTypeWXDF) : @"WXDF",@(QTZShareCodeTypeQDHD) : @"QDHD",@(QTZShareCodeTypeWDZJ) : @"WDZJ",@(QTZShareCodeTypeCJBG) : @"CJBG",
                            @(QTZShareCodeTypeQMBG) : @"QMBG",@(QTZShareCodeTypeACWZ) : @"ACWZ",@(QTZShareCodeTypeQTZJS) : @"QTZJS",@(QTZShareCodeTypeQTZCYQ) : @"QTZCYQ"}[@(codeType)];
    
    NSMutableDictionary *param = [NSMutableDictionary dictionaryWithDictionary:netParam];
    [param setValue:shareCode forKey:@"shareCode"];
    
    [XZApp.window.rootViewController POST:API_getShareInfo HudParam:param Suc:^(NSDictionary *Res) {
        if (Res == nil) { return ;}
        
        //基本参数
        NSMutableDictionary *shareParam = [@{@"type" : @"ios",
                                             @"token" : ([USDF stringForKey:UserDef_Tmbj_Token] ? : @""),
                                             @"versionCode" : Tmbj_code,
                                             @"tmbj-mobile-code" : [UIDevice currentDevice].identifierForVendor.UUIDString,
                                             @"use_latAndlng": [NSString stringWithFormat:@"%f,%f",XZApp.APPLocation.coordinate.latitude,XZApp.APPLocation.coordinate.longitude],
                                             @"tmbj_city_id":[NSString stringWithFormat:@"%ld",(long)XZApp.tmbj_cityId]} mutableCopy];
        //可能的附加参数
        [URLParam enumerateKeysAndObjectsUsingBlock:^(NSString  * key, NSString  * obj, BOOL * _Nonnull stop) {
            [shareParam setValue:obj forKey:key];
        }];
        
        NSString *shareURL = [NSString URLWithBaseString:[Res str:@"url"] parameters:shareParam];
        [[XZDebugTool__ Shared] addDicLog:@{@"urlstr" : shareURL} Param:@{} API:@"构建的分享链接"];
        
        [XZApp.window addSubview:[[QTZ_ShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:[Res str:@"title"] content:[Res str:@"content"] url:shareURL icon:[Res str:@"icon"] captureView:captureView type:viewType block:block]];
    }];
    
}

+(void)ShareTitle:(NSString*)title content:(NSString*)content url:(NSString*)Url type:(QTZShareViewType)type icon:(NSString *)icon captureView:(UIView *)captureView block:(UMSocialRequestCompletionHandler)block{
    [XZApp.window addSubview:[[QTZ_ShareView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) title:title content:content url:Url icon:icon captureView:captureView type:type block:block]];
}

-(instancetype)initWithFrame:(CGRect)frame title:(NSString*)title content:(NSString*)content url:(NSString*)Url icon:(NSString *)icon captureView:(UIView *)captureView type:(QTZShareViewType)type block:(UMSocialRequestCompletionHandler)block{
    self = [super initWithFrame:frame];
    if (self) {
        _title = title;
        _content = content;
        _Url = Url;
        _shareType = type;
        _icon = icon;
        Ve_shareCaptureView = captureView;
        _completion = block;
        [self BaseSetup];
    }
    return self;
}

-(void)BaseSetup{
    self.alpha = 0;
    self.backgroundColor = kRGBA(0, 0, 0, 0.5);
    
    //隐藏的点击背景
    BackView = [[UIView alloc]initWithFrame:self.bounds];
    [self addSubview:BackView];
    
    //有截图过来的
    if (Ve_shareCaptureView) {
        Ve_shareCaptureView.x = (ScreenWidth - Ve_shareCaptureView.width)/2;
        Ve_shareCaptureView.y = (ScreenHeight - contentHeight - Ve_shareCaptureView.height)/2;
        [BackView addSubview:Ve_shareCaptureView];
    }
    
    [BackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(HideView)]];
    [self UI_ShareView];
    
    [self ShowView];
    
}

/** 显示 */
-(void)ShowView{
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 1;
        V_Content.y = V_Content.y - contentHeight;
    }];
}

/** 隐藏 销毁 */
-(void)HideView{
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 0;
        V_Content.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [BackView removeFromSuperview];
    }];
}

#pragma mark - UI

-(void)shareButtonClick:(UIButton*)btn{
    [self HideView];
    NSInteger index = btn.tag;
    
    if (_Url.length == 0) {
        _Url = bojueWebSide;
    }
    
    if (index == 4) {//微博 特殊搞
//        WBMessageObject *message = [WBMessageObject message];
//        WBWebpageObject *webpage = [WBWebpageObject object];
//        webpage.objectID = @"";
//        webpage.title = _title;
//        webpage.description = _content;
//        webpage.thumbnailData = UIImageJPEGRepresentation([UIImage imageNamed:@"shareIcon"], 0.5);
//        webpage.webpageUrl = _Url;
//        message.mediaObject = webpage;
//        
//        [WeiboSDK sendRequest:[WBSendMessageToWeiboRequest requestWithMessage:message]];
        
        return;
    }
    
//    NSArray  *shareTypes = @[@(UMSocialPlatformType_WechatSession),@(UMSocialPlatformType_WechatTimeLine),@(UMSocialPlatformType_QQ),@(UMSocialPlatformType_Qzone),@(UMSocialPlatformType_Sina)];
//    UMSocialMessageObject *msgObj = [UMSocialMessageObject messageObject];
//    msgObj.title = _title;
//    msgObj.text = _content;
//    
//    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:_title descr:_content thumImage:_icon.length > 0 ? _icon : [UIImage imageNamed:@"shareIcon"]];
//    shareObject.webpageUrl = _Url;
//    msgObj.shareObject = shareObject;
//    
//    if (index == 0 || index == 1) {
//        if ((![WXApi isWXAppSupportApi] || ![WXApi isWXAppInstalled])) {
//            [[[QTZ_AlertView alloc]initWithTitle:@"提示" message:@"无法分享到微信" buttonTitles:@[@"好的"]] showWithCompletion:nil];
//            return;
//        }
//    }else if (index == 2 || index == 3) {
//        if (![TencentOAuth  iphoneQQInstalled]) {
//            [[[QTZ_AlertView alloc]initWithTitle:@"提示" message:@"无法分享到QQ" buttonTitles:@[@"好的"]] showWithCompletion:nil];
//            return;
//        }
//    }
    
//    [[UMSocialManager defaultManager] shareToPlatform:(UMSocialPlatformType)[shareTypes[index] integerValue] messageObject:msgObj currentViewController:nil completion:^(id result, NSError *error) {
//        if (error) {
//            UMSocialLogInfo(@"************Share fail with error %@*********",error);
//        }else{
//            Block_Exec(_completion,result,error);
//        }
//    }];
    
}

+ (void)shareToWeixin:(NSString*)Url title:(NSString*)title content:(NSString*)content {
//    if ((![WXApi isWXAppSupportApi] || ![WXApi isWXAppInstalled])) {
//        [[[QTZ_AlertView alloc]initWithTitle:@"提示" message:@"无法分享到微信" buttonTitles:@[@"好的"]] showWithCompletion:nil];
//        return;
//    }
//    
//    WXMediaMessage *message = [WXMediaMessage message];
//    message.title = title;
//    message.description = content;
//    [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
//    WXWebpageObject *ext = [WXWebpageObject object];
//    
//    ext.webpageUrl =  Url;
//    
//    message.mediaObject = ext;
//    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
//    req.bText = NO;
//    req.message = message;
//    req.scene = WXSceneSession;
//    [WXApi sendReq:req];
    
}


-(void)UI_ShareView{
    NSArray *titleArr = [NSArray arrayWithObjects:@"微信好友",@"朋友圈", @"QQ好友",@"QQ空间", @"新浪微博",nil];
    NSArray *imgNames = [NSArray arrayWithObjects:@"weixin",@"pengyouquan",@"qqhaoyou",@"qqkongjian",@"weibo",nil];
    
    [self addSubview:V_Content = [UIView Frame:CGRectMake(0,ScreenHeight,ScreenWidth, contentHeight) color:[UIColor whiteColor]]];
    
    CGFloat margin = 15;
    CGFloat itemViewWH = ((ScreenWidth - (titleArr.count + 1)*margin) / titleArr.count)*1;
    
    if (_shareType == QTZShareViewTypeWXQQ) {
        titleArr = [NSArray arrayWithObjects:@"微信好友", @"QQ好友",nil];
        imgNames = [NSArray arrayWithObjects:@"weixin",@"qqhaoyou",nil];
        itemViewWH = 54;
    }
    
    for (int i = 0; i < titleArr.count; i++) {
        XZButton *Btn = [[XZButton alloc]initWithFrame:CGRectMake((margin + (margin + itemViewWH) * i), 25, itemViewWH, itemViewWH + 20) ImgF:CGRectMake((itemViewWH - 44)/2, 0, 44, 44) TitF:CGRectMake(0, itemViewWH + 3, itemViewWH, 20) Title:nil FontS:13 Color:nil imageName:nil Target:nil action:nil];
        Btn.tag = i;
        Btn.titleLabel.textAlignment = NSTextAlignmentCenter;
        Btn.titleLabel.adjustsFontSizeToFitWidth = YES;
        Btn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
        if (_shareType == QTZShareViewTypeWXQQ && i == 1) { Btn.tag = 2;}
        [Btn setTitleColor:kColorTextGray forState:UIControlStateNormal];
        [Btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [Btn setTitle:titleArr[i] forState:UIControlStateNormal];
        [Btn setImage:[UIImage imageNamed:imgNames[i]] forState:UIControlStateNormal];
        [Btn addTarget:self action:@selector(shareButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        [V_Content addSubview:Btn];
    }
    [V_Content.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(29, contentHeight - 50) To:CGPointMake(V_Content.width - 29, contentHeight - 50) color:kColorSeparator]];
    UIButton *cancleBtn = [UIButton Frame:CGRectMake(0, contentHeight - 50, self.width, 50) Title:@"取消" FontS:17 Color:kColorText radius:0 Target:self action:@selector(HideView) Bimg:[UIColor whiteColor]];
    cancleBtn.titleLabel.font = [ UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [cancleBtn setBackClickImg_h:[[UIColor whiteColor] XZ_Abe:0.9 Alpha:0.9]];
    
    [V_Content addSubview:cancleBtn];
}

@end
