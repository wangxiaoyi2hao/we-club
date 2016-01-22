//
//  BeginRegisterVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface BeginRegisterVC : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *beginScorollView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;

@property (weak, nonatomic) IBOutlet UITextField *rePasswordText;

//上一些页面传值
@property(nonatomic,copy)NSString*fromSex;
@property(nonatomic,copy)NSString*fromBirthday;
@property(nonatomic,copy)NSString*fromHomeTown;
@property(nonatomic,copy)NSString*fromUser2;
@property(nonatomic,copy)NSString*fromPhoneNum;





- (IBAction)BeginAction:(UIButton *)sender;


@end
