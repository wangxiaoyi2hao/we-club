//
//  ListViewController.m
//  Weclub
//
//  Created by chen on 16/1/6.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "ListViewController.h"
#import "RCDataManager.h"
#import "ChatViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "RCCustomCell.h"
#import "RCListCustomCell.h"
#import "AppDelegate.h"
#import "BarTabBarController.h"
#import "massageModels.h"
#import "notificationViewController.h"

extern UserInfo *LoginUserInfo;
extern NSMutableArray *friendsAndRoucludUserInfoArray;
extern NSMutableArray *rouclubGroupInfoArray;
@interface ListViewController (){
    UIView *bgView;
    UILabel *desLabel;
    UIImageView *defaultIV;
    UIView *firstShowView;
    UIImageView *headerIV;
    MBProgressHUD *hud;
    UIImageView *aIV;
    UILabel *aLabel;
}

@end

@implementation ListViewController
-(void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:RCKitDispatchMessageNotification object:nil];
}

-(instancetype)init{
    self = [super init];
    if (self) {
//        //这个是接收消息的监听代理
//        [RCIM sharedRCIM].receiveMessageDelegate = self;
        //链接状态的代理
        [RCIM sharedRCIM].connectionStatusDelegate = self;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(didReceiveMessageNotification:)name:RCKitDispatchMessageNotification object:nil];
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(removeLoginHud:) name:@"alreadyLogin" object:nil];
        hud = [[MBProgressHUD alloc]initWithView:self.view]; hud.square = YES;
        [self.view addSubview:hud];
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([RCIM sharedRCIM].currentUserInfo.userId) {
        if (self.conversationListDataSource.count==0) {
            self.conversationListTableView.tableFooterView = [UIView new];
        }else{
            UIView *afooter = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.conversationListTableView.frame.size.width, 0.5)];
            afooter.backgroundColor = [UIColor lightGrayColor]; self.conversationListTableView.tableFooterView = afooter;
        }
    }else{
        self.conversationListTableView.tableFooterView = [UIView new];
    }
    //加载数据
    [self _lodeData];
    //设置导航栏
    [self initNavBar];
}
//设置导航栏
-(void)initNavBar{
    self.navigationItem.title = @"消息";
    //设置导航栏标题字体颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
    NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:17],NSForegroundColorAttributeName: [UIColor whiteColor]};
    self.navigationController.navigationBar.titleTextAttributes = unselectedTextAttributes;
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    //右侧按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    rightButton.tag = 2;
    [rightButton addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setImage:[UIImage imageNamed:@"3-1-1.png"] forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * rightbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
}
- (void)rightButtonAction{
//    _buttonNumber.hidden = YES;
    UIStoryboard * Message = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    notificationViewController * notificationVC = [Message instantiateViewControllerWithIdentifier:@"notificationViewControllerID"];
    [self.navigationController pushViewController:notificationVC animated:YES];
}
//加载数据
- (void) _lodeData{
    //把数据传给model
    _dataArray = [[NSMutableArray alloc] init];
    massageModels *model = [[massageModels alloc] init];
    model.photo = [[NSMutableArray alloc] init];
    [model.photo addObject:[UIImage imageNamed:@"barchat.png"]];
    model.name = @"工体酒吧";
    model.unreadMessage = [[NSMutableArray alloc] initWithObjects:@"刚到",@"今天范冰冰来啦,大家快来慢城酒吧", nil];
    
    massageModels *model2 = [[massageModels alloc] init];
    model2.photo = [[NSMutableArray alloc] init];
    [model2.photo addObject:[UIImage imageNamed:@"3-1-2.png"]];
    model2.name = @"有一个人和你打招呼";
    model2.unreadMessage = [[NSMutableArray alloc] initWithObjects:@"KIM和你打了一个招呼", nil];
    
    massageModels *model3 = [[massageModels alloc] init];
    model3.photo = [[NSMutableArray alloc] init];
    [model3.photo addObject:[UIImage imageNamed:@"girlpicture.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"manpicture.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"酒吧美女图4.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"酒吧美女图7.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"girlpicture.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"酒吧美女图2.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"酒吧美女图6.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"manpicture.png"]];
    [model3.photo addObject:[UIImage imageNamed:@"girlpicture.png"]];
    model3.name = @"聊天小组";
    model3.unreadMessage = [[NSMutableArray alloc] initWithObjects:@"Jeck:我们去慢城酒吧", nil];
    
    massageModels *model4 = [[massageModels alloc] init];
    model4.photo = [[NSMutableArray alloc] init];
    [model4.photo addObject:[UIImage imageNamed:@"girlpicture.png"]];
    model4.name = @"李书鹏";
    model4.unreadMessage = [[NSMutableArray alloc] initWithObjects:@"我来了",@"来慢城酒吧", nil];
    
    massageModels *model5 = [[massageModels alloc] init];
    model5.photo = [[NSMutableArray alloc] init];
    [model5.photo addObject:[UIImage imageNamed:@"红包.png"]];
    model5.name = @"红包邀约";
    NSString *name = @"KIM";
    model5.unreadMessage = [[NSMutableArray alloc] initWithObjects:[NSString stringWithFormat:@"您正在和%@邀约ing",name], nil];
    massageModels *model6 = [[massageModels alloc] init];
    model6.photo = [[NSMutableArray alloc] init];
    [model6.photo addObject:[UIImage imageNamed:@"girlpicture.png"]];
    model6.name = @"朱立佳";
    model6.unreadMessage = [[NSMutableArray alloc] initWithObjects:@"我来了",@"来慢城酒吧", nil];
    
    massageModels *model7 = [[massageModels alloc] init];
    model7.photo = [[NSMutableArray alloc] init];
    [model7.photo addObject:[UIImage imageNamed:@"girlpicture.png"]];
    model7.name = @"何曼妮";
    model7.unreadMessage = [[NSMutableArray alloc] initWithObjects:@"我来了",@"来慢城酒吧", nil];
    
    [_dataArray addObject:model5];
    [_dataArray addObject:model];
    [_dataArray addObject:model3];
    [_dataArray addObject:model4];
    [_dataArray addObject:model6];
    [_dataArray addObject:model7];
    [_dataArray addObject:model2];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshConversationTableViewIfNeeded];
    [self resetConversationListBackgroundViewIfNeeded];
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId) {
        //登录
//        [[RCDataManager shareManager] refreshBadgeValue];
        [self setDisplayConversationTypeArray:@[
                                                @(ConversationType_PRIVATE),
                                                @(ConversationType_DISCUSSION),
                                                @(ConversationType_GROUP),
                                                @(ConversationType_CHATROOM),
                                                @(ConversationType_CUSTOMERSERVICE),
                                                @(ConversationType_SYSTEM),
                                                @(ConversationType_APPSERVICE),
                                                @(ConversationType_PUBLICSERVICE),
                                                @(ConversationType_PUSHSERVICE)
                                                ]];
    
    aIV.hidden = NO;
    aLabel.hidden = NO;
    [bgView sendSubviewToBack:aIV];
    [bgView sendSubviewToBack:aLabel];
    [hud removeFromSuperview];
    }else{
    //没登录
    [BarTabBarController shareBarTabBarController].numberLabel.text = nil;
    [self setDisplayConversationTypeArray:nil];
    
        if (self.conversationListDataSource.count) {
        //已登出，有数据
        // [hud show:YES];
        aIV.hidden = YES;
        aLabel.hidden = YES;
        [bgView sendSubviewToBack:aIV];
        [bgView sendSubviewToBack:aLabel];
        [hud removeFromSuperview];
        
        }else{//已登出，没数据
        [hud show:NO];
        aIV.hidden = NO;
        aLabel.hidden = NO;
        [hud removeFromSuperview];
        }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self refreshConversationTableViewIfNeeded];
        [self showEmptyConversationView];
    });
    
    }
    [self showEmptyConversationView];
    
}
#pragma mark-//******************修改自定义Cell中model的会话model类型******************//
//单元格数
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSLog(@"%ld",self.conversationListDataSource.count);
    return self.conversationListDataSource.count;
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
    NSLog(@"%@",dataSource);
    return dataSource;
}
//开始使用自定义cell
//*****************插入自定义Cell******************//
//这个返回cell的方法，以前也贴出来过，不过注视比较少，这次专门来讲解这个返回cell的方法，这里就返回了我们自定义的cell
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
        RCListCustomCell *cell = (RCListCustomCell *)[[RCListCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCCustomCell"];
//                static   NSString *str=@"RCCustomCell";
//                RCCustomCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
//                if (cell==nil) {
//                    NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"InviteTableViewCell" owner:self options:nil];
//                    cell=[arry objectAtIndex:0];
//                }
        
        
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
        cell.ppBadgeView.dragdropCompletion = ^{
            NSLog(@"VC = FFF ，ID ＝ %@",model.targetId);
            [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_PRIVATE targetId:model.targetId];
            model.unreadMessageCount = 0;
            NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
            
            long tabBarCount = ToatalunreadMsgCount-model.unreadMessageCount;
            
            //获取所有未读消息数
            //    int notReadMessage = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
            //    int notReadMessage = [[UserInfoModel currentUserinfo].notReadMessage intValue];
            
            if (tabBarCount > 0) {
                
                [BarTabBarController shareBarTabBarController].numberLabel.text = [NSString stringWithFormat:@"%ld",tabBarCount];
                
                //        if (notReadMessage > 0) {
                //            [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage + tabBarCount;
                //        }
                //        else {
                //            [UIApplication sharedApplication].applicationIconBadgeNumber = tabBarCount;
                //        }
            }else {
                [BarTabBarController shareBarTabBarController].numberLabel.text = nil;
                
                //        if (notReadMessage > 0) {
                //            [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage;
                //        }
                //        else {
                //            [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                //        }
            }
        };
        if (unreadCount==0) {
            cell.ppBadgeView.text = @"";
            
        }else{
            if (unreadCount>=100) {
                cell.ppBadgeView.text = @"99+";
            }else{
                cell.ppBadgeView.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
                
            }
        }
        
        
        
        for (RCUserInfo *userInfo in friendsAndRoucludUserInfoArray) {
            if ([model.targetId isEqualToString:userInfo.userId]) {
                //赋值名字属性
                cell.realNameLabel.text = [userInfo.name isEqualToString:@""]?[NSString stringWithFormat:@"%@",userInfo.name]:[NSString stringWithFormat:@"%@",userInfo.name];
                
                //赋值头像
                if ([userInfo.portraitUri isEqualToString:@""]||userInfo.portraitUri==nil) {
                    cell.avatarIV.image = [UIImage imageNamed:@"chatlistDefault"];
                    [cell.contentView bringSubviewToFront:cell.avatarIV];
                }else{
                    [cell.avatarIV sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"chatlistDefault"]];
                }
                
                if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
                    cell.contentLabel.text = [model.lastestMessage valueForKey:@"content"];
                    
                }else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
                    
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                        }else{
                            cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
                            
                        }
                    }else{
                        
                        cell.contentLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",userInfo.name] ;
                    }
                    
                }else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                            
                        }else{
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
                        }
                    }else{
                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",userInfo.name];
                    }
                }
                else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
                    if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
                        //我自己发的
                        RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
                        if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                        }else{
                            cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
                        }
                    }else{
                        cell.contentLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",userInfo.name];
                    }
                }
                
            }
        }
        
        return cell;
    }else{
        
        return [[RCConversationBaseCell alloc]init];
    }
}
//点击单元格方法
-(void)onSelectedTableRow:(RCConversationModelType)conversationModelType conversationModel:(RCConversationModel *)model atIndexPath:(NSIndexPath *)indexPath{
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType = model.conversationType;
    conversationVC.targetId = model.targetId;
    for (RCUserInfo *userInfo in friendsAndRoucludUserInfoArray) {
        if ([model.targetId isEqualToString:userInfo.userId]) {
            conversationVC.userName = userInfo.name;
            conversationVC.title =[userInfo.name isEqualToString:@""]?@"昵称":[NSString stringWithFormat:@"%@",userInfo.name];
        }
    }
    [self.navigationController pushViewController:conversationVC animated:YES];
}

#pragma mark - 监听收到消息
/**
 *  收到新消息,用于刷新会话列表，如果派生类调用了父类方法，请不要再次调用refreshConversationTableViewIfNeeded，避免多次刷新
 *  当收到多条消息时，会在最后一条消息时在内部调用refreshConversationTableViewIfNeeded
 *
 *  @param notification notification
 */
-(void)didReceiveMessageNotification:(NSNotification *)notification{
    __weak typeof(&*self) blockSelf_ = self;
    //处理好友请求
    RCMessage *message = notification.object;
    
    if ([message.content isMemberOfClass:[RCMessageContent class]]) {
        if (message.conversationType == ConversationType_PRIVATE) {
            NSLog(@"好友消息要发系统消息！！！");
            @throw  [[NSException alloc] initWithName:@"error" reason:@"好友消息要发系统消息！！！" userInfo:nil];
        }
        RCConversationModel *customModel = [RCConversationModel new];
        //自定义cell的type
        customModel.conversationModelType = RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION;
        customModel.senderUserId = message.senderUserId;
        customModel.lastestMessage = message.content;
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            
        });
        
    }else if (message.conversationType == ConversationType_PRIVATE){
        //获取接收到会话
        RCConversation *receivedConversation = [[RCIMClient sharedRCIMClient] getConversation:message.conversationType targetId:message.targetId];
        
        //转换新会话为新会话模型
        RCConversationModel *customModel = [[RCConversationModel alloc] init:RC_CONVERSATION_MODEL_TYPE_CUSTOMIZATION conversation:receivedConversation extend:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [blockSelf_ refreshConversationTableViewWithConversationModel:customModel];
            //[super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //当消息为RCContactNotificationMessage时，没有调用super，如果是最后一条消息，可能需要刷新一下整个列表。
            //原因请查看super didReceiveMessageNotification的注释。
            NSNumber *left = [notification.userInfo objectForKey:@"left"];
            if (0 == left.integerValue) {
                [super refreshConversationTableViewIfNeeded];
            }
        });
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            //调用父类刷新未读消息数
            [super didReceiveMessageNotification:notification];
            [blockSelf_ resetConversationListBackgroundViewIfNeeded];
            [self notifyUpdateUnreadMessageCount];
            
            //super会调用notifyUpdateUnreadMessageCount
        });
    }
    [[RCDataManager shareManager] getUserInfoWithUserId:message.senderUserId completion:^(RCUserInfo *userInfo) {
        NSLog(@"didReceiveMessageNotification 名字 ＝ %@  ID ＝ %@",userInfo.name,userInfo.userId);
    }];
    [self refreshConversationTableViewIfNeeded];
}
//通知更新未读消息数目，用于显示未读消息，当收到会话消息的时候，会触发一次。
-(void)notifyUpdateUnreadMessageCount{
    [[RCDataManager shareManager] refreshBadgeValue];
}
#pragma mark 是否禁止右滑删除
//允许左滑删除
-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{ return YES;
}
//左滑删除
-(void)rcConversationListTableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    //可以从数据库删除数据
    if (indexPath.row < self.conversationListDataSource.count) {
        RCConversationModel *model = self.conversationListDataSource[indexPath.row];
        [[RCIMClient sharedRCIMClient] removeConversation:ConversationType_PRIVATE targetId:model.targetId];
        [self.conversationListDataSource removeObjectAtIndex:indexPath.row];
        [self.conversationListTableView reloadData]; [[RCDataManager shareManager] refreshBadgeValue];
    }
}
//高度
-(CGFloat)rcConversationListTableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 100;
}
#pragma mark-还不明白其作用方法
-(void)didSendMessage:(NSInteger)stauts content:(RCMessageContent *)messageCotent{
    NSLog(@"fffff %@",messageCotent);
}
-(void)didReceiveMemoryWarning {
    NSLog(@"ChatViewController ReceiveMemoryWarning");
    [super didReceiveMemoryWarning];
}
/**
 
 @brief 生成当天的某个点（返回的是伦敦时间，可直接与当前时间[NSDate date]比较）
 @param hour 如hour为“8”，就是上午8:00（本地时间） */

-(NSDate *)getCustomDateWithHour:(NSInteger)hour {
    //获取当前时间
    NSDate *currentDate = [NSDate date]; NSCalendar *currentCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; NSDateComponents *currentComps = [[NSDateComponents alloc] init];
    NSInteger unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSWeekdayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit;
    
    currentComps = [currentCalendar components:unitFlags fromDate:currentDate];
    
    //设置当天的某个点
    NSDateComponents *resultComps = [[NSDateComponents alloc] init]; [resultComps setYear:[currentComps year]]; [resultComps setMonth:[currentComps month]]; [resultComps setDay:[currentComps day]]; [resultComps setHour:hour];
    
    NSCalendar *resultCalendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar]; return [resultCalendar dateFromComponents:resultComps];
}

-(void)removeShowView:(UIButton *)sender{
    if (firstShowView) {
        [firstShowView removeFromSuperview]; firstShowView = nil;
    }
    
    [self showEmptyConversationView];
}
////提示框点击方法
//-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
//
//    if ([UserInfoModel currentUserinfo].pushToken.length > 0 && [UserInfoModel currentUserinfo].userEncrypt.length > 0) {
//
//        [Networking logout:^(NetworkModel *model) {
//
//            if ([[NSString stringWithFormat:@"%@",model.result]isEqualToString:@"10000"]) {
//                [UserInfoModel logoutUserinfo];
//
//                BaseNavigationController  *chatNav = [AppDelegate shareAppDelegate].rootTabbar.viewControllers[2];
//                chatNav.tabBarItem.badgeValue = nil;
//                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
//
//                [[RCIMClient sharedRCIMClient] clearConversations:@[@(ConversationType_PRIVATE)]];
//                [[RCIMClient sharedRCIMClient] disconnect:NO];
//
//                BaseNavigationController *baseVC = (BaseNavigationController *)[AppDelegate shareAppDelegate].rootTabbar.selectedViewController;
//                [baseVC pushViewController:[[LoginViewController alloc]init] animated:YES];
//            }
//            else {
//                [MSUtil showTipsWithHUD:model.msg inView:self.view];
//            }
//
//        } fail:^(NSError *error) {
//            [MSUtil showTipsWithHUD:kTips_NetworkError inView:self.view];
//        }];
//    }
//}

#pragma mark-还没用到的方法
/**
 *  网络状态变化。
 *
 *  @param status 网络状态。
 */
- (void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status{
    
}
//重写方法，设置会话列表emptyConversationView的视图。
//无聊天cell的时候一般会显示一个默认的图片或者加一些button或者一些imageView啊等等，那么逻辑就是在下面的这个方法中处理，我的方法可能不是最好的，如果有同学有好方法欢迎找我交流，加我的iOS技术交流群487599875，谢谢。
//-(void)showEmptyConversationView{
//    
//}
//登录或者注册(可能是被挤下去以后的操作)
//-(void)loginorRegister:(UIButton *)sender{
//    [self.navigationController pushViewController:[LoginViewController new] animated:YES];
//}
/**
 指派初始化方法，根据给定信息初始化实例 *
 @param conversationType 会话类型
 @param targetId 目标ID，如讨论组ID, 群ID, 聊天室ID
 @param messageDirection 消息方向
 @param messageId 消息ID
 @param content 消息体内容字段 */
//-(instancetype)initWithType:(RCConversationType)conversationType targetId:(NSString *)targetId direction:(RCMessageDirection)messageDirection messageId:(long)messageId content:(RCMessageContent *)content;
///**
// 根据服务器返回JSON创建新实例 *
// @param jsonData JSON数据字典 */
//-(instancetype)messageWithJSON:(NSDictionary *)jsonData;

/**
 *  将要显示会话列表单元，可以有限的设置cell的属性或者修改cell,例如：setHeaderImagePortraitStyle
 *
 *  @param cell      cell
 *  @param indexPath 索引
 */
//-(void)willDisplayConversationTableCell:(RCConversationBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath{
//    if ([cell isMemberOfClass:[RCListCustomCell class]]) {
//        RCListCustomCell *conversationCell = (RCListCustomCell *)cell;
////        conversationCell.conversationTitle.text=@"";
//
//       RCConversationModel *model = self.conversationListDataSource[indexPath.row];
//
//     conversationCell.conversationTitle.text = [[RCDataManager shareManager] currentNameWithUserId:model.targetId];
//     if (model) {
//         if (model.targetId) {
//         if ([[AppDelegate shareAppDelegate].friendsArray containsObject:[[RCDataManager shareManager] currentUserInfoWithUserId:model.targetId]]) {
//         [[RCIM sharedRCIM] refreshUserInfoCache:[[RCDataManager shareManager] currentUserInfoWithUserId:model.targetId] withUserId:model.targetId];
//         // }
//         }
//         }
//
//    for (RCUserInfo *userInfo in friendsAndRoucludUserInfoArray) {
//        if ([model.targetId isEqualToString:userInfo.userId]) {
//            NSDictionary *attributeDic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18], NSFontAttributeName, nil];
//            CGSize nameLabelSize = [userInfo.realName boundingRectWithSize:CGSizeMake(MAXFLOAT, conversationCell.realNameLabel.frame.size.height) options:NSStringDrawingUsesLineFragmentOrigin attributes:attributeDic context:nil].size;
//            conversationCell.realNameLabel.frame = CGRectMake(conversationCell.realNameLabel.frame.origin.x, conversationCell.realNameLabel.frame.origin.y, nameLabelSize.width, conversationCell.realNameLabel.frame.size.height);
//            conversationCell.typeNameLabel.frame = CGRectMake(conversationCell.realNameLabel.frame.origin.x+conversationCell.realNameLabel.frame.size.width+10, conversationCell.realNameLabel.frame.origin.y, conversationCell.typeNameLabel.frame.size.width, conversationCell.realNameLabel.frame.size.height);
//            if (indexPath.row==self.conversationListDataSource.count-1) {
//                conversationCell.seprateLine.hidden = YES;
//            }else{
//                conversationCell.seprateLine.hidden = NO;
//            }
//        }
//    }
//
//
//}
//}
//}
#pragma mark-接收通知后移除登录Hud
//-(void)removeLoginHud:(NSNotification *)obj{
//    NSLog(@"收到通知");
//    if (hud) { dispatch_async(dispatch_get_main_queue(), ^{
//
//    [self setDisplayConversationTypeArray:@[@(ConversationType_PRIVATE)]];
//
//    [self performSelector:@selector(refershTable) withObject:nil afterDelay:0.5];
//        });
//    }
//}
//-(void)refershTable{ dispatch_async(dispatch_get_main_queue(), ^{
//    [self.conversationListTableView reloadData];
//    [self performSelector:@selector(refershTableIfNeeded) withObject:nil afterDelay:0.5];
//    });
//}
//-(void)refershTableIfNeeded{
//    [hud hide:YES];
//    [hud removeFromSuperview];
//    aIV.hidden = NO;
//    aLabel.hidden = NO;
//    dispatch_async(dispatch_get_main_queue(), ^{
//        [self refreshConversationTableViewIfNeeded]; [self showEmptyConversationView];
//    });
//
//}



#pragma mark-//******************插入自定义Cell******************//
/*
 -(RCConversationBaseCell *)rcConversationListTableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
 
 if (self.conversationListDataSource.count&&indexPath.row < self.conversationListDataSource.count) {
 RCConversationModel *model = self.conversationListDataSource[indexPath.row];
 [[RCDataManager shareManager] getUserInfoWithUserId:model.targetId completion:^(RCUserInfo *userInfo) {
 NSLog(@"rcConversationListTableView 名字 ＝ %@ ID ＝ %@",userInfo.name,userInfo.userId);
 }];
 NSInteger unreadCount = model.unreadMessageCount;
 
 static   NSString *str=@"RCCustomCell";
 RCCustomCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
 if (cell==nil) {
 NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"InviteTableViewCell" owner:self options:nil];
 cell=[arry objectAtIndex:0];
 }
 
 //        RCCustomCell *cell = (RCCustomCell *)[[RCCustomCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"RCCustomCell"];
 //    //设置时间
 //    NSDate *date = [NSDate dateWithTimeIntervalSince1970:model.receivedTime/1000];
 //    NSString *timeString = [[MSUtil stringFromDate:date] substringToIndex:10];
 //    NSString *temp = [MSUtil getyyyymmdd];
 //    NSString *nowDateString = [NSString stringWithFormat:@"%@-%@-%@",[temp substringToIndex:4],[temp substringWithRange:NSMakeRange(4, 2)],[temp substringWithRange:NSMakeRange(6, 2)]];
 //
 //    if ([timeString isEqualToString:nowDateString]) {
 //        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
 //        [formatter setDateFormat:@"HH:mm"];
 //        NSString *showtimeNew = [formatter stringFromDate:date];
 //        cell.timeLabel.text = [NSString stringWithFormat:@"%@",showtimeNew];
 //
 //    }else{
 //        cell.timeLabel.text = [NSString stringWithFormat:@"%@",timeString];
 //    }
 
 //    cell.unReadMessageLable.dragdropCompletion = ^{
 //        NSLog(@"VC = FFF ，ID ＝ %@",model.targetId);
 
 
 
 
 
 [[RCIMClient sharedRCIMClient] clearMessagesUnreadStatus:ConversationType_CUSTOMERSERVICE targetId:model.targetId];
 model.unreadMessageCount = 0;
 NSInteger ToatalunreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_CUSTOMERSERVICE)]];
 
 //        long tabBarCount = ToatalunreadMsgCount-model.unreadMessageCount;
 //        int notReadMessage = [[UserInfoModel currentUserinfo].notReadMessage intValue];
 //
 //        if (tabBarCount > 0) {
 //            [AppDelegate shareAppDelegate].rootTabbar.selectedViewController.tabBarItem.badgeValue = [NSString stringWithFormat:@"%ld",tabBarCount];
 //
 //            if (notReadMessage > 0) {
 //                [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage + tabBarCount;
 //            }
 //            else {
 //                [UIApplication sharedApplication].applicationIconBadgeNumber = tabBarCount;
 //            }
 //        }
 //        else {
 //            [AppDelegate shareAppDelegate].rootTabbar.selectedViewController.tabBarItem.badgeValue = nil;
 //
 //            if (notReadMessage > 0) {
 //                [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage;
 //            }
 //            else {
 //                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
 //            }
 //        }
 //    };
 
 if (unreadCount==0) {
 cell.unReadMessageLable.text = @"";
 }else{
 if (unreadCount>=100) {
 cell.unReadMessageLable.text = @"99+";
 }else{
 cell.unReadMessageLable.text = [NSString stringWithFormat:@"%li",(long)unreadCount];
 
 }
 }
 
 for (RCUserInfo *userInfo in friendsAndRoucludUserInfoArray) {
 if ([model.targetId isEqualToString:userInfo.userId]) {
 
 cell.nameLabel.text = [userInfo.name isEqualToString:@""]?[NSString stringWithFormat:@"%@",userInfo.name]:[NSString stringWithFormat:@"%@",userInfo.name];
 
 if ([userInfo.portraitUri isEqualToString:@""]||userInfo.portraitUri==nil) {
 cell.iconImageView.image = [UIImage imageNamed:@"chatlistDefault"];
 [cell.contentView bringSubviewToFront:cell.iconImageView];
 }else{
 [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:userInfo.portraitUri] placeholderImage:[UIImage imageNamed:@"chatlistDefault"]];
 }
 
 if ([model.lastestMessage isKindOfClass:[RCTextMessage class]]) {
 cell.messageLabel.text = [model.lastestMessage valueForKey:@"content"];
 
 }else if ([model.lastestMessage isKindOfClass:[RCImageMessage class]]){
 
 if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
 //我自己发的
 RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
 
 if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
 cell.messageLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
 }else{
 cell.messageLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",myselfInfo.name];
 
 }
 }else{
 
 cell.messageLabel.text =[NSString stringWithFormat:@"来自\"%@\"的图片消息，点击查看",userInfo.name] ;
 }
 
 }else if ([model.lastestMessage isKindOfClass:[RCVoiceMessage class]]){
 if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
 //我自己发的
 RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
 if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
 cell.messageLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
 
 }else{
 cell.messageLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",myselfInfo.name];
 }
 }else{
 cell.messageLabel.text = [NSString stringWithFormat:@"来自\"%@\"的语音消息，点击查看",userInfo.name];
 }
 }
 else if ([model.lastestMessage isKindOfClass:[RCLocationMessage class]]){
 if ([model.senderUserId isEqualToString:[RCIMClient sharedRCIMClient].currentUserInfo.userId]) {
 //我自己发的
 RCUserInfo *myselfInfo = [RCIMClient sharedRCIMClient].currentUserInfo;
 if ([[NSString stringWithFormat:@"%@",myselfInfo.name] isEqualToString:@""]) {
 cell.messageLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
 }else{
 cell.messageLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",myselfInfo.name];
 }
 }else{
 cell.messageLabel.text = [NSString stringWithFormat:@"来自\"%@\"的位置消息，点击查看",userInfo.name];
 }
 }
 
 }
 }
 
 return cell;
 }else{
 
 return [[RCConversationBaseCell alloc]init];
 }
 }
 */


@end
