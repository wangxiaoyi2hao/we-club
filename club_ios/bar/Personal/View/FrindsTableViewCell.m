//
//  FrindsTableViewCell.m
//  bar
//
//  Created by chen on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FrindsTableViewCell.h"
#import "AppDelegate.h"

@implementation FrindsTableViewCell

- (void)awakeFromNib {
    [self initView];
    [AppDelegate matchAllScreenWithView:self.contentView];
}
- (void)initView{
    _iconImageView.image = [UIImage imageNamed:@"分享个帅图.jpg"];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
