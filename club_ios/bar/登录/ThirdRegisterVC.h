//
//  ThirdRegisterVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface ThirdRegisterVC : BaseViewController<UITextFieldDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *thirdScorollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;

@property (weak, nonatomic) IBOutlet UITextField *SecurityText;
@property (weak, nonatomic) IBOutlet UILabel *sendLabel;
@property (weak, nonatomic) IBOutlet UIButton *sendButton;


- (IBAction)sendButtonAction:(UIButton *)sender;

- (IBAction)nextButtonAction:(UIButton *)sender;
@property(nonatomic,copy)NSString*fromSex;
@property(nonatomic,copy)NSString*fromBirthday;
@property(nonatomic,copy)NSString*fromHomeTown;
@property(nonatomic,copy)NSString*fromUser2;


@property(weak,nonatomic)IBOutlet UILabel*lbTime;
@property(weak,nonatomic)IBOutlet UILabel*lbReceive;
@property(weak,nonatomic)IBOutlet UITextField*tfPwd;
@property(weak,nonatomic)IBOutlet UITextField*tfAgainPwd;

@end
