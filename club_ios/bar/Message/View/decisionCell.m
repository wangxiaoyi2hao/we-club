//
//  decisionCell.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//通知提醒界面
#import "decisionCell.h"
#import "AppDelegate.h"

@implementation decisionCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    _segmentControl.selectedSegmentIndex = -1;

}

- (IBAction)segBtnClick:(UISegmentedControl *)sender {
    if (sender.selectedSegmentIndex == 0) {
        NSLog(@"你点击了同意");
    } else if (sender.selectedSegmentIndex == 1) {
        NSLog(@"你点击了拒绝");
    } else if (sender.selectedSegmentIndex == 2) {
        NSLog(@"你点击了查看邀请");
    }
    sender.selectedSegmentIndex = -1;
}
@end
