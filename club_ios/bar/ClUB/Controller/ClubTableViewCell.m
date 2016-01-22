//
//  ClubTableViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/11/13.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ClubTableViewCell.h"
#import "AppDelegate.h"

@implementation ClubTableViewCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    //    self.layer.cornerRadius = 5.0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;

    //[self.attentionButAction setTitle:@"关注" forState:UIControlStateNormal];
    //[self.attentionButAction setTitle:@"已关注" forState:UIControlStateSelected];
    //_attentionButAction.selected = NO;
    
    //[self.attentionButAction setImage:[UIImage imageNamed:@"2-1-7"] forState:UIControlStateNormal];
    
    //[self.attentionButAction setImage:[UIImage imageNamed:@"2-1-7"] forState:UIControlStateSelected];
    //self.attentionButAction.titleLabel.font = [UIFont systemFontOfSize:12];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
