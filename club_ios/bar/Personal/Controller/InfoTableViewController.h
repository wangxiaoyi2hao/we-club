//
//  InfoTableViewController.h
//  bar
//
//  Created by chen on 15/11/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfoTableViewController : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>
#pragma mark- headView
@property (weak, nonatomic) IBOutlet UIView *infoHeadView;
@property (weak, nonatomic) IBOutlet UIImageView *headViewIcon;
@property (weak, nonatomic) IBOutlet UILabel *signLabel;
@property (weak, nonatomic) IBOutlet UIView *othersView;//如果是自己则隐藏,是他人的,则显示
- (IBAction)chatAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *chatButton;
@property (weak, nonatomic) IBOutlet UIButton *likeButton;
- (IBAction)likeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *reportButton;
- (IBAction)reportAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *imageView;

- (IBAction)backButton:(id)sender;
@property (weak, nonatomic) IBOutlet UICollectionView *headCollectionView;

@property(weak,nonatomic)IBOutlet UIButton*rightButton;
@property(nonatomic, copy) NSString *fromUserId;
@property(weak,nonatomic)IBOutlet UILabel*lbAge;
@property(weak,nonatomic) IBOutlet UILabel*lbConstellation;//星座
@property(weak,nonatomic)IBOutlet UILabel*lbHeart;
@property(weak,nonatomic)IBOutlet UILabel*lbLove;
@property(weak,nonatomic)IBOutlet UILabel*lbProject;
@property(weak,nonatomic)IBOutlet UILabel*lbSchool;
@property(weak,nonatomic)IBOutlet UILabel*lbHome;
@property(weak,nonatomic)IBOutlet UILabel*lbClubNumber;
@property(weak,nonatomic)IBOutlet UILabel*lbMovie;
@property(weak,nonatomic)IBOutlet UILabel*lbMusic;
@property(weak,nonatomic)IBOutlet UILabel*lbWork;
@property(weak,nonatomic)IBOutlet UILabel*lbArrive;
@property(weak,nonatomic)IBOutlet UILabel*lbGuanXi;
@property(weak,nonatomic)IBOutlet UILabel*lbYear;
@property(weak,nonatomic)IBOutlet UITableView*_tableView;

@property(weak,nonatomic)IBOutlet UIImageView*image1;
@property(nonatomic,weak)IBOutlet UIImageView*image2;
@property(nonatomic,weak)IBOutlet UIImageView*image3;


// 这里也要问设计为什么上面有一个大的签名，下面还要有一个小的签名 臣妾看不懂设计啊
@property(nonatomic,weak)IBOutlet UILabel*lbHeartUp;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UIImageView *headBackImgView;






@end
