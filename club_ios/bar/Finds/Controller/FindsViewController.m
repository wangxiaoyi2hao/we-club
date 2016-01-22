//
//  FindsViewController.m
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FindsViewController.h"
#import "InviteTableViewCell.h"
#import "AppDelegate.h"
#import "TestViewController.h"
#import "InviteSetViewController.h"
#import "SignUpListViewController.h"
#import "Common.pbobjc.h"
#import "GPBMessage.h"
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
#import "ReportViewController.h"
#import "Tostal.h"
#import "selfViewController.h"
#import "UMSocial.h"
#import "HostViewController.h"
#import "UserInfo.h"
#import "InfoTableViewController.h"
#import "LookUpImageViewController.h"
#import "BarTabBarController.h"
#import "InviteViewControllerComplete.h"
#import "MpaViewController.h"
#import "LookForWeclubViewController.h"
#import "HorizontalMenuView.h"
#import "ProtectFindViewController.h"
//发布邀约新界面
#import "InviteCompleteViewController.h"
#import "ChooseInviteVC.h"




extern UserInfo*LoginUserInfo;
static FindsViewController *singleInstance;
extern float fromLongitude;
extern float fromLatitude;
@interface FindsViewController ()<findsViewDelegate,ASIHTTPRequestDelegate,UMSocialUIDelegate,HorizontalMenuProtocol>
{
    ASIFormDataRequest *_requestInvite;
    ASIFormDataRequest*_requestCollect;
    Response12001*response;
    ASIFormDataRequest*_requestNextPage;
    int onePageNum;
    float fromArea;
    int fromCount;
    //这个才是邀约的数据
    NSMutableArray*findsArray;
    NSString*dayDate;
    //动态计算lable高宽大小
    int isSelectAllPage;
    
    //网格视图
    NSMutableArray *_mArray;
    int _index;
    UICollectionView *_collectionView;
    ASIFormDataRequest*_requestRcloudToken;
    
    int rongRunNum;

}
@end

@implementation FindsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  
    _tableView.showsVerticalScrollIndicator=NO;
    fromArea=0;
    [AppDelegate matchAllScreenWithView:self.view];
    [AppDelegate matchAllScreenWithView:_tableView];
    [self loadNav];
    //融云登录服务器
    [self loginRC];
    [_tableView addFooterWithTarget:self action:@selector(refreshFootLoadMoreData)];
    [_tableView addHeaderWithTarget:self action:@selector(requestSearchFriend)];
    [_tableView headerBeginRefreshing];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText =@"正在帮您加载中";
    _tableView.headerPullToRefreshText=@"下拉可以加载更多数据";
    _tableView.headerReleaseToRefreshText=@"松开马上加载更多数据了";
    _tableView.headerRefreshingText=@"宝宝正在加载中";
    [[Tostal sharTostal]showLoadingView:@"正在加载数据"];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(loadThisVIewFindInview) name:@"refreshInvite" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(presetNextController) name:@"tiaozhuan" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(helloModeHaHa) name:@"requestInviteDes" object:nil];
    _tableView.tableHeaderView=_headerView;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(chooseInviteChangeAction:) name:@"chooseInviteNotification" object:nil];
}
//接收通知
- (void)chooseInviteChangeAction:(NSNotification *)notification {
    
    NSLog(@"changeAction:%@",notification.userInfo);
    //取得传递的数据
    NSDictionary *dic = notification.userInfo;
    NSLog(@"changeAction:%@",dic);
    
}
//这里面试发通知之后需要的请求事
-(void)helloModeHaHa{




}
- (void)getTag:(NSInteger)tag{

    NSLog(@"%li",tag);
}//获取当前被选中下标值
-(void)presetNextController{
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    [self presentViewController:controller animated:YES completion:nil];

}
-(void)loadThisVIewFindInview{

    [_tableView headerBeginRefreshing];


}
-(void)viewWillAppear:(BOOL)animated{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;

}
-(void)viewDidAppear:(BOOL)animated{
    
  
    [super viewWillAppear:YES];
    //取得标签栏
    UITabBar *tabbar = self.navigationController.tabBarController.tabBar;
    //1.移除系统默认生成的item
    //    NSLog(@"tabbar.subviews:%@",tabbar.subviews);
    for (UIView *subView in tabbar.subviews) {
        //将string->class
        Class class = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:class]) {
            [subView removeFromSuperview];
        }
    }
}
-(void)requestRcloudToken{
    Request11014*request=[[Request11014 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getRongyunToken",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestRcloudToken = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=10002;
    request.common.userkey=LoginUserInfo.user_key;
    NSLog(@"%@",LoginUserInfo.user_key);
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

- (void)loginRC{
    
    NSLog(@"%@",LoginUserInfo.rongYunTOken);
    // 快速集成第二步，连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:LoginUserInfo.rongYunTOken success:^(NSString *userId) {
        // Connect 成功
        NSLog(@"链接融云成功");
        
    }
                                  error:^(RCConnectErrorCode status) {
                                      NSLog(@"链接融云失败");
                                      rongRunNum++;
                                      if (rongRunNum<=3) {
                                        [self requestRcloudToken];
                                      }
                                  
                                  }
                         tokenIncorrect:^() {
                             if (rongRunNum<=3) {
                                 [self requestRcloudToken];
                             }
                             rongRunNum++;
                             NSLog(@"token失效");
                             // Token 失效的状态处理
                         }];
}
#pragma mark  获取邀约列表
-(void)requestSearchFriend{
    findsArray=nil;
    findsArray=[NSMutableArray array];

    Request12001*request12001=[[Request12001 alloc]init];
    //设置请求参数
    request12001.common.userid=LoginUserInfo.user_id;
    request12001.common.userkey=LoginUserInfo.user_key;
    NSLog(@"%@",LoginUserInfo.user_key);
    request12001.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12001.common.version=@"1.0.0";//版本号
    request12001.common.platform=2;//ios  andriod
    request12001.common.cmdid=12001;
#pragma  mark  这里还要处理
    request12001.params.latitude=fromLatitude;//创建人所在的纬度
    request12001.params.longitude=fromLongitude;//创建人所在的经度
//    request12001.params.lastid=@"";
    request12001.params.totleCount=fromCount;
    request12001.params.area=fromArea;
    //下面还可能有上传图片的内容
    NSData*data= [request12001 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/getInvites",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestInvite = [ASIFormDataRequest requestWithURL:url];
    [_requestInvite setPostBody:(NSMutableData*)data];
    [_requestInvite setDelegate:self];
    //请求延迟时间
    _requestInvite.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestInvite.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestInvite.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestInvite.secondsToCache=3600;
    [_requestInvite startAsynchronous];
    
}
#pragma mark 分页
-(void)refreshFootLoadMoreData{
    fromCount+=20;
    Request12001*request12001=[[Request12001 alloc]init];
    //设置请求参数
    request12001.common.userid=LoginUserInfo.user_id;
    request12001.common.userkey=LoginUserInfo.user_key;
    request12001.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12001.common.version=@"1.0.0";//版本号
    request12001.common.platform=2;//ios  andriod
    request12001.common.cmdid=12001;
#pragma  mark  这里还要处理
    request12001.params.latitude=fromLatitude;//创建人所在的纬度
    request12001.params.longitude=fromLongitude;//创建人所在的经度
    ClubInvite*clubOO=[findsArray lastObject];
        request12001.params.lastid=clubOO.inviteId;
    NSLog(@"%@",clubOO.inviteId);
    request12001.params.totleCount=fromCount;
    request12001.params.area=fromArea;
    
    //下面还可能有上传图片的内容
    NSData*data= [request12001 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/getInvites",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestInvite = [ASIFormDataRequest requestWithURL:url];
    [_requestInvite setPostBody:(NSMutableData*)data];
    [_requestInvite setDelegate:self];
    //请求延迟时间
    _requestInvite.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestInvite.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestInvite.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestInvite.secondsToCache=3600;
    [_requestInvite startAsynchronous];  
}
-(void)requestCollect{
    Request12007*request12007=[[Request12007 alloc]init];
    //设置请求参数
    request12007.common.userid=LoginUserInfo.user_id;
    request12007.common.userkey=LoginUserInfo.user_key;
    request12007.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12007.common.version=@"1.0.0";//版本号
    request12007.common.platform=2;//ios  andriod
    request12007.common.cmdid=12007;
#pragma  mark  这里还要处理
    //下面还可能有上传图片的内容
    NSData*data= [request12007 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/collectInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestCollect = [ASIFormDataRequest requestWithURL:url];
    [_requestCollect setPostBody:(NSMutableData*)data];
    [_requestCollect setDelegate:self];
    //请求延迟时间
    _requestCollect.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestCollect.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestCollect.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestCollect.secondsToCache=3600;
    [_requestCollect startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestInvite]) {
       response=[Response12001 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response.common.message tostalTime:1];
        }
        
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        NSLog(@"%@",response.data_p.invitesArray);//返回的属性
        for (int i=0; i< response.data_p.invitesArray.count; i++) {
            ClubInvite*clubFor=[response.data_p.invitesArray objectAtIndex:i];
            [findsArray addObject:clubFor];
        }
        [_tableView headerEndRefreshing];
        [_tableView footerEndRefreshing];
    }
    if ([request isEqual:_requestCollect]) {
        Response12007*response12007=[Response12007 parseFromData:request.responseData error:nil];
        if (response12007.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
        }else{
            [[Tostal sharTostal]tostalMesg:@"收藏成功" tostalTime:1];
        }
    }
    
    if ([request isEqual:_requestRcloudToken]) {
        Response11014*responser11014=[Response11014 parseFromData:request.responseData error:nil];
        if (responser11014.common.code==0) {
            LoginUserInfo.rongYunTOken=responser11014.data_p.token;
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
            if (rongRunNum<=3) {
                [self loginRC];
            }
            
        }
    }

      [[Tostal sharTostal]hiddenView];
      [_tableView reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];

}
-(void)viewDidDisappear:(BOOL)animated{

    [_requestCollect clearDelegatesAndCancel];
    [_requestInvite clearDelegatesAndCancel];
    self.tabBarController.hidesBottomBarWhenPushed=YES;

}
#pragma mark 导航条的配置
-(void)loadNav{
    UIImageView*imageTitle=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/3.5,14, 70, 18)];
    //    imageTitle.a
    [imageTitle setImage:[UIImage imageNamed:@"logo_1.png"]];
    UIView*titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    [titleView addSubview:imageTitle];
    self.navigationItem.titleView = titleView;
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"] forBarMetrics: UIBarMetricsDefault];
    UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
//    [btn setBackgroundImage:[UIImage imageNamed:@"1-1-1.png"] forState:UIControlStateNormal];
    [btn setImage:[UIImage imageNamed:@"icon_fabu.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 20)];
//    [leftButton setBackgroundImage:[UIImage imageNamed:@""]forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"icon_choose.png"] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftClickButTON) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftItem;
}

#pragma MARK  点击左边的按钮的事件，以后每个页面这个东西都不消失
-(void)leftClickButTON{
    ChooseInviteVC*controller=[[ChooseInviteVC alloc]init];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}
-(void)findsDidSelectFefresh:(UIViewController *)controller{


     //网络请求刷新tableview

}
-(void)rightClick{

    
    InviteViewControllerComplete*controller=[[InviteViewControllerComplete alloc]init];
    controller.hidesBottomBarWhenPushed=YES;

    [self.navigationController pushViewController:controller animated:YES];
    


}
//头视图高度～～
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{


    return 0.0000000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;

    
        return 329*app.autoSizeScaleY;
//    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return findsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    InviteTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"InviteTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    ClubInvite*invite;
    NSLog(@"%@",invite);
    if (findsArray.count!=0) {
        invite =[findsArray objectAtIndex:indexPath.row];
    }
     cell.mutableArray = invite.invitePicArray;
    if ([invite.briefUser.userid isEqualToString:LoginUserInfo.user_id])
    {
        [cell.imageSIGN setImage:[UIImage imageNamed:@"管理.png"]];
    }
    cell.lbAddress.text=invite.inviteLocation;
    cell.lbHeart.text=[HelperUtil isDefault:invite.briefUser.signature];
    if (invite.briefUser.sex==1) {
    [cell.sexImageView setImage:[UIImage imageNamed:@"邀约-男性.png"]];
    }else{
    [cell.sexImageView setImage:[UIImage imageNamed:@"icon_girl.png"]];
    }
    if (invite.hasMoney==2) {
        cell.lbHongBaoMoney.hidden=NO;
        cell.lbHongBaoMoney.text=[NSString stringWithFormat:@"%i/%i小时",invite.payMoney,invite.during/60];
        cell.redPacketImageView.hidden=NO;
//        cell.iconImageView.layer.borderWidth = 3;//边框线宽度
//        cell.iconImageView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:66/255.0 blue:108/255.0 alpha:1.0].CGColor;
    }else{
        cell.lbHongBaoMoney.hidden=YES;
        cell.redPacketImageView.hidden=YES;
    }
 
    //1AA制 2我请客 3男生请客 4待定
    if (invite.payWay==1) {
    //1AA制
         cell.manQingKe.hidden=YES;
    }else if (invite.myState==2){
    //2我请客
        cell.manQingKe.hidden=YES;
    }else if (invite.myState==3){
    //男生请客
        cell.manQingKe.hidden=NO;
    }else if (invite.myState==4){
    //待定
        cell.manQingKe.hidden=YES;
    }
    
    if (invite.justFemale==1) {
       cell._imageGirl.hidden=NO;
    }else{
       cell._imageGirl.hidden=YES;
    }
   
    //应该还有一个支付方式的地方
    cell.lbSignUp.text=[NSString stringWithFormat:@"报名（%i）",invite.signUpCount];
    if (fromLongitude!=0) {
        cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.2fkm｜%i分钟",[MyFile meterKiloHaveHowLong:fromLongitude wei: fromLatitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]/1000,[self intervalSinceNow:invite.createTime]];
        NSLog(@"%f,%f",LoginUserInfo.longitude,LoginUserInfo.latitude);
    }else{
        cell.lbDistanceAndMintues.text=@"";
    }
    cell.lbName.text=invite.briefUser.username;
    if ([self intervalSinceNow:invite.createTime]==0) {
       cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.2fkm｜1%@前",[MyFile meterKiloHaveHowLong:LoginUserInfo.longitude wei:LoginUserInfo.latitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]/1000,dayDate];
    }else{
       cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.2fkm｜%i%@前",[MyFile meterKiloHaveHowLong:LoginUserInfo.longitude wei:LoginUserInfo.latitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]/1000,[self intervalSinceNow:invite.createTime],dayDate];
    }
 
    NSLog(@"%@",invite.createTime);
    cell.lbTime.text=invite.startTime;
    NSLog(@"%@",invite.startTime);
    NSLog(@"%i",[self intervalSinceNow:invite.createTime]);
    [cell._buttonSignUp addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
    cell._buttonSignUp.tag=indexPath.row;
    [cell._buttonMyInvite addTarget:self action:@selector(MyInviteClick) forControlEvents:UIControlEventTouchUpInside];
    [cell._buttonReport addTarget:self action:@selector(ReportClick:)
                 forControlEvents:UIControlEventTouchUpInside];
    cell._buttonReport.tag=indexPath.row;
    [cell._buttonShare addTarget:self action:@selector(sheraToAnyPeson:) forControlEvents:UIControlEventTouchUpInside];
    cell._buttonShare.tag=indexPath.row;
     cell._buttonUser.tag=indexPath.row;
    [cell._buttonUser addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",invite.briefUser.avatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    //查看大图
    [cell.buttonAll addTarget:self action:@selector(inviteAll:) forControlEvents:UIControlEventTouchUpInside];
    [cell.lookImage1.imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",[invite.invitePicArray objectAtIndex:0]]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    [invite.invitePicArray objectAtIndex:0];
    NSLog(@"%@", [invite.invitePicArray objectAtIndex:0]);
    cell.buttonAll.tag=indexPath.row;
    NSLog(@"%@",invite.invitePicArray);
    cell.lbtitle.text=invite.description_p;
    if (KScreenHeight==480) {
        if (cell.lbtitle.text.length<10) {
            cell.buttonAll.hidden=YES;
        }
    }
    if (KScreenHeight==568) {
        if (cell.lbtitle.text.length<17) {
            cell.buttonAll.hidden=YES;
        }
    }
    if (KScreenHeight==667) {
        if (cell.lbtitle.text.length<21) {
            cell.buttonAll.hidden=YES;
        }
    }
    if (KScreenHeight>667) {
        if (cell.lbtitle.text.length<30) {
            cell.buttonAll.hidden=YES;
        }
    }
    if (invite.isSelected==1) {
        UIFont *font=[UIFont systemFontOfSize:12];
        CGRect rect=[invite.description_p boundingRectWithSize:CGSizeMake(232*(KScreenWidth/320), 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil];
        [cell.lbtitle setFrame:CGRectMake(40*(KScreenWidth/320), 124*(KScreenHeight/568), rect.size.width, rect.size.height)];
        [cell.changeView setFrame:CGRectMake(30*(KScreenWidth/320), rect.size.height+cell.lbtitle.frame.origin.y+10, 200*(KScreenWidth/320), 144.5*(KScreenHeight/568))];
        [cell.verticalView setFrame:CGRectMake(29*(KScreenWidth/320), 77*(KScreenHeight/568), 1, 218+cell.lbtitle.frame.origin.y-30)];
        [cell.buttonAll setTitle:@"收起" forState:UIControlStateNormal];
    }else{
        [cell.buttonAll setTitle:@"全文" forState:UIControlStateNormal];
    }
        [cell.buttonAround addTarget:self action:@selector(buttonAroundClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonAround.tag=indexPath.row;
    return cell;
    
}
-(void)buttonAroundClick:(UIButton*)sender{
    MpaViewController*controller=[[MpaViewController alloc]init];
    ClubInvite* invite =[findsArray objectAtIndex:sender.tag];
    controller.barAddress=invite.inviteLocation;
    NSLog(@"%@",invite.inviteLocation);
    
    controller.barCity=invite.inviteLocation;
    [self.navigationController pushViewController:controller animated:YES];
}
//计算时间－－从当前时间计算时间
- (int)intervalSinceNow: (NSString *) theDate
{
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *d=[date dateFromString:theDate];
    NSTimeInterval late=[d timeIntervalSince1970]*1;
    NSDate* dat = [NSDate dateWithTimeIntervalSinceNow:0];
    NSTimeInterval now=[dat timeIntervalSince1970]*1;
    NSString *timeString=@"";
    NSTimeInterval cha=now-late;
    if (cha/86400>1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
        dayDate=@"天";
        return [timeString intValue];
    }
    if (cha/3600<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        timeString = [timeString substringToIndex:timeString.length-7];
          dayDate=@"分钟";
        return [timeString intValue];
    }
    if (cha/3600>1&&cha/86400<1)
    {
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        timeString = [timeString substringToIndex:timeString.length-7];
         dayDate=@"小时";
        return [timeString intValue];
    }
    return -1;
}

-(void)inviteAll:(UIButton*)sender{
    ClubInvite*invite=[findsArray objectAtIndex:sender.tag];
    if (invite.isSelected==0) {
       invite.isSelected=1;
    }else{
       invite.isSelected=0;
    }
    [_tableView reloadData];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    
    
}
//点击用户头像跳转到用户信息页面
-(void)userClick:(UIButton*)sender{
    ClubInvite*invite=[response.data_p.invitesArray objectAtIndex:sender.tag];
    UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
    InfoTableViewController*controller=[storyBoard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    controller.fromUserId=invite.briefUser.userid;
    NSLog(@"%@",invite.briefUser.userid);
    [self.navigationController pushViewController:controller animated:YES];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
}
//分享按钮的事件
- (void)sheraToAnyPeson:(UIButton*)sender{
    ClubInvite*    invite =[findsArray objectAtIndex:sender.tag];
    //设置微信和qq(分享代码前设置)
    [self settingWechatAndQQ];
    //使用默认UI
    [UMSocialSnsService presentSnsIconSheetView:self
                                    appKey:@"56443b13e0f55a9d3200117e"
                                      shareText:invite.description_p
                                     shareImage:[UIImage imageNamed:@"0001.png"]
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToTencent,UMShareToSina,nil]
                                       delegate:self];
    
}
- (void) settingWechatAndQQ{
    //注意设置的链接必须为http链接
    //当分享消息类型为图文时，点击分享内容会跳转以下链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
    //qq好友
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    //qqQzone
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://baidu.com";
    
    //微信朋友分享消息只显示title
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"徐俊哲是个傻逼";
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"我们是weclub";
    //qq title
    [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享title";
    //Qzone title
    [UMSocialData defaultData].extConfig.qzoneData.title = @"Qzone分享title";
    //微信分享消息类型分为图文、纯图片、纯文字、应用四种类型，默认分享类型为图文分享，即展示分享文字及图片缩略图，点击后跳转到预设链接
    //纯图片分享类型没有文字，点击图片可以查看大图
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    //纯文字分享类型没有图片，点击不会跳转
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    //应用分享类型点击分享内容后跳转到应用下载页面，下载地址自动抓取开发者在微信开放平台填写的应用地址，如果用户已经安装应用，则打开APP
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    //QQ分享消息类型分为图文、纯图片，QQ空间分享只支持图文分享（图片文字缺一不可）
    //QQ分享消息默认为图文类型，设置纯图片类型方法为
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    //在调用分享代码前调用即可
}

//报名按钮
-(void)signUpClick:(UIButton*)sender{
     ClubInvite*invite=[response.data_p.invitesArray objectAtIndex:sender.tag];
    if ([LoginUserInfo.user_id isEqualToString:invite.briefUser.userid]){
        if (invite.hasMoney==1) {
            //这里非红包邀约的时候点进去是要有个一个什么样的界面
            //这里面暂时 先用了红包邀约的东西 耍一个流氓  我在这里耍了一个流氓
            HostViewController*controller=[[HostViewController alloc]init];
            controller.hidesBottomBarWhenPushed=YES;
            controller.fromUserId=invite.inviteId;
            controller.fromPayMoney=invite.payMoney;
            [self.navigationController pushViewController:controller animated:YES];
            
        }else{
            HostViewController*controller=[[HostViewController alloc]init];
            controller.hidesBottomBarWhenPushed=YES;
            controller.fromUserId=invite.inviteId;
            controller.fromPayMoney=invite.payMoney;
            [self.navigationController pushViewController:controller animated:YES];
        }
       
    }else{
        SignUpListViewController*controller=[[SignUpListViewController alloc]init];
        controller.hidesBottomBarWhenPushed=YES;
        controller.fromUserId=invite.inviteId;
        [self.navigationController pushViewController:controller animated:YES];
    }
}

//举报方法
-(void)ReportClick:(UIButton*)sender{
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"举报" otherButtonTitles:@"收藏", nil];
    actionSheet.tag=sender.tag;
      [actionSheet showInView:self.view];
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
         ClubInvite*invite=[findsArray objectAtIndex:actionSheet.tag];
        ReportViewController*controller=[[ReportViewController alloc]init];
        controller.fromInviteID=invite.inviteId;
        controller.hidesBottomBarWhenPushed=YES;
        [self.navigationController pushViewController:controller animated:YES];
        //这里跳转举报页面
    }else if (buttonIndex==1){
        [self requestCollect];
    }
}
-(void)viewWillDisappear:(BOOL)animated{
    [_requestInvite clearDelegatesAndCancel];
    [_requestCollect clearDelegatesAndCancel];
}
-(void)MyInviteClick{

}







- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
