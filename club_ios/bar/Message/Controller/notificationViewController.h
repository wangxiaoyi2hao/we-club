//
//  notificationViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

//通知提醒界面
#import <UIKit/UIKit.h>
#import "notificationCell.h"
#import "decisionCell.h"
#import "notificationModel.h"
#import "deleteToolbar.h"

@interface notificationViewController : UITableViewController <deleteTableViewDelegate>

@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBtn;//导航栏右键编辑
@property (nonatomic , strong) NSMutableArray *dataArray;
@property (strong, nonatomic) IBOutlet deleteToolbar *deleteTool;//删除按钮
@property (strong, nonatomic) NSMutableDictionary *deleteDic;

- (IBAction)deleteBtnClick:(UIButton *)sender;
- (IBAction)backBtnClick:(UIBarButtonItem *)sender;
- (IBAction)editBtnClick:(UIBarButtonItem *)sender;

@end
