//
//  BaseCell.m
//  bar
//
//  Created by chen on 15/10/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseCell.h"
#import "AppDelegate.h"

@implementation BaseCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        [AppDelegate matchAllScreenWithView:self.contentView];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
