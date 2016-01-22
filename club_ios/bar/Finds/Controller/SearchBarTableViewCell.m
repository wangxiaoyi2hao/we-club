//
//  SearchBarTableViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/11/11.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SearchBarTableViewCell.h"
#import "AppDelegate.h"

@implementation SearchBarTableViewCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
