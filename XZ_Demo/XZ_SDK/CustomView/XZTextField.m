
#import "XZTextField.h"
#import "NSString+XZ.h"
#import <objc/runtime.h>
#import "XZUtility.h"

static const char *PlaceLabel = "PlaceLabel";

@interface XZTextField ()

@property (nonatomic,strong) UIButton *V_alpha;/**< 编辑的时候不允许点击 覆盖个透明的view */

@end

@implementation XZTextField

//    [self setValue:[UIFont boldSystemFontOfSize:12] forKeyPath:@"_placeholderLabel.font"];
-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.returnKeyType = UIReturnKeyDone;
        [self setValue:kColorText99 forKeyPath:@"_placeholderLabel.textColor"];
        self.delegate = (id<UITextFieldDelegate>)self;//   > iOS 8.0
    }
    return self;
}


//添加边界 点击范围
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent*)event{
    CGRect bouds = CGRectMake(self.bounds.origin.x - _moreTouchMargin.origin.x,
                              self.bounds.origin.y - _moreTouchMargin.origin.y,
                              self.bounds.size.width + _moreTouchMargin.size.width + _moreTouchMargin.origin.x,
                              self.bounds.size.height + _moreTouchMargin.size.height + _moreTouchMargin.origin.y);
    BOOL contain = CGRectContainsPoint(bouds,point);
    return contain;
}

-(void)awakeFromNib{
    [super awakeFromNib];
    self.returnKeyType = UIReturnKeyDone;
    [self setValue:kColorText99 forKeyPath:@"_placeholderLabel.textColor"];
    if (self.delegate == nil) {
        self.delegate = (id<UITextFieldDelegate>)self;//   > iOS 8.0
    }
}

- (CGRect)editingRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , 12 , 0 );
}

- (CGRect)textRectForBounds:(CGRect)bounds{
    return CGRectInset(bounds , 12 , 0 );
}


-(UILabel*)placeHolderLabel{
    return objc_getAssociatedObject(self, PlaceLabel);
}

-(void)setPlaceHolderLabel:(UILabel *)placeHolderLabel{
    objc_setAssociatedObject(self, PlaceLabel, placeHolderLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)addRightPlaceHolder:(NSString *)placeHolder{
    CGFloat W =  [placeHolder __W__:12 H:20];
    UILabel *La = [[UILabel alloc]initWithFrame:CGRectMake(self.frame.size.width - W - 8,0, W, self.frame.size.height)];
    La.text = placeHolder;
    La.textColor = [UIColor lightGrayColor];
    La.font =  [UIFont systemFontOfSize:12];
    [self addSubview:La];
    [self setPlaceHolderLabel:La];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidChangeNotification object:self];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(TextFieldChange) name:UITextFieldTextDidEndEditingNotification object:self];
}

-(void)TextFieldChange{
    [self placeHolderLabel].hidden = self.text.length;
}





//认为是电话号码 按电话号码的限制输入
-(void)setXZTelePhone:(BOOL)XZTelePhone{
    _XZTelePhone = XZTelePhone;
    self.keyboardType = UIKeyboardTypePhonePad;
}

/** 每隔X 分割一个空格 */
-(void)setXZDivision:(NSUInteger)XZDivision{
    _XZDivision = XZDivision;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
}

//纯数字形式的输入
-(void)setXZNumber:(BOOL)XZNumber{
    _XZNumber = XZNumber;
    self.keyboardType = UIKeyboardTypeNumberPad;
}
//数字形式的输入 可以有小数点 点后最多两位数
-(void)setXZNumber_dot:(BOOL)XZNumber_dot{
    _XZNumber_dot = XZNumber_dot;
    self.keyboardType = UIKeyboardTypeDecimalPad;
}


//限制特殊字符的输入
-(void)setXZDisableSpecialChat:(BOOL)XZDisableSpecialChat{
    _XZDisableSpecialChat = XZDisableSpecialChat;
}

//必须是 ASCII字符
-(void)setXZMust_ASCII:(BOOL)XZMust_ASCII{
    _XZMust_ASCII = XZMust_ASCII;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

//必须是 字母和数字
-(void)setXZMust_AZ09:(BOOL)XZMust_AZ09{
    _XZMust_AZ09 = XZMust_AZ09;
    self.keyboardType = UIKeyboardTypeASCIICapable;
}

//强制按字符长度计算限制文本的最大长度 (一个中文算两个字符！) 加强判断 设另个为0
-(void)setXZMaxCharactersLength:(NSUInteger)XZMaxCharactersLength{
    _XZMaxCharactersLength = XZMaxCharactersLength;
    _XZMaxTextLength = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XZTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:self];
}

//强制按text.length长度计算限制文本的最大长度 加强判断  设另个为0
-(void)setXZMaxTextLength:(NSUInteger)XZMaxTextLength{
    _XZMaxTextLength = XZMaxTextLength;
    _XZMaxCharactersLength = 0;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(XZTextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
}

//NSNotification
-(void)XZTextFieldDidChange{
    if (_XZMaxCharactersLength) {
        if (self.markedTextRange == nil && [self.text textLength] > _XZMaxCharactersLength) {
            self.text = [self.text LimitMaxTextShow:_XZMaxCharactersLength];
        }
    }
    if (_XZMaxTextLength) {
        if (self.markedTextRange == nil && self.text.length > _XZMaxTextLength) {
            self.text = [self.text substringToIndex:_XZMaxTextLength];
        }
    }
}

#pragma mark - textField Delegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if (range.length >= 1) {
        return YES;
    }
    //电话号码
    if (_XZTelePhone) {
        NSString *Mix = [textField.text addStr:string];
        if (Mix.DelSpace.length > 11 || ![string isNumber] ) {
            return NO;
        }
        if (Mix.length == 3 || Mix.length == 8){
            textField.text = [Mix addStr:@" "];
            return NO;
        }
        return YES;
    }
    //数字
    if (_XZNumber) {
        if (![string isNumber]) {
            return NO;
        }
    }
    //可以有小数点的 数字 小数点有判断
    if (_XZNumber_dot) {
        if (![string isNumber] && ![string isEqualToString:@"."]) {
            return NO;
        }
        if ([string isEqualToString:@"."]) {
            if (textField.text.length == 0 || [textField.text rangeOfString:@"."].location != NSNotFound) {
                return NO;
            }
        }else{//输入数字
            NSUInteger at =  [textField.text rangeOfString:@"."].location;
            if (at != NSNotFound) {
                if (textField.text.length - at > 2) {//点后最多两位数
                    return NO;
                }
            }
        }
        
    }
    if (_XZDivision) {
        NSUInteger targetCursorPostion = [textField offsetFromPosition:textField.beginningOfDocument toPosition:textField.selectedTextRange.start];
        NSMutableString *Mix = [NSMutableString stringWithString:[textField.text addStr:string].DelSpace];
        if (Mix.DelSpace.length > _XZMaxTextLength) {
            return NO;
        }else if (targetCursorPostion != textField.text.length ){
            Mix = [NSMutableString stringWithString:textField.text];
            [Mix insertString:string atIndex:targetCursorPostion];
            Mix = [NSMutableString stringWithString:Mix.DelSpace];
            for (int i = 0 ; i<Mix.length; i++) {
                if (i%(_XZDivision + 1 )== 0) {
                    [Mix insertString:@" " atIndex:i];
                }
            }
            [textField setText:Mix];
            UITextPosition *targetPostion = [textField positionFromPosition:textField.beginningOfDocument offset:targetCursorPostion + 1];
            [textField setSelectedTextRange:[textField textRangeFromPosition:targetPostion toPosition:targetPostion]];
            return NO;
        }
        NSInteger which = _XZDivision;
        for (int i = 0 ; i<Mix.length; i++) {
            if (i == which) {
                [Mix insertString:@" " atIndex:i];
                which = _XZDivision*2 + 1;
            }
        }
        [textField setText:Mix];
        return NO;
    }
    
    if (_XZMaxTextLength && textField.text.length >= _XZMaxTextLength) {
        return NO;
    }
    
    if (_XZMaxCharactersLength && textField.text.textLength >= _XZMaxCharactersLength) {
        return NO;
    }
    
    if (_XZDisableSpecialChat && [string isSpecialCharacter]) {
        return NO;
    }
    
    if (_XZMust_AZ09 && ![string is_A_Z_0_9]) {
        return NO;
    }
    
    if (_XZMust_ASCII && ![string isASCII]) {
        return NO;
    }
    
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return YES;
}

-(UIButton *)V_alpha{
    if (_V_alpha == nil) {
        CGRect bouds = CGRectMake(self.frame.origin.x - _moreTouchMargin.origin.x,
                                  self.frame.origin.y - _moreTouchMargin.origin.y,
                                  self.frame.size.width + _moreTouchMargin.size.width + _moreTouchMargin.origin.x,
                                  self.frame.size.height + _moreTouchMargin.size.height + _moreTouchMargin.origin.y);
        _V_alpha = [[UIButton alloc]initWithFrame:bouds];
        [self.superview addSubview:(_V_alpha)];
    }
    return _V_alpha;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField{
    if (_noTouchInEditing) {
        [self.superview bringSubviewToFront:self.V_alpha];
        _V_alpha.hidden = NO;
    }
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    _V_alpha.hidden = YES;
}


@end
