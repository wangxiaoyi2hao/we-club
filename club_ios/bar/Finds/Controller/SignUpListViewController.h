//
//  SignUpListViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpListViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UITableView*_tableView;

}
@property(nonatomic,copy)NSString*fromUserId;

@end
