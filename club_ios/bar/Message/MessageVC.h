//
//  MessageVC.h
//  bar
//
//  Created by chen on 15/11/20.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "massageModels.h"
#import "chatCell.h"
#import "groupTableCell.h"
#import <RongIMKit/RongIMKit.h>
@interface MessageVC : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic , strong) NSMutableArray *dataArray;
@property (weak, nonatomic) IBOutlet UITableView *massageTableView;


@end
