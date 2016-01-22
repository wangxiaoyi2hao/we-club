//
//  fansViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "fansViewCell.h"

@interface fansViewController : UITableViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UITableView*_tableView;
}

@end
