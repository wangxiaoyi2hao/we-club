//
//  helloCell.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "helloCell.h"
#import "AppDelegate.h"

@implementation helloCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
