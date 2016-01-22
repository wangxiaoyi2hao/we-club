//
//  SearchBarVC.h
//  Weclub
//
//  Created by chen on 16/1/20.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "FMDB.h"

@interface SearchBarVC : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) FMDatabase *fmdb;

@property (weak, nonatomic) IBOutlet UIImageView *backGroandImageView;
@property (weak, nonatomic) IBOutlet UITableView *searchHistoryTableView;
@property (weak, nonatomic) IBOutlet UIButton *backButton;
@property(weak,nonatomic)IBOutlet UIView*footerView;
@property(weak,nonatomic)IBOutlet UIView*headerView;

- (IBAction)backButton:(UIButton *)sender;


@end
