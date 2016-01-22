//
//  ConversationListViewController.h
//  bar
//
//  Created by chen on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>

@interface ConversationListViewController : RCConversationListViewController
- (void)chatList;
@property(nonatomic,copy)NSString*fromUerId;
@end
