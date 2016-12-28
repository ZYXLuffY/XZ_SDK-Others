
#import "XZSingleTextVC.h"
#import "XZUtility.h"
const CGFloat TopSep = 15;

@interface XZSingleTextVC ()<UITextViewDelegate,UITextFieldDelegate>
{
    UILabel *La_Lim;
    UITableView *Tv_;
}

@end

@implementation XZSingleTextVC
@synthesize TextV_  ;

-(void)dealloc{
    JIE1;
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:YES];
    if (_UseTextField) {
        [self.Tf_ becomeFirstResponder];
    }
}

+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title Sex:(NSString*)sex Call:(ResString)call{
    XZSingleTextVC *TextVc =  [[XZSingleTextVC alloc]init];
    TextVc.VcTitle = title;
    TextVc.ResCall = call;
    TextVc.UseTableSex = sex;
    [vc pushVC:TextVc];
    return TextVc;
}

+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title Text:(NSString*)text  Limit:(NSUInteger)limit Call:(ResString)call{
    return  [XZSingleTextVC Vc:vc Title:title Text:text placeHolder:nil Limit:limit TextH:0 Call:call];
}

+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title TfText:(NSString*)text placeHolder:(NSString*)place  Limit:(NSUInteger)limit Call:(ResString)call{
    XZSingleTextVC *TextVc = [XZSingleTextVC Vc:vc Title:title Text:text placeHolder:nil Limit:limit TextH:0 Call:call];
    TextVc.UseTextField = YES;
    return TextVc;
}
+(instancetype)Vc:(UIViewController*)vc Title:(NSString*)title Text:(NSString*)text placeHolder:(NSString*)place  Limit:(NSUInteger)limit  TextH:(NSUInteger)textH Call:(ResString)call{
    XZSingleTextVC *TextVc =  [[XZSingleTextVC alloc]init];
    TextVc.VcTitle = title;
    TextVc.DefaultText = [text copy];
    TextVc.PlaceText = place;
    TextVc.limit = limit;
    TextVc.VHeight = textH;
    TextVc.ResCall = call;
    [vc pushVC:TextVc];
    return TextVc;
}

-(XZTextView *)TextV_{
    if (TextV_ == nil) {
        XZTextView *_ = [[XZTextView alloc]initWithFrame:CGRectMake(0,TopSep,ScreenWidth,_VHeight == 0 ? ((_limit > 20 ? _limit : 20 )*2.4) : _VHeight)];
        _.layer.borderWidth = 1;
        _.layer.borderColor = (HexColor(0xe5e5e5)).CGColor;
        _.font = [UIFont systemFontOfSize:15];
        _.textContainerInset = UIEdgeInsetsMake(5, 8, 3, 8);
        _.textColor = (HexColor(0x333333));
        _.text = _DefaultText;
        _.returnKeyType = UIReturnKeyDone;
        _.delegate = self;
        _.placeHolder = _PlaceText;
        //        _.XZMaxTextLength = _limit;
        [self.view addSubview:TextV_ =  _];
    }
    return TextV_;
}

-(XZTextField *)Tf_{
    if (_Tf_ == nil) {
        XZTextField *_ = [[XZTextField alloc]initWithFrame:CGRectMake(0, TopSep, ScreenWidth, 20*2.4)];
        _.backgroundColor = [UIColor whiteColor];
        _.layer.borderWidth = 1;
        _.layer.borderColor = (HexColor(0xe5e5e5)).CGColor;
        _.font = [UIFont systemFontOfSize:15];
        //        _.tex = UIEdgeInsetsMake(5, 8, 3, 8);
        _.textColor = (HexColor(0x333333));
        _.text = _DefaultText;
        _.returnKeyType = UIReturnKeyDone;
        _.delegate = self;
        _.clearButtonMode = UITextFieldViewModeWhileEditing;
        _.XZMaxTextLength = _limit;
        [self.view addSubview:_Tf_ =  _];
    }
    return _Tf_;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = (HexColor(0xf6f6f6));
    self.title = _VcTitle;
    
    if (_UseTableSex) {
        [self SetupTableview];
        return;
    }
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(TExtvEditimgDown)];
    
    if (_UseTextField) {
        [self Tf_];
        return;
    }
    
    self.TextV_.placeHolder = _PlaceText;
    [TextV_ becomeFirstResponder];
    
    //显示剩余字符限制的label
    UILabel *_ = [[UILabel alloc]initWithFrame:CGRectMake(TextV_.superview.width - 33, TextV_.bottom - 24, 30, 15)];
    _.textColor = [UIColor grayColor];
    _.font = [UIFont systemFontOfSize:15.5];
    [self.view addSubview:La_Lim = _];
    [self textViewDidChange:TextV_];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange:) name:UITextFieldTextDidChangeNotification object:TextV_];
}

#pragma mark - 选性别的

-(void)SetupTableview{
    UITableView *_ = [[UITableView alloc]initWithFrame:CGRectMake(0, TopSep, ScreenWidth, 88) style:UITableViewStyleGrouped];
    _.delegate = (id<UITableViewDelegate>)self;
    _.dataSource = (id<UITableViewDataSource>)self;
    _.scrollEnabled = NO;
    [_ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    [self.view addSubview: Tv_ = _];
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{ return  0.1;}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{ return 2;}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.textColor = kColorText;
    cell.textLabel.text = indexPath.row ? @"女" : @"男";
    cell.accessoryType =  [cell.textLabel.text isEqualToString:_UseTableSex] ?   UITableViewCellAccessoryCheckmark : UITableViewCellAccessoryNone;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
     Block_Exec(_ResCall,indexPath.row ? @"女" : @"男");
    [self.Nav popViewControllerAnimated:YES];
}


#pragma mark - 完成

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [self EditEnd:_Tf_ textLength:[_Tf_.text length] text:_Tf_.text];
    return YES;
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    return [(XZTextField*)textField textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

-(void)TExtvEditimgDown{
    if (TextV_) {
        [self EditEnd:TextV_ textLength:[TextV_.text length] text:TextV_.text];
    }else{
        [self EditEnd:_Tf_ textLength:[_Tf_.text length] text:_Tf_.text];
    }
}

-(void)EditEnd:(UIView*)view textLength:(NSInteger)textL text:(NSString*)text{
    if (textL > _limit) {
        [self ShowHUD:[NSString stringWithFormat:@"限制%d个字符",(int)_limit] De:1];
        [view.layer XZ_Shake];
        return;
    }
    [view resignFirstResponder];
    Block_Exec(_ResCall,text);
    [self.Nav popViewControllerAnimated:YES];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]){
        [self TExtvEditimgDown];
        return NO;
    }
    if (range.length >= 1) {
        return YES;
    }
    if (textView.text.length >_limit) {
        return NO;
    }
    return YES;
}


- (void)textViewDidChange:(UITextView *)textView{
    if ([textView.text length] > _limit && textView.markedTextRange == nil  ) {
//        textView.text = [textView.text LimitMaxTextShow:_limit];
         textView.text = [textView.text substringToIndex:_limit];
    }
    if (textView.markedTextRange == nil) {
        La_Lim.text = [NSString stringWithFormat:@"%d",(int)(_limit - [TextV_.text length])];
    }
}

-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
    
}


@end
