//
//  ChatViewController.h
//  bar
//
//  Created by chen on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//
#warning 这里不要直接继承于融云的类
#import <RongIMKit/RongIMKit.h>
#import "BaseRCConversationViewController.h"


@interface ChatViewController : BaseRCConversationViewController//<RCIMUserInfoDataSource,RCIMReceiveMessageDelegate>
@property (nonatomic, copy)NSString *userID;
@property (nonatomic, copy)NSString *userNames;
//@property (nonatomic, copy)NSString *userUrl;
@property (nonatomic, retain)RCUserInfo*strangeruserinfo;
+(ChatViewController *)shareChat;

@end
