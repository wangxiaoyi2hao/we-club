//
//  notificationCell.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "notificationCell.h"
#import "AppDelegate.h"

@implementation notificationCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)viewBtnClick:(UIButton *)sender {
    NSLog(@"点击了查看邀约");
}
@end
