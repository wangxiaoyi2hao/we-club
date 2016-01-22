//
//  chatCell.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "chatCell.h"
#import "AppDelegate.h"

@implementation chatCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    [_messageNumber setBackgroundColor:[HelperUtil colorWithHexString:@"e43f6d"]];
    _messageNumber.font = [UIFont systemFontOfSize:7];
    _messageNumber.textColor = [UIColor whiteColor];
    _messageNumber.textAlignment = NSTextAlignmentCenter;
    _messageNumber.layer.cornerRadius = 5;
    _messageNumber.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
