//
//  HostFriendsViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostFriendsViewController : UIViewController<UIAlertViewDelegate>
{

    IBOutlet UITableView*_tableView;

}
@property(nonatomic,copy)NSString*fromUserId;
@end
