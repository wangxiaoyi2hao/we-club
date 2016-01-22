//
//  EnterPasswordVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "EnterPasswordVC.h"
#import "BarTabBarController.h"
#import "RefreshThisViewController.h"
extern UserInfo*LoginUserInfo;
@interface EnterPasswordVC ()
{

    ASIFormDataRequest*_reuqestAgain;
    ASIFormDataRequest*_requestLogin;
     Response10002*response10002;
    NSTimer*_timer;
    
    NSTimer*_timer2;
    int  seconds;//这个是显示上面的红背景的
    //第二个计算描述的东西 这个上面计算秒数 就是计算三秒钟 跳回到登录页面
    
    int  seconds2;
    
}
@end

@implementation EnterPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _wrongView.hidden=YES;
    _imageBlack.hidden=YES;
    _tanView.hidden=YES;
    seconds2=3;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页-背景"]];
    //单击取消键盘相应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];
    [_passwordText becomeFirstResponder];
    _passwordText.delegate = self;
    _rePasswordText.delegate = self;
    if (KScreenHeight ==480) {
        _enterScorollView.contentOffset = CGPointMake(0, 55);
    }
    //发送通知 到返回登录页面
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(goBacklogin) name:@"gobackLogin" object:nil];
}
-(void)goBacklogin{

    [self.navigationController popToRootViewControllerAnimated:NO];

}
//也是改变位置  有没有用  待定
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (KScreenHeight ==480) {
        _enterScorollView.contentOffset = CGPointMake(0, 55);
    }
    
    return YES;
}
//添加的手势 ，有没有用 待定
- (void)tapAction{
    _enterScorollView.contentOffset = CGPointMake(0, 0);
    [_passwordText resignFirstResponder];
    [_rePasswordText resignFirstResponder];
    
}

//重置密码的按钮
- (IBAction)beginAction:(UIButton *)sender {
    if (![_passwordText.text isEqualToString:_rePasswordText.text] ) {
        _wrongView.hidden=NO;
        _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
    }else{
        if ([HelperUtil checkPassaword:_passwordText.text]==NO) {
            [[Tostal sharTostal]tostalMesg:@"密码不合法" tostalTime:1];
        }else{
            [self requestUpdate];
        }
    }
}
#pragma mark 修改密码调用的接口方法
-(void)requestUpdate{
    Request10013*request10013=[[Request10013 alloc]init];
    //设置请求参数
    request10013.common.userid=LoginUserInfo.user_id;
    request10013.common.userkey=LoginUserInfo.user_key;
    request10013.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request10013.common.version=@"1.0.0";//版本号
    request10013.common.platform=2;//ios  andriod
    request10013.common.cmdid=10013;
    request10013.params.newMd5Psw=[HelperUtil md532BitUpper:_passwordText.text];
    request10013.params.phoneNumber=_fromPhoneNumber;
    NSData*data= [request10013 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/resetPassword",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
     _reuqestAgain = [ASIFormDataRequest requestWithURL:url];
    [_reuqestAgain setPostBody:(NSMutableData*)data];
    [_reuqestAgain setDelegate:self];
    //请求延迟时间
     _reuqestAgain.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
     _reuqestAgain.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
     _reuqestAgain.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
     _reuqestAgain.secondsToCache=3600;
     [_reuqestAgain startAsynchronous];
    
}



- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_reuqestAgain]) {
        Response10013*response=[Response10013 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            _wrongView.hidden=NO;
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
        }else{
            _imageBlack.hidden=NO;
            _timer2=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBigin2) userInfo:nil repeats:YES];
            _tanView.hidden=NO;
        }
    }
    
    
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    
}
//这个是判断 密码错误的时候上面的那个红色的框
-(void)timeBegin{

    seconds++;
    if (seconds==2) {
        _wrongView.hidden=YES;
        [_timer invalidate];
        seconds=0;
    }
}

//让跳转的时间
-(void)timeBigin2{

    seconds2--;
    lbHowToSecond.text=[NSString stringWithFormat:@"%i秒后跳转登录页",seconds];
    if (seconds2==0) {
        [self.navigationController popToRootViewControllerAnimated:YES];
        [_timer2 invalidate];
   
    }


}
-(IBAction)popViewController:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
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
