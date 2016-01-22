//
//  followViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "barViewCell.h"
#import "fansViewCell.h"

@interface followViewController : UIViewController <UITableViewDelegate , UITableViewDataSource>

@property BOOL barOrPeople;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
