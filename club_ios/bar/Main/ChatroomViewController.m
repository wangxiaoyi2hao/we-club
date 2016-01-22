//
//  ChatroomViewController.m
//  bar
//
//  Created by chen on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ChatroomViewController.h"

@interface ChatroomViewController ()

@end

@implementation ChatroomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置头像为圆角
- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
{
    if ([cell isKindOfClass:[RCMessageCell class]]) {
        RCMessageCell *messageCell = (RCMessageCell *)cell;
        
        UIImageView *portraitImageView= (UIImageView *)messageCell.portraitImageView;
        portraitImageView.layer.cornerRadius = 23;
    }
    //隐藏聊天头像
    //    RCMessageCell *BaseCell=(RCMessageCell *)cell;
    //    UIImageView *imageView= (UIImageView *)BaseCell.portraitImageView;
    //    imageView.hidden=YES;
}



@end
