
#import "UIScrollView+XZ.h"
#import <objc/runtime.h>
#import "XZUtility.h"
#import "MJRefresh.h"


static const char *TableObjectArr = "TableObjectArr";
static const char *ActivityIndicatorView = "ActivityIndicatorView";

@implementation UIScrollView (XZ)

//*< UIScrollView 和侧滑返回的冲突问题  有 UIScrollView时没有全屏侧滑返回，但至少有边界的侧滑返回！
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[FDPanGestureRecognizer class]] && ([otherGestureRecognizer locationInView:otherGestureRecognizer.view].x < QTZAllowedInitialDistanceToLeftEdge )) {
        return YES;
    }
    else{
        return  NO;
    }
}


/** 基础数据源 */
-(NSMutableArray *)Arr{
    NSMutableArray *Arrobj = objc_getAssociatedObject(self, &TableObjectArr);
    if (Arrobj == nil) {
        self.Arr = [[NSMutableArray alloc]init];
        Arrobj = self.Arr;
    }
    return Arrobj;
}

-(void)setArr:(NSMutableArray *)Arr{
    objc_setAssociatedObject(self, &TableObjectArr, Arr, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


-(UIActivityIndicatorView *)ActView{
    UIActivityIndicatorView *act = objc_getAssociatedObject(self, &ActivityIndicatorView);
    if (act == nil) {
        self.ActView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        act = self.ActView;
    }
    return act;
}

-(void)setActView:(UIActivityIndicatorView *)ActView{
    objc_setAssociatedObject(self, &ActivityIndicatorView, ActView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


/** storyboard 静态tableview 加载 */
- (void)staticLoading{
    [self layoutIfNeeded];
    [self.ActView startAnimating];
    ((UITableView*)self).backgroundView = self.ActView;
    for (UITableViewCell *cell in ((UITableView*)self).visibleCells) {
        cell.hidden = YES;
    }
}

/** storyboard 静态tableview 停止加载 */
- (void)staticStopLoading{
    [self.ActView stopAnimating];
    ((UITableView*)self).backgroundView = nil;
    for (UITableViewCell *cell in ((UITableView*)self).visibleCells) {
        cell.hidden = NO;
    }
}



#pragma mark - 空数据时的展示

/** 如果没有数据 count = 0  显示 图片 文本 */
- (NSInteger)XZ_emptyImgN:(NSString*)imageName title:(NSString*)title count:(NSInteger)row{
    if (row != 0) {
//        if (self.backgroundColor != [UIColor whiteColor]) {
//            self.backgroundColor = kColorBackground;
//        }
        ((UITableView*)self).backgroundView = nil;//有数据了 这个view 滞空
        return row;
    }
    
    //网络请求失败的 没有缓存的 显示的点击加载什么的 需和MJrefresh的匹配
    if (self.mj_header && self.mj_header.JENetworkingFail && row == 0) {
        if (![((UITableView*)self).backgroundView isKindOfClass:[UIActivityIndicatorView class]]) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        ((UITableView*)self).backgroundView = [self networkingFailView_Target:self action:@selector(XZNetworkingFailRelaodClick)];
        
        return row;
    }
    
    if (((UITableView*)self).backgroundView != nil) {//有自己定义的view或已经存在
        if (![((UITableView*)self).backgroundView isKindOfClass:[UIActivityIndicatorView class]]) {
            self.backgroundColor = [UIColor whiteColor];
        }
        
        return row;
    }
    
    ((UITableView*)self).backgroundView = [self customViewWhitImgName:imageName title:title];
    
    return 0;
}

/** 自己定义的没有数据时显示的 视图 */
- (UIView*)customViewWhitImgName:(NSString*)imageName title:(NSString*)title {
    if (!imageName && !title) { return nil; }
    [self layoutIfNeeded];
    UIView* Ve = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    UIImageView *ImgV;
    if (imageName.length) {
        UIImage* image = [UIImage imageNamed:imageName];
        CGSize Size = [image XZ_reSetMaxWH:Ve.width*0.618];//不知道你放的图片的大小 只是限制最大比例屏占比
        [Ve addSubview:(ImgV = [UIImageView Frame:CGRectMake((Ve.width - Size.width)/2, (self.height)*0.2 , Size.width, Size.height) image:image])];
    }
    
    UILabel *La = [UILabel Frame:CGRectMake(0,ImgV ? ImgV.bottom + 24 : self.height *0.4,Ve.width, [title __H__:14 W:Ve.width]) Title:title FontS:14 Color:kColorTextGray Alignment:NSTextAlignmentCenter];
    
    if (imageName == nil) {
        La.text = @[@"你来或者不来，我一直在这里，不离不弃",@"最美的艺术，是留白",@"亲爱的车主，这一页还在怀孕"][arc4random_uniform(3)];
    }
    
    [Ve addSubview:La];
    
    return Ve;
}

/** 网络请求失败时显示的   */
- (UIView*)networkingFailView_Target:(id)target action:(SEL)action{
    [self layoutIfNeeded];
    UIView *Ve = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    
    UIImage* image = [UIImage imageNamed:@"DefaulNotNetwork"];
    CGSize Size = [image XZ_reSetMaxWH:Ve.width*0.618];//不知道你放的图片的大小 只是限制最大比例屏占比
    UIImageView *ImgV = [UIImageView Frame:CGRectMake((Ve.width - Size.width)/2, (self.height)*0.2 , Size.width, Size.height) image:image];
    [Ve addSubview:ImgV];
    
    UILabel *La = [UILabel Frame:CGRectMake(0, ImgV.bottom + 10, self.width, 20) Title:@[@"你来或者不来，我一直在这里，不离不弃",@"最美的艺术，是留白",@"亲爱的车主，这一页还在怀孕"][arc4random_uniform(3)] FontS:15 Color:kColorTextGray Alignment:NSTextAlignmentCenter];
    [Ve addSubview:La];
    
    [Ve addSubview:[UIButton Frame:CGRectMake((self.width - 80)/2, La.bottom + 23, 80, 30) Title:@"重新加载" FontS:14 Color:[UIColor whiteColor] radius:5 Target:target action:action Bimg:kColorBlue]];
    
    return Ve;
}

- (void)XZNetworkingFailRelaodClick{
    self.mj_footer.hidden = self.mj_header.hidden = YES;
    ((UITableView*)self).backgroundView = self.ActView;
    [self.ActView startAnimating];
    
    [self.mj_header beginRefreshing];
}


#pragma mark -


static const void *XZListManagerKey = &XZListManagerKey;

#pragma mark - listManager

-(void)setListManager:(XZListManager *)ListManager{
    objc_setAssociatedObject(self, &XZListManagerKey, ListManager, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

-(XZListManager *)ListManager{
    return  objc_getAssociatedObject(self, &XZListManagerKey);
}


/** 创建个列表管理的 */
- (void)listAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)Hpage mod:(Class)modclass caChe:(NSString*)caChe suc:(NetSuccess)success fail:(NetFailure)fail{
    UIViewController *superVC =  self.superVC;
    NSAssert(([self isKindOfClass:[UITableView class]] || [self isKindOfClass:[UICollectionView class]]) && superVC, @"no UIScrollView ,or can not find superVC?");
    [self listAPI:API param:param pages:Hpage mod:modclass superVC:superVC caChe:caChe suc:success fail:fail]; 
}

- (void)listAPI:(NSString*)API param:(NSDictionary*)param pages:(BOOL)Hpage mod:(Class)modclass superVC:(UIViewController*)superVC caChe:(NSString*)caChe suc:(NetSuccess)success fail:(NetFailure)fail{
    XZListManager *manager = [[XZListManager alloc]initWithAPI:API Dic:param Pages:Hpage Tv:self Arr:self.Arr VC:superVC Af:superVC.AFM Mod:modclass CaChe:caChe Suc:success Fail:fail];
    [self setListManager:manager];
}

/** 列表的头部主动下拉刷新 自带请求结束的停止刷新 并reloadData  Res有值才返回 */
-(void)refreshingPOST:(NSString*)API Param:(NSDictionary*)param Suc:(void(^)(NSDictionary *Res))Suc Fai:(void(^)(NSURLSessionDataTask * task, NSError *error))Fai{
    UIViewController *superVC =  self.superVC ? : XZApp.window.rootViewController;
    
    [superVC POST:API Param:param Suc:^(NSDictionary *Res) {
        [self.mj_header endRefreshing];
        if (Res && Suc) {
            Suc(Res);
        }
        if ([self isKindOfClass:[UITableView class]]) { [(UITableView*)self reloadData]; }
    }Fai:^(NSURLSessionDataTask *task, NSError *error) {
        [self.mj_header endRefreshing];
        if (Fai) { Fai(task,error);}
        if ([self isKindOfClass:[UITableView class]]) { [(UITableView*)self reloadData]; }
    }];
    
}



@end
