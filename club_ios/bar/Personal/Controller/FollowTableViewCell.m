//
//  FollowTableViewCell.m
//  Weclub
//
//  Created by chen on 15/12/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FollowTableViewCell.h"

@implementation FollowTableViewCell

- (void)awakeFromNib {
    [self.contentView setBackgroundColor:[UIColor clearColor]];
    if (KScreenHeight == 480) {
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }else if(KScreenHeight == 568){
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }else if(KScreenHeight == 667){
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }else{
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }
    
    self.picture.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
