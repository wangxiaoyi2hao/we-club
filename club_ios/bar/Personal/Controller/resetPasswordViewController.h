//
//  resetPasswordViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//修改密码界面
#import <UIKit/UIKit.h>

@interface resetPasswordViewController : UIViewController <UITextFieldDelegate , UITextViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *completeBtn;//完成按钮
@property (weak, nonatomic) IBOutlet UITextField *originPwdInput;//输入旧密码
@property (weak, nonatomic) IBOutlet UITextField *tempPwdInput;//新密码
@property (weak, nonatomic) IBOutlet UITextField *tempPwdInputAgain;//再次输入新密码




- (IBAction)validate:(UITextField *)sender;
- (IBAction)backBtnClick:(UIBarButtonItem *)sender;//返回按钮
- (IBAction)completeBtnClick:(id)sender;//完成按钮
- (IBAction)forgetBtnClick:(UIButton *)sender;//忘记密码
- (IBAction)touchBlack:(id)sender;//手势返回

@end
