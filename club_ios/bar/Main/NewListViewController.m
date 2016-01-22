//
//  NewListViewController.m
//  Weclub
//
//  Created by chen on 16/1/8.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "NewListViewController.h"
#import "RCDataManager.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCCustomCell.h"
#import "RCListCustomCell.h"
#import "AppDelegate.h"
#import "BarTabBarController.h"
#import "massageModels.h"
#import "notificationViewController.h"
#import "RedPacketInvitationVC.h"
#import "InfoTableViewController.h"

extern UserInfo *LoginUserInfo;
extern NSMutableArray *friendsAndRoucludUserInfoArray;
extern NSMutableArray *rouclubGroupInfoArray;

@interface NewListViewController ()

@end

@implementation NewListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *headView = [UIView new];
//    headView.frame = CGRectMake(0, 0, KScreenWidth, 44*KScreenWidth/320);
//    headView.backgroundColor = [UIColor greenColor];
    self.conversationListTableView.tableHeaderView = headView;
    UIView *footView = [UIView new];
    self.conversationListTableView.tableFooterView = footView;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //设置需要显示哪些类型的会话
    [self setDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION),@(ConversationType_CHATROOM),@(ConversationType_GROUP),@(ConversationType_APPSERVICE),@(ConversationType_SYSTEM),@(ConversationType_CUSTOMERSERVICE)]];
//    [self setCollectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_CHATROOM)]];
}
//添加自定义数据
- (void)addModel{
    NSArray * nameArray = @[@"朱立佳",@"李书鹏",@"何曼妮",@"红包邀约"];
    NSArray * idArray = @[@"beb694c7-2509-4fde-bc0c-ca7612e2bded",@"0cf1d5dd-79b2-4549-a910-60146249f0ca",@"2f9ce1ed-3279-474b-bcbf-983805b768f4",@"hongbao"];
   
    for (int i=0; i<nameArray.count; i++) {
         NSMutableDictionary *mdic = [[NSMutableDictionary alloc] init];
        RCConversationModel *conversationModel =[[RCConversationModel alloc] init];
        conversationModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        if (i==nameArray.count-1) {
            
            conversationModel.conversationType = ConversationType_CUSTOMERSERVICE;
            //            conversationModel.isTop = YES;
        }else{
            conversationModel.conversationType = ConversationType_PRIVATE;
            //            conversationModel.isTop = NO;
            
        }
        conversationModel.targetId = idArray[i];
        conversationModel.conversationTitle = nameArray[i];
        
        [mdic setObject:nameArray[i] forKey:@"name"];
        [mdic setObject:@"girlpicture.png" forKey:@"iconName"];
        conversationModel.extend = mdic;
        [_dataArray addObject:conversationModel];
    }
    NSLog(@"需要添加的model数%ld",_dataArray.count);
    //    [self willReloadTableData:self.conversationListDataSource];
    //    [self.conversationListTableView reloadData];
    //    [[RCIMClient sharedRCIMClient] setConversationToTop:ConversationType_CUSTOMERSERVICE targetId:conversationModel.targetId isTop:YES];
}
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
//                       isTop:(BOOL)isTop{
//    return YES;
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    //Dispose of any resources that can be recreated.
}
#pragma mark-//******************修改自定义Cell中model的会话model类型******************//
//单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"创建单元格数%ld",self.conversationListDataSource.count);
    return self.conversationListDataSource.count;
}
/**
 *  将要显示会话列表单元，可以有限的设置cell的属性或者修改cell,例如：setHeaderImagePortraitStyle
 *
 *  @param cell      cell
 *  @param indexPath 索引
 */
- (void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
    
//    RCConversationModel *model=[self.conversationListDataSource lastObject];
//    model.isTop = YES;
    
    for (int i=0; i<self.conversationListDataSource.count; i++) {
        RCConversationModel *model = self.conversationListDataSource[i];
        NSString *str = [(NSDictionary *)model.extend objectForKey:@"name"];
        NSLog(@"%@",str);
        if([str  isEqualToString:@"红包邀约"]){
            model.isTop = YES;
            
        }
    }
}
//插入自定义会话model,这个很重要，一定要实现
-(NSMutableArray*)willReloadTableData:(NSMutableArray *)dataSource{
    for (int i=0; i<dataSource.count; i++) {
        RCConversationModel *model = dataSource[i];
        if(model.conversationType == ConversationType_CUSTOMERSERVICE){
            //如果是单聊，那么我们改model的一个属性，就是把会话model的类型改为自定义
            model.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        }
    }
    _dataArray = [[NSMutableArray alloc] init];
    if (_dataArray.count==0) {
        
        [self addModel];
    }
    [dataSource addObjectsFromArray:_dataArray];
//    [self.conversationListTableView reloadData];
    NSLog(@"添加数据后的数据源model数%ld",dataSource.count);
    return dataSource;
}
//开始使用自定义cell(只创建插入的新单元格)
//*****************插入自定义Cell******************//
//这个返回cell的方法，以前也贴出来过，不过注释比较少，这次专门来讲解这个返回cell的方法，这里就返回了我们自定义的cell
-(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.conversationListDataSource.count&&indexPath.row < self.conversationListDataSource.count) {
        //首先我们要从数据源数组中取出融云的model类，方便下面使用model的属性，大把资料要从model的属性中获取，或者间接获取到
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
            NSLog(@"rcConversationListTableView 名字 ＝ %@ ID ＝ %@",userInfo.name,userInfo.userId);
        }];
        //每个cell的未读消息数量
        NSInteger unreadCount = model.unreadMessageCount;
        //我们alloc 一个自己的cell，下面给他赋值，处理逻辑
//        RCListCustomCell *cell = (RCListCustomCell *)[[RCListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCCustomCell"];

        static NSString *iden = @"RCCustomCell";
        RCCustomCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            //需要使用Nib获得RCCustomCell.xib中已经创建好的单元格
            cell = (RCCustomCell *)[[[NSBundle mainBundle] loadNibNamed:@"RCCustomCell" owner:self options:nil] lastObject];//这里调用加载nib文件
            
        }
        //获取当前时间
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *currentDateFormatter =
        [[NSDateFormatter alloc] init];
        [currentDateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *currentDateString = [currentDateFormatter stringFromDate:currentDate];
        //获取接收时间
        NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.receivedTime/1000];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd"];
        NSString *dateString = [dateFormatter stringFromDate:date];
        //NSString *timeString = [[MSUtil stringFromDate:date] substringToIndex:10];
        //NSString *temp = [MSUtil getyyyymmdd];
        //NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
        
        if ([dateString isEqualToString:currentDateString]) {
            
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            [formatter setDateFormat:@"HH:mm"];
            NSString *showtimeNew = [formatter stringFromDate:date];
            
            //这里赋值时间，时间显示，融云mode里面的是long long类型的，用的时候一定要转化，方法和代码都有了，不多赘述
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",showtimeNew];
            
        }else{
            cell.timeLabel.text = [NSString stringWithFormat:@"%@",dateString];
        }
        //处理角标的拖曳，这里拖曳完成之后回调一个block，在block里面我们要处理逻辑了，你把角标拖曳掉之后，要调用RCIMClient这个单例，设置某人的未读消息为0.因为你已经拖曳掉了这个角标啊。到此还不行，因为数据源里面model的属性没变，model的属性没变，滑动table，角标又一次出现了，治标不治本，那么我们直接设置,那么我们这样就做到了，融云服务器上的某人的未读消息数量和本地cell上面的一致了；
        model.unreadMessageCount = 0;
//        cell.ppBadgeView.dragdropCompletion = ^{
//            NSLog(@"VC = FFF ，ID ＝ %@",model.targetId);
//            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
//            model.unreadMessageCount = 0;
//            NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
//            
//            long tabBarCount = ToatalunreadMsgCount-model.unreadMessageCount;
//            
//            //获取所有未读消息数
////                int notReadMessage = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
////                int notReadMessage = [[UserInfoModel currentUserinfo].notReadMessage intValue];
//            
//            if (tabBarCount > 0) {
//                
//                [BarTabBarController shareBarTabBarController].numberLabel.text = [NSString stringWithFormat:@"%ld",tabBarCount];
//                
//                //        if (notReadMessage > 0) {
//                //            [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage + tabBarCount;
//                //        }
//                //        else {
//                //            [UIApplication sharedApplication].applicationIconBadgeNumber = tabBarCount;
//                //        }
//            }else {
//                [BarTabBarController shareBarTabBarController].numberLabel.text = nil;
//                
//                //        if (notReadMessage > 0) {
//                //            [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage;
//                //        }
//                //        else {
//                //            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//                //        }
//            }
//        };
//        if (unreadCount==0) {
//            cell.ppBadgeView.text = @"19";
//            
//        }else{
//            if (unreadCount>=100) {
//                cell.ppBadgeView.text = @"99+";
//            }else{
//                cell.ppBadgeView.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
//                
//            }
//        }
        
        
        
//        for (RCUserInfo *userInfo in friendsAndRoucludUserInfoArray) {
//            if ([model.targetId isEqualToString:userInfo.userId]) {
//                //赋值名字属性
//                cell.realNameLabel.text = [userInfo.name isEqualToString:@""]?[NSString stringWithFormat:@"%@",userInfo.name]:[NSString stringWithFormat:@"%@",userInfo.name];
//                
//                //赋值头像
//                if ([userInfo.portraitUri isEqualToString:@""]||userInfo.portraitUri==nil) {
//                    cell.avatarIV.image = [UIImage imageNamed:@"chatlistDefault"];
//                    [cell.contentView bringSubviewToFront:cell.avatarIV];
//                }else{
//                    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"chatlistDefault"]];
//                }
//                
//                if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
//                    cell.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
//                    
//                }else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
//                    
//                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
//                        //我自己发的
//                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
//                        
//                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
//                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
//                        }else{
//                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
//                            
//                        }
//                    }else{
//                        
//                        cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",userInfo.name] ;
//                    }
//                    
//                }else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
//                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
//                        //我自己发的
//                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
//                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
//                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
//                            
//                        }else{
//                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
//                        }
//                    }else{
//                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",userInfo.name];
//                    }
//                }
//                else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
//                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
//                        //我自己发的
//                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
//                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
//                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
//                        }else{
//                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
//                        }
//                    }else{
//                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",userInfo.name];
//                    }
//                }
//                
//            }
//        }
        //目前最后一个为红包
        if (indexPath.row == self.conversationListDataSource.count-1) {
            
            cell.realNameLabel.text = @"红包邀约";
            cell.iconImageView.image = [UIImage imageNamed:@"红包.png"];
            cell.contentLabel.text = [NSString stringWithFormat:@"您正在和kim邀约ing"];
        }else{
            cell.realNameLabel.text = [(NSDictionary *)model.extend objectForKey:@"name"];
            cell.iconImageView.image =  [UIImage imageNamed:[(NSMutableDictionary *)model.extend objectForKey:@"iconName"]];
            cell.contentLabel.text = @"来慢城酒吧玩";
        }
        return cell;
    }else{
        
        return [[RCConversationBaseCell alloc]init];
    }
}
//点击单元格方法
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    //最后4个的点击方法为测试方法
    if (indexPath.row == self.conversationListDataSource.count-1) {
        UIStoryboard *redStoryboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
        RedPacketInvitationVC *redVC = [redStoryboard instantiateViewControllerWithIdentifier:@"RedPacketInvitationVCID"];
        [self.navigationController pushViewController:redVC animated:YES];
        NSLog(@"点击了红包");
        
    }else if(indexPath.row == self.conversationListDataSource.count-2){
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        ChatViewController * conversationVC = [club instantiateViewControllerWithIdentifier:@"ChatViewControllerID"];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"2f9ce1ed-3279-474b-bcbf-983805b768f4"; // 接收者的 targetId，这里为举例。
        conversationVC.title = @"何曼妮";
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
        
    }else if(indexPath.row == self.conversationListDataSource.count-3){
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        ChatViewController * conversationVC = [club instantiateViewControllerWithIdentifier:@"ChatViewControllerID"];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"0cf1d5dd-79b2-4549-a910-60146249f0ca"; // 接收者的 targetId，这里为举例。
        conversationVC.title = @"李书鹏";
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else if(indexPath.row == self.conversationListDataSource.count-4){
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        ChatViewController * conversationVC = [club instantiateViewControllerWithIdentifier:@"ChatViewControllerID"];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"beb694c7-2509-4fde-bc0c-ca7612e2bded";
        //conversationVC.targetId = @"0cf1d5dd-79b2-4549-a910-60146249f0ca"; // 接收者的 targetId，这里为举例。
        conversationVC.title = @"朱立佳";
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else{
        
        ChatViewController *conversationVC = [[ChatViewController alloc]init];
        conversationVC.conversationType = model.conversationType;
        conversationVC.targetId = model.targetId;
        for (RCUserInfo *userInfo in friendsAndRoucludUserInfoArray) {
            if ([model.targetId isEqualToString:userInfo.userId]) {
                conversationVC.title =[userInfo.name isEqualToString:@""]?@"昵称":[NSString stringWithFormat:@"%@",userInfo.name];
            }
        }
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}

#pragma mark - 监听收到消息
/**
 *  收到新消息,用于刷新会话列表，如果派生类调用了父类方法，请不要再次调用refreshConversationTableViewIfNeeded，避免多次刷新
 *  当收到多条消息时，会在最后一条消息时在内部调用refreshConversationTableViewIfNeeded
 *
 *  @param notification notification
 */
//-(void)didReceiveMessageNotification:(NSNotification *)notification{
//    __weak typeof(&*self) blockSelf_ = self;
//    //处理好友请求
//    RCMessage *message = notification.object;
//    
//    if ([message.content isMemberOfClass:[RCMessageContent class]]) {
//        if (message.conversationType == ConversationType_PRIVATE) {
//            NSLog(@"好友消息要发系统消息！！！");
//            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
//        }
//        RCConversationModel *customModel = [RCConversationModel new];
//        //自定义cell的type
//        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
//        customModel.senderUserId = message.senderUserId;
//        customModel.lastestMessage = message.content;
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //调用父类刷新未读消息数
//            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
//            [super didReceiveMessageNotification:notification];
//            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
//            [self notifyUpdateUnreadMessageCount];
//            
//            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
//            //原因请查看super didReceiveMessageNotification的注释。
//            
//        });
//        
//    }else if (message.conversationType == ConversationType_PRIVATE){
//        //获取接收到会话
//        RCConversation *receivedConversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
//        
//        //转换新会话为新会话模型
//        RCConversationModel *customModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:receivedConversation extend:nil];
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //调用父类刷新未读消息数
//            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
//            //[super didReceiveMessageNotification:notification];
//            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
//            [self notifyUpdateUnreadMessageCount];
//            
//            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
//            //原因请查看super didReceiveMessageNotification的注释。
//            NSNumber *left = [notification.userInfo objectForKey:@"left"];
//            if (0 == left.integerValue) {
//                [super refreshConversationTableViewIfNeeded];
//            }
//        });
//    } else {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            //调用父类刷新未读消息数
//            [super didReceiveMessageNotification:notification];
//            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
//            [self notifyUpdateUnreadMessageCount];
//            
//            //super会调用notifyUpdateUnreadMessageCount
//        });
//    }
//    [[RCDataManager shareManager] getUserInfoWithUserId:message.senderUserId completion:^(RCUserInfo *userInfo) {
//        NSLog(@"didReceiveMessageNotification 名字 ＝ %@  ID ＝ %@",userInfo.name,userInfo.userId);
//    }];
//    [self refreshConversationTableViewIfNeeded];
//}
//通知更新未读消息数目，用于显示未读消息，当收到会话消息的时候，会触发一次。
-(void)notifyUpdateUnreadMessageCount{
    [[RCDataManager shareManager] refreshBadgeValue];
}
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
////    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/

/*!
 点击Cell头像的回调
 
 @param model   会话Cell的数据模型
 */
- (void)didTapCellPortrait:(RCConversationModel *)model{
    if (model.conversationType == ConversationType_PRIVATE) {
        
        UIStoryboard *storyBd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        InfoTableViewController *infoTVC = [storyBd instantiateViewControllerWithIdentifier:@"infoPeronnal"];
        infoTVC.fromUserId =  model.targetId;
        [self.navigationController pushViewController:infoTVC animated:YES];
    }else{
        
    }
    
    
}
@end
