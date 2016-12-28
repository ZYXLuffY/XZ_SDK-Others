
#import "XZListManager.h"
#import "XZData.h"
#import "XZNetWorking.h"
#import "XZUtility.h"

const BOOL NeedCaChe   = YES;/**< 该项目是否需要缓存 */

@interface XZListManager ()


//just 引用
@property(nonatomic,copy)   NSString                      *API_;
@property(nonatomic,weak)   UIViewController              *Vc_;
@property(nonatomic,weak)   UITableView                   *Tv_;
@property(nonatomic,weak)   AFHTTPSessionManager *Af_;
@property(nonatomic,copy)   NSString                      *CacheName_;
@property(nonatomic,assign) BOOL                          HavePage_;
@property(nonatomic,copy)   Class                         ModClass_;


@end

@implementation XZListManager

-(void)dealloc{
    _BL_NetEnd = nil;
    _NetSuccessdBlock = nil;
    _NetworkFailedBlock = nil;
    JIE1;
}

+(void)API:(NSString*)API Dic:(NSDictionary*)Dic Pages:(BOOL)Hpage Tv:(UIView*)tableview Arr:(NSMutableArray*)dataSoure VC:(UIViewController*)SuperVc Af:(AFHTTPSessionManager*)manager Mod:(Class)modclass CaChe:(NSString*)caChe Suc:(NetSuccess)success Fail:(NetFailure)fail{
    if ([[XZListManager alloc]initWithAPI:API Dic:Dic Pages:Hpage Tv:tableview Arr:dataSoure VC:SuperVc Af:manager Mod:modclass CaChe:caChe Suc:success Fail:fail]) {
    }
}

-(instancetype)initWithAPI:(NSString*)API Dic:(NSDictionary*)Dic Pages:(BOOL)Hpage Tv:(UIView*)tableview Arr:(NSMutableArray*)dataSoure VC:(UIViewController*)SuperVc  Af:(AFHTTPSessionManager*)manager Mod:(Class)modclass CaChe:(NSString*)caChe Suc:(NetSuccess)success Fail:(NetFailure)fail{
    if (tableview == nil) {
        return nil;
    }
    _NetSuccessdBlock = success; _NetworkFailedBlock = fail;_API_ = API; _Param_ = Dic;    _Tv_ = (UITableView*)tableview;
    _Arr_ = dataSoure; _Af_ = manager;  _Vc_ = SuperVc; _HavePage_ = Hpage;   _CacheName_ = caChe;_ModClass_ = modclass;
    
    [self StartLoad];
    return self;
}

/** 请求加参数 */
- (void)addValue:(NSString*)value key:(NSString*)key{
    NSMutableDictionary *dic = [_Param_ mutableCopy];
    [dic setValue:value forKey:key];
    _Param_ = dic;
}


-(void)StartLoad{
    _Page_ = BeginPage;
    
    _Tv_.mj_header = [MJRefreshHeader headerWithRefreshingBlock:^{//初始下拉刷新
        
        _Tv_.mj_footer.hidden = YES;
        _Page_ = BeginPage;
        [self startNetworking];
    }];
    
    if (_HavePage_) { //如果有页的概念   页数固定从BeginPage开始  （与当前后台设置的起始页数为准）
        _Page_ = BeginPage;
        
        _Tv_.mj_footer = [MJRefreshFooter footerWithRefreshingBlock:^{
            if (_Tv_.mj_footer.state == MJRefreshStateNoMoreData) {
                [_Tv_.mj_footer endRefreshingWithNoMoreData];return ;
            }
            _Tv_.mj_header.hidden = YES;
            _Page_ ++ ;
            [self startNetworking];
        }];
    }
    
    _Tv_.mj_footer.hidden = _Tv_.mj_header.hidden = YES;
    
    _Tv_.backgroundView = _Tv_.ActView;
    [_Tv_.ActView startAnimating];
    
    [self startNetworking];
    
    
    if (_CacheName_ && NeedCaChe) {//先显示缓存的数据
        XZdbObj *XZdbObj = [XZdb GetXZObj:_CacheName_ Table:T_XZdbDefaultT];
        if (XZdbObj == nil || ([XZdbObj.Obj isKindOfClass:[NSArray class]] && [(NSArray*)XZdbObj.Obj count] == 0)) {
            return;
        }
        [self networkSuccess:XZdbObj.Obj];
    }
}

#pragma mark - 网络 提交前 制定一下

-(void)startNetworking{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionaryWithDictionary:_Param_];
    
    if (_HavePage_) {
        [parameters setObject:@(_Page_).stringValue forKey:PageParam];
        if (parameters[rowsParam] == nil) {
            [parameters setObject:@(rowsNum).stringValue forKey:rowsParam];
        }
    }
    
    [XZNetWorking API:_API_ Param:parameters Vc:_Vc_ AF:_Af_ Suc:^(NSDictionary *Res) {
        
        [self networkSuccess:Res];
        Block_Exec(_BL_NetEnd);
        
    } Fai:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error){
        if (task.error.code == NSURLErrorCancelled) {//自己取消的网络请求
            [self networkFailure];
            return ;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.618 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self networkFailure];
            if (_NetworkFailedBlock) {
                _NetworkFailedBlock();return;
            }
            [_Vc_ hideHud];
        });
    }];
}


#pragma mark -  特殊处理
//成功时的处理
-(void)networkSuccess:(NSDictionary*)NetRes{
    [_Tv_.mj_header endRefreshing];[_Tv_.mj_footer endRefreshing];
    _Tv_.mj_footer.hidden = _Tv_.mj_header.hidden = NO;
    _Tv_.backgroundView = _Tv_.ActView = nil;
    
//    _Tv_.header.XZNetworkingFail = NO;
    
    if (NetRes == nil || ([NetRes isKindOfClass:[NSDictionary class]] && _NetSuccessdBlock == nil)) {
        [_Tv_ reloadData];
        return;
    }
    
    NSMutableArray *ArrLists = (NSMutableArray*)NetRes;/**< 实际得带的数组 */
    if ([ArrLists isKindOfClass:[NSNull class]]) {
        ArrLists = [@[]mutableCopy];
    }
    
    
    NSInteger maxRow = [_Param_ objectForKey:rowsParam] ? [[_Param_ objectForKey:rowsParam] integerValue] : rowsNum;
    if ([ArrLists isKindOfClass:[NSArray class]] && ((ArrLists.count < maxRow) || ((ArrLists.count == 0 || ArrLists == nil) ))) {//请求没数据 就说 没有更多了
        [_Tv_.mj_footer endRefreshingWithNoMoreData];
    }
    
    if (((_Page_ == BeginPage || !_HavePage_) && _CacheName_ && NeedCaChe)) {//重新刷新的 删除所有数据  只缓存page 为BeginPage时 的数据
        [XZdb Save:NetRes Id:_CacheName_ Table:T_XZdbDefaultT];
    }
    
    if ((_Page_ == BeginPage || !_HavePage_)) {//无分页 或是第一页
        [_Arr_ removeAllObjects];
    }
    
    //有自己定义处理网络数据的方法
    if (_NetSuccessdBlock) {
        _NetSuccessdBlock(NetRes,(_Page_),_Tv_);
    }else{
        [self defaultAnalysisArrList:ArrLists];
    }
    
}

/** 默认处理数组的方法 */
-(void)defaultAnalysisArrList:(NSArray*)ArrLists{
//    if ((_Page_ == BeginPage || !_HavePage_) && ArrLists != nil) {//无分页 或是第一页
//        [_Arr_ removeAllObjects];
//    }
    if (_ModClass_ && [ArrLists isKindOfClass:[NSArray class]]) {
        [_Arr_ addObjectsFromArray:[_ModClass_ objectArrayWithKeyValuesArray:ArrLists]];
    }else{
        if (ArrLists) {
            [ArrLists isKindOfClass:[NSArray class]] ? [_Arr_ addObjectsFromArray:ArrLists] : [_Arr_ addObject:ArrLists];
        }
    }
    [_Tv_ reloadData];
}

#pragma mark - 失败

//失败时的处理
-(void)networkFailure{
    if (_HavePage_) {//失败了 这次页不算 减去
        _Page_--;
    }
    [_Tv_.mj_header endRefreshing];[_Tv_.mj_footer endRefreshing];
    
    delay(MJRefreshSlowAnimationDuration, ^{
        _Tv_.mj_header.hidden = NO;
    });
    
    _Tv_.backgroundView = _Tv_.ActView = nil;
//    _Tv_.header.XZNetworkingFail = YES;
    _Tv_.mj_footer.hidden = YES;
    
    [_Tv_ reloadData];
}


@end
