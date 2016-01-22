//
//  ThirdRegisterVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ThirdRegisterVC.h"
#import "BeginRegisterVC.h"
#import <SMS_SDK/SMSSDK.h>
#import "SecondRegisterVC.h"
#import "UIDevice+IdentifierAddition.h"
#import "UMSocial.h"
#import "UMSocialQQHandler.h"
extern UserInfo*LoginUserInfo;
@interface ThirdRegisterVC ()
{
     //验证手机号
    ASIFormDataRequest*_request;
    //注册
    ASIFormDataRequest*_reuqestRegirse;
    NSTimer*_timer;
    int  sendMessageTime;
    
    
    //让button来回变化的int 值去判断
    int  isSelect;
    //判断什么类型的注册
    int loginNum;
    //要id
    NSString*userIconUrl;
    NSString*userNameThree;
    
    NSString*userOtherID;

    
}
@end

@implementation ThirdRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    //单击取消键盘相应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];
    sendMessageTime=56;
    _lbTime.text=[NSString stringWithFormat:@"%is",sendMessageTime];
    _phoneNumberText.delegate = self;
    _SecurityText.delegate = self;
    if (KScreenHeight ==480) {
        _thirdScorollView.contentOffset = CGPointMake(0, 10);
    }
    loginNum=1;
    [_SecurityText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [_tfPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
     [_tfAgainPwd setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
      [_phoneNumberText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];

    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (KScreenHeight ==480) {
        if (textField ==_phoneNumberText) {
            
            _thirdScorollView.contentOffset = CGPointMake(0, 10);
        }else{
            _thirdScorollView.contentOffset = CGPointMake(0, 50);
        }
    }
    return YES;
}

- (void)tapAction{
    _thirdScorollView.contentOffset = CGPointMake(0, 0);
    [_phoneNumberText resignFirstResponder];
    [_SecurityText resignFirstResponder];
    [_tfPwd resignFirstResponder];
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//网络请求事件  判断手机号是否注册过
-(void)requestUrl{
    Request10018*request=[[Request10018 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/verifyPhoneNumber",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //    request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳
    request.common.cmdid=10018;
    request.params.phoneNumber=_phoneNumberText.text;//手机号
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

//这里我是要让这个导航条隐藏
-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = YES;
    //每次进来的时候让那个显示秒数的地方隐藏  让从新发送的地方显示
    _lbTime.hidden=YES;
    _lbReceive.hidden=NO;
}
//这里是点击发送按钮的时候 要显示的发送
- (IBAction)sendButtonAction:(UIButton *)sender {
 
    //正则判断手机号是否正确
    if ([MyFile isValidateMobile:_phoneNumberText.text]!=YES) {
        [[Tostal sharTostal]tostalMesg:@"请输入正确手机号" tostalTime:1];
    }else if ([HelperUtil checkPassaword:_tfPwd.text]==NO){
        
        [[Tostal sharTostal]tostalMesg:@"密码输入不合法" tostalTime:1];
    }
      else if (![_tfPwd.text isEqualToString:_tfAgainPwd.text]){
        [[Tostal sharTostal]tostalMesg:@"两次密码输入不一致" tostalTime:1];
    }
    
    
    else{
         [self requestUrl];
      
        
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [_tfPwd resignFirstResponder];
    [_phoneNumberText resignFirstResponder];
    [_SecurityText resignFirstResponder];
    [_tfAgainPwd resignFirstResponder];

    return YES;
}
-(IBAction)popViewController:(id)sender{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
//这里面是时间器的事件
-(void)timeBegin{
    sendMessageTime--;
    _lbTime.text=[NSString stringWithFormat:@"%is",sendMessageTime];
    if (sendMessageTime==0) {
        _lbTime.hidden=YES;
        _lbReceive.hidden=NO;
        _lbReceive.text=@"重新发送";
        _sendButton.hidden=NO;
        [_timer invalidate];
        sendMessageTime=56;
        _lbTime.text=[NSString stringWithFormat:@"%is",sendMessageTime];
    }
}



- (IBAction)nextButtonAction:(UIButton *)sender {
    //供测试用
//    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
//    SecondRegisterVC *secondRegisteVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"SecondRegisterVCID"];
//    [self.navigationController pushViewController:secondRegisteVC animated:YES];


    [SMSSDK  commitVerificationCode:_SecurityText.text
     //传获取到的区号
                        phoneNumber:_phoneNumberText.text
                               zone:@"86"
                             result:^(NSError *error)
     {
         
         if (!error)
         {
             NSLog(@"验证成功");
             [[Tostal sharTostal]showLoadingView:@"正在加载中"];
             [self requestUrlRegirser:nil];
             
         }
         else
         {
             [[Tostal sharTostal]tostalMesg:@"验证码错误" tostalTime:1];
             NSLog(@"验证失败");
         }
         
     }];
    [_timer invalidate];
 
}
//注册页面
-(void)requestUrlRegirser:(NSString*)otherId{
    Request10001*request=[[Request10001 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/register",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestRegirse = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //    request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳
    request.common.cmdid=10018;
    request.params.phoneNumber=_phoneNumberText.text;//手机号
    request.params.md5Psw=[HelperUtil md532BitUpper:_tfPwd.text];
    request.params.diviceNumber=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
    request.params.otherId=otherId;
        request.params.registerType= loginNum;
    NSData*data= [request data];
    [_reuqestRegirse setPostBody:(NSMutableData*)data];
    [_reuqestRegirse setDelegate:self];
    //请求延迟时间
    _reuqestRegirse.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestRegirse.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestRegirse.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestRegirse.secondsToCache=3600;
    [_reuqestRegirse startAsynchronous];
    //（2）创建manager
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request  isEqual:_request]) {
        //    NSLog(@"返回的数据时啥－－%@",request.);
        Response10018*response10018 = [Response10018 parseFromData:request.responseData error:nil];
        if (response10018.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response10018.common.message  tostalTime:1];
            _lbReceive.hidden=NO;
            _sendButton.hidden=NO;
            _lbTime.hidden=YES;
        }else{
            _lbReceive.hidden=YES;
            _sendButton.hidden=YES;
            _lbTime.hidden=NO;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
            
            [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS
             //这个参数可以选择是通过发送验证码还是语言来获取验证码
                                    phoneNumber:_phoneNumberText.text
                                           zone:@"86"
                               customIdentifier:@"[weClub]验证码，仅用于注册，为确保你的安全，请勿告知他人，客服电话15939865871" //自定义短信模板标识
                                         result:^(NSError *error)
             {
                 
                 if (!error)
                 {
                     NSLog(@"block 获取验证码成功");
                     
                 }
                 else
                 {
                     
                     UIAlertView* alert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"codesenderrtitle", nil)
                                                                     message:[NSString stringWithFormat:@"%@",[error.userInfo objectForKey:@"getVerificationCode"]]
                                                                    delegate:self
                                                           cancelButtonTitle:NSLocalizedString(@"sure", nil)
                                                           otherButtonTitles:nil, nil];
                     [alert show];
                     
                 }
                 
             }];
            
        }

    }
    
    if ([request isEqual:_reuqestRegirse]) {
        Response10001*response10001 = [Response10001 parseFromData:request.responseData error:nil];
        if (response10001.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response10001.common.message tostalTime:1];
        }else{
            UserInfo*user=[[UserInfo alloc]init];
            user.user_id=response10001.data_p.useId;
            user.user_key=response10001.data_p.userKey;
            user.vClubId=response10001.data_p.vClubId;
            NSLog(@"%@",response10001.data_p.vClubId);
            LoginUserInfo=user;
            //这里到时候存档一下
            [NSKeyedArchiver archiveRootObject:user toFile:[MyFile          fileByDocumentPath:@"/isUserAll.archiver"]];
            UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
            SecondRegisterVC *secondRegisteVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"SecondRegisterVCID"];
            secondRegisteVC.fromUserId=response10001.data_p.useId;
            secondRegisteVC.fromUserkey=response10001.data_p.userKey;
            secondRegisteVC.fromVclubNumber=response10001.data_p.vClubId;
            secondRegisteVC.fromType=loginNum;
            secondRegisteVC.fromPhoneNUm=_phoneNumberText.text;
            secondRegisteVC.fromPwd=_tfPwd.text;
            secondRegisteVC.fromUserIcon=userIconUrl;
            secondRegisteVC.fromOtherId=userOtherID;
            secondRegisteVC.fromUserName=userNameThree;
            secondRegisteVC.fromVclubNumber=response10001.data_p.vClubId;
            NSLog(@"%@",userIconUrl);
            NSLog(@"%@",userNameThree);
            [self.navigationController pushViewController:secondRegisteVC animated:YES];
        }
    
    }
    
    [[Tostal sharTostal]hiddenView];
    
}

- (void)requestFailed:(ASIHTTPRequest *)request{
    
    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    
}

//微信第三方登录
-(IBAction)buttonWeChat:(id)sender{
    loginNum=4;
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToWechatSession];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary]valueForKey:UMShareToWechatSession];
            [self requestUrlRegirser:snsAccount.usid];
            userIconUrl=snsAccount.iconURL;
            userNameThree=snsAccount.userName;
            userOtherID=snsAccount.usid;
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
            [self requestUrlRegirser:snsAccount.usid];
            userIconUrl=snsAccount.iconURL;
            userNameThree=snsAccount.userName;
              userOtherID=snsAccount.usid;
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
            [self requestUrlRegirser:snsAccount.usid];
            userIconUrl=snsAccount.iconURL;
            userNameThree=snsAccount.userName;
              userOtherID=snsAccount.usid;
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            
        }});
    
}
-(IBAction)directLogin:(id)sender{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"rangdengluchualai" object:nil];

}
//qq的回调方法
-(void)QQcomeBack{
    
    [[UMSocialDataService defaultDataService] requestSnsInformation:UMShareToQQ  completion:^(UMSocialResponseEntity *response){
        NSLog(@"SnsInformation is %@",response.data);
    }];
}





@end
