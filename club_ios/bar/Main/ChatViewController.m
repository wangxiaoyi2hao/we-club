//
//  ChatViewController.m
//  bar
//
//  Created by chen on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ChatViewController.h"
#import "ConversationListViewController.h"
#import "ChatListViewController.h"
#import "InfoTableViewController.h"

extern UserInfo*LoginUserInfo;
@interface ChatViewController ()<RCPluginBoardViewDelegate>

@end

@implementation ChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSLog(@"%@",_userID);
    //设置conversationMessageCollectionView的背景色为透明
    self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
    //设置self.view.backgroundColor用自己的背景图片
    //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"girlpicture.png"]];
    //设置是否显示竖向滚动条
    self.conversationMessageCollectionView.showsVerticalScrollIndicator=NO;
    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-49);
    //添加功能板
    [self.pluginBoardView insertItemWithImage:[UIImage imageNamed:@"美女.jpg"] title:@"红包" atIndex:3 tag:1001];
    
    self.enableUnreadMessageIcon = YES;
    self.enableNewComingMessageIcon= YES;
    //设置导航栏
    [self _initNavBar];
    [self scrollToBottomAnimated:YES];
    
}
+(ChatViewController *)shareChat{
    
    static ChatViewController* shareChat = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        shareChat = [[[self class] alloc] init];
    });
    
    return shareChat;
    
}
#pragma mark- 设置导航栏
-(void)_initNavBar{
    
    //左侧按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(returnLastView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
//导航栏左侧按钮
- (void)returnLastView{
    [self.navigationController popViewControllerAnimated:YES];
    
}
//功能板的点击事件
/**
 *  点击事件
 *
 *  @param pluginBoardView 功能模板
 *  @param index           索引
 */
-(void)pluginBoardView:(RCPluginBoardView*)pluginBoardView clickedItemWithTag:(NSInteger)tag{
    [super pluginBoardView:pluginBoardView clickedItemWithTag:tag];
    
    if (tag == 1001) {
//        UIViewController * vc = [[UIViewController alloc] init];
//        vc.view.backgroundColor = [UIColor redColor];
//        [self presentViewController:vc animated:YES completion:nil];
        NSLog(@"红包点击了");
        [self sendImageMessage:[RCImageMessage messageWithImage:[UIImage imageNamed:@"分享个帅图.jpg"]] pushContent:nil appUpload:YES];
    }
}
/**
 *  将要显示会话消息，可以修改RCMessageBaseCell的头像形状，添加自定定义的UI修饰，建议不要修改里面label 文字的大小，cell 大小是根据文字来计算的，如果修改大小可能造成cell 显示出现问题
 *
 *  @param cell      cell
 *  @param indexPath indexPath
 */
////设置头像为圆角
//- (void)willDisplayConversationTableCell:(RCMessageBaseCell *)cell atIndexPath:(NSIndexPath *)indexPath
//{
//    if ([cell isKindOfClass:[RCMessageCell class]]) {
//        RCMessageCell *messageCell = (RCMessageCell *)cell;
//        
//        UIImageView *portraitImageView= (UIImageView *)messageCell.portraitImageView;
//        portraitImageView.layer.cornerRadius = 23;
//}
//    //隐藏聊天头像
////    RCMessageCell *BaseCell=(RCMessageCell *)cell;
////    UIImageView *imageView= (UIImageView *)BaseCell.portraitImageView;
////    imageView.hidden=YES;
//}
#pragma mark - 上传图片
//然后融云就会回调上传函数，app需要继承会话，然后覆写上传函数：
/**
 *  上传图片到应用的图片服务器。
 *  当应用使用非融云的图片服务器时，请调用sendImageMessage:pushContent:appUpload:这个接口发送图片消息，appUpload设置为YES。融云会自动调用到本函数进行图片上传。
 *  应用需要overwrite此函数，在这个函数里上传并把进度和结果告诉融云，融云用来更新UI和发送消息。
 *
 *  @param message        保持下来的图片消息
 *
 *  @param uploadListener 上传状态回调。请务必在恰当的时机调用updateBlock和successBlock来通知融云状态
 */
//- (void)uploadImage:(RCMessage *)message uploadListener:(RCUploadImageStatusListener *)uploadListener{
//    
//}
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

/**
 *  长按头像事件
 *
 *  @param userId 用户的ID
 */
//- (void)didLongPressCellPortrait:(NSString *)userId{
//    NSLog(@"长按头像");
//}
/**
 *  获取用户信息。
 *
 *  @param userId     用户 Id。
 *  @param completion 用户信息
 */
//-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
//{
//    // 此处最终代码逻辑实现需要您从本地缓存或服务器端获取用户信息。
//    if ([userId isEqual:self.targetId]) {
//        RCUserInfo *user = [[RCUserInfo alloc]init];
//        user.userId =userId;
//        user.name = self.userName;
//        user.portraitUri = self.userUrl;
//        completion(user);
//    }else{
//        RCUserInfo *user = [[RCUserInfo alloc]init];
//        user.userId =LoginUserInfo.user_id;
//        user.name =LoginUserInfo.user_name ;
//        user.portraitUri =LoginUserInfo.user_head;
//        completion(user);
//    }
//}
//- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//    _strangeruserinfo=message.content.senderUserInfo;
//}
#pragma mark- 将要发送信息的时候,及时更新头像等信息
-(RCMessageContent *)willSendMessage:(RCMessageContent *)messageCotent{
    
    if ([RCIMClient sharedRCIMClient].currentUserInfo.userId) {
        //如果登录了
        NSDictionary *jsonDic = @{
                                  @"sendUsersId":LoginUserInfo.user_id,
                                  @"sendUsersName":LoginUserInfo.user_name,
                                  @"sendUsersPhoto":LoginUserInfo.user_head
                                  };
        NSLog(@"+++++_____%@",jsonDic);
        NSLog(@"+++++%@",LoginUserInfo.user_head);
        NSError *parseError = nil;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonDic options:NSJSONWritingPrettyPrinted error:&parseError];
        
        NSString *jsonString = [[NSString alloc]initWithData:jsonData encoding:NSUTF8StringEncoding];
        
        if ([messageCotent isKindOfClass:[RCTextMessage class]]) {
            
            RCTextMessage *textMessage = (RCTextMessage*)messageCotent;
            
            textMessage.extra = jsonString;
            NSLog(@"+++++_____++++%@",textMessage.extra);
            
        }else if ([messageCotent isKindOfClass:[RCVoiceMessage class]]) {
            
            RCVoiceMessage *voiceMessage = (RCVoiceMessage*)messageCotent;
            
            voiceMessage.extra = jsonString;
            NSLog(@"+++++_____++++%@",voiceMessage.extra);
            
        }else if ([messageCotent isKindOfClass:[RCImageMessage class]]) {
            
            RCImageMessage *imageMessage = (RCImageMessage*)messageCotent;
            
            imageMessage.extra = jsonString;
            NSLog(@"+++++_____++++%@",imageMessage.extra);
            
        }
    }else{
        
        NSLog(@"没东西");
        
    }
    
    return messageCotent;
}
///*!
// 发送消息完成的回调
// 
// @param stauts          发送状态，0表示成功，非0表示失败
// @param messageCotent   消息内容
// */
//- (void)didSendMessage:(NSInteger)stauts
//               content:(RCMessageContent *)messageCotent{
//    [self.conversationMessageCollectionView reloadData];
//}

@end
