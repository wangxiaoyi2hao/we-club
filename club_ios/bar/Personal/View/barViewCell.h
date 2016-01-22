//
//  barViewCell.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface barViewCell : UITableViewCell



@property (weak, nonatomic) IBOutlet UILabel *barName;
@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *femaleNumber;
@property (weak, nonatomic) IBOutlet UILabel *maleNumber;

@property (weak, nonatomic) IBOutlet UILabel *followingOrNot;
@property (weak, nonatomic) IBOutlet UILabel *distance;
@property(weak,nonatomic) IBOutlet UILabel*lbAddress;
@property(weak,nonatomic)IBOutlet UIButton*buttonAddress;
@property(weak,nonatomic)IBOutlet UILabel*isGuanZhu;

@end
