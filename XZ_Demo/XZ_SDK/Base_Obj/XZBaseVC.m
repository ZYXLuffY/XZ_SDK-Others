
#import "XZBaseVC.h"
#import "XZTextField.h"
@interface XZBaseVC ()


@end

@implementation XZBaseVC

-(void)dealloc{
    [self cancelNetworking];
    NSLog(@"%@  dealloc 🌅🌅🌅🌅🌅🌅🌅",NSStringFromClass([self class]));
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    [self.view endEditing:YES];
}

#pragma mark -

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad %@ 🌏🌏🌏",NSStringFromClass([self class]));
    if (self.view.backgroundColor == nil) {
        self.view.backgroundColor = kColorBackground;    
    }
    
}


#pragma mark - UITableView

-(void)Create__TvRect:(CGRect)rect Style:(UITableViewStyle)style{
    UITableView *_ = [[UITableView alloc]initWithFrame:rect style:style];
    _.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    _.delegate = (id<UITableViewDelegate>)self;
    _.dataSource = (id<UITableViewDataSource>)self;
    _.tableFooterView = [UIView new];
    [self.view addSubview:_Tv__ = _];
}

#pragma mark - 交互

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}

-(void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}


#pragma mark  textField
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([textField isKindOfClass:[XZTextField class]]) {
        return [(XZTextField*)textField textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}

-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    [textField resignFirstResponder];
    return  YES;
}

@end
