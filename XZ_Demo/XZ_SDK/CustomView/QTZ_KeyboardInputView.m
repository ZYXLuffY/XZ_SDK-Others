
#import "QTZ_KeyboardInputView.h"
#import "XZUtility.h"
#import "XZButton.h"


#pragma mark - ================== @interface QTZ_KeyboardInputView ()

@interface QTZ_KeyboardInputView ()
{
    NSString *currentleftDes;
    //    QTZkeyboarViewType
}
@property (nonatomic,weak) UITextField *Tf_quote;/**< 引用的 */
@property (nonatomic,copy) NSString *Str_tfSuffix;/**< 固定后缀 */

@property (nonatomic,copy) dateBlock Block_date;

@end

@implementation QTZ_KeyboardInputView

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    JIE1;
}


- (instancetype)initWithTf:(UITextField*)tf viewH:(CGFloat)selfHeight leftDes:(NSString*)leftDes arrowX:(CGFloat)arrowX type:(QTZkeyboarViewType)type date:(dateBlock)dateBlock{
    self = [super initWithFrame:CGRectMake(0, 0, ScreenWidth, selfHeight)];
    currentleftDes = leftDes;
    _Tf_quote = tf;
    _Block_date = dateBlock;
    
    CGFloat labelHeight = 44;
    CGFloat eachW = 0.0,eachH = 0.0;
    
    UIView *keyView = [[UIView alloc]initWithFrame:CGRectMake(0, (selfHeight - 0), ScreenWidth, 0)];
    keyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:keyView];
    
    switch (type) {
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case QTZkeyboarViewTypeNumber:{
            keyView.height = 260 - (labelHeight = 44);
            keyView.y = (selfHeight - keyView.height);
            eachW = self.width/3;
            eachH = keyView.height/4;
            
            
            NSArray *titles = @[@[@"1",@"2",@"3"],@[@"4",@"5",@"6"],@[@"7",@"8",@"9"],@[@"",@"0",@""]];
            for (int i = 0; i < 4; i++) {
                for (int j = 0; j < 3; j++) {
                    UIButton *_ = [UIButton Frame:CGRectMake(j*eachW, eachH*i, eachW, eachH) Title:titles[i][j] FontS:24 Color:kColorText radius:0 Target:self action:@selector(NumberClick:) Bimg:nil];
                    [_ setBackgroundImage:[UIImage XZ_ColoreImage:kRGBA(216, 216, 216, 1)] forState:UIControlStateHighlighted];
                    [_ setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
                    
                    if (i == 3 && j == 2) {
                        [_ setImage:[UIImage imageNamed:@"M1_kreepkeyboardDel_black"] forState:UIControlStateNormal];
                        [_ setImage:[UIImage imageNamed:@"M1_kreepkeyboardDel"] forState:UIControlStateHighlighted];
                    }
                    
                    [keyView addSubview:_];
                    
                    if (j == 0) { [keyView.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(0, _.y) To:CGPointMake(self.width, _.y) color:kColorDividing]];//4条横线
                    }if (i == 0 && j <= 1) {[keyView.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(_.right, _.y) To:CGPointMake(_.right, keyView.height) color:kColorDividing]];//2条竖线
                    }if (i == 3 && j == 0) { _.userInteractionEnabled = NO;}
                }
            }
            
        }break;
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case QTZkeyboarViewTypeDatePicker:{
            keyView.height = 216;
            keyView.y = (selfHeight - keyView.height);
            
            UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0 ,0,ScreenWidth, keyView.height)];
            datePicker.backgroundColor = [UIColor whiteColor];
            datePicker.datePickerMode = UIDatePickerModeDate;
            datePicker.maximumDate = [NSDate date];
            [keyView addSubview:(_datePicker = datePicker)];
            
            [keyView.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(0, 0) To:CGPointMake(self.width,0) color:kColorDividing]];
            
        }break;
            
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case QTZkeyboarViewTypeCarAddress:{
            NSArray *PlateArr = @[@"京",@"沪",@"浙",@"苏",@"粤",@"鲁",@"晋",@"冀",@"豫",@"川",@"渝",@"辽",@"吉",@"黑",@"皖",@"鄂",@"湘",@"赣",@"闽",@"陕",@"甘",@"宁",@"蒙",@"津",@"贵",@"云",@"桂",@"琼",@"青",@"新",@"藏",@"港",@"澳"];
            
            keyView.height = 270;
            keyView.y = (selfHeight - keyView.height);
            
            eachW = ScreenWidth/7;
            eachH = keyView.height/(((int)PlateArr.count/7)+1);
            labelHeight = 0;
            
            CGFloat X = 0.0,Y = 0.0;
            UIImage *image = [UIImage XZ_ColoreImage:kColorBlue];
            
            for (int i = 1; i < 7; i++) {
                [keyView.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(i*eachW, 0) To:CGPointMake(i*eachW, keyView.height) color:kColorDividing]];
            }
            for (int i = 0; i < (((int)PlateArr.count/7)+1); i++) {
                [keyView.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(0, i*eachH) To:CGPointMake(keyView.width, i*eachH) color:kColorDividing]];
            }
            
            for (NSString*str in PlateArr) {
                UIButton *btn = [UIButton Frame:CGRectMake(X, Y, eachW, eachH) Title:str FontS:21 Color:kColorText radius:0 Target:self action:@selector(CarAddressClick:) Bimg:nil];
                X += eachW;
                if (X >= ScreenWidth + 10) {
                    X = 0; Y += eachH;
                    btn.frame = CGRectMake(X, Y, eachW, eachH);X += eachW;
                }
                [btn setBackgroundImage:image forState:UIControlStateHighlighted];
                [keyView addSubview:btn];
            }
        }break;
            
            
            ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
        case QTZkeyboarViewTypeCarPlate:{
            keyView.height = 216;
            keyView.y = (selfHeight - keyView.height);
            
            // 35 31 6 36*3  36
            UIColor *backCol = [UIColor whiteColor];
            keyView.backgroundColor = backCol;
            NSArray *heights = @[@(42),@(39),@(6),@(43)];
            CGFloat Y = 0;
            NSArray *titles1 = @[@"港",@"澳",@"学",@"警",@"领"];
            //            eachW = self.width/titles1.count;
            labelHeight = 44;
            NSArray *titles2 = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"0"];
            //            NSArray *titles3 = @[@[@"Q",@"W",@"E",@"R",@"T",@"Y",@"U",@"I",@"O"],@[@"A",@"S",@"D",@"F",@"G",@"H",@"J",@"K",@"P"],@[@"Z",@"X",@"C",@"V",@"B",@"N",@"M",@"L",@"删除"]];
            
            NSArray *titles3 = @[@[@"A",@"B",@"C",@"D",@"E",@"F",@"G",@"H",@"J"],@[@"K",@"L",@"M",@"N",@"P",@"Q",@"R",@"S",@"T"],@[@"U",@"V",@"W",@"X",@"Y",@"Z",@"",@"删除",@""]];
            
            [titles1 enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [UIButton Frame:CGRectMake(idx*((self.width+2)/titles1.count)-1, Y, ((self.width+2)/titles1.count), [heights[0] floatValue]) Title:str FontS:21 Color:kColorText radius:0 Target:self action:@selector(textTitleClick:) Bimg:backCol];
                [btn border:kColorDividing width:0.5];
                [keyView addSubview:btn];
            }];
            
            Y += [heights[0] floatValue];
            [titles2 enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx, BOOL * _Nonnull stop) {
                UIButton *btn = [UIButton Frame:CGRectMake(idx*((self.width+2)/titles2.count)-1, Y, ((self.width+2)/titles2.count), [heights[1] floatValue]) Title:str FontS:21 Color:kColorText radius:0 Target:self action:@selector(textTitleClick:) Bimg:backCol];
                [btn border:kColorDividing width:0.5];
                [keyView addSubview:btn];
            }];
            
            Y += ([heights[1] floatValue] + [heights[2] floatValue]);
            
            [titles3 enumerateObjectsUsingBlock:^(NSArray *Arr1, NSUInteger idx1, BOOL * _Nonnull stop) {
                [Arr1 enumerateObjectsUsingBlock:^(NSString *str, NSUInteger idx2, BOOL * _Nonnull stop) {
                    UIButton *btn = [UIButton Frame:CGRectMake(idx2*((self.width+2)/Arr1.count)-1, Y + idx1*[heights[3] floatValue], ((self.width+2)/Arr1.count), [heights[3] floatValue]) Title:str FontS:21 Color:kColorText radius:0 Target:self action:@selector(textTitleClick:) Bimg:backCol];
                    [btn border:kColorDividing width:0.5];
                    [keyView addSubview:btn];
                    if (str.length == 0) {
                        btn.userInteractionEnabled = NO;
                    }
                    if ([str isEqualToString:@"删除"]) {
                        btn.width = btn.width*2;
                        [btn setTitle:nil forState:UIControlStateNormal];
                        [btn setImage:[UIImage imageNamed:@"M1_kreepkeyboardDel_black"] forState:UIControlStateNormal];
                        *stop = YES;
                    }
                }];
            }];
        }break;
            
            
            
        default:
            break;
    }
    
    if (selfHeight - keyView.height > 0) {
        //背景灰色
        UIView *topBackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width,selfHeight - keyView.height)];//上面剩余的地方填充灰色
        topBackView.backgroundColor = kRGBA(0, 0, 0, 0.38);
        [self addSubview:topBackView];
        WSELF
        [topBackView tapGesture:^(UIGestureRecognizer *Ges) {
            [wself.Tf_quote resignFirstResponder];
        }];
    }
    
    if (labelHeight != 0) {
        UIView *whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, selfHeight - keyView.height - labelHeight, ScreenWidth, labelHeight)];
        whiteView.backgroundColor = keyView.backgroundColor;
        if (leftDes) {
            [whiteView addSubview:[UILabel Frame:CGRectMake(12, 0, self.width*0.6, whiteView.height) Title:leftDes FontS:16 Color:kColorText]];
        }
        
        NSString *title = @"确定";//@"完成" @"验证"
        if (leftDes && [leftDes rangeOfString:@"验证"].length) {
            title = @"验证";
        }
        
        UIButton *done = [UIButton Frame:CGRectMake(ScreenWidth - 60, 0, 60, whiteView.height) Title:title FontS:18 Color:kColorBlue radius:0 Target:self action:@selector(sureClick:) Bimg:nil];
        [whiteView addSubview:done];
        [self addSubview:whiteView];
    }
    
    
    //    if (type == QTZkeyboarViewTypeCarAddress || type == QTZkeyboarViewTypeCarPlate) {
    //        UIBezierPath *path = [UIBezierPath bezierPath];
    //        [path moveToPoint:CGPointMake(eachW*4, whiteView.height)];
    //        [path addLineToPoint:CGPointMake(eachW*4+eachW*0.3, 0)];
    //        [path addLineToPoint:CGPointMake(whiteView.width, 0)];
    //        [path addLineToPoint:CGPointMake(whiteView.width, whiteView.height)];
    //        [path addLineToPoint:CGPointMake(eachW*4, whiteView.height)];
    //        [path closePath];
    //
    //        CAShapeLayer *layer = [CAShapeLayer layer];
    //        layer.path = path.CGPath;
    //        whiteView.layer.mask = layer;
    //    }
    
    //一个小箭头
    if (arrowX > 0 && (selfHeight - keyView.height - labelHeight > 0)) {
        UIImageView *Img_Arrow = [[UIImageView alloc]initWithFrame:CGRectMake(arrowX, 0, 12, 9)];
        Img_Arrow.image = [UIImage imageNamed:@"M1_kreepPointArrow"];
        [self addSubview:Img_Arrow];
    }
    
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QTZ_KeyboardInputViewkeyboardWillShow) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(QTZ_KeyboardInputViewkeyboardWillShow) name:UIKeyboardDidShowNotification object:nil];
    
    return self;
}


- (void)QTZ_KeyboardInputViewkeyboardWillShow {
    if (![_Tf_quote isFirstResponder]) {
        return;
    }
    UIView *peripheralHostView = [[[[[UIApplication sharedApplication] windows] lastObject] subviews] lastObject];
    for (UIView *view in peripheralHostView.subviews) {
        for (UIView *view2 in view.subviews) {
            if ([view2 isKindOfClass:NSClassFromString(@"UIKBInputBackdropView")]) {
                [[view2 layer] setOpacity:0];
            }
        }
    }
}

#pragma mark - 数字键盘点击
- (void)NumberClick:(UIButton*)sender{
    //输入12位服务验证码的
    if ([currentleftDes rangeOfString:@"验证"].length) {
        if (_Tf_quote.text.DelSpace.length >= 12 && sender.currentTitle.length != 0) {
            return;
        }
        [_Tf_quote changetext:sender.currentTitle];
        if (sender.currentTitle.length == 0) {//可能连带空格删掉
            if (_Tf_quote.text.length >=4 && [[_Tf_quote.text substringFromIndex:_Tf_quote.text.length - 1] isEqualToString:@" "]) {
                [_Tf_quote changetext:sender.currentTitle];
            }
            return;
        }
        NSMutableString *Str = [NSMutableString stringWithString:_Tf_quote.text.DelSpace];
        if (Str.length >= 4) {[Str insertString:@" " atIndex:4];}
        if (Str.length >= 9) {[Str insertString:@" " atIndex:9];}
        _Tf_quote.text = Str;
        
        return;
    }
    if ([currentleftDes rangeOfString:@"里程"].length) {
        if ([_Tf_quote.text stringByReplacingOccurrencesOfString:QTZ_KeyboardInputViewTF_Km withString:@""].length == 0 && [sender.currentTitle integerValue] == 0) {
            return;//第一位数不要0 啊
        }
    }
    
    
    
    if (_Tf_quote.text.length >= 7 + 2 && sender.currentTitle.length != 0) {
        return;
    }
    if ([_Tf_quote.text stringByReplacingOccurrencesOfString:_Str_tfSuffix ? : @"" withString:@""].length == 0 && [sender.currentTitle isEqualToString:@"0"]) {
        return;
    }
    [_Tf_quote changetext:sender.currentTitle];
    
}

#pragma mark - 车牌省市区前缀点击
- (void)CarAddressClick:(UIButton*)sender{
    _Tf_quote.text = nil;
    [_Tf_quote changetext:sender.currentTitle];
    Block_Exec(_Block_date,_datePicker ? _datePicker.date : [NSDate date]);
}

#pragma mark - CarPlate 文本点击
- (void)textTitleClick:(UIButton*)sender{
    NSString *changeStr = sender.currentTitle;
    if (changeStr !=nil && changeStr.length == 0) {//@""
        return;
    }
    
    if (_Tf_quote.text.length >= 6 && changeStr.length != 0) {//6 7
        return;
    }
    
    NSArray *arr = @[@"港",@"澳",@"学",@"警",@"领"];
    if ([arr containsObject:changeStr]) {//要写 @[@"港",@"澳",@"学",@"警",@"领"]  有其中一个不许继续加了
        for (NSString *each in arr) {
            if ([_Tf_quote.text rangeOfString:each].length) {
                return;
            }
        }
        _Tf_quote.text = [NSString stringWithFormat:@"%@%@%@",_Tf_quote.text,changeStr,@" "];
        [_Tf_quote changetext:@""];return;
    }
    
    for (NSString *each in arr) {
        NSRange rang = [_Tf_quote.text rangeOfString:each];
        if (rang.length) {
            if (changeStr != nil) {
                [_Tf_quote setSelectedRange:NSMakeRange(rang.location, 0)];break;
            }
        }
    }
    
    if (changeStr == nil && _Tf_quote.text.length == 2) {
        for (NSString *each in arr) {
            NSRange rang = [_Tf_quote.text rangeOfString:each];
            if (rang.length) {
                [_Tf_quote changetext:changeStr];
                [_Tf_quote setSelectedRange:NSMakeRange(_Tf_quote.text.length, 0)];return;
            }
        }
    }
    
    [_Tf_quote changetext:changeStr];
}

#pragma mark - 确定 验证
- (void)sureClick:(UIButton*)sender{
    [_Tf_quote endEditing:YES];
    Block_Exec(_Block_date,_datePicker ? _datePicker.date : [NSDate date]);
    
}




@end

