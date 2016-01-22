//
//  bindingViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "bindingModel.h"
#import "specificBindViewController.h"

@interface bindingViewController : UITableViewController

@property (nonatomic , strong) NSMutableArray *array;

- (IBAction)backBtnClick:(id)sender;

@end
