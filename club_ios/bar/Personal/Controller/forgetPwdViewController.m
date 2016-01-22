//
//  forgetPwdViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "forgetPwdViewController.h"

@interface forgetPwdViewController ()

@end

@implementation forgetPwdViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //接收键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate:) name:UITextFieldTextDidChangeNotification object:_validationCodeInput];
    //返回按钮
    [self loadNav];
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView1{
    
    
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

- (void)validate:(NSString *)str {
    if (str.length > 0) {
        //提交按钮可点击
        _submitBtn.enabled = YES;
    } else {
        //提交按钮不可点击
        _submitBtn.enabled = NO;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //取消作为第一响应者
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)validationCodeAcition:(UIButton *)sender {
    NSLog(@"你点击了验证码按钮");
    _validationCodeBtn.enabled = NO;
}

- (IBAction)submitBtnClick:(UIButton *)sender {
    NSLog(@"你点击了提交按钮");
}

- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)touchBlank:(id)sender {
    //验证码输入框取消作为第一相应者
    [_validationCodeInput resignFirstResponder];
}
@end
