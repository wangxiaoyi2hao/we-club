//
//  InvitationViewController.h
//  bar
//
//  Created by chen on 15/10/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
@interface InvitationViewController : BaseViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic,strong) UITableView *invitationTableView;
@property (nonatomic,assign)BOOL isMyInvitation;









@end
