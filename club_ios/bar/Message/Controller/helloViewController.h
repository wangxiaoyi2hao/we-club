//
//  helloViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//打过的招呼界面导航栏
#import <UIKit/UIKit.h>
#import "helloCell.h"
#import "HelloModel.h"

@interface helloViewController : UITableViewController

@property (nonatomic , strong) NSMutableArray *dataArray;

- (IBAction)backBtnClick:(UIBarButtonItem *)sender;
- (IBAction)clearBtnClick:(UIBarButtonItem *)sender;

@end
