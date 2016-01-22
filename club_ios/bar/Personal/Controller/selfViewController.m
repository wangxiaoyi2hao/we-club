//
//  selfViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//我 主页
#import "selfViewController.h"
#import "InvitationViewController.h"
#import "InfoTableViewController.h"
#import "AppDelegate.h"
#import "DrawRectView.h"
#import "CollectTableViewController.h"

#import "friendViewController.h"
#import "fansViewController.h"
#import "followViewController.h"
#import "HelpViewController.h"
#import "settingViewController.h"
#import "TopUpViewController.h"
#import "ErWeiMaViewController.h"


extern UserInfo*LoginUserInfo;
@interface selfViewController ()
{
    ASIFormDataRequest*_request;
    Response10003* _response;
    ASIFormDataRequest*_requestLoginInfo;

}
@end


@implementation selfViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //禁止视图滑动
    self.tableView.scrollEnabled = NO;
    UIView * view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:view];
    //设置导航栏
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = unselectedTextAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    self.navigationController.navigationBar.frame = CGRectMake(0, 20, KScreenWidth, 44);
    self.tableView.tableHeaderView = _headView;
    self.iconImageView.layer.cornerRadius = 32;//边框圆角
    self.iconImageView.layer.borderWidth = 2;//边框线宽度
    self.iconImageView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.iconImageView.layer.masksToBounds = YES;
    DrawRectView *drawView = [[DrawRectView alloc] initWithFrame:CGRectMake((KScreenWidth-84)/2.0, 44, 84, 84)];
    drawView.backgroundColor = [UIColor clearColor];
    drawView.fromFloat = 0.1;
    [_headView addSubview:drawView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}
#pragma mark这里是一个登录判断是不是要登录
-(void)requestLoginIsOk{
    Request10002*request=[[Request10002 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/login",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestLoginInfo = [ASIFormDataRequest requestWithURL:url];
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=10002;
    if (LoginUserInfo.user_pwd!=nil) {
        request.params.md5Psw=[HelperUtil md532BitUpper:LoginUserInfo.user_pwd ];//密码
    }
    request.params.account=LoginUserInfo.phoneNum;//账号
    NSLog(@"%@",LoginUserInfo.user_pwd);
    request.params.type=LoginUserInfo.loginType;
    request.params.otherId=LoginUserInfo.otherId;
    NSData*data= [request data];
    [_requestLoginInfo setPostBody:(NSMutableData*)data];
    [_requestLoginInfo setDelegate:self];
    //请求延迟时间
    _requestLoginInfo.timeOutSeconds=0;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestLoginInfo.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestLoginInfo.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestLoginInfo.secondsToCache=3600;
    [_requestLoginInfo startAsynchronous];
}

#pragma mark 我的信息的接口 我的信息调用此方法
//1.好友的参数
//2.粉丝的参数
//3.关注的参数
-(void)requestUrl{
        [[Tostal sharTostal]showLoadingView:@"正在加载信息"];
    Request10003*request=[[Request10003 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getUserBrief",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    NSLog(@"%@",LoginUserInfo.user_id);
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=10003;//现在标注为假数据
    request.common.timestamp=2;//现在标注为真数据
    request.common.version=@"1.0.0";
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];
    request.params.userid=LoginUserInfo.user_id;
    
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]) {
        _response = [Response10003 parseFromData:request.responseData error:nil];
        if (_response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
        }else{
            _userName.text=_response.data_p.username;
            _clubNumber.text=[NSString stringWithFormat:@"%lli",_response.data_p.clubNumber];
            _friendsLabel.text=[NSString stringWithFormat:@"%i",_response.data_p.friendNumber];//从网路获得参数
            _followLabel.text=[NSString stringWithFormat:@"%i",_response.data_p.followNumber];//关注的参数
            NSLog(@"%i",_response.data_p.followNumber);
            _fansLabel.text=[NSString stringWithFormat:@"%i",_response.data_p.followerNumber];//粉丝的
            NSLog(@"%i",_response.data_p.followerNumber);
            [_iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_response.data_p.avatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
            //判断如果说这一天之内没有登录的话 就在给他一次登录
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            NSMutableDictionary*loginDic=[NSMutableDictionary dictionaryWithContentsOfFile:[MyFile fileByDocumentPath:@"loginIsOk.plist"]];
            NSLog(@"%@",loginDic);
            NSString*nowDateMon=[loginDic objectForKey:@"weclub"];
            NSLog(@"%@",nowDateMon);
            if (![dateString isEqualToString:nowDateMon]) {
                [self requestLoginIsOk];
            }else{
                
                NSLog(@"caotama");
            }
            NSLog(@"%@",_response.data_p.avatar);
        }
        [[Tostal sharTostal]hiddenView];
        NSLog(@"%@",_response.data_p.avatar);
        NSLog(@"%@",_response.data_p.username);
        NSLog(@"%lli",_response.data_p.clubNumber);//用户账号也就是club账号
    }
   
    if ([request isEqual:_requestLoginInfo]) {
        Response10002*  response10002 = [Response10002 parseFromData:request.responseData error:nil];
        if (response10002.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response10002.common.message tostalTime:1];
        }else{
            NSLog(@"%@", response10002.data_p.name);
            UserInfo*user=[[UserInfo alloc]init];
            user.user_id=response10002.data_p.userid;
            user.user_name=response10002.data_p.name;
            user.user_key=response10002.data_p.key;
            NSLog(@"%@",response10002.data_p.key);
            user.user_sex=response10002.data_p.sex;
            user.sessionkey=response10002.data_p.sessionkey;
            user.rongYunTOken=response10002.data_p.rongyunToken;
//            user.qiNiuTOken=response10002.data_p.qiniuToken;
            user.user_head=response10002.data_p.avatarurl;
            user.user_pwd=LoginUserInfo.user_pwd;
            user.phoneNum=LoginUserInfo.phoneNum;
            user.loginType=response10002.data_p.type;
            user.otherId=LoginUserInfo.otherId;
            LoginUserInfo=user;
            [NSKeyedArchiver archiveRootObject:user toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
            NSLog(@"%@",LoginUserInfo.user_id);
            //这里是写一个字典判断今天是否登录过,保证一个静默登录
            NSDate *currentDate = [NSDate date];//获取当前时间，日期
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"YYYY-MM-dd"];
            NSString *dateString = [dateFormatter stringFromDate:currentDate];
            NSLog(@"%@",dateString);
            NSMutableDictionary*dictionary=[[NSMutableDictionary alloc]init];
            [dictionary setObject:dateString forKey:@"weclub"];
            [dictionary writeToFile:[MyFile fileByDocumentPath:@"loginIsOk.plist"] atomically:YES];
        }
    }

}
//添加数据
- (void)addData{
    _userName.text = _response.data_p.username;
    NSString *str = [NSString stringWithFormat:@"%lld",_response.data_p.clubNumber];
    _clubNumber.text = str;
}

//返回5组cell
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
    
}
//第一组,2个,其他的每组一个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return 5;
}

- (IBAction)friendsAction:(UIButton *)sender {
    UIStoryboard * friendViewVCSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    friendViewController * friendViewVC= [friendViewVCSB instantiateViewControllerWithIdentifier:@"friendViewControllerID"];
    [self.navigationController pushViewController:friendViewVC animated:YES];
}

- (IBAction)fansAction:(UIButton *)sender {

    UIStoryboard * fansViewVCSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    fansViewController * fansViewVC= [fansViewVCSB instantiateViewControllerWithIdentifier:@"fansViewControllerID"];
    [self.navigationController pushViewController:fansViewVC animated:YES];
}

- (IBAction)followAction:(UIButton *)sender {
    UIStoryboard * followViewVCSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    followViewController * followViewVC= [followViewVCSB instantiateViewControllerWithIdentifier:@"followViewControllerID"];
    [self.navigationController pushViewController:followViewVC animated:YES];
}
//跳转到充值界面
- (IBAction)topUpAction:(UIButton *)sender {
    TopUpViewController*controller=[[TopUpViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}



- (IBAction)infoBtnClick:(UIButton *)sender {
    UIStoryboard * memberTableVCSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController * memberTableVC= [memberTableVCSB instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    memberTableVC.fromUserId=nil;
    [self.navigationController pushViewController:memberTableVC animated:YES];
}
//我的邀约
- (IBAction)inviteViewBtnClick:(UIButton *)sender {
//    InvitationViewController *view1 = [[InvitationViewController alloc] init];
//    view1.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:view1 animated:YES];
    ErWeiMaViewController*controller=[[ErWeiMaViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
//收藏
- (IBAction)saveBtnClick:(UIButton *)sender {
    UIStoryboard * MainVc = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
     CollectTableViewController* collectTableViewController = [MainVc instantiateViewControllerWithIdentifier:@"CollectTableViewControllerID"];
    [self.navigationController pushViewController:collectTableViewController animated:YES];
}

//设置
- (IBAction)settingBtnClick:(UIButton *)sender {
    UIStoryboard * MainVc = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    settingViewController *settingViewVC = [MainVc instantiateViewControllerWithIdentifier:@"settingViewControllerID"];
    [self.navigationController pushViewController:settingViewVC animated:YES];
    
}
//帮助
- (IBAction)helpBtnClick:(UIButton *)sender {
    UIStoryboard * MainVc = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    HelpViewController *HelpViewVC = [MainVc instantiateViewControllerWithIdentifier:@"HelpViewControllerID"];
    [self.navigationController pushViewController:HelpViewVC animated:YES];
}
-(void)viewDidAppear:(BOOL)animated{
    [self requestUrl];

}

- (void)viewWillAppear:(BOOL)animated{


    
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;


    //隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    _friendsLabel.textColor = [UIColor darkGrayColor];
    _friendsNameLabel.textColor = [UIColor darkGrayColor];
    _fansLabel.textColor = [UIColor darkGrayColor];
    _fansNameLabel.textColor = [UIColor darkGrayColor];
    _followLabel.textColor = [UIColor darkGrayColor];
    _followNameLabel.textColor = [UIColor darkGrayColor];
}
- (void)viewWillDisappear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
    [_request clearDelegatesAndCancel];
}

- (IBAction)friendTouchDown:(UIButton *)sender {
    _friendsLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
    _friendsNameLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
    
}

- (IBAction)fansTouchDown:(UIButton *)sender {
    _fansLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
    _fansNameLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
}

- (IBAction)followTouchDown:(UIButton *)sender {
    _followLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
    _followNameLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
}

@end
