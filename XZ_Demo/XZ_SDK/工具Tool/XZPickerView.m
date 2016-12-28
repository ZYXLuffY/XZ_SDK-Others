
#import "XZPickerView.h"
#import "XZUtility.h"

const static CGFloat AnimateDuration  = 0.25;/**< 动画时间 */

@interface XZPickerView ()
{
    UIView *BackView;
}

@property (nonatomic,strong) NSArray *CustomArr;

@property (nonatomic,strong) NSDate *CurrentDate;
@property (nonatomic,strong) NSDate *minDate;
@property (nonatomic,strong) NSDate *maxDate;

@end


@implementation XZPickerView

-(void)dealloc{JIE1;}

/**< 显示 地区选择器 */
+(void)ShowLocationPick:(LocationBlock)loca{
    [XZApp.window addSubview:[[XZPickerView_City alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) loca:loca]];
}

/**< 显示 定义的数组 */
+(void)ShowCustomArr:(NSArray*)arr res:(CusArrBlock)Cus{
    XZPickerView *Pick = [[XZPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    Pick.CustomArr = arr;
    Pick.CusArrBlockCall = Cus;
    [Pick.PickV reloadAllComponents];
    [XZApp.window addSubview:Pick];
}

/**  显示 时间选择器 */
+(void)ShowDatePicker:(DateBlock)date{
    [XZApp.window addSubview:[[XZPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) dateComplete:date current:[NSDate date] min:nil max:nil]];
}

/**  显示 时间选择器 显示 年和月 日遮盖了*/
+(void)ShowDatePicker_YM:(DateBlock)date{
    [XZApp.window addSubview:[[XZPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) dateComplete:date current:[NSDate date] min:nil max:nil]];
}

+(void)ShowDatePicker:(DateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max{
    [XZApp.window addSubview:[[XZPickerView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight) dateComplete:date current:current min:min max:max]];
}

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) { [self BaseSetup];}
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame dateComplete:(DateBlock)date current:(NSDate*)current min:(NSDate*)min max:(NSDate*)max{
    self = [super initWithFrame:frame];
    if (self) {
        _DateBlockCall = date;
        _CurrentDate = current;
        _minDate = min;
        _maxDate = max;
        
        [self BaseSetup];
    }
    return self;
}

- (void)BaseSetup{
    self.alpha = 0;
    self.backgroundColor = kRGBA(0, 0, 0, 0.5);
    
    BackView = [[UIView alloc]initWithFrame:self.bounds];  //隐藏的点击背景
    [self addSubview:BackView];
    [BackView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(XZPickerHideView)]];
    
    if (_DateBlockCall) {
        [self datePicker];
    }
    
    [self XZPickerShowView];
}


-(void)ChangeNavPopGestureEnable:(BOOL)enable{
    UINavigationController *Nav = (UINavigationController*)XZApp.window.rootViewController;
    if ([Nav isKindOfClass:[UINavigationController class]]) {
        Nav.interactivePopGestureRecognizer.enabled = enable;
    }
}

/** 显示 */
-(void)XZPickerShowView{
    [self ChangeNavPopGestureEnable:NO];
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 1;
        //        V_Content.y = V_Content.y - contentHeight;
    }];
}

/** 隐藏 销毁 */
-(void)XZPickerHideView{
    [self ChangeNavPopGestureEnable:YES];
    [UIView animateWithDuration:AnimateDuration animations:^{
        self.alpha = 0;
        //        V_Content.y = ScreenHeight;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        [BackView removeFromSuperview];
        //        _BL_Select = nil;
    }];
}
#pragma mark - UI


-(UIView *)createActionBar {
    //    UIToolbar *actionBar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, ScreenHeight - 216 - 44, ScreenWidth, 1)];
    //    [actionBar sizeToFit];
    //    UIBarButtonItem *L = [[UIBarButtonItem alloc]initWithTitle:@"    取消" style:UIBarButtonItemStylePlain target:self action:@selector(XZPickerHideView)];
    //    UIBarButtonItem *R = [[UIBarButtonItem alloc]initWithTitle:@"完成    " style:UIBarButtonItemStylePlain target:self action:@selector(XZPickerensure)];
    //    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //    [actionBar setItems:[NSArray arrayWithObjects: L,flexible, R, nil]];
    //    return actionBar;
    
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 216 - 44, ScreenWidth, 52)];
    view.backgroundColor = [UIColor whiteColor];
    [view.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(0, view.height) To:CGPointMake(view.width, view.height) color:kColorDividing]];
    UIButton *btnL = [UIButton Frame:CGRectMake(0, 0, view.width/2, view.height) Title:@"取消" FontS:17 Color:kColorText radius:0 Target:self action:@selector(XZPickerHideView) Bimg:nil];
    btnL.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    UIButton *btnR = [UIButton Frame:CGRectMake(view.width/2, 0, view.width/2, view.height) Title:@"确定" FontS:17 Color:kColorBlue radius:0 Target:self action:@selector(XZPickerensure) Bimg:nil];
    btnR.titleLabel.font = [UIFont systemFontOfSize:17 weight:UIFontWeightMedium];
    [view.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(view.width/2, 14) To:CGPointMake(view.width/2, 14+24) color:kColorSeparator]];
    
    [view addSubview:btnL];
    [view addSubview:btnR];
    return view;
}

-(UIPickerView *)PickV{
    if (!_PickV) {
        UIPickerView *_ = [[UIPickerView alloc]initWithFrame:CGRectMake(0, ScreenHeight - 216, ScreenWidth, 216)];
        _.delegate = (id<UIPickerViewDelegate>)self;
        _.dataSource = (id<UIPickerViewDataSource>)self;
        _.backgroundColor = [UIColor whiteColor];
        [self addSubview:(_PickV = _)];
        [self addSubview:[self createActionBar]];
        
        [_PickV.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(57, 92) To:CGPointMake(ScreenWidth - 57, 92) color:kColorSeparator]];
        [_PickV.layer addSublayer:[UIView XZ_DrawLine:CGPointMake(57, 92 + 30) To:CGPointMake(ScreenWidth - 57, 92 + 30) color:kColorSeparator]];
    }
    return _PickV;
}

-(UIDatePicker *)datePicker{
    if (_datePicker == nil) {
        UIDatePicker *datePicker = [ [ UIDatePicker alloc] initWithFrame:CGRectMake(0 ,ScreenHeight - 216, 0, 0)];
        datePicker.x = (ScreenWidth - datePicker.width)/2;
        datePicker.backgroundColor = [UIColor whiteColor];
        datePicker.datePickerMode = UIDatePickerModeDate;
        //        [datePicker setValue:kColorBlue forKey:@"textColor"];
        //        [datePicker propertyList_methodList_ivarList];
        
        if (_CurrentDate) {datePicker.date = _CurrentDate; }
        if (_minDate) {  datePicker.minimumDate = _minDate; }
        if (_maxDate) {  datePicker.maximumDate = _maxDate; }
        
        if (iPhone6_PBigger) {
            UIView *White1 = [[UIView alloc]initWithFrame:CGRectMake(0, datePicker.y, ScreenWidth, 216)];
            White1.backgroundColor = [UIColor whiteColor];
            [self addSubview:White1];
        }
        
        [self addSubview:(_datePicker = datePicker)];
        [self addSubview:[self createActionBar]];
        
        
    }
    return _datePicker;
}


-(void)XZPickerensure{
    //定义的数组
    if (_CusArrBlockCall) {
        _CusArrBlockCall([_PickV selectedRowInComponent:0],[_CustomArr objectAtIndex:[_PickV selectedRowInComponent:0]]);
    }
    
    //时间选择
    if (_DateBlockCall) {
        _DateBlockCall(_datePicker.date);
    }
    
    [self XZPickerHideView];
}


#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}
- (CGSize)rowSizeForComponent:(NSInteger)component{
    return CGSizeMake(ScreenWidth*0.6, 32);
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    UILabel* pickerLabel = (UILabel*)view;
    if (!pickerLabel){
        pickerLabel = [[UILabel alloc] init];
        pickerLabel.adjustsFontSizeToFitWidth = YES;
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setFont:[UIFont systemFontOfSize:17]];
    }
    pickerLabel.text= [self pickerView:pickerView titleForRow:row forComponent:component];
    return pickerLabel;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return _CustomArr.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return _CustomArr[row];
}

//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (self.CustomArr) {
//        CurrentIndex = row;
//        return;
//    }
//}



@end




////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#pragma mark - ====================  @implementation 城市选择
@implementation XZPickerView_City

-(void)dealloc{JIE1;}

- (instancetype)initWithFrame:(CGRect)frame loca:(LocationBlock)loca{
    self = [super initWithFrame:frame ];
    if (self) {
        self.LocationBlockCall = loca;
        [self getPickerData];
    }
    return self;
}

#pragma mark - Address plist


- (void)getPickerData {
    if (_pickerDic) {
        return;
    }
    _pickerDic = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"XZAddress" ofType:@"plist"]];
    _provinceArray = [_pickerDic allKeys];
    _selectedArray = [_pickerDic objectForKey:[[_pickerDic allKeys] objectAtIndex:0]];
    
    if (_selectedArray.count > 0) {
        _cityArray = [[_selectedArray objectAtIndex:0] allKeys];
    }
    
    if (_cityArray.count > 0) {
        _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:0]];
    }
    [self.PickV reloadAllComponents];
}

#pragma mark - UIPicker Delegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [(NSArray*)[self valueForKey:@[@"provinceArray",@"cityArray",@"townArray"][component]] count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [(NSArray*)[self valueForKey:@[@"provinceArray",@"cityArray",@"townArray"][component]] objectAtIndex:row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0) {
        _selectedArray = [_pickerDic objectForKey:[_provinceArray objectAtIndex:row]];
        if (_selectedArray.count > 0) {
            _cityArray = [[_selectedArray objectAtIndex:0] allKeys];
        } else {
            _cityArray = nil;
        }
        if (_cityArray.count > 0) {
            _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:0]];
        } else {
            _townArray = nil;
        }
    }
    [pickerView selectedRowInComponent:1];
    [pickerView reloadComponent:1];
    [pickerView selectedRowInComponent:2];
    
    if (component == 1) {
        if (_selectedArray.count > 0 && _cityArray.count > 0) {
            _townArray = [[_selectedArray objectAtIndex:0] objectForKey:[_cityArray objectAtIndex:row]];
        } else {
            _townArray = nil;
        }
        [pickerView selectRow:1 inComponent:2 animated:YES];
    }
    
    [pickerView reloadComponent:2];
}

#pragma mark -

- (void)XZPickerensure{
    NSArray *City = @[[_provinceArray objectAtIndex:[self.PickV selectedRowInComponent:0]],[_cityArray objectAtIndex:[self.PickV selectedRowInComponent:1]],[_townArray objectAtIndex:[self.PickV selectedRowInComponent:2]]];
    NSString *First = City[0];
    if ([City[0] isEqualToString:City[2]]) {//香港 台湾 澳门
    }else if ([City[0] isEqualToString:City[1]]) {
        First = [NSString stringWithFormat:@"%@ %@",First,City[2]];
    }else{
        First = [NSString stringWithFormat:@"%@ %@ %@",First,City[1],City[2]];
    }
    
    self.LocationBlockCall(City,First);
    
    [self XZPickerHideView];
}





@end





