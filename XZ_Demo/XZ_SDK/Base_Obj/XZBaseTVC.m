
#import "XZBaseTVC.h"
#import "XZTextView.h"
#import "XZTextField.h"

@implementation XZBaseTVC

-(void)dealloc{
    NSLog(@"%@  dealloc 🌅🌅🌅🌅🌅🌅🌅",NSStringFromClass([self class]));
}

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"viewDidLoad %@ 🌏🌏🌏",NSStringFromClass([self class]));
    
    if (self.view.backgroundColor == nil) {
        self.view.backgroundColor = kColorBackground;
    }
    
    self.tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    
}



#pragma mark - 交互

-(void)tapToEndEditing{
    WSELF
    [self.tableView tapGesture:^(UIGestureRecognizer *Ges) {
        [wself.tableView endEditing:YES];
    }];
}

-(void)touchesBegan:(nonnull NSSet *)touches withEvent:(nullable UIEvent *)event{
    [self.view endEditing:YES];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}
-(BOOL)scrollViewShouldScrollToTop:(UIScrollView *)scrollView{
    return YES;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{ return  0.1;}//15

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

//
//#pragma mark - UITableView Delegate DataSource
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 44;
//}
//
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
//    return 1;
//}
//
//-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
//    return 1;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{ return 3;
//}
//
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{ return 3;
//}
//
//-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
//    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth, 48)];
//    return view;
//}
//
//
//- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
//    //    [self.Tv__ registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
//    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
//    cell.textLabel.text = [NSString stringWithFormat:@"%d%d___%@",(int)indexPath.section,(int)indexPath.row,tableView];
//    
//    
//    NSInteger row = indexPath.row;
//    NSInteger section = indexPath.section;
//    
//    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
//    
//    
//    return cell;
//}
//
//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    
//}
//
//
//
//-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
//    if (editingStyle==UITableViewCellEditingStyleDelete) {
//        
//    }
//}
//
//
//-(UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return UITableViewCellEditingStyleDelete;
//}


//- (void) tableViewDisplayWitMsg:(NSString *) message ifNecessaryForRowCount:(NSUInteger) rowCount
//{
//    if (rowCount == 0) {
//        // Display a message when the table is empty
//        // 没有数据的时候，UILabel的显示样式
//        UILabel *messageLabel = [UILabel new];
//        
//        messageLabel.text = message;
//        messageLabel.font = [UIFont preferredFontForTextStyle:UIFontTextStyleBody];
//        messageLabel.textColor = [UIColor lightGrayColor];
//        messageLabel.textAlignment = NSTextAlignmentCenter;
//        [messageLabel sizeToFit];
//        
//        self.backgroundView = messageLabel;
//        self.separatorStyle = UITableViewCellSeparatorStyleNone;
//    } else {
//        self.backgroundView = nil;
//        self.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
//    }
//}


@end




@implementation XZTableView

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    self = [super initWithFrame:frame style:style];
    [self fixDelaysContentTouches];
    return self;
}

-(instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    [self fixDelaysContentTouches];
    return self;
}

-(void)didMoveToWindow{
    self.separatorColor = kColorSeparator;
}

/** 修改有点击效果 */
- (void)fixDelaysContentTouches{
    self.delaysContentTouches = NO;
    self.canCancelContentTouches = YES;
    
    // Remove touch delay (since iOS 8)
    UIView *wrapView = self.subviews.firstObject;
    if (wrapView && [NSStringFromClass(wrapView.class) hasSuffix:@"WrapperView"]) {    // UITableViewWrapperView
        //        wrapView.backgroundColor = kColorBackground;
        for (UIGestureRecognizer *gesture in wrapView.gestureRecognizers) {
            if ([NSStringFromClass(gesture.class) containsString:@"DelayedTouchesBegan"] ) { // UIScrollViewDelayedTouchesBeganGestureRecognizer
                gesture.enabled = NO;
                break;
            }
        }
    }
}

- (BOOL)touchesShouldCancelInContentView:(UIView *)view {
    if ( [view isKindOfClass:[UIControl class]]) {
        return YES;
    }
    return [super touchesShouldCancelInContentView:view];
}

@end
