//
//  LoginVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "LoginVC.h"
#import "BarTabBarController.h"
#import "ForgetPasswordVC.h"
#import "APService.h"
#import "AppDelegate.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
#import "SecondRegisterVC.h"
#import "ThirdRegisterVC.h"

extern UserInfo*LoginUserInfo;
@interface LoginVC ()
{

    ASIFormDataRequest*_request;
    Response10002*response10002;
    NSTimer *_timer;
    
    //用来显示那个密码错误的界面
    int secondeS;
    //用来传参数 看是什么登录
    int loginNum;
    
    NSString*threeName;
    NSString*threeIconURL;
    NSString*threeOtherID;
    ASIFormDataRequest*_requestHead;
    
    //
    NSString*imageIconUrl;
    
}
@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
  
    loginNum=1;
    _forgetView.hidden=YES;
    secondeS=0;
    //设置状态栏
    self.navigationController.navigationBarHidden=YES;
    //单击取消键盘相应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];

   [_phoneNumberText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_passwordText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    _passwordText.delegate = self;
    _phoneNumberText.delegate = self;
    if (KScreenHeight ==480) {
        _loginScorollView.contentOffset = CGPointMake(0, 30);
    }
    //为了接受上面的一个页面的结束让这个页面显示出来
    
}
-(void)viewWillAppear:(BOOL)animated{
   [self requestHead];
  [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}
-(void)requestHead{
    NSString * str1=[NSString stringWithFormat:@"%@",imageIconUrl];
    //将str 进行编码
    //    unsigned long encode=CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString*requestStr=[str1 stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL*url=[NSURL URLWithString:requestStr];
    _requestHead=[ASIFormDataRequest requestWithURL:url];
    //设置缓存存储模式
    _requestHead.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    //设置缓存策略
    _requestHead.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存时间
    _requestHead.secondsToCache=6000;
    _requestHead.delegate=self;
    _requestHead.timeOutSeconds=10;
    _requestHead.numberOfTimesToRetryOnTimeout=1;
    [_requestHead startAsynchronous];
    
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{

    return YES;
}

-(IBAction)puchForget:(id)sender{
    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    
    ForgetPasswordVC * enterPasswordVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"ForgetPasswordVCID"];
    [self.navigationController pushViewController:enterPasswordVC animated:YES];

}
- (void)tapAction{
//    _loginScorollView.contentOffset = CGPointMake(0, 0);
    [_phoneNumberText resignFirstResponder];
    [_passwordText resignFirstResponder];                         
    
}
-(IBAction)popViewController:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
    
}
#pragma mark  登录按钮
//登录按钮  点击登陆按钮
-(void)requestUrl:(NSString*)OherID{
    Request10002*request=[[Request10002 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/login",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.params.md5Psw=[HelperUtil md532BitUpper:_passwordText.text];//密码
    NSLog(@"－－－－－－－－－－－－－－－－%@",_passwordText.text);
    request.params.account=_phoneNumberText.text;//账号
    // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
    request.params.type=loginNum;
    
    request.params.otherId=OherID;
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    response10002 = [Response10002 parseFromData:request.responseData error:nil];
    NSLog(@"%i",response10002.common.code);
    if (response10002.common.code!=0&&response10002.common.code!=CODENUM) {
        [[Tostal sharTostal]hiddenView];
         _forgetView.hidden=NO;
         _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
    }else if(response10002.common.code==CODENUM) {
        [[Tostal sharTostal]hiddenView];
        UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
        ThirdRegisterVC *secondRegisteVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"ThirdRegisterVCID"];
        [[Tostal sharTostal]tostalMesg:@"您的第三方号码未注册" tostalTime:1];
        [self.navigationController pushViewController:secondRegisteVC animated:YES];
    }else{
    
        NSLog(@"%@", response10002.data_p.name);
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
        NSLog(@"%i",response10002.data_p.type);
        user.loginType=response10002.data_p.type;
        user.phoneNum=_phoneNumberText.text;
        user.user_pwd=_passwordText.text;
        user.user_head=response10002.data_p.avatarurl;
        user.otherId=threeOtherID;
        NSLog(@"%@",threeOtherID);
        LoginUserInfo=user;
        [NSKeyedArchiver archiveRootObject:user toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
        [[Tostal sharTostal]hiddenView];
        BarTabBarController *rooCtrl = [[BarTabBarController alloc] init];
        rooCtrl.view.layer.transform = CATransform3DMakeScale(.5, .5, 0);
        self.view.window.rootViewController = rooCtrl;
        [UIView animateWithDuration:.5 animations:^{
            rooCtrl.view.layer.transform = CATransform3DIdentity;
        }];
        NSString*str=[LoginUserInfo.user_id stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [APService setTags:nil alias:str callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
#pragma mark-手动登录后获取好友列表
        [[AppDelegate shareAppDelegate] requestFriendList];
    }
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{

    [[Tostal sharTostal]hiddenView];
//    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];

}
-(void)timeBegin{
    secondeS++;
    if (secondeS==2) {
        _forgetView.hidden=YES;
        secondeS=0;
        [_timer invalidate];
    }
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
- (IBAction)loginAction:(UIButton *)sender{
    [_phoneNumberText resignFirstResponder];
    [_passwordText resignFirstResponder];
    
    
    if ([_phoneNumberText.text isEqualToString:@""]) {
        [[Tostal sharTostal]tostalMesg:@"账号不能为空" tostalTime:1];
    }else if ([_passwordText.text isEqualToString:@""]){
        [[Tostal sharTostal]tostalMesg:@"密码不能为空" tostalTime:1];
    }else{
        //这里要判断
        if ([HelperUtil checkTel:_phoneNumberText.text]==NO) {
            [[Tostal sharTostal]tostalMesg:@"请输入正确手机号" tostalTime:1];
        }else {
            [self requestUrl:nil];
            [[Tostal sharTostal]showLoadingView:@"宝宝正在登录中"];
        }
        
        
    }

}
 // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
#pragma mark 等三方登录的按钮
//微信第三方登录
-(IBAction)buttonWeChat:(id)sender{
    loginNum=4;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            threeName=snsAccount.userName;
            threeIconURL=snsAccount.iconURL;
            
            threeOtherID=snsAccount.usid;
            
             [self requestUrl:threeOtherID];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
            [self weChatComeBack];
        }
        
    });
    
}
//微信回调方法
-(void)weChatComeBack{
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToWechatSession  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
}
 // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
//微博第三方登录
-(IBAction)buttonWeiBo:(id)sender{
    loginNum=3;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToSina];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToSina];
             [self requestUrl:snsAccount.usid];
            threeName=snsAccount.userName;
            threeIconURL=snsAccount.iconURL;
               threeOtherID=snsAccount.usid;
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            [self weChatComeBack];
        }});
}
//微博回调方法
-(void)weiBoComeBack{
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToSina  completion:^(UMSocialResponseEntity *response){
        
        NSLog(@"新浪微博的个人信息是： %@",response.data);
    }];
}
//qq第三方登录
-(IBAction)buttonQQ:(id)sender{
    // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
    loginNum=2;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            threeName=snsAccount.userName;
            threeIconURL=snsAccount.iconURL;
            NSLog(@"%@",threeIconURL);
            threeOtherID=snsAccount.usid;
            [self requestUrl:snsAccount.usid];
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
        }});
}
//qq的回调方法
-(void)QQcomeBack{
    //sssss
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
}

-(IBAction)direRegirse:(UIButton*)sender{
    
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"goRegirse" object:nil];

}






- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
