//
//  ReportTableViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/11/6.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ReportTableViewCell.h"
#import "AppDelegate.h"

@implementation ReportTableViewCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
