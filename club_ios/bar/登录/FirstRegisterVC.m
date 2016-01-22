//
//  FirstRegisterVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FirstRegisterVC.h"
#import "SecondRegisterVC.h"
#import "AppDelegate.h"

@interface FirstRegisterVC ()
{

    ASIFormDataRequest*_request;
}
@end

@implementation FirstRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    self.navigationController.navigationBarHidden=YES;
    
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"邀约-图片一.png"]];
    self.view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页-背景"]];
    if (KScreenHeight ==480) {
        
        _firstScrollView.contentOffset = CGPointMake(0, 10);
    }
    
    //单击取消键盘相应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];
    _nameText.delegate = self;
    _nameText.autocorrectionType=UITextAutocorrectionTypeNo;
    [_nameText becomeFirstResponder];
}
//在点击textfield 的时候让页面向上平移
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (KScreenHeight ==480) {
        
        _firstScrollView.contentOffset = CGPointMake(0, 10);
    }

    return YES;
}

- (void)tapAction{
    _firstScrollView.contentOffset = CGPointMake(0, 0);
    [_nameText resignFirstResponder];
}
//网络请求事件
#pragma mark 获取姓名  验证信息 判断信息是否重复
-(void)requestUrl{
    Request10017*request=[[Request10017 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/verifyUsername",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //    request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.cmdid=10017;
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳
    request.params.username=_nameText.text;//密码
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
//网络请求结束方法
- (void)requestFinished:(ASIHTTPRequest *)request{
    Response10017*response10017 = [Response10017 parseFromData:request.responseData error:nil];
    if (response10017.common.code!=0) {
        [[Tostal sharTostal]tostalMesg:@"此用户名已被占用" tostalTime:1];
         [[Tostal sharTostal]hiddenView];
    }else{
        [[Tostal sharTostal]hiddenView];
        UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
        SecondRegisterVC * secondRegisterVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"SecondRegisterVCID"];
//        secondRegisterVC.fromUser=_nameText.text;
        [self.navigationController pushViewController:secondRegisterVC animated:YES];
    }
}
//点击下一步的按钮时候需要完成的事件
- (IBAction)nextButtonAction:(UIButton *)sender{
    if ([_nameText.text isEqual:@""]) {
        [[Tostal sharTostal]tostalMesg:@"用户名不能为空" tostalTime:1];
    
    }else{
        //判断用户名的合法性｀｀｀
//        if ([HelperUtil checkNickname:_nameText.text]==NO) {
//            [[Tostal sharTostal]tostalMesg:@"用户名过长或者不合法" tostalTime:1];
//        }else{
            [self requestUrl];
            [[Tostal sharTostal]showLoadingView:@"正在识别是否有重复"];
//        }
        
    }

}
-(IBAction)dismissThiseView:(id)sender{
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
