//
//  fansViewCell.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface fansViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *message;
@property (weak, nonatomic) IBOutlet UILabel *genderAndAge;
@property (weak, nonatomic) IBOutlet UILabel *distanceAndTime;
@property(weak,nonatomic)IBOutlet UIImageView*_imageViewSex;
@property(weak,nonatomic)IBOutlet UIButton*buttonHead;
- (IBAction)addFriends:(UIButton *)sender;


@end
