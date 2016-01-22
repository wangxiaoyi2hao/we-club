//
//  forgetPwdViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//点击忘记密码后,重置密码界面
#import <UIKit/UIKit.h>

@interface forgetPwdViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *validationCodeInput;
@property (weak, nonatomic) IBOutlet UILabel *currentPhoneNumber;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;
@property (weak, nonatomic) IBOutlet UIButton *validationCodeBtn;

- (IBAction)validationCodeAcition:(UIButton *)sender;
- (IBAction)submitBtnClick:(UIButton *)sender;
- (IBAction)backBtnClick:(UIBarButtonItem *)sender;
- (IBAction)touchBlank:(id)sender;

@end
