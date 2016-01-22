//
//  FindsViewController.h
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
//给block方法改名
//typedef  void(^MyBlock)(NSInteger count);

@interface FindsViewController : UIViewController<UITableViewDelegate,UITableViewDataSource,UIActionSheetDelegate,UISearchBarDelegate>
{
    IBOutlet UITableView*_tableView;
}
@property(nonatomic,weak)IBOutlet UIView*headerView;
@property(nonatomic,weak)IBOutlet UISearchBar*_searchBar;
////数据源代理协议
//@property (nonatomic, weak) id<BAddressPickerDataSource> dataSource;
//委托代理协议

//定义一个block方法对象
//@property(nonatomic, copy)MyBlock block;

@end
