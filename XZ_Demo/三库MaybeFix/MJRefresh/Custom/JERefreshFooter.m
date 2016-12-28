
#import "JERefreshFooter.h"
#import "XZUtility.h"

@interface JERefreshFooter()
{
    /** 显示刷新状态的label */
    __unsafe_unretained UILabel *_stateLabel;
}
/** 所有状态对应的文字 */
@property (strong, nonatomic) NSMutableDictionary *stateTitles;
@end


@implementation JERefreshFooter

#pragma mark - 懒加载
- (NSMutableDictionary *)stateTitles{
    if (!_stateTitles) {
        self.stateTitles = [NSMutableDictionary dictionary];
    }
    return _stateTitles;
}

- (UILabel *)stateLabel{
    if (!_stateLabel) {
        [self addSubview:_stateLabel = [UILabel label]];
    }
    return _stateLabel;
}

#pragma mark - 公共方法
- (void)setTitle:(NSString *)title forState:(MJRefreshState)state{
    if (title == nil) return;
    self.stateTitles[@(state)] = title;
    self.stateLabel.text = self.stateTitles[@(self.state)];
}

- (void)setfont:(UIFont*)font{
        self.stateLabel.font = font;
}


#pragma mark - 私有方法
- (void)stateLabelClick{
    if (self.state == MJRefreshStateIdle) {
        [self beginRefreshing];
    }
}

#pragma mark - 懒加载子控件
- (UIActivityIndicatorView *)loadingView{
    if (!_loadingView) {
        UIActivityIndicatorView *loadingView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        loadingView.hidesWhenStopped = YES;
        [self addSubview:_loadingView = loadingView];
    }
    return _loadingView;
}

- (void)prepare{
    [super prepare];
    // 初始化文字
    [self setTitle:MJRefreshAutoFooterIdleText forState:MJRefreshStateIdle];
    [self setTitle:MJRefreshAutoFooterRefreshingText forState:MJRefreshStateRefreshing];
    [self setTitle:MJRefreshAutoFooterNoMoreDataText forState:MJRefreshStateNoMoreData];
    
    // 监听label
    self.stateLabel.userInteractionEnabled = YES;
    [self.stateLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(stateLabelClick)]];
}

#pragma makr - 重写父类的方法
- (void)placeSubviews{
    [super placeSubviews];
    
    if (self.loadingView.constraints.count) return;
    
    // 圈圈
    CGFloat loadingCenterX = self.mj_w * 0.5;
//    if (!self.isRefreshingTitleHidden) {
//        loadingCenterX -= 100;
//    }
    CGFloat loadingCenterY = self.mj_h * 0.5;
    self.loadingView.center = CGPointMake(loadingCenterX, loadingCenterY);
    
    self.stateLabel.frame = self.bounds;
}

- (void)setState:(MJRefreshState)state{
    MJRefreshCheckState
    
    if (state == MJRefreshStateNoMoreData) {
        self.stateLabel.textColor = kColorText99;
    }else{
         self.stateLabel.textColor = kColorText;
    }
    
    // 根据状态做事情
    if (state == MJRefreshStateNoMoreData || state == MJRefreshStateIdle) {
        [self.loadingView stopAnimating];
    } else if (state == MJRefreshStateRefreshing) {
        [self.loadingView startAnimating];
    }
    
    self.stateLabel.text = self.stateTitles[@(state)];
}

@end
