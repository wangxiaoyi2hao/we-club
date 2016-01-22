//
//  messageViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface messageViewController : UITableViewController
{
    BOOL notiBtnOn,voiceBtnOn,vibrateBtnOn,showContentBtnOn;
}
@property (weak, nonatomic) IBOutlet UIImageView *notiImg;
@property (weak, nonatomic) IBOutlet UIImageView *voiceImg;
@property (weak, nonatomic) IBOutlet UIImageView *vibrateImg;
@property (weak, nonatomic) IBOutlet UIImageView *showConteImg;

@property (weak, nonatomic) IBOutlet UIButton *notiBtn;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UIButton *vibrateBtn;
@property (weak, nonatomic) IBOutlet UIButton *showContentBtn;

- (IBAction)notiBtnClick:(UIButton *)sender;
- (IBAction)voiceBtnClick:(UIButton *)sender;
- (IBAction)vibrateBtnClick:(UIButton *)sender;
- (IBAction)showContentBtnClick:(UIButton *)sender;
- (IBAction)backBtnClick:(id)sender;


@end
