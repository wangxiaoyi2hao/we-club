//
//  EnterPasswordVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface EnterPasswordVC : BaseViewController<UITextFieldDelegate>


{

    IBOutlet UIImageView*_imageBlack;
    IBOutlet UILabel*lbHowToSecond;

}
@property (weak, nonatomic) IBOutlet UIScrollView *enterScorollView;
@property (weak, nonatomic) IBOutlet UITextField *passwordText;
@property (weak, nonatomic) IBOutlet UITextField *rePasswordText;
@property(nonatomic,copy)NSString*fromPhoneNumber;
- (IBAction)beginAction:(UIButton *)sender;

@property(weak,nonatomic)IBOutlet UIView*wrongView;
@property(weak,nonatomic)IBOutlet UIView*tanView;





@end
