

/**< 
 
 sit环境配置域名&https，
 sitapi.bojuecar.com;sitmanager.bojuecar.com;sitweixin.bojuecar.com
 
 */

#if         (          0         )             //0 测试              1 正式
static NSString *const BoJue_BASEHTTP                = @"https://api3.bojuecar.com/api";
static NSString *const BoJue_BASEHTTP_Web            = @"https://wx3.bojuecar.com";
static NSString *const BoJue_ADVISETOHEALTHUrl       = @"https://api3.bojuecar.com/api/obdDevice/advice?troubleCodeIds=";
#else

static NSString *const BoJue_BASEHTTP                = @"https://sitapi.bojuecar.com/api";
static NSString *const BoJue_BASEHTTP_Web            = @"https://sitweixin.bojuecar.com";
static NSString *const BoJue_ADVISETOHEALTHUrl       = @"https://sitapi.bojuecar.com/api/obdDevice/advice?troubleCodeIds=";

#endif











#pragma mark - H5

static NSString *const API_H5                        = @"/weixin/app";/**< H5前缀*/
static NSString *const API_CheJianRules              = @"/cheJianRules";/**< 车检评分规则H5页面*/
static NSString *const API_ShouDanFree               = @"/shouDanFree";/**< 首单免费洗车H5页面*/


#pragma mark - user

static NSString *const API_register                  = @"/user/register";/**< 注册  userInfo.mobile userInfo.passWord identifyCode*/

static NSString *const API_login                     = @"/user/login";/**< 登录  userInfo.mobile userInfo.passWord*/

static NSString *const API_updateUserInfo            = @"/user/updateUserInfo";/**< 修改用户信息  userInfo.id userInfo.sex userInfo.userName userInfo.userIcon  userInfo.driverYear userInfo.sign*/

static NSString *const API_updatePassWord            = @"/user/updatePassWord";/**< 修改密码  userInfo.mobile userInfo.passWord*/

static NSString *const API_findUserInfo              = @"/user/findUserInfo";/**< 查找用户信息  userId*/

static NSString *const API_updateHeadIcon            = @"/user/updateHeadIcon";/**< 上传头像  headIcon (base64) string*/

static NSString *const API_updateDefaultCar          = @"/user/updateDefaultCar";/**< 切换车辆  carBaseInfo.id oldCarId*/

static NSString *const API_findCarDetail             = @"/user/findCarDetail";/**< 查询车辆详情  carId*/

static NSString *const API_findCarList               = @"/user/findCarList";/**< 查询车辆列表  userId*/

static NSString *const API_maininfo                  = @"/user/maininfo";/**< 主页  userId*/

static NSString *const API_updateServiceNumber       = @"/user/updateServiceNumber";/**< 更新报险救援电话  serviceNumber.userId serviceNumber.sosNo serviceNumber.insuranceNumber serviceNumber.serverNumber*/

static NSString *const API_wifiIndex                 = @"/user/wifiIndex";/**< wifi管理 deviceId*/

static NSString *const API_updateWifi                = @"/user/updateWifi";/**< 修改wifi管理 obd.isDormancy obd.flowAlarm obd.wifiPassWord obd.isWifi obd.obdId*/

static NSString *const API_reportDeviceInfo          = @"/user/reportDeviceInfo";/**< 上报设备信息 deviceId*/

static NSString *const API_findCarInfoDetail         = @"/user/findCarInfoDetail";/**< 查询品牌车系车型 type : 1  车品牌  2 车系  3 车型 modelSeries modelName*/

static NSString *const API_getPlateAbbreviation      = @"/user/getPlateAbbreviation";/**< 获取城市简称*/

static NSString *const API_updateCar                 = @"/user/updateCar";/**< 更新我的爱车 ！！！*/

static NSString *const API_deleteCar                 = @"/user/deleteCar";/**< 删除我的爱车 carId*/

static NSString *const API_addCar                    = @"/user/addCar";/**< 新增我的爱车 carId*/

static NSString *const API_getHotCity                = @"/user/getHotCity";/**< 热门城市*/

static NSString *const API_weixinLogin               = @"/user/weixinLogin";/**< 微信登陆接口 openid unionid*/

static NSString *const API_wifiOnOff                 = @"/user/wifiOnOff";/**< 控制wifi开关 deviceId onOff*/

static NSString *const API_setFlowAlarm              = @"/user/setFlowAlarm";/**< 设置流量提醒 deviceId flowAlarm*/

static NSString *const API_msgBox                    = @"/user/msgBox";/**< 消息智能终端 userId*/

static NSString *const API_msgCount                  = @"/user/msgCount";/**< 未读消息 userId*/

static NSString *const API_getWifiInfo               = @"/user/getWifiInfo";/**< deviceId*/

static NSString *const API_saveWifi                  = @"/user/saveWifi";/**< deviceId wifiName wifiPassWord*/

static NSString *const API_getUserCoupon             = @"/user/getUserCoupon";/**< 获取我的优惠券 userId couponType 优惠券类型，优惠券类型，1，未使用 2，已使用 3，过期4，可用 5, 不可用
                                                                               类型为4，5时必须传orderNo orderNo 订单编码，查询当前订单可用优惠券列表 */

static NSString *const API_getUserVoiceList          = @"/user/getUserVoiceList";/**< 获取语音包列表 userId */

static NSString *const API_updateVoice               = @"/user/updateVoice";/**< 修改语音播报语言 userId voiceId*/

static NSString *const API_changeMobile              = @"/user/changeMobile";/**< 修改用户联系方式（1.3.2 不做账号修改，只做服务订单联系） code   userId mobile*/

static NSString *const API_getMeInitInfo             = @"/user/getMeInitInfo";/**< 获取“我的”初始属性 userId */

static NSString *const API_getUserMsgTypeList        = @"/user/getUserMsgTypeList";/**< 获取用户消息类型列表 userId */

static NSString *const API_getUserMsgList            = @"/user/getUserMsgList";/**< 获取用户消息列表 userId msgTypeId*/

static NSString *const API_saveUserAdviceInfo        = @"/user/saveUserAdviceInfo";/**< 用户建议和反馈 userId adviceContent linkmanTel screenResolution mobileModel userAddress*/

static NSString *const API_setUserMsgStatus          = @"/user/setUserMsgStatus";/**< 设置用户消息状态（已读状态） userId msgTypeId*/

static NSString *const API_getKeepCarInfo            = @"/user/getKeepCarInfo";/**< 获取养车信息 userId carId*/

static NSString *const API_getKeepPlanInfo           = @"/user/getKeepPlanInfo";/**< 获取保养计划信息 userId carId*/

static NSString *const API_getKeepHandbook           = @"/user/getKeepHandbook";/**< 获取保养手册信息 userId carId*/

static NSString *const API_getKeepProjectDetail      = @"/user/getKeepProjectDetail";/**< 获取保养项目详情 keepProjectId*/

static NSString *const API_saveTravelCard            = @"/user/saveTravelCard";/**< 保存行驶证信息 userId  carId frontIcon backIcon*/

static NSString *const API_getTravelCardInfo         = @"/user/getTravelCardInfo";/**< 获取行驶证信息 userId  carId */

static NSString *const API_getSignInfo               = @"/user/getSignInfo";/**< 获取签到信息 userId*/

static NSString *const API_sign                      = @"/user/sign";/**< 签到 userId*/

static NSString *const API_getOrderAddressList       = @"/user/getOrderAddressList";/**< 获取用户收货地址 userId */

static NSString *const API_saveUserAddress           = @"/user/saveUserAddress";/**< 保存用户收货地址 userId... */

static NSString *const API_deleteUserAddress         = @"/user/deleteUserAddress";/**< 	删除用户收货地址 userId... */

static NSString *const API_deleteUserMsg             = @"/user/deleteUserMsg";/**< 	删除用户消息 userId... msgId...*/


#pragma mark - alarm

static NSString *const API_qureyMain                 = @"/alarm/qureyMain";/**< 提醒设置一级栏目 userId*/

static NSString *const API_queryList                 = @"/alarm/queryList";/**< 查询提醒二级和三级栏目 userId warnId*/

static NSString *const API_updateAlert               = @"/alarm/updateAlert";/**< 提醒开启关闭 userId securityId 与 warnId state 填其中一个即可*/

static NSString *const API_updateVoiceAlert          = @"/alarm/updateVoiceAlert";/**< 更新语音提醒设置 userId securityId soundState */

static NSString *const API_sensLevel                 = @"/alarm/sensLevel";/**< 查看震动报警强度设置 userId*/

static NSString *const API_updateSensLevel           = @"/alarm/updateSensLevel";/**< 更新设置震动报警强度 userId sensLevel*/

static NSString *const API_getCarInsureAlert         = @"/alarm/getCarInsureAlert";/**< 获取车险提醒信息 userId carId*/



#pragma mark - dAnalysis

static NSString *const API_currentTrajectory         = @"/dAnalysis/currentTrajectory";/**< 当前驾驶轨迹 carBaseInfoId*/

static NSString *const API_travelRecord              = @"/dAnalysis/travelRecord";/**< 行程记录 carBaseInfoId pageNum*/

static NSString *const API_delTraverRecord           = @"/dAnalysis/delTraverRecord";/**< 删除行程记录 tripId*/

static NSString *const API_statistics                = @"/dAnalysis/statistics";/**< 数据统计 carBaseInfoId beginDate endDate */

static NSString *const API_carCurrentPlace           = @"/dAnalysis/carCurrentPlace";/**< 当前位置 carBaseInfoId */

static NSString *const API_footprint                 = @"/dAnalysis/footprint";/**< 我的足迹 carBaseInfoId beginDate endDate */

static NSString *const API_getTripGps                = @"/dAnalysis/getTripGps";/**< 获取行程的gps轨迹 carTripId */

static NSString *const API_flowMonitoring            = @"/dAnalysis/flowMonitoring";/**< 流量详情  carBaseInfoId*/



#pragma mark - car

static NSString *const API_getTripRecordByPage       = @"/car/getTripRecordByPage";/**< 获取里程数据列表 */

static NSString *const API_getTroubleCodeInfo        = @"/car/getTroubleCodeInfo";/**< 获取具体某天的故障码信息 */

static NSString *const API_getDevicesOnlineInfo      = @"/car/getDevicesOnlineInfo";/**< 查询设备在线信息 */

static NSString *const API_updateCarBrand            = @"/car/updateCarBrand";/**< 修改车牌号 */



#pragma mark - system

static NSString *const API_checkVerification         = @"/system/checkVerification";/**< 验证码验证 mobile code */

static NSString *const API_sendVerificationCode      = @"/system/sendVerificationCode";/**< 发送手机验证码 mobile:手机号 type:类型 （1：注册2：修改手机号，3：修改密码 4:找回密码 5:微信合并数据 6:微信绑定手机号） */

static NSString *const API_getWeatherData            = @"/system/getWeatherData";/**< 天气接口 city*/

static NSString *const API_updateApp                 = @"/system/updateApp";/**< 升级接口 */

static NSString *const API_sleepContact              = @"/system/sleepContact";/**< 智能终端失联心跳 deviceId */

static NSString *const API_getSysFaq                 = @"/system/getSysFaq";/**< 获取FAQ问题列表 faqType 问题类型（1：智能终端；2：车服务；3：车险；4：优惠券；5：通用问题）*/

static NSString *const API_uploadImg                 = @"/system/uploadImg";/**< 上传图片 userId imgStr */

static NSString *const API_getAdsInfoList            = @"/system/getAdsInfoList";/**< 获取公告 userId */

static NSString *const API_getHotList                = @"/system/getHotList";/**< 获取热门搜索 hotType 热门搜索类型，默认1 1：商家， 2:其他搜索*/

static NSString *const API_getObdUserList            = @"/system/getObdUserList";/**< 获取擎天助车友圈 */

static NSString *const API_refreshToken              = @"/system/refreshToken";/**< 刷新用户TOKEN */


#pragma mark - public

static NSString *const API_publicUrlAd               = @"/publicUrl/ad";/**< 首页bander页*/

static NSString *const API_getCustomerServiceInfo    = @"/publicUrl/getCustomerServiceInfo";/**< 获取客服信息 */

static NSString *const API_getShareInfo              = @"/publicUrl/getShareInfo";/**< 获取分享信息 shareCode WXDF:微信代付，QDHD:签到活动 */


#pragma mark - obdDevice

static NSString *const API_validateDevice            = @"/obdDevice/validateDevice";/**< 验证激活智能终端的接口 carBaseInfoId deviceId  devicePwd*/

static NSString *const API_activatedObd              = @"/obdDevice/activatedObd";/**< 激活智能终端 carBaseInfoId deviceId devicePwd VINcode */

static NSString *const API_showObdInfo               = @"/obdDevice/showObdInfo";/**< 智能终端管理 deviceId */

static NSString *const API_deleteObd                 = @"/obdDevice/deleteObd";/**< 注销智能终端 deviceId */

static NSString *const API_changeObd                 = @"/obdDevice/changeObd";/**< 更换智能终端 deviceId newDeviceId newDeviceIdPwd*/

static NSString *const API_saveExaminationInfo       = @"/obdDevice/saveExaminationInfo";/**< 保存体检结果 carBaseInfoId jsonReport */

static NSString *const API_examinationList           = @"/obdDevice/examinationList";/**< 体检报告 carBaseInfoId */

static NSString *const API_inspectionReportDetail    = @"/obdDevice/inspectionReportDetail";/**< 体检报告 reportId */

static NSString *const API_downLoadCarInfo           = @"/obdDevice/downLoadCarInfo";/**< 下载车辆配置文件 carBaseInfoId  deviceId devicePwd appId*/

static NSString *const API_clearTroubleCode          = @"/obdDevice/clearTroubleCode";/**< 一键清码 carBaseInfoId jsonStr */

static NSString *const API_advice                    = @"/obdDevice/advice";/**< 保存体检结果 inspectionId */

static NSString *const API_carTroubleCodes           = @"/obdDevice/carTroubleCodes";/**< 获取车辆故障码接口 */

static NSString *const API_obdDeviceEobdInfo         = @"/obdDevice/eobdInfo";/**< 获取车辆检测详情数据流接口 */

static NSString *const API_examinationDetail         = @"/obdDevice/examinationDetail";/**< 报告详情接口 */

static NSString *const API_obdDevice_lastExamination = @"/obdDevice/lastExamination";/**< 获取首页分数，故障码，体检时间 */

static NSString *const API_serverUpdateLoadCarInfo   = @"/obdDevice/serverUpdateLoadCarInfo";/**< 提示后台更新配置文件*/


static NSString *const API_checkupCar                = @"/checkup/checkupCar";/**< 郎人快速体检接口*/


#pragma mark - carserver

static NSString *const API_payOrderDetail            = @"/carServer/payOrderDetail";/**< Obd商品详情 */

static NSString *const API_createOBDOrder            = @"/carServer/createOBDOrder";/**< 创建购买obd订单 */

static NSString *const API_prepareOrderInfo          = @"/carServer/prepareOrderInfo";/**< 准备下单 */

static NSString *const API_createOrder               = @"/carServer/createOrder";/**< 创建订单 */

static NSString *const API_topShop                   = @"/carServer/topShop";/**< 获取top商家信息 */

static NSString *const API_getCarServerTypeList      = @"/carServer/getCarServerTypeList";/**< 获取车服务类型列表 servicesType */

static NSString *const API_getCarServerList          = @"/carServer/getCarServerList";/**< 获取车服务列表  */

static NSString *const API_getShopDetail             = @"/carServer/getShopDetail";/**< 获取商家详情 shopInfoId*/

static NSString *const API_getCarServerDetail        = @"/carServer/getCarServerDetail";/**< 获取车服务详情 serviceInfoId*/










#pragma mark - pay

static NSString *const API_createWXpayOrder          = @"/tmPay/createWXpayOrder";/**< 获取微信预支付基本信息 */

static NSString *const API_getAlipayInfo             = @"/tmPay/getAlipayInfo";/**< 获取支付宝支付基本信息 */

//static NSString *const API_bindOrderCoupon           = @"/pay/bindOrderCoupon";/**< 支付绑定优惠券 orderId coupontId status 1:绑定，0:解绑 */
static NSString *const API_weixinPay                 = @"/tmPay/weixinPay";/**< 微信代付 orderId*/


#pragma mark - inSure

static NSString *const API_insureDetail              = @"/inSure/insureDetail";/**< 创建保险订单 orderId*/

static NSString *const API_insurePayInfo             = @"/inSure/insurePayInfo";/**< 获取订单信息 orderId 订单ID  couponNo 优惠券编码 为空：返回优惠券可用数量 不为空，计算订单金额*/

static NSString *const API_bindCoupon                = @"/inSure/bindCoupon";/**< 绑定优惠券 orderId   couponNo*/

static NSString *const API_saveOrderImg              = @"/inSure/saveOrderImg";/**< 保存保单图片 orderNo idcardFrontImg idcardBackImg driveCardOriginalImg driveCardDuplicateImg*/

static NSString *const API_insureOrderImg            = @"/inSure/insureOrderImg";/**< 查看保单图片 orderNo idcardFrontImg idcardBackImg driveCardOriginalImg driveCardDuplicateImg*/

static NSString *const API_getCarInsure              = @"/inSure/getCarInsure";/**< 获取保险信息  userId carId*/

static NSString *const API_updateInsureEndTime       = @"/inSure/updateInsureEndTime";/**< 更新保险和保养信息  userId carId insureEndTime insureStartTime nowMileage fristRoadTime lastKeepTime lastKeepMileage*/





#pragma mark - activity

static NSString *const API_getActivityList           = @"/activity/getActivityList";/**< 查看活动信息接口 activityId 活动ID,有值查询单个活动信息   shopId 查询店铺所有活动 pageNum pageSize*/

static NSString *const API_searchShopInfo            = @"/shop/searchShopInfo";/**< 查看活动信息接口 activityId 活动ID,有值查询单个活动信息   searchValue 查询店铺所有活动 goodsTypeId  lng lat pageNum pageSize*/



#pragma mark - goods

static NSString *const API_getGoodsList              = @"/goods/getGoodsList";/**< 获取商品信息 shopId goodsTypeId searchValue orderBy 1：上架时间2：商品价格 3：销售数量 pageNum pageSize*/

static NSString *const API_goodscreateOrder          = @"/goods/createOrder";/**< 创建订单(礼品卡下单) userId  userMobile lng lat shopId 为空，系统订单 activityId goodsId*/




#pragma mark - order

static NSString *const API_getOrderStatus            = @"/order/getOrderStatus";/**< 获取订单状态（搜索状态） */

static NSString *const API_getOrderList              = @"/order/getOrderList";/**< 获取订单列表 userId status type 分页 */

static NSString *const API_getOrderDetail            = @"/order/getOrderDetail";/**< 获取订单详情 orderNo */

static NSString *const API_cancelOrder               = @"/order/cancelOrder";/**< 取消订单 order/cancelOrder orderId cancelMsg */

static NSString *const API_getOrderPayMode           = @"/order/getOrderPayMode";/**< 获取支付方式、配送方式 orderId */

static NSString *const API_order_createOrder         = @"/order/createOrder";/**< 创建订单(支持所有类型) */

static NSString *const API_commpleteTmOrder          = @"/order/commpleteTmOrder";/**< 商品确认收货 orderNo */

static NSString *const API_getOrderInfo              = @"/order/getOrderInfo";/**< 获取订单信息(收银台页面调用) orderNo couponNo*/

static NSString *const API_orderBindCoupon           = @"/order/bindCoupon";/**< 绑定优惠券 orderNo couponNo*/

static NSString *const API_confirmOrder              = @"/order/confirmOrder";/**< 保险确认订单 orderNo... */

static NSString *const API_reckonOrderPrice          = @"/order/reckonOrderPrice";/**< 选择优惠劵计算订单金额 couponNo... */

static NSString *const API_getOrderCouponList        = @"/order/getOrderCouponList";/**< 获取可使用(不可使用)的优惠券列表 couponNo... */




#pragma mark - comment

static NSString *const API_commentOrder              = @"/comment/commentOrder";/**< 评论订单 */

static NSString *const API_getShopCommentList        = @"/comment/getShopCommentList";/**< 获取店铺评论 shopInfoId serviceInfoId 分页*/









