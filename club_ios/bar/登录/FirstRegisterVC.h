//
//  FirstRegisterVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface FirstRegisterVC : BaseViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nameText;
@property (weak, nonatomic) IBOutlet UIButton *nextButton;
- (IBAction)nextButtonAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIScrollView *firstScrollView;

@end
