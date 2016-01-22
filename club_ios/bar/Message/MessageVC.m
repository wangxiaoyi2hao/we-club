//
//  MessageVC.m
//  bar
//
//  Created by chen on 15/11/20.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "MessageVC.h"
#import "InvitationViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "ConversationListViewController.h"
#import "helloViewController.h"
#import "notificationViewController.h"
#import "RedPacketInvitationVC.h"
#import "AppDelegate.h"
#import "GroupViewController.h"
#import "ChatViewController.h"
#import "OneBarViewController.h"
#import "ChatListViewController.h"
extern UserInfo*LoginUserInfo;
@interface MessageVC ()<ASIHTTPRequestDelegate>{
    UIButton *_buttonNumber;
    chatCell *_cell;
    UIButton *_button1;
    UIButton *_button2;
    UIButton *_button3;
    UIButton *_button4;
    
    
    
    //message  请求所需要的请求
    ASIFormDataRequest*_requestMessage;
    //读区read message 接口所需要的请求变量
    ASIFormDataRequest*_requestReadMessage;
    
    
}


@end

@implementation MessageVC
- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    //加载数据
    [self _lodeData];
    //设置tabelview
    [self _setTableView];
    //设置导航栏
    [self initNavBar];
    //获取对应类型聊天消息数
    [self getCount];
#pragma mark 这里是请求信息界面的方法
    [self requestMessage];
    
}
- (void)getCount{
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
    //私聊消息数
    
    
    NSLog(@"获取某会话类型的未读消息数:%d",unreadMsgCount);
//    [RCIMClient sharedRCIMClient] setReceiveMessageDelegate:(id<RCIMClientReceiveMessageDelegate>) object:<#(id)#>];
    
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
   // _dataArray = [[NSMutableArray alloc] init];
    
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

//设置tabelview
- (void) _setTableView{
    //禁止视图滑动
    //_massageTableView.scrollEnabled = NO;
    //设置分割线风格及尾视图
    _massageTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [_massageTableView setTableFooterView:view];
    
}
//设置导航栏
-(void)initNavBar{
    self.navigationItem.title = @"消息";
    //设置导航栏标题字体颜色
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"] forBarMetrics: UIBarMetricsDefault];
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
    //小红点
    _buttonNumber = [UIButton buttonWithType:UIButtonTypeCustom];
    _buttonNumber.frame = CGRectMake(27, 0, 10, 10);
    [_buttonNumber setBackgroundImage:[UIImage imageNamed:@"3-1-4.png"] forState:UIControlStateNormal];
    [rightButton addSubview:_buttonNumber];
}
- (void)rightButtonAction{
    _buttonNumber.hidden = YES;
    UIStoryboard * Message = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
    notificationViewController * notificationVC = [Message instantiateViewControllerWithIdentifier:@"notificationViewControllerID"];
    [self.navigationController pushViewController:notificationVC animated:YES];    
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.dataArray count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ////
    massageModels *model = [_dataArray objectAtIndex:indexPath.row];
    if ([model.photo count] == 1) {
        chatCell *cell = [tableView dequeueReusableCellWithIdentifier:@"chatCellIdentifier" forIndexPath:indexPath];
        cell.photo.image = [model.photo objectAtIndex:0];
        cell.nameLabel.text = model.name;
        cell.messageLabel.text = [NSString stringWithFormat:@"(%li条)%@",[model.unreadMessage count], [model.unreadMessage objectAtIndex:[model.unreadMessage count] - 1]];
        cell.lastTimeLabel.text = @"15:32";
        if (![model.name isEqualToString:@"工体酒吧"]) {
            
            cell.untroubleMark.hidden = YES;
            
        }
        if ([model.name isEqualToString:@"有一个人和你打招呼"]) {
            cell.messageNumber.hidden = YES;
            
        }else if ([model.name isEqualToString:@"红包邀约"]){
            cell.messageNumber.hidden = YES;
        }else if ([model.name isEqualToString:@"李书鹏"]){
//            _button4 = cell.messageNumber;
        }else{
//            _button1 = cell.messageNumber;
        }
        return cell;
    } else {
        groupTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"groupChatCellIdentifier"forIndexPath:indexPath];
        
        //把model中数据传给cell
        [cell setData:model.photo];
        
        cell.nameLabel.text = model.name;
        cell.messageLabel.text = [NSString stringWithFormat:@"(%li条)%@",[model.unreadMessage count], [model.unreadMessage objectAtIndex:[model.unreadMessage count] - 1]];
        cell.lastTimeLabel.text = @"15:32";
        cell.gropeMsgNumber.hidden = YES;
        
        return cell;
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return 60* app.autoSizeScaleY;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    NSLog(@"你点击了%ld行",(long)indexPath.row);
    massageModels *model = [_dataArray objectAtIndex:indexPath.row];
    if ([model.name isEqualToString:@"红包邀约"]){
        UIStoryboard *redStoryboard = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
        RedPacketInvitationVC *redVC = [redStoryboard instantiateViewControllerWithIdentifier:@"RedPacketInvitationVCID"];
        [self.navigationController pushViewController:redVC animated:YES];
        NSLog(@"点击了红包");
    }
    if (indexPath.row == 1){
        _button1.hidden = YES;
        // 启动聊天室，与启动单聊等类似
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        OneBarViewController * temp = [club instantiateViewControllerWithIdentifier:@"OneBarViewControllerID"];
        temp.targetId = @"01343869-7dc8-4058-a80e-4475ebf0ade8";
        temp.conversationType = ConversationType_CHATROOM;// 传入聊天室类型
        temp.userName = @"jeck";
        temp.title = @"we club 聊天室";
        //temp.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:temp animated:YES];
        
       // _button2.hidden = YES;
        
    }else if (indexPath.row == 2){
//        // 启动讨论组，与启动单聊等类似
//        RCConversationViewController *temp = [[RCConversationViewController alloc]init];
//        temp.targetId = @"b99758c9-ea1b-4235-ae93-ca8ce7d14225";
//        temp.conversationType = ConversationType_GROUP;// 传入讨论组类型
//        temp.title = @"讨论组标题";
//        self.hidesBottomBarWhenPushed = YES;
//        [self.navigationController pushViewController:temp animated:YES];
        // 启动讨论组，与启动单聊等类似
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        GroupViewController * temp = [club instantiateViewControllerWithIdentifier:@"GroupViewControllerID"];
        
        temp.conversationType = ConversationType_GROUP;// 传入讨论组类型
        temp.targetId = @"a43dec04-cfd6-4571-9125-d6757d9938a4";
        temp.title = @"we club 讨论组";
        [self.navigationController pushViewController:temp animated:YES];
        
//        
//        //融云相关
//        ConversationListViewController *converListVC = [[ConversationListViewController alloc] init];
//        [self.navigationController pushViewController:converListVC animated:YES];
//        
//        _button3.hidden = YES;
        
    }else if(indexPath.row == 3){
        _button4.hidden = YES;
        // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        ChatViewController * conversationVC = [club instantiateViewControllerWithIdentifier:@"ChatViewControllerID"];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"0cf1d5dd-79b2-4549-a910-60146249f0ca"; // 接收者的 targetId，这里为举例。
        conversationVC.userName = @"李书鹏"; // 接受者的 username，这里为举例。
//        conversationVC.userUrl = @"http://p.3761.com/pic/66141435714380.jpg";
        conversationVC.title = conversationVC.userName;//conversationVC.userName; // 会话的 title。
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        //_button4.hidden = YES;
    }else if(indexPath.row == 4){
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        ChatViewController * conversationVC = [club instantiateViewControllerWithIdentifier:@"ChatViewControllerID"];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"beb694c7-2509-4fde-bc0c-ca7612e2bded";
        //conversationVC.targetId = @"0cf1d5dd-79b2-4549-a910-60146249f0ca"; // 接收者的 targetId，这里为举例。
        conversationVC.userName = @"朱立佳"; // 接受者的 username，这里为举例。
        conversationVC.title = conversationVC.userName;//conversationVC.userName; // 会话的 title。
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
        

    }else if(indexPath.row == 5){
        _button4.hidden = YES;
        // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        ChatViewController * conversationVC = [club instantiateViewControllerWithIdentifier:@"ChatViewControllerID"];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = @"2f9ce1ed-3279-474b-bcbf-983805b768f4"; // 接收者的 targetId，这里为举例。
        conversationVC.userName = @"何曼妮"; // 接受者的 username，这里为举例。
        conversationVC.title = conversationVC.userName;//conversationVC.userName; // 会话的 title。
        
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
        
        //_button4.hidden = YES;
    }else if(indexPath.row == 6){
        //点击有一个人和你打招呼
        UIStoryboard * Message = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
        helloViewController * helloVC = [Message instantiateViewControllerWithIdentifier:@"helloViewControllerID"];
        [self.navigationController pushViewController:helloVC animated:YES];
        
    }
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

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
//消息界面单元格自定义滑动
- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *allReadRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"置顶" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        [_dataArray insertObject:_dataArray[indexPath.row] atIndex:0];
        [_dataArray removeObjectAtIndex:indexPath.row+1];
        [_massageTableView reloadData];
        
//        if (indexPath.row == 0) {
//            _button1.hidden = NO;
//        } else if (indexPath.row == 1){
//            _button2.hidden = NO;
//            
//        }else if (indexPath.row == 2){
//            _button3.hidden = NO;
//            
//        }else if(indexPath.row == 3){
//            _button4.hidden = NO;
//        }
        NSLog(@"点击了设置为未读");
    }];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        NSLog(@"点击了删除");
    }];
    NSArray *array = [[NSArray alloc] initWithObjects:deleteRowAction, allReadRowAction,  nil];
    return array;
}
//编辑模式风格
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        
    }
}
#pragma mark 消息界面的接口文件
//获取消息列表
-(void)requestMessage{
    Request15001*request15001=[[Request15001 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@messageAction/getMessages",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestMessage = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request15001.common.userid=LoginUserInfo.user_id;
    request15001.common.platform=2;//已经传好
    request15001.common.version=@"1.0.0";//版本号
    request15001.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request15001.common.cmdid=15001;
    request15001.common.userkey=LoginUserInfo.user_key;
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSData*data= [request15001 data];
    [_requestMessage setPostBody:(NSMutableData*)data];
    [_requestMessage setDelegate:self];
    //请求延迟时间
    _requestMessage.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestMessage.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestMessage.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestMessage.secondsToCache=3600;
    [_requestMessage startAsynchronous];
}
//这里是消息已读的时候需要调的接口
-(void)requestReadMessage{
    Request15002*request15002=[[Request15002 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@messageAction/readMessage",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestReadMessage = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request15002.common.userid=LoginUserInfo.user_id;//登录不用传userid
    request15002.common.platform=2;//已经传好
    request15002.common.version=@"1.0.0";//版本号
    request15002.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request15002.common.cmdid=15002;
    request15002.common.userkey=LoginUserInfo.user_key;
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSData*data= [request15002 data];
    [_requestReadMessage setPostBody:(NSMutableData*)data];
    [_requestReadMessage setDelegate:self];
    //请求延迟时间
    _requestReadMessage.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestReadMessage.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestReadMessage.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestReadMessage.secondsToCache=3600;
    [_requestReadMessage startAsynchronous];
}


//读消息 用户点击该条消息，需要把该消息设置为已读
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestMessage]) {
       Response15001* response15001 = [Response15001 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response15001.common.code);
        if (response15001.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response15001.common.message tostalTime:1];
        }else{
            NSLog(@"%@",response15001.data_p.messagesArray);
            for (int i=0; i<response15001.data_p.messagesArray.count; i++) {
                Message*message=[response15001.data_p.messagesArray objectAtIndex:i];
                NSLog(@"%@",message);
            }
        }
    }
    
    if ([request isEqual:_requestReadMessage ]) {
        Response15002*response15002=[Response15002 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response15002.common.code);
        if (response15002.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response15002.common.message tostalTime:1];
        }
    }
         [_massageTableView reloadData];
}
@end
