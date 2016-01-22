//
//  FollowTableViewCell.h
//  Weclub
//
//  Created by chen on 15/12/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FollowTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *picture;
@property (weak, nonatomic) IBOutlet UILabel *nickname;
@property (weak, nonatomic) IBOutlet UILabel *message;

@property (weak, nonatomic) IBOutlet UILabel *distanceAndTime;
@property(weak,nonatomic)IBOutlet UIImageView*_imageViewSex;
@property(weak,nonatomic)IBOutlet UIButton*buttonHead;
@end
