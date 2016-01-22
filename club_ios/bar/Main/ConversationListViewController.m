//
//  ConversationListViewController.m
//  bar
//
//  Created by chen on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ConversationListViewController.h"
#import "ChatListViewController.h"
#import "ChatroomViewController.h"
#import "ChatViewController.h"
#import "blackListViewController.h"
#import "GroupViewController.h"


@interface ConversationListViewController ()

@end

@implementation ConversationListViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"聊天控制器";
    //打开聊天列表
    UIButton *button0 = [UIButton buttonWithType:UIButtonTypeCustom];
    button0.frame = CGRectMake(0, KScreenHeight-49-50, KScreenWidth, 50);
    [button0 setTitle:@"打开聊天列表(记录)" forState:UIControlStateNormal];
    button0.backgroundColor = [UIColor greenColor];
    [button0 addTarget:self action:@selector(chatList) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button0];
    
    //开启单聊
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 64, KScreenWidth, 50);
    [button setTitle:@"开启单聊" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    //开启聊天室
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(0, 115, KScreenWidth, 50);
    button1.backgroundColor = [UIColor greenColor];
    [button1 setTitle:@"开启聊天室" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    //开启客服
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(0, 166, KScreenWidth, 50);
    button2.backgroundColor = [UIColor greenColor];
    [button2 setTitle:@"开启客服" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    
    
    //开启讨论组
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(0, 217, KScreenWidth, 50);
    button4.backgroundColor = [UIColor greenColor];
    [button4 setTitle:@"开启讨论组" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonAction4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.conversationListTableView.tableFooterView = view;
    
    //开启黑名单
    UIButton *button5 = [UIButton buttonWithType:UIButtonTypeCustom];
    button5.frame = CGRectMake(0, 268, KScreenWidth, 50);
    button5.backgroundColor = [UIColor greenColor];
    [button5 setTitle:@"黑名单" forState:UIControlStateNormal];
    [button5 addTarget:self action:@selector(buttonAction5) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button5];
    
}
//黑名单
- (void)buttonAction5{
    UIStoryboard * Mainsb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    blackListViewController * blackVC = [Mainsb instantiateViewControllerWithIdentifier:@"blackListViewControllerID"];
    [self.navigationController pushViewController:blackVC animated:YES];
}

//开启讨论组
- (void)buttonAction4{
    // 启动讨论组，与启动单聊等类似
    // 启动讨论组，与启动单聊等类似
    UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
    GroupViewController * temp = [club instantiateViewControllerWithIdentifier:@"GroupViewControllerID"];
    temp.targetId = @"19527";
    temp.conversationType = ConversationType_DISCUSSION;// 传入讨论组类型
    temp.title = @"we club 讨论组";
    [self.navigationController pushViewController:temp animated:YES];
    
    NSLog(@"发起小组右键点击了");
}

//获取未读消息数
- (void)buttonAction1{
    // 启动聊天室，与启动单聊等类似
    RCConversationViewController *temp = [[RCConversationViewController alloc]init];
    temp.targetId = @"19527";
    temp.conversationType = ConversationType_CHATROOM;// 传入聊天室类型
    temp.userName = @"jeck";
    temp.title = @"we club 聊天室";
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:temp animated:YES];
    
}
//开启客服
- (void)buttonAction2{
    /**
     * 参数说明
     *
     * conversationType 会话类型，此处应该传 RCConversationType.ConversationType_APPSERVICE
     * targetId 客服 Id
     * userName 客服名称
     * title 客服会话界面 Title
     */
    RCPublicServiceChatViewController *conversationVC = [[RCPublicServiceChatViewController alloc] init];
    conversationVC.conversationType = ConversationType_CUSTOMERSERVICE;
    conversationVC.targetId = @"KEFU144705892268776";
    conversationVC.userName = @"lucy";
    conversationVC.title = @"客服中心";
    [self.navigationController pushViewController:conversationVC animated:YES];
    
}

//开启单聊
- (void)buttonAction{
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = @"0cf1d5dd-79b2-4549-a910-60146249f0ca"; // 接收者的 targetId，这里为举例。
    conversationVC.userName = @"李书鹏"; // 接受者的 username，这里为举例。
    conversationVC.title = conversationVC.userName; // 会话的 title。
    self.hidesBottomBarWhenPushed = YES;
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController pushViewController:conversationVC animated:YES];
}
//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}
//打开聊天列表
- (void)chatList{
    ChatListViewController * chatListViewController=[[ChatListViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)] collectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:chatListViewController animated:YES];
    
}


@end
