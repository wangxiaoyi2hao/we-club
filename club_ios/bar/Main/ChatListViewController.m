//
//  ChatListViewController.m
//  RCdemo
//
//  Created by chen on 15/11/9.
//  Copyright © 2015年 jeck. All rights reserved.
//

#import "ChatListViewController.h"
#import "ChatViewController.h"
//#import "messViewController.h"
#import "LxxPlaySound.h"

@interface ChatListViewController ()

@end

@implementation ChatListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    messViewController *mecv = [[messViewController alloc] init];
//    mecv.view.frame = CGRectMake(0, 0, KScreenWidth, 200);    
//    self.conversationListTableView.tableHeaderView = mecv.view;
    
    //会话列表界面的用户头像设置为圆形边角
    [RCIM sharedRCIM].globalConversationAvatarStyle=RC_USER_AVATAR_CYCLE;
    //添加黑名单
    self.title = @"聊天列表";
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(220, 64, 100, 50);
    button.backgroundColor = [UIColor greenColor];
    [button setTitle:@"添加黑名单" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(rightBarButtonItemPressed:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //获取未读消息数
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeCustom];
    button1.frame = CGRectMake(220, 115, 100, 50);
    button1.backgroundColor = [UIColor greenColor];
    [button1 setTitle:@"获取未读消息数" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(buttonAction1) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];
    //开启客服
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeCustom];
    button2.frame = CGRectMake(220, 166, 100, 50);
    button2.backgroundColor = [UIColor greenColor];
    [button2 setTitle:@"开启客服" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(buttonAction2) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button2];
    //声音和振动
    UIButton *button4 = [UIButton buttonWithType:UIButtonTypeCustom];
    button4.frame = CGRectMake(220, 217, 100, 50);
    button4.backgroundColor = [UIColor greenColor];
    [button4 setTitle:@"声音和振动" forState:UIControlStateNormal];
    [button4 addTarget:self action:@selector(buttonAction4) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button4];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    self.conversationListTableView.tableFooterView = view;

}
//这个方法可以查看聊天记录
//重载函数，onSelectedTableRow 是选择会话列表之后的事件，该接口开放是为了便于您自定义跳转事件。在快速集成过程中，您只需要复制这段代码。
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath
{
    RCConversationViewController *conversationVC = [[RCConversationViewController alloc]init];
    conversationVC.conversationType =model.conversationType;
    conversationVC.targetId = model.targetId;
//    conversationVC.userName =model.conversationTitle;
    conversationVC.title = model.conversationTitle;
    [self.navigationController pushViewController:conversationVC animated:YES];
}


//开启讨论组
- (void)buttonAction4{
   
    
}
//未读消息数
- (void)buttonAction1{
    /**
     *  获取所有未读消息数。
     *
     *  @return 未读消息数。
     */
    int count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    NSLog(@"获取未读消息数:%d",count);
    /**
     *  获取某会话类型的未读消息数.
     *
     *  @param conversationTypes 会话类型, 存储对象为NSNumber type类型为int
     *
     *  @return 未读消息数。
     */
    int unreadMsgCount = [[RCIMClient sharedRCIMClient] getUnreadCount:@[
                                                                         @(ConversationType_PRIVATE),
                                                                         @(ConversationType_DISCUSSION),
                                                                         @(ConversationType_APPSERVICE),
                                                                         @(ConversationType_PUBLICSERVICE),
                                                                         @(ConversationType_GROUP)
                                                                         ]];
    NSLog(@"获取某会话类型的未读消息数:%d",unreadMsgCount);
    /**
     *  获取会话信息。
     *
     *  @param conversa tionType 会话类型。
     *  @param targetId         会话 Id。
     *
     *  @return 会话信息。
     */
    RCConversation *rccon =[[RCIMClient sharedRCIMClient] getConversation:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca"];
    /*!
     会话中未读消息数
     */
    int count1 = rccon.unreadMessageCount;
    NSLog(@"获取某一会话未读消息数:%d",count1);
    
    /**
     *  会话的json数据
     */
    //获取某一会话(类)最近一条未读消息实体
    NSDictionary *dic = rccon.jsonDict;
    NSLog(@"获取某一类型当前会话最近一条未读消息实体:%@",dic);
    //设置消息置顶
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca" isTop:YES];
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca" isTop:NO];
}
//开启客服
- (void)buttonAction2{
    /**
     *  设置某一会话为置顶或者取消置顶。
     *
     *  @param conversationType 会话类型。
     *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
     *  @param isTop            是否置顶。
     *
     *  @return 是否设置成功。
     */
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca" isTop:NO];
    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca" isTop:YES];
    
    
    [self refreshConversationTableViewIfNeeded];
    [[RCIMClient sharedRCIMClient] setConversationNotificationStatus:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca" isBlocked:YES success:^(RCConversationNotificationStatus nStatus) {
        nStatus = DO_NOT_DISTURB;
    } error:^(RCErrorCode status) {
        NSLog(@"设置静音失败");
    }];
    }
/**
 *  设置会话消息提醒状态。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param isBlocked        是否屏蔽。
 *  @param successBlock     调用完成的处理。
 *  @param errorBlock       调用返回的错误信息。
 */
//- (void)
//setConversationNotificationStatus:(RCConversationType)conversationType
//targetId:(NSString *)targetId
//isBlocked:(BOOL)isBlocked
//success:(void (^)(RCConversationNotificationStatus
//                  nStatus))successBlock
//error:(void (^)(RCErrorCode status))errorBlock;
/**
 *  设置某一会话为置顶或者取消置顶。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id 或聊天室 Id。
 *  @param isTop            是否置顶。
 *
 *  @return 是否设置成功。
 */
//- (BOOL)setConversationToTop:(RCConversationType)conversationType
//                    targetId:(NSString *)targetId
//                       isTop:(BOOL)isTop;

// 快速集成第四步，发起单聊会话。
-(void)rightBarButtonItemPressed:(id)sender
{

#pragma mark - 加入黑名单
    ///**
    // *  获取用户黑名单状态
    // *
    // *  @param userId     用户id
    // *  @param successBlock 获取用户黑名单状态成功。bizStatus：0-在黑名单，101-不在黑名单
    // *  @param errorBlock      获取用户黑名单状态失败。
    // */
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:@"1001" success:^(int bizStatus) {
        if (bizStatus ==0) {
            NSLog(@"已经在黑名单");
        }else{
            /**
             *  加入黑名单
             *
             *  @param userId     用户id
             *  @param successBlock 加入黑名单成功。
             *  @param errorBlock      加入黑名单失败。
             */
            [[RCIMClient sharedRCIMClient] addToBlacklist:@"1001" success:^{
                NSLog(@"添加成功");
                
            } error:^(RCErrorCode status) {
                NSLog(@"添加失败");
            }];
        }
    } error:^(RCErrorCode status) {
        NSLog(@"获取用户黑名单状态失败");
    }];
}


//重写展示空列表的方法，展示自定义的view
- (void)showEmptyConversationView
{
    UIView *blankView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    blankView.backgroundColor = [UIColor greenColor];
    
    // todo
    super.emptyConversationView=blankView;
    [self.view addSubview:self.emptyConversationView];
}

- (NSArray *)getConversationList:(NSArray *)conversationTypeList{
    NSArray *arry = conversationTypeList;
    NSLog(@"%@",arry);
    return arry;
}
//插入自定义会话model
//-(NSMutableArray *)willReloadTableData:(NSMutableArray *)dataSource
//{
//    
//    for (int i=0; i<dataSource.count; i++) {
//        RCConversationModel *model = dataSource[i];
//        //筛选请求添加好友的系统消息，用于生成自定义会话类型的cell
//        if(model.conversationType == ConversationType_SYSTEM && [model.lastestMessage isMemberOfClass:[RCContactNotificationMessage class]])
//        {
//            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//        }
//    }
//    
//    return dataSource;
//}
/**
 *  获取某会话类型的未读消息数.
 *
 *  @param conversationTypes 会话类型, 存储对象为NSNumber type类型为int
 *
 *  @return 未读消息数。
 */
//- (int)getUnreadCount:(NSArray *)conversationTypes{
//    return 10;
//}



@end
