//
//  ForgetPasswordVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface ForgetPasswordVC : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *forgetScorollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *SecurityText;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;
- (IBAction)sendAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
@property(weak,nonatomic)IBOutlet UILabel*lbTime;

- (IBAction)nextAction:(UIButton *)sender;

@end
