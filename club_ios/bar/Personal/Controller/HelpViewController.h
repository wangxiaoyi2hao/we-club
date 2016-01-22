//
//  HelpViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/4.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HelpViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UILabel *updateInfo;
- (IBAction)evaluateBtnClick:(UIButton *)sender;
- (IBAction)introductionBtnClick:(UIButton *)sender;
- (IBAction)commentBtnClick:(UIButton *)sender;
- (IBAction)updateBtnClick:(UIButton *)sender;
- (IBAction)aboutBtnClick:(UIButton *)sender;

@end
