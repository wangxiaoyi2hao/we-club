//
//  InviteCompleCell.m
//  Weclub
//
//  Created by chen on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "InviteCompleCell.h"
#import "AppDelegate.h"
#import "UIView+UiViewConctroller.h"

@implementation InviteCompleCell{
    UITableView *_tableView;
}

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    _contentText.delegate = self;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
//点击事件
- (void)tapActionLeft:(UITapGestureRecognizer *)tap{
    [_contentText resignFirstResponder];
    _tableView.contentOffset = CGPointMake(0, 0);
    [self.viewController.view removeGestureRecognizer:tap];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    //设置偏移量
    NSArray *array =[self.viewController.view subviews];
    if (array.count >0) {
        
        _tableView = array[0];
        _tableView.contentOffset = CGPointMake(0, 62);
    }
//    self.viewController.view.
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionLeft:)];
    [self.viewController.view addGestureRecognizer:singleTap];
    
    return YES;
}

@end
