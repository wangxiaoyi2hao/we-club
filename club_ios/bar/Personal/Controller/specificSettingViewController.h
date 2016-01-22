//
//  specificSettingViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//安全设置
#import <UIKit/UIKit.h>

@interface specificSettingViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *securityLevel;

- (IBAction)backBtnClick:(UIBarButtonItem *)sender;
- (IBAction)resetPwdBtnClick:(UIButton *)sender;
- (IBAction)bindingPhoneBtnClick:(UIButton *)sender;

@end
