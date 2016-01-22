//
//  RedPacketInvitationVC.h
//  bar
//
//  Created by chen on 15/11/21.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@interface RedPacketInvitationVC : BaseViewController
@property (weak, nonatomic) IBOutlet UILabel *successLabel;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addressLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateAndTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *redPacketLabel;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UILabel *timerLabel;
- (IBAction)startAction:(UIButton *)sender;
- (IBAction)stopAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;

@property(copy,nonatomic)NSString*fromInviteID;

@end
