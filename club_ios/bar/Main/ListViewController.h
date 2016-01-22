//
//  ListViewController.h
//  Weclub
//
//  Created by chen on 16/1/6.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
//#import "BaseViewController.h"

@interface ListViewController : RCConversationListViewController</*RCIMReceiveMessageDelegate,*/RCIMConnectionStatusDelegate>
@property(nonatomic, strong)NSMutableArray *dataArray;
- (void)showEmptyConversationView;
@end
