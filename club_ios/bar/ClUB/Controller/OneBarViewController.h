//
//  OneBarViewController.h
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "BaseRCConversationViewController.h"


@interface OneBarViewController : BaseRCConversationViewController
@property(nonatomic,copy)NSString*fromClubId;
@property(nonatomic,assign)float fromDistance;
+(OneBarViewController *)shareChatRoom;

@end
