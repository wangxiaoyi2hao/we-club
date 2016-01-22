//
//  InvarionTableViewCell2.h
//  bar
//
//  Created by lsp's mac pro on 15/11/12.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InvarionTableViewCell2 : UITableViewCell<UICollectionViewDelegateFlowLayout,UICollectionViewDataSource>

@property (weak, nonatomic) IBOutlet UIImageView *sexImageView;//性别标志
@property (weak, nonatomic) IBOutlet UIImageView *redPacketImageView;//红包背景图
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property(nonatomic,weak)   IBOutlet UIView*_topView;
@property(nonatomic,weak)   IBOutlet UIButton*_buttonSignUp;
@property(nonatomic,weak)  IBOutlet UIButton*_buttonMyInvite;
@property(nonatomic,weak) IBOutlet UIButton*_buttonReport;//举报按钮
@property(nonatomic,weak) IBOutlet UIButton*_buttonShare;
@property(nonatomic,weak)IBOutlet UIButton*_buttonUser;
@property(nonatomic,weak)IBOutlet UILabel*lbName;
@property(nonatomic,weak)IBOutlet UILabel*lbHeart;
@property(nonatomic,weak)IBOutlet UILabel*lbAddress;
@property(nonatomic,weak)IBOutlet UILabel*lbTime;
@property(nonatomic,weak)IBOutlet UILabel*lbtitle;
@property(nonatomic,weak)IBOutlet UILabel*lbYear;
@property(nonatomic,weak)IBOutlet UIImageView*_imageViewSex;
@property(nonatomic,weak)IBOutlet UILabel*lbHongBaoMoney;
@property(nonatomic,weak)IBOutlet UILabel*lbSignUp;
@property(nonatomic,weak)IBOutlet UILabel*lbDistanceAndMintues;
@property(nonatomic,weak)IBOutlet UIButton*buttonAll;
@property(nonatomic,weak)IBOutlet UIImageView*_imageGirl;
@property(nonatomic,weak)IBOutlet UIImageView*manQingKe;

@property(nonatomic,weak)IBOutlet UIButton*lookImage1;
@property(nonatomic,weak)IBOutlet UIButton*lookImage2;
@property(nonatomic,weak)IBOutlet UIButton*lookImage3;
@property(nonatomic,weak)IBOutlet UIButton*lookImage4;

@property(nonatomic,weak)IBOutlet UILabel*lbMissTime;

@property (weak, nonatomic) IBOutlet UIView *myChangView;
@property (weak, nonatomic) IBOutlet UIView *myBackImageView;
- (IBAction)mySignUpAction:(UIButton *)sender;
- (IBAction)sheraAction:(UIButton *)sender;
@property (nonatomic, strong)NSMutableArray *myInvireMutableArray;



@end
