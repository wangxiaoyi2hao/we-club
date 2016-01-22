//
//  ForgetPasswordVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ForgetPasswordVC.h"
#import "EnterPasswordVC.h"
#import <SMS_SDK/SMSSDK.h>

@interface ForgetPasswordVC ()
{

    NSTimer*_timer;
    int  sendMessageTime;
}
@end

@implementation ForgetPasswordVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
    self.view.backgroundColor= [UIColor colorWithPatternImage:[UIImage imageNamed:@"引导页-背景"]];
    //单击取消键盘相应
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];
    [_phoneNumberText becomeFirstResponder];
    [_SecurityText becomeFirstResponder];
    sendMessageTime=46;
//    _lbTime.text=[NSString stringWithFormat:@"验证码已发送,%i秒后可重发",sendMessageTime];
    //计算
    _lbTime.hidden=YES;
    _phoneNumberText.delegate = self;
    _SecurityText.delegate = self;
    [_phoneNumberText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    [_SecurityText setValue:[UIColor whiteColor] forKeyPath:@"_placeholderLabel.textColor"];
    if (KScreenHeight ==480) {
        _forgetScorollView.contentOffset = CGPointMake(0, 55);
    }
    
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (KScreenHeight ==480) {
        if (textField ==_phoneNumberText) {
            
            _forgetScorollView.contentOffset = CGPointMake(0, 10);
        }else{
            _forgetScorollView.contentOffset = CGPointMake(0, 55);
        }

    }
    
    return YES;
}

- (void)tapAction{
    _forgetScorollView.contentOffset = CGPointMake(0, 0);
    [_phoneNumberText resignFirstResponder];
    [_SecurityText resignFirstResponder];
    
}
-(IBAction)popViewController:(id)sender{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark  发短信
- (IBAction)sendAction:(UIButton *)sender {
    if ([MyFile isValidateMobile:_phoneNumberText.text]!=YES) {
        [[Tostal sharTostal]tostalMesg:@"请输入正确手机号" tostalTime:1];
    }else{
         _lbTime.hidden=NO;
        sender.hidden=YES;
        if (_timer==nil) {
            _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
        }
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
-(void)timeBegin{
    sendMessageTime--;
    _lbTime.text=[NSString stringWithFormat:@"%is",sendMessageTime];
    if (sendMessageTime==0) {
        _sendButton.hidden=NO;
        [_sendButton setTitle:@"重新发送" forState:UIControlStateNormal];
        _lbTime.hidden=YES;
    }
}
- (IBAction)nextAction:(UIButton *)sender {
    
#pragma mark 这里仅供测试用
    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    EnterPasswordVC * enterPasswordVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"EnterPasswordVCID"];
    enterPasswordVC.fromPhoneNumber=_phoneNumberText.text;
    [self.navigationController pushViewController:enterPasswordVC animated:YES];
    
//#pragma mark   这里是正式的代码
//    [SMSSDK  commitVerificationCode:_SecurityText.text
//     //传获取到的区号
//                        phoneNumber:_phoneNumberText.text
//                               zone:@"86"
//                             result:^(NSError *error)
//     {
//         
//         if (!error)
//         {
//             NSLog(@"验证成功");
//             UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
//             EnterPasswordVC * enterPasswordVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"EnterPasswordVCID"];
//             enterPasswordVC.fromPhoneNumber=_phoneNumberText.text;
//             [self.navigationController pushViewController:enterPasswordVC animated:YES];
//             
//         }
//         else
//         {
//             [[Tostal sharTostal]tostalMesg:@"验证码错误" tostalTime:1];
//             NSLog(@"验证失败");
//         }
//         
//     }];
//
//    [_timer invalidate];
}
@end
