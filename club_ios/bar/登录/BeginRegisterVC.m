//
//  BeginRegisterVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BeginRegisterVC.h"
#import "UIDevice+IdentifierAddition.h"
#import "BarTabBarController.h"
extern UserInfo*LoginUserInfo;
@interface BeginRegisterVC ()
{

    ASIFormDataRequest*_request;
    ASIFormDataRequest*_requestLogin;
}
@end

@implementation BeginRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页-背景"]];
    //单击取消键盘相应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];
    [_passwordText becomeFirstResponder];
    [_rePasswordText becomeFirstResponder];
    _passwordText.delegate = self;
    _rePasswordText.delegate = self;
    if (KScreenHeight ==480) {
        
        _beginScorollView.contentOffset = CGPointMake(0, 55);
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (KScreenHeight ==480) {
        
        _beginScorollView.contentOffset = CGPointMake(0, 55);
    }
    
    return YES;
}

- (void)tapAction{
    _beginScorollView.contentOffset = CGPointMake(0, 0);
    [_passwordText resignFirstResponder];
    [_rePasswordText resignFirstResponder];
    
}

//网络请求事件
-(void)requestUrlLogin{
    Request10002*request=[[Request10002 alloc]init];
    
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/login",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestLogin = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //    request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳
    request.common.cmdid=10002;
    request.params.md5Psw=[HelperUtil md532BitUpper:_passwordText.text];//密码
    request.params.account=_fromPhoneNum;//账号
    NSData*data= [request data];
    [_requestLogin setPostBody:(NSMutableData*)data];
    [_requestLogin setDelegate:self];
    //请求延迟时间
    _requestLogin.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestLogin.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestLogin.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestLogin.secondsToCache=3600;
    [_requestLogin startAsynchronous];
    //（2）创建manager
    
    
}

-(IBAction)popViewController:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}
//注册
-(void)requestUrl{
    Request10001*request=[[Request10001 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/register",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.common.version=@"1.0.0";
    request.common.cmdid=10001;
    request.params.phoneNumber=_fromPhoneNum;
    request.params.md5Psw=[HelperUtil md532BitUpper:_passwordText.text];
    request.params.diviceNumber=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
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
    //（2）创建manager
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]) {
        Response10001* response = [Response10001 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            NSLog(@"注册失败");
             [[Tostal sharTostal]hiddenView];
            [[Tostal sharTostal]tostalMesg:@"注册失败" tostalTime:1];
        }else{
            [[Tostal sharTostal]hiddenView];
            [self requestUrlLogin];
        }
    }
    if ([request isEqual:_requestLogin]) {
       
       Response10002* response10002 = [Response10002 parseFromData:request.responseData error:nil];
        if (response10002.common.code==0) {
            NSLog(@"%@", response10002.data_p.name);
            UserInfo*user=[[UserInfo alloc]init];
            user.user_id=response10002.data_p.userid;
            user.user_name=response10002.data_p.name;
            user.user_key=response10002.data_p.key;
            user.user_sex=response10002.data_p.sex;
            user.sessionkey=response10002.data_p.sessionkey;
            user.phoneNum=_fromPhoneNum;
            user.user_pwd=[HelperUtil md532BitUpper:_passwordText.text];
            LoginUserInfo=user;
            [NSKeyedArchiver archiveRootObject:user toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
            BarTabBarController *rooCtrl = [[BarTabBarController alloc] init];
            rooCtrl.view.layer.transform = CATransform3DMakeScale(.5, .5, 0);
            self.view.window.rootViewController = rooCtrl;
            [UIView animateWithDuration:.5 animations:^{
                rooCtrl.view.layer.transform = CATransform3DIdentity;
            }];
            

        }
      
    }
  
    
}
- (IBAction)BeginAction:(UIButton *)sender {
    
    
//    if ([HelperUtil checkPassaword:_rePasswordText.text]==NO) {
//        [[Tostal sharTostal]tostalMesg:@"密码不合法" tostalTime:1];
//    }else{
    
#pragma mark  密码正则判断合法性的时候这里面还有问题
        if (![_passwordText.text isEqual:_rePasswordText.text]) {
            [[Tostal sharTostal]tostalMesg:@"两次密码不一致" tostalTime:1];
        }else{
            
            [self requestUrl];
            [[Tostal sharTostal]showLoadingView:@"正在注册请等待"];
        }
        
//    }
//    
    
    

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
