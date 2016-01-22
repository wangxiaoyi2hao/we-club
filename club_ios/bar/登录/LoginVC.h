//
//  LoginVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface LoginVC : BaseViewController<UITextFieldDelegate,ASIHTTPRequestDelegate>
//这个事那个
@property (weak, nonatomic) IBOutlet UIScrollView *loginScorollView;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumberText;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
- (IBAction)loginAction:(UIButton *)sender;

@property(weak,nonatomic) IBOutlet UIView*forgetView;

////好友信息数组
//@property (nonatomic, strong)NSMutableArray *friendsArray;
@end
