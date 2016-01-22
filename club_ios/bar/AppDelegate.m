//
//  AppDelegate.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "AppDelegate.h"
#import "MobClick.h"
#import "BarTabBarController.h"
//微博设置sso
#import "UMSocialSinaSSOHandler.h"
//极光推送
#import "APService.h"
//友盟
#import "UMSocial.h"
#import "UMSocialWechatHandler.h"
#import "UMSocialQQHandler.h"
#import "UMCheckUpdate.h"
#import "UMSocialSinaHandler.h"



#import "GuideViewController.h"
#import "UserInfo.h"
#import "MyFile.h"
#import <CoreLocation/CoreLocation.h>
// 引用 融云IMKit 头文件。
#import <RongIMKit/RongIMKit.h>
#import "ConversationListViewController.h"
//判断网络
#import <Reachability.h>
#import <SMS_SDK/SMSSDK.h>
#import "GuideGOViewController.h"

//#define LOCATION userLocation.coordinate.longitude
//#define LOCATIONLAT userLocation.coordinate.latitude
//融云信息管理者
#import "RCDataManager.h"
//设置融云链接状态监听者
#import "settingViewController.h"

extern UserInfo*LoginUserInfo;
NSMutableArray *friendsAndRoucludUserInfoArray;
NSMutableArray *rouclubGroupInfoArray;
float fromLongitude;
float fromLatitude;
@interface AppDelegate ()<CLLocationManagerDelegate>
{
    CLLocationManager *_locationManager;//用于获取位置
    CLLocation *_checkLocation;//用于保存位置信息
    ASIFormDataRequest*  _requestRcloudToken;
    Response10002*response10002;
    ASIFormDataRequest*_requestRcuerInfo;
    ASIFormDataRequest*_request;
    NSString*userNameRcunInfo;
    NSString*userAvataRcunInfo;
    int rongTokenNum;
    
    //获取好友列表
    ASIFormDataRequest*_requestFriends;//获取好友列表
    Response10006*response10006;
    
    //获取群组成员信息
    ASIFormDataRequest *_reuqestGroup;
    Response11018*response11018;
    
    //获取群组信息
    ASIFormDataRequest *_requestGroupInfo;
    Response16009*response16009;
}
@end

@implementation AppDelegate
+(AppDelegate *)shareAppDelegate{
    
    static AppDelegate* appDelegate = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        appDelegate = [[[self class] alloc] init];
    });
    
    return appDelegate;
    
}
//t531w182209
//102515
#pragma mark 判断网络
-(BOOL) isConnectionAvailable{
    
    BOOL isExistenceNetwork = YES;
    Reachability *reach = [Reachability reachabilityWithHostName:@"www.apple.com"];
    switch ([reach currentReachabilityStatus]) {
        case NotReachable:
            isExistenceNetwork = NO;
            //NSLog(@"notReachable");
            break;
        case ReachableViaWiFi:
            isExistenceNetwork = YES;
            //NSLog(@"WIFI");
            break;
        case ReachableViaWWAN:
            isExistenceNetwork = YES;
            //NSLog(@"3G");
            break;
    }
    
    if (!isExistenceNetwork) {
        [[Tostal sharTostal]tostalMesg:@"无网络连接" tostalTime:2];
        return NO;
    }
    
    return isExistenceNetwork;
}



-(void)setupLocationManager{
    _locationManager = [[CLLocationManager alloc] init];
    
    if ([CLLocationManager locationServicesEnabled]) {
        NSLog(@"开始定位");
        _locationManager.delegate = self;
        // distanceFilter是距离过滤器，为了减少对定位装置的轮询次数，位置的改变不会每次都去通知委托，而是在移动了足够的距离时才通知委托程序
        // 它的单位是米，这里设置为至少移动1000再通知委托处理更新;
        _locationManager.distanceFilter = 200.0;
        // kCLLocationAccuracyBest:设备使用电池供电时候最高的精度
        _locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        //ios8+以上要授权，并且在plist文件中添加NSLocationWhenInUseUsageDescription，NSLocationAlwaysUsageDescription，值可以为空
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0) {//ios8+，不加这个则不会弹框
            [_locationManager requestWhenInUseAuthorization];//使用中授权
            [_locationManager requestAlwaysAuthorization];
        }
        [_locationManager startUpdatingLocation];
    }else{
        NSLog(@"定位失败，请确定是否开启定位功能");
    }
}
-(void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    NSLog(@"didUpdateToLocation+++");
    //此处locations存储了持续更新的位置坐标值，取最后一个值为最新位置，如果不想让其持续更新位置，则在此方法中获取到一个值之后让locationManager stopUpdatingLocation
    CLLocation *cl = [locations lastObject];
     fromLatitude = cl.coordinate.latitude;
     fromLongitude = cl.coordinate.longitude;
    NSLog(@"纬度--%f",cl.coordinate.latitude);//要的经度和纬度、
    NSLog(@"经度--%f",cl.coordinate.longitude);
 
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    [[UITabBar appearance] setShadowImage:[[UIImage alloc]init]];
    [[UITabBar appearance] setBackgroundImage:[[UIImage alloc]init]];
    LoginUserInfo=[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
    if (LoginUserInfo!=nil) {
        [self requestUrl];
    }
    
    NSLog(@"%@",NSHomeDirectory());
    //融云好友数组和聊天小组数组
    friendsAndRoucludUserInfoArray = [[NSMutableArray alloc] init];
    rouclubGroupInfoArray =[[NSMutableArray alloc] init];
    
    [SMSSDK registerApp:@"c633218a2940" withSecret:@"16516e5d9b2d34c09c88461b3471afc8"];
    _window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _window.backgroundColor = [UIColor whiteColor];
    [_window makeKeyAndVisible];
   
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
   //创建标签控制器
    [self isConnectionAvailable];
    
    //设置融云是否有声音提示
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger number2 = [userDefaultes integerForKey:@"_number2"];
    if (number2 == 0) {
        /**
         *  收到消息铃声处理。用户可以自定义新消息铃声，不实现SDK会处理。
         *
         *  @param message 收到的消息实体。
         *
         *  @return 返回NO，SDK处理铃声；返回YES，App自定义通知音，SDK不再播放铃音。
         */
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
    }else if(number2 == 1){
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
    }
    //集成融云
    [self _initRCIM];
    /**
     * 推送处理1
     */
    [self RCpush1:application];

    //设置定位
    [self setupLocationManager];
    //适配屏幕尺寸
    [self _judgementScreen];
    //集成友盟数据统计
    [self _initUmMobClick];
    
    //集成友盟分享
    [self _initUmSheare];
    //集成友盟自动更新
    [self _initUmCheckUpdate];
    
    //集成极光推送
    [self _initAddJpush:launchOptions];
    //微信支付
    [self WeiChatPay];
    //第一次调用
    [self isFirstOpen];
    
    //将数据库存入沙盒
    [self addDataBaseToSandBox];
    NSLog(@"%@",NSHomeDirectory());
    
    return YES;
}
#pragma mark-友盟自动更新第一步
- (void)_initUmCheckUpdate{
    [UMCheckUpdate checkUpdateWithAppkey:@"56443b13e0f55a9d3200117e" channel:response10002.data_p.downloadURL];
}

- (void)isFirstOpen{
    //第一次进入应用程序
    LoginUserInfo=[NSKeyedUnarchiver unarchiveObjectWithFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
    if (LoginUserInfo ==nil) {
        _window.rootViewController = [[GuideGOViewController alloc] init];
        NSLog(@"第一次进入应用程序");
        
    }else {
        //创建标签控制器
        BarTabBarController *tabBarController = [[BarTabBarController alloc] init];
        [_window setRootViewController:tabBarController];
        NSLog(@"第二次进入应用程序");
    }
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    [[UIApplication sharedApplication]setApplicationIconBadgeNumber:0];
}
//这个方法是在前台时候进的方法

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
    [application setApplicationIconBadgeNumber:0];
    [application cancelAllLocalNotifications];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
#pragma mark-友盟自动更新2
    [UMCheckUpdate checkUpdate:@"有新版本更新啦！" cancelButtonTitle:@"以后再说" otherButtonTitles:@"立即更新" appkey:@"56443b13e0f55a9d3200117e" channel:response10002.data_p.downloadURL];
    /*可选用一下方法自定义:友盟SDK默认取的APP version是Build号。
     callBackSelectorWithDictionary这个方法接收一个(NSDictionary *)类型的参数,是服务器传回来的app相关信息。*/
//     [UMCheckUpdate checkUpdateWithDelegate:(id)delegate selector:(SEL)callBackSelectorWithDictionary appkey:@"56443b13e0f55a9d3200117e" channel:
//     (NSString *)channel];
    
    //另外需要app网址和版本号在友盟官网进行配置,每一次更新版本都要去友盟官网修改版本号
//参考网址:http://www.iliunian.com/2619.html

}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
#pragma mark - 微信支付
- (void) WeiChatPay{
    [WXApi registerApp:@"wx2399e525fde53617" withDescription:@"weclub"];
}
#pragma mark - 配置微信支付和分享
- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url{
    if ([url.host isEqualToString:@"pay"]) {
        //微信支付
        return [WXApi handleOpenURL:url delegate:self];
    }else{
        //友盟分享
        return  [UMSocialSnsService handleOpenURL:url];
    }

}
-(void)requestUrl{
    Request10002*request=[[Request10002 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/login",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=10002;
    if (LoginUserInfo.user_pwd!=nil) {
    request.params.md5Psw=[HelperUtil md532BitUpper:LoginUserInfo.user_pwd ];//密码
    }
    request.params.account=LoginUserInfo.phoneNum;//账号
    NSLog(@"%@",LoginUserInfo.user_pwd);
    // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
    request.params.type=LoginUserInfo.loginType;
    request.params.otherId=LoginUserInfo.otherId;
    //
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=0;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
}
#pragma mark- 群组消息获取
-(void)requestGroupMessage:(NSString*)talekTeamId{
    Request11018*request=[[Request11018 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getTalkTeamUsers",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestGroup = [ASIFormDataRequest requestWithURL:url];
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=10002;
    request.params.talkTeamId=talekTeamId;
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSData*data= [request data];
    [_reuqestGroup setPostBody:(NSMutableData*)data];
    [_reuqestGroup setDelegate:self];
    //请求延迟时间
    _reuqestGroup.timeOutSeconds=0;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestGroup.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestGroup.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestGroup.secondsToCache=3600;
    [_reuqestGroup startAsynchronous];
}
#pragma mark- 获取群组信息
-(void)requestGroupInfo{
    Request16009*request=[[Request16009 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@rongyunAction/getUserTalkTeamInfo",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestGroupInfo = [ASIFormDataRequest requestWithURL:url];
    request.common.userid=LoginUserInfo.user_id;//已经传好
    NSLog(@"%@",LoginUserInfo.user_id);
    request.common.userkey= LoginUserInfo.user_key;
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=16009;//协议号
    //    request.params.talkTeamId=talekTeamId;
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSData*data= [request data];
    [_requestGroupInfo setPostBody:(NSMutableData*)data];
    [_requestGroupInfo setDelegate:self];
    //请求延迟时间
    _requestGroupInfo.timeOutSeconds=0;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestGroupInfo.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestGroupInfo.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestGroupInfo.secondsToCache=3600;
    [_requestGroupInfo startAsynchronous];
}

#pragma mark 获取我的好友列表
-(void)requestFriendList{
    Request10006*request10006=[[Request10006 alloc]init];
    //设置请求参数
    request10006.common.userid=LoginUserInfo.user_id;
    request10006.common.userkey=LoginUserInfo.user_key;
    request10006.common.timestamp=2;//现在标注为真数据
    request10006.common.version=@"1.0.0";//版本号
    request10006.common.platform=2;//ios  andriod
    request10006.common.cmdid=10006;
    NSData*data= [request10006 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getMyFriends",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestFriends = [ASIFormDataRequest requestWithURL:url];
    [_requestFriends setPostBody:(NSMutableData*)data];
    [_requestFriends setDelegate:self];
    //请求延迟时间
    _requestFriends.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestFriends.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestFriends.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestFriends.secondsToCache=3600;
    [_requestFriends startAsynchronous];
}

#pragma mark-完成网络请求
- (void)requestFinished:(ASIHTTPRequest *)request{
    //获取群组信息
    if ([request isEqual:_requestGroupInfo]) {
        response16009 = [Response16009 parseFromData:request.responseData error:nil];
        if (response16009.common.code!=0) {
            
        }else{
            NSLog(@"_________00000%ld",response16009.data_p.teaminfosArray.count);
            for (int i=0; i<response16009.data_p.teaminfosArray.count; i++) {
                //把请求下来的群组对象存入本地群组数组中
                TeamInfo *teamInfo = response16009.data_p.teaminfosArray[i];
                RCGroup *rcGroup = [[RCGroup alloc] initWithGroupId:teamInfo.talkTeamId groupName:teamInfo.talkTeamName portraitUri:teamInfo.talkTeamAvatarURL];
                [rouclubGroupInfoArray addObject:rcGroup];
                NSLog(@"%@",teamInfo.talkTeamId);
                NSLog(@"%@",teamInfo.talkTeamName);
                NSLog(@"%@",teamInfo.talkTeamAvatarURL);
                
            }
        }        
    }

    //获取群组成员信息
    if ([request isEqual:_reuqestGroup]) {
        Response11018*reponse11018 = [Response11018 parseFromData:request.responseData error:nil];
        if (reponse11018.common.code!=0) {
            
        }else{
            NSLog(@"%@",reponse11018.data_p.chatUsersArray);
        }
    }
    //获取好友信息
    if ([request isEqual:_requestFriends]) {
        response10006=[Response10006 parseFromData:request.responseData error:nil];
        for (int i=0; i<response10006.data_p.userAvatarAndNameArray.count; i++) {
            UserAvatarAndName*userAvatat=[response10006.data_p.userAvatarAndNameArray objectAtIndex:i];
            RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:userAvatat.userid name:userAvatat.username portrait:userAvatat.avatar];
            [friendsAndRoucludUserInfoArray addObject:userInfo];
        }
    }
    
    if ([request isEqual:_request]) {
        response10002 = [Response10002 parseFromData:request.responseData error:nil];
        if (response10002.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response10002.common.message tostalTime:1];
        }else{
            UserInfo*user=[[UserInfo alloc]init];
            user.user_id=response10002.data_p.userid;
            NSLog(@"%@",user.user_id);
            user.user_name=response10002.data_p.name;
            user.user_key=response10002.data_p.key;
            NSLog(@"%@",response10002.data_p.key);
            user.user_sex=response10002.data_p.sex;
            user.sessionkey=response10002.data_p.sessionkey;
            user.rongYunTOken=response10002.data_p.rongyunToken;
            // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
            user.loginType=response10002.data_p.type;
              user.otherId=LoginUserInfo.otherId;
            user.phoneNum=LoginUserInfo.phoneNum;
            user.user_pwd=LoginUserInfo.user_pwd;
            user.user_head=response10002.data_p.avatarurl;
            LoginUserInfo=user;
            [NSKeyedArchiver archiveRootObject:user toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
            NSLog(@"%@",LoginUserInfo.user_id);
            NSString*str=[LoginUserInfo.user_id stringByReplacingOccurrencesOfString:@"-" withString:@""];
            [APService setTags:nil alias:str callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"geilaozishuaxinyaoyue" object:nil];
            //这里是写一个字典判断今天是否登录过,保证一个静默登录
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            NSLog(@"%@",dateString);
            NSMutableDictionary*dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:dateString forKey:@"weclub"];
            [dictionary writeToFile:[MyFile fileByDocumentPath:@"loginIsOk.plist"] atomically:YES];
            //获取好友列表
            [self requestFriendList];
            //获取群组信息
            [self requestGroupInfo];
        }
     }
    
    if ([request isEqual:_requestRcloudToken]) {
        Response11014*responser11014=[Response11014 parseFromData:request.responseData error:nil];
        if (responser11014.common.code==0) {
            LoginUserInfo.rongYunTOken=responser11014.data_p.token;
             [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
        }
    }
    
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation{
    
    
    NSLog(@"Calling Application Bundle ID: %@", sourceApplication);
    NSLog(@"URL scheme:%@", [url scheme]);
    NSLog(@"URL query: %@", [url query]);
    NSLog(@"%@",url);
    
    
    
    
    if ([url.host isEqualToString:@"pay"]) {
        //微信支付
         return [WXApi handleOpenURL:url delegate:self];
    }else{
        //友盟分享
        [[NSNotificationCenter defaultCenter]postNotificationName:@"requestInviteDes" object:nil];
        return  [UMSocialSnsService handleOpenURL:url];
    }
}
//onReq是微信终端向第三方程序发起请求，要求第三方程序响应。第三方程序响应完后必须调用sendRsp返回。在调用sendRsp返回时，会切回到微信终端程序界面。
-(void) onReq:(BaseReq*)req{
    
    
    
}
//如果第三方程序向微信发送了sendReq的请求，那么onResp会被回调。sendReq请求调用后，会切到微信终端程序界面。
-(void) onResp:(BaseResp*)resp{
    
    
}
//如果你的程序要发消息给微信，那么需要调用WXApi的sendReq函数：
//其中req参数为SendMessageToWXReq类型。
//需要注意的是，SendMessageToWXReq的scene成员，如果scene填WXSceneSession，那么消息会发送至微信的会话内。如果scene填WXSceneTimeline，那么消息会发送至朋友圈。如果scene填WXSceneFavorite,那么消息会发送到“我的收藏”中。scene默认值为WXSceneSession。
-(BOOL) sendReq:(BaseReq*)req{
    
    return YES;
}

#pragma mark - 屏幕适配
- (void)_judgementScreen{
    //  程序启动的时候进行对屏幕大小的判断，获取伸缩比例
//    if(KScreenHeight > 568){
//        self.autoSizeScaleX = KScreenWidth/320;
//        self.autoSizeScaleY = KScreenHeight/568;
//    } else if(KScreenHeight == 568){
//        self.autoSizeScaleX = 1.0;
//        self.autoSizeScaleY = 1.0;
//    }else{
//        self.autoSizeScaleX = KScreenWidth/320;
//        self.autoSizeScaleY = KScreenHeight/568;
//    }
    if (KScreenWidth==375) {
        self.autoSizeScaleX = 1.0;
        self.autoSizeScaleY = 1.0;
    }else if(KScreenWidth < 375){
        self.autoSizeScaleX = KScreenWidth/375;
        self.autoSizeScaleY = KScreenHeight/667;
        
    }else if(KScreenWidth > 375){
        self.autoSizeScaleX = KScreenWidth/375;
        self.autoSizeScaleY = KScreenHeight/667;
    }
}
//屏幕适配
+ (void)matchAllScreenWithView:(UIView *)allView
{
    for (UIView * tmpView in allView.subviews)
    {
        tmpView.frame = CGRectMake1(tmpView.frame.origin.x, tmpView.frame.origin.y, tmpView.frame.size.width, tmpView.frame.size.height);
        [self matchAllScreenWithView:tmpView];
    }
}
CG_INLINE CGRect
CGRectMake1(CGFloat x, CGFloat y, CGFloat width, CGFloat height)
{
    AppDelegate *myDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    CGRect rect;
    rect.origin.x = x * myDelegate.autoSizeScaleX;
    rect.origin.y = y * myDelegate.autoSizeScaleY;
    rect.size.width = width * myDelegate.autoSizeScaleX;
    rect.size.height = height * myDelegate.autoSizeScaleY;
    return rect;
}

#pragma mark - 友盟统计和分享
//集成友盟数据统计
- (void) _initUmMobClick{
    [MobClick startWithAppkey:@"56443b13e0f55a9d3200117e" reportPolicy:BATCH channelId:nil];
}
//集成友盟分享
- (void) _initUmSheare{
//    由于苹果审核政策需求，建议大家对未安装客户端平台进行隐藏，在设置QQ、微信AppID之后调用下面的方法，[UMSocialConfig hiddenNotInstallPlatforms:@[UMShareToQQ, UMShareToQzone, UMShareToWechatsession, UMShareToWechatTimeline]]; 这个接口只对默认分享面板平台有隐藏功能，自定义分享面板或登录按钮需要自己处理
    //设置友盟appkey
    [UMSocialData setAppKey:@"56443b13e0f55a9d3200117e"];
    //设置微信AppId、appSecret，分享url
    [UMSocialWechatHandler setWXAppId:@"wx2399e525fde53617" appSecret:@"db426a9829e4b49a0dcac7b4162da6b6" url:@"http://www.umeng.com/social"];
    //设置分享到QQ/Qzone的应用Id，和分享url 链接,URL必须为http链接，如果设置为nil则默认为友盟官网链接
    //为什么我的真机不能测试??
    [UMSocialQQHandler setQQWithAppId:@"1104966952" appKey:@"hHzhqRsZ36z6DZS6" url:@"http://www.umeng.com/social"];
    //这个是原声的sdk
    [UMSocialSinaSSOHandler openNewSinaSSOWithAppKey:@"2556945589" RedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
    //非原生的微博sdk  用的是友盟的
    [UMSocialSinaHandler openSSOWithRedirectURL:@"http://sns.whalecloud.com/sina2/callback"];
 
}
#pragma mark - 极光推送
//集成极光推送
- (void) _initAddJpush:(NSDictionary *)lunchOptions{
    //区分开发环境和生产环境,需要配置开发者证书,还需要配置PushConfig.list文件的appkey
    // Required
#if __IPHONE_OS_VERSION_MAX_ALLOWED > __IPHONE_7_1
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //categories
        [APService
         registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |UIUserNotificationTypeSound |UIUserNotificationTypeAlert)
         categories:nil];
    } else {
        //categories nil
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |          UIRemoteNotificationTypeSound |           UIRemoteNotificationTypeAlert)
#else
         //categories nil
         categories:nil];
        [APService
         registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |         UIRemoteNotificationTypeSound |        UIRemoteNotificationTypeAlert)
#endif
         // Required
         categories:nil];
    }
    [APService setupWithOption:lunchOptions];
    
    
}

- (void)application:(UIApplication *)application
didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    // Required
    [APService registerDeviceToken:deviceToken];
    NSLog(@"%@",deviceToken);
    /**
     * 融云推送处理3
     */
    [self RCpush3:deviceToken];
    // 设置 deviceToken。
    NSString *deviceTokenString = [[NSString alloc] initWithData:deviceToken encoding:NSUTF8StringEncoding];
    [[RCIMClient sharedRCIMClient] setDeviceToken:deviceTokenString];
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo {
    // Required
    [APService handleRemoteNotification:userInfo];
}
- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void
                        (^)(UIBackgroundFetchResult))completionHandler {
    
    [APService handleRemoteNotification:userInfo];
    completionHandler(UIBackgroundFetchResultNewData);
    
}

#pragma mark- 融云相关
- (void) _initRCIM{
    //初始化 SDK，传入 App Key，deviceToken 暂时为空，等待获取权限。
    //初始化融云SDK。
    [[RCIM sharedRCIM] initWithAppKey:@"x18ywvqf80umc"];
    //登录融云
    [[RCDataManager shareManager] loginRongCloud];
    
    //设置用户信息提供者。
    [[RCIM sharedRCIM] setUserInfoDataSource:[RCDataManager shareManager]];
    [[RCIM sharedRCIM] setGroupInfoDataSource:[RCDataManager shareManager]];
    //接收消息的监听器
    RCIM *rcim = [RCIM sharedRCIM];
    //IMKit消息接收的监听器
    rcim.receiveMessageDelegate = [RCDataManager shareManager];
    //链接状态监听
    rcim.connectionStatusDelegate = [settingViewController shareSetting];
    
}
-(void)requestRcloudToken{
    Request11014*request=[[Request11014 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getRongyunToken",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestRcloudToken = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=10002;
    request.common.userkey=LoginUserInfo.user_key;
    request.params.tokenCannotUse=1;
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSData*data= [request data];
    [_requestRcloudToken setPostBody:(NSMutableData*)data];
    [_requestRcloudToken setDelegate:self];
    //请求延迟时间
    _requestRcloudToken.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestRcloudToken.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestRcloudToken.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestRcloudToken.secondsToCache=3600;
    [_requestRcloudToken startAsynchronous];
    //（2）创建manager
}
/**
 * 推送处理1
 */
- (void)RCpush1:(UIApplication *)application{
    if ([application
         respondsToSelector:@selector(registerUserNotificationSettings:)]) {
        UIUserNotificationSettings *settings = [UIUserNotificationSettings
                                                settingsForTypes:(UIUserNotificationTypeBadge |
                                                                  UIUserNotificationTypeSound |
                                                                  UIUserNotificationTypeAlert)
                                                categories:nil];
        [application registerUserNotificationSettings:settings];
    } else {
        UIRemoteNotificationType myTypes = UIRemoteNotificationTypeBadge |
        UIRemoteNotificationTypeAlert |
        UIRemoteNotificationTypeSound;
        [application registerForRemoteNotificationTypes:myTypes];
    }
}

/**
 * 推送处理2
 */
//注册用户通知设置
- (void)application:(UIApplication *)application
didRegisterUserNotificationSettings:
(UIUserNotificationSettings *)notificationSettings {
    // register to receive notifications
    [application registerForRemoteNotifications];
}
/**
 * 融云推送处理3
 */
- (void)RCpush3:(NSData *)deviceToken{
    NSString *token =
    [[[[deviceToken description] stringByReplacingOccurrencesOfString:@"<"
                                                           withString:@""]
      stringByReplacingOccurrencesOfString:@">"
      withString:@""]
     stringByReplacingOccurrencesOfString:@" "
     withString:@""];
    
    [[RCIMClient sharedRCIMClient] setDeviceToken:token];
}
#pragma mark - 设置用户头像,昵称,用户id
#ifdef __IPHONE_8_0
- (void)application:(UIApplication *)application handleActionWithIdentifier:(NSString *)identifier forRemoteNotification:(NSDictionary *)userInfo completionHandler:(void(^)())completionHandler
{
    // Handle the actions.
    if ([identifier isEqualToString:@"declineAction"]){
    }
    else if ([identifier isEqualToString:@"answerAction"]){
    }
}
#endif
-(void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    
}

#pragma mark - 是否允许通知提醒
 /**
   2  *  check if user allow local notification of system setting
   3  *
   4  *  @return YES-allowed,otherwise,NO.
   5  */
+ (BOOL)isAllowedNotification {
    //iOS8 check if user allow notification
     if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {// system is iOS8
         UIUserNotificationSettings *setting = [[UIApplication sharedApplication] currentUserNotificationSettings];
         if (UIUserNotificationTypeNone != setting.types) {
             return YES;
         }
    } else {//iOS7
         UIRemoteNotificationType type = [[UIApplication sharedApplication] enabledRemoteNotificationTypes];
         if(UIRemoteNotificationTypeNone != type)
             return YES;
     }
    
     return NO;
 }
//把数据库加入沙盒中
-(void)addDataBaseToSandBox{
    //在用户第一次进入项目的时候，将数据库拷贝到沙盒中
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    //获取程序包的路径
    NSString *fromPath = [[NSBundle mainBundle] pathForResource:@"DB_RongCloud.sqlite" ofType:nil];
    //获取目标路径
    NSString *toPath = [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DB_RongCloud.sqlite"];
    NSLog(@"%@",toPath);
    
    //判断toPath是否存在myData.sqlite
    if (![fileManager fileExistsAtPath:toPath]) {
        [fileManager copyItemAtPath:fromPath toPath:toPath error:nil];
    }else{
        
    }
}

@end
