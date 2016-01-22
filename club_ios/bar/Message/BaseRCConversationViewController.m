//
//  BaseRCConversationViewController.m
//  Weclub
//
//  Created by chen on 15/12/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseRCConversationViewController.h"
#import "InfoTableViewController.h"

//extern UserInfo*LoginUserInfo;
@interface BaseRCConversationViewController ()

@end

@implementation BaseRCConversationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
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
/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    UIStoryboard *storyBd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *infoTVC = [storyBd instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    infoTVC.fromUserId =  userId;
    [self.navigationController pushViewController:infoTVC animated:YES];
    
}
@end
