//
//  RCCustomCell.m
//  Weclub
//
//  Created by chen on 16/1/7.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "RCCustomCell.h"
#import "AppDelegate.h"

@implementation RCCustomCell

- (void)awakeFromNib {
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 10, 40*KScreenWidth/320, 40*KScreenWidth/320)];
    [self.contentView addSubview:_iconImageView];
    
    //[AppDelegate matchAllScreenWithView:self.contentView];
//    //角标，这个用来显示每个好友的角标，实现类似QQ聊天列表中强大的拖曳角标的功能
//    self.ppBadgeView = [[PPDragDropBadgeView alloc]initWithFrame:CGRectMake(self.contentLabel.frame.origin.x+self.contentLabel.frame.size.width, self.contentLabel.frame.origin.y, 25, 25)]; self.ppBadgeView.fontSize = 12;
//    [self.contentView addSubview:self.ppBadgeView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
