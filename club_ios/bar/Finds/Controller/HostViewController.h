//
//  HostViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UITableView*_tableView;
    //红包金额大小  
    IBOutlet UILabel*lbMoney;
}
@property(nonatomic,copy)NSString*fromUserId;
@property(nonatomic,assign)int fromPayMoney;

@end
