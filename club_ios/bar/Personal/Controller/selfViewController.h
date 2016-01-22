//
//  selfViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface selfViewController : UITableViewController

//@property (nonatomic , weak) NSString *nickName;
//@property (nonatomic , weak) NSString *accountName;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UILabel *friendsLabel;
@property (weak, nonatomic) IBOutlet UILabel *friendsNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *fansLabel;
@property (weak, nonatomic) IBOutlet UILabel *fansNameLabel;

@property (weak, nonatomic) IBOutlet UILabel *followLabel;
@property (weak, nonatomic) IBOutlet UILabel *followNameLabel;

- (IBAction)friendsAction:(UIButton *)sender;
- (IBAction)fansAction:(UIButton *)sender;
- (IBAction)followAction:(UIButton *)sender;
- (IBAction)topUpAction:(UIButton *)sender;


- (IBAction)infoBtnClick:(UIButton *)sender;//个人资料按钮
- (IBAction)inviteViewBtnClick:(UIButton *)sender;//我的邀约
- (IBAction)saveBtnClick:(UIButton *)sender;//收藏
- (IBAction)settingBtnClick:(UIButton *)sender;//设置
- (IBAction)helpBtnClick:(UIButton *)sender;//帮助

@property (strong, nonatomic) IBOutlet UITableView *myTableView;

@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *clubNumber;
- (IBAction)friendTouchDown:(UIButton *)sender;
- (IBAction)fansTouchDown:(UIButton *)sender;

- (IBAction)followTouchDown:(UIButton *)sender;



@end
