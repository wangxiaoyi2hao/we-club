//
//  settingViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

@interface settingViewController : UITableViewController<UIActionSheetDelegate,RCIMConnectionStatusDelegate,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *cacheLabel;

@property (weak, nonatomic) IBOutlet UILabel *securityLevel;


- (IBAction)securityBtnClick:(UIButton *)sender;
- (IBAction)bindingBtnClick:(UIButton *)sender;
- (IBAction)messageBtnClick:(UIButton *)sender;
- (IBAction)blackListBtnClick:(UIButton *)sender;
- (IBAction)exitBtnClick:(UIButton *)sender;
+(settingViewController *)shareSetting;

@end
