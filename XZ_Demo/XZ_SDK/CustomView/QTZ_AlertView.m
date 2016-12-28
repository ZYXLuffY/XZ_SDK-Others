
#import "QTZ_AlertView.h"
#import "XZUtility.h"
#import "XZTextField.h"
//#import "OrderDetailMod.h"

@interface QTZ_AlertView (){
    UIView *_Ve_content;
    QTZ_AlertViewType _QTZ_AlertViewType;
}

@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *message;
@property (nonatomic,retain) NSMutableArray *Arr_btns;

@property (nonatomic,copy) void (^dialogViewCompleteHandle)(int index);
@property (nonatomic,copy) void (^BL_input)(NSString*money);
@property (nonatomic,copy) void (^BL_slider)(CGFloat value);

@property (nonatomic,strong) XZTextField *Tf_;
@property (nonatomic,strong) UISlider *Slider;

@end

@implementation QTZ_AlertView

-(void)dealloc{
    JIE1;
}

+ (void)Msg:(NSString *)message affirm:(void (^)())completeBlock{
    [[[QTZ_AlertView alloc]initWithTitle:@"提示" message:message Type:QTZ_AlertViewTypeNormal buttonTitles:@[@"取消",@"确认"]] showWithCompletion:^(int index) {
        if (index == 1) {
            if (completeBlock) { completeBlock();}
        }
    }];
}

/**  默认 输入金额 取消 确认 点击了index 1才回调  */
+ (void)MoneyInputMsg:(NSString *)message affirm:(void (^)(NSString *money))completeBlock{
    [[[QTZ_AlertView alloc]initWithTitle:@"" message:message Type:QTZ_AlertViewTypeMoney buttonTitles:@[@"取消",@"确认"]] inputCompletion:^(NSString *money) {
        if (completeBlock) { completeBlock(money);}
    }];
}

/**  当前行驶里程  上次保养里程 等*/
+ (void)MileageInputCurrent:(NSString*)Mileage title:(NSString*)title Affirm:(void (^)(NSString *Mileage))completeBlock{
    [[[QTZ_AlertView alloc]initWithTitle:Mileage message:title Type:QTZ_AlertViewTypeMileage buttonTitles:@[@"取消",@"确定"]] inputCompletion:^(NSString *money) {
        if (completeBlock) { completeBlock(money);}
    }];
}

/**  盒子插入 请输入当前行驶里程 半强制 等*/
+(void)MustInpuMileageInputAffirm:(void (^)(NSString *Mileage))completeBlock current:(NSString*)current{
    [[[QTZ_AlertView alloc]initWithTitle:current message:@"请输入当前行驶里程" Type:QTZ_AlertViewTypeMustInputMileage buttonTitles:@[@"确定"]] inputCompletion:^(NSString *money) {
        if (completeBlock) { completeBlock(money);}
    }];
}

/** 灵敏度设置的 */
+ (void)SliderSelectValue:(NSString*)value complete:(void (^)(CGFloat value))completeBlock{
    [[[QTZ_AlertView alloc]initWithTitle:@"灵敏度设置" message:value Type:QTZ_AlertViewTypeSlider buttonTitles: @[@"取消",@"切换"]] sliderCompletion:^(CGFloat value) {
        if (completeBlock) { completeBlock(value);}
    }];
}

/** 导航的 */
+ (void)MapSelect:(void (^)(NSInteger index))completeBlock{
    [[[QTZ_AlertView alloc]initWithTitle:@"请选择导航地图" message:nil Type:QTZ_AlertViewTypeMap buttonTitles: nil] showWithCompletion:^(int index) {
        if (completeBlock) { completeBlock(index);}
    }];
}

/** 核保信息 */
+ (void)ShowInsureInfo:(OrderListMod_insureConfirmInfo *)insureInfo affirm:(void (^)())completeBlock{
    [[[QTZ_AlertView alloc]initWithTitle:@"核保信息" message:(NSString *)insureInfo Type:QTZ_AlertViewTypeInsureInfo buttonTitles: @[@"取消",@"确定并支付"]] showWithCompletion:^(int index) {
        if (index == 1) {
            if (completeBlock) { completeBlock();}
        }
    }];
}

- (QTZ_AlertView*)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSArray *)otherButtonTitles{
    return [self initWithTitle:title message:message Type:QTZ_AlertViewTypeNormal buttonTitles:otherButtonTitles];
}

- (id)initWithTitle:(NSString *)title message:(NSString *)message Type:(QTZ_AlertViewType)type buttonTitles:(NSArray *)otherButtonTitles{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    
    //    UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    //    self = [super initWithEffect:effect];
    //    self.frame = [UIScreen mainScreen].bounds;
    
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5f];
        _QTZ_AlertViewType = type;
        _title = title;
        _message = message;
        _Arr_btns = [otherButtonTitles mutableCopy];
        
        [self setupContentView];
    }
    
    return self;
}

-(void)setupContentView{
    //内容视图 中间的框框
    [self addSubview:_Ve_content = ({
        UIView *_ = [[UIView alloc]initWithFrame:CGRectMake((ScreenWidth - 280)/2, 0, 280, 200)];
        _.clipsToBounds = YES;
        _.backgroundColor = [UIColor whiteColor];
        //        _.backgroundColor = kRGBA(240, 240, 240, 0.95);
        [_.layer setCornerRadius:13.0f];
        _;
    })];
    
    CGFloat topMargin = 18;
    //标题
    if (_title) {
        _La_title = [UILabel Frame:CGRectMake(0, topMargin, _Ve_content.width, 20) Title:_title Font:fontB(17) Color:HexColor(0x030303) Alignment:NSTextAlignmentCenter];
        [_Ve_content addSubview:_La_title];
    }
    
    //地图选择
    if (_QTZ_AlertViewType == QTZ_AlertViewTypeMap) {
        _La_title.font = [UIFont systemFontOfSize:15];
        _La_title.frame = CGRectMake(0, 0, _Ve_content.width, 45);
        _La_title.text = _title;
        
        NSArray *ArrTitle = @[@"百度地图",@"高德地图",@"腾讯地图"];
        NSArray *ArrIcon = @[@"baiduIcon.png",@"gaodeIcon.png",@"tencentIcon.png"];
        
        for (int i = 0; i< ArrTitle.count; i++) {
            XZButton *_ = [[XZButton alloc]initWithFrame:CGRectMake(-1, _La_title.bottom + i*55, _Ve_content.width + 2, 56) ImgF:CGRectMake(14, 12, 31, 31) TitF:CGRectMake(55, 18, 80, 20) Title:nil FontS:14 Color:nil imageName:nil Target:nil action:nil];
            [_ border:kColorDividing width:1];
            _.titleLabel.textAlignment = NSTextAlignmentLeft;
            [_ setTitle:ArrTitle[i] forState:UIControlStateNormal];
            [_ setTitleColor:kRGB(83.0,83.0 , 83.0) forState:UIControlStateNormal];
            [_ setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
            [_ setImage:[UIImage imageNamed:ArrIcon[i]] forState:UIControlStateNormal];
            _.tag = i;
            [_ addTarget:self action:@selector(MapClick:) forControlEvents:UIControlEventTouchUpInside];
            [_Ve_content addSubview:_];
            
        }
        
        _Ve_content.height = 240;
        _Ve_content.y = (ScreenHeight - _Ve_content.height)/2;
        
        WSELF
        [self tapGesture:^(UIGestureRecognizer *Ges) {
            [wself closeView];
        }];
        
        return;
    }
    
    if ([_message isKindOfClass:[NSString class]]) {
        //消息体
        _La_msg = [UILabel Frame:CGRectMake(17,(_title ? _La_title.bottom : topMargin )+ 18, _Ve_content.width - 17 * 2, 1) Title:_message FontS:13 Color:_La_title.textColor Alignment:NSTextAlignmentCenter];
        [_Ve_content addSubview:_La_msg];
        if ([_title isEqualToString:@"升级提示"]) {
            NSMutableAttributedString * attrStr = [[NSMutableAttributedString alloc] initWithData:[_message dataUsingEncoding:NSUnicodeStringEncoding] options:@{NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
            [attrStr addAttribute:NSForegroundColorAttributeName value:kColorText range:NSMakeRange(0,attrStr.length)];
            _La_msg.attributedText = attrStr;
        }else{
            [_La_msg paragraph:5];
        }
        
        _La_msg.height = [_La_msg sizeThatFits:CGSizeMake(_La_msg.width, 0)].height;
    }
    
    _Ve_content.height = _La_msg.height + 132;
    
    //核保信息
    if (_QTZ_AlertViewType == QTZ_AlertViewTypeInsureInfo){
//        OrderListMod_insureConfirmInfo *mod = (OrderListMod_insureConfirmInfo*)_message;
        UIScrollView *scr = [[UIScrollView alloc]initWithFrame:CGRectMake(0, _La_title.bottom + 15, _Ve_content.width, 0)];
        [_Ve_content addSubview:scr];
        __block CGFloat Y = 0;
        
        NSArray *insureConstArrs = @[@"交强险(车船税)",@"商业险"];
        [insureConstArrs enumerateObjectsUsingBlock:^(NSString *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            [scr addSubview:[UILabel Frame:CGRectMake(12, Y, scr.width/2 - 12, 17) Title:obj FontS:14 Color:kColorTextGray]];
            
//            [scr addSubview:[UILabel Frame:CGRectMake(scr.width/2 - 12, Y, scr.width/2, 17) Title:[@"￥" addStr:(idx == 0 ? mod.jqxPrice.F2f : mod.syxPrice.F2f)]  FontS:14 Color:kColorText Alignment:NSTextAlignmentRight]];
            Y += 30;
        }];
//        [scr addSubview:[UILabel Frame:CGRectMake(scr.width/2 - 12, Y, scr.width/2, 17) Title:[NSString stringWithFormat:@"保费总额：￥%@",mod.totalPrice.F2f] FontS:14 Color:kColorRed Alignment:NSTextAlignmentRight]];Y += 30;
        
        scr.height = Y > 220 ? 220 : Y;
        scr.contentSize = CGSizeMake(scr.width, Y);
        
        _Ve_content.height = scr.height + 100;
    }
    
    _Ve_content.y = (ScreenHeight - _Ve_content.height)/2;
    
    //灵敏度设置的
    if (_QTZ_AlertViewType == QTZ_AlertViewTypeSlider) {
        [_La_msg removeFromSuperview];
        _Ve_content.height = 160;
        [_Ve_content addSubview:[UILabel Frame:CGRectMake(17, _La_title.bottom + 5, _Ve_content.width - 17 * 2, 15) Title:@"灵敏度越高表示越容易提醒" FontS:11 Color:kColorBlue Alignment:NSTextAlignmentCenter]];
        [_Ve_content addSubview:( _Slider = [[UISlider alloc]initWithFrame:CGRectMake(38, _La_title.bottom + 22, _Ve_content.width - 38*2, 45)])];
        _Slider.minimumValue = ShakeMin;_Slider.maximumValue = ShakeMax;
        _Slider.value = [_message floatValue];
        _Slider.minimumTrackTintColor = kColorBlue;
        [_Slider addTarget:self action:@selector(SliderValueChange:) forControlEvents:UIControlEventValueChanged];
        [self SliderValueChange:_Slider];
        
        [_Ve_content addSubview:[UILabel Frame:CGRectMake(_Slider.x - 25, _Slider.centerY - 6, 20, 15) Title:@"低" FontS:10 Color:kColorText Alignment:NSTextAlignmentCenter]];
        [_Ve_content addSubview:[UILabel Frame:CGRectMake(_Slider.right + 5, _Slider.centerY - 6, 20, 15) Title:@"高" FontS:10 Color:kColorText Alignment:NSTextAlignmentCenter]];
    }
    
    //价格 XZTextField 或 有输入框的
    if (_QTZ_AlertViewType == QTZ_AlertViewTypeMoney || _QTZ_AlertViewType == QTZ_AlertViewTypeMileage || _QTZ_AlertViewType == QTZ_AlertViewTypeMustInputMileage) {
        
        _La_title.text = _message;
        _La_msg.font = font(12);
        [_La_msg paragraph:4 str:@"提供准确的里程，才能享受\n更好的服务哦"];
        
        _La_msg.height = [_La_msg sizeThatFits:CGSizeMake(_La_msg.width, 0)].height;
        _Ve_content.height = _La_msg.height + 168;
        
        _Ve_content.y = ScreenHeight*(iPhone6_PBigger ? 0.3 : 0.24);
        
        XZTextField *_ = [[XZTextField alloc]initWithFrame:CGRectMake((_Ve_content.width - 150)/2, _La_msg.bottom + 18, 150, 36)];
        _.font = [UIFont systemFontOfSize:17];
        _.textColor = kColorText;
        [_ border:kColorSeparator width:1];
        _.XZMaxTextLength = 8;
        
        if (_QTZ_AlertViewType == QTZ_AlertViewTypeMoney) {
            _.XZNumber_dot = YES;
        }else{
            _.XZNumber = YES;
        }
        _.delegate = (id<UITextFieldDelegate>)self;
        _.text = _title;
        [_Ve_content addSubview:_Tf_ = _];
        
        [_Ve_content addSubview:[UILabel Frame:CGRectMake(_.right - 35, _.y, 30, _.height) Title:@"km" FontS:17 Color:kColorBlue Alignment:NSTextAlignmentRight]];
        
        WSELF
        [self tapGesture:^(UIGestureRecognizer *Ges) {
            [wself endEditing:YES];
        }];
        
        [_ becomeFirstResponder];
    }
    
    CGFloat BtnH = 44;
    NSAssert(_Arr_btns.count <= 2, @"最多两个");
    for (int i = 0; i < _Arr_btns.count; i++) {
        UIButton *_ = [[UIButton alloc]initWithFrame:CGRectMake(i*(_Ve_content.width/2), _Ve_content.height - BtnH , (_Ve_content.width/2), BtnH)];
        [_.titleLabel setFont:fontM(17)];
        [_ setTitle:[_Arr_btns objectAtIndex:i] forState:UIControlStateNormal];
        [_ setTitleColor:i ? kColorBlue : kColorText forState:UIControlStateNormal];
        [_ setBackClickImg:_Ve_content.backgroundColor];
        [_ setBackClickImg_h:[_Ve_content.backgroundColor XZ_Abe:0.9 Alpha:0.9]];
        [_ addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        _.tag = i;
        
        if (_Arr_btns.count == 1) {
            _.width = _Ve_content.width;
            _.tag = 1;
            [_ setTitleColor:kColorBlue forState:UIControlStateNormal];//kColorBlue kColorDeepBlue
        }
        if ([_title isEqualToString:@"退出登录"]) {
            [_ setTitleColor:i ? kColorText : kColorRed forState:UIControlStateNormal];
        }
        [_Ve_content addSubview:_];
    }
    
    //两条线
    [_Ve_content.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(0, _Ve_content.height - BtnH) To:CGPointMake(_Ve_content.width, _Ve_content.height - BtnH) color:kColorSeparator]];
    if (_Arr_btns.count == 2) {
        [_Ve_content.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(_Ve_content.width/2, _Ve_content.height - BtnH + 0) To:CGPointMake(_Ve_content.width/2, _Ve_content.height - 0) color:kColorSeparator]];
    } 
    
}

/** 点击按钮事件 */
-(void)buttonAction:(UIButton *)sender{
    [self endEditing:YES];
    NSInteger selIndex = sender.tag;
    if(_dialogViewCompleteHandle)  {
        _dialogViewCompleteHandle((int)selIndex);
    }
    if (_BL_input && sender.tag == 1) {
        _BL_input(_Tf_.text);
    }
    if (_BL_slider && sender.tag == 1) {
        _BL_slider(_Slider.value);
    }
    
    [self closeView];
}


-(void)inputCompletion:(void (^)(NSString *money))completeBlock{
    [self Showin:XZApp.window];
    _BL_input = completeBlock;
}

- (void)SliderValueChange:(UISlider*)sender{
    sender.minimumTrackTintColor = kColorGreen;
    if (sender.value < (ShakeMax - ShakeMin)*0.33) {
        
    }else if (sender.value > (ShakeMax - ShakeMin)*0.66){
        sender.minimumTrackTintColor = kColorRed;
    }else{
        sender.minimumTrackTintColor = kColorOrange;
    }
}

-(void)sliderCompletion:(void (^)(CGFloat value))completeBlock{
    [self Showin:XZApp.window];
    _BL_slider = completeBlock;
}


/** 显示弹出框 */
-(void)showWithCompletion:(void (^)(int index))completeBlock{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self Showin:XZApp.window];
    });
    _dialogViewCompleteHandle = completeBlock;
}



-(void)Showin:(UIView*)baseView{
    [baseView addSubview:self];
    self.alpha = 0.1;
    
    _Ve_content.alpha = 0;
    _Ve_content.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration:0.25f animations:^{
        _Ve_content.alpha = 1.0;
        self.alpha = 1.0;
        _Ve_content.transform = CGAffineTransformMakeScale(1.0, 1.0);
    }];
}

/** 关闭视图 */
-(void)closeView{
    [UIView animateWithDuration:0.25f animations:^{
        _Ve_content.alpha = 0;
        self.alpha = 0;
        //        _Ve_content.transform = CGAffineTransformMakeScale(0.01, 0.01);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
    
    [XZHandleCommon share].isShowAlterView = NO;
}

#pragma mark  textField  < iOS8
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [(XZTextField*)textField textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self buttonAction:[self viewWithTag:1]];
    return YES;
}

#pragma mark -

-(void)MapClick:(UIButton*)sender{
    if(_dialogViewCompleteHandle)  {
        _dialogViewCompleteHandle((int)sender.tag);
    }
    [self closeView];
}


@end
