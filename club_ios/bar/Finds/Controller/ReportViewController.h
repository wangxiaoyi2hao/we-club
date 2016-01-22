//
//  ReportViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/6.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface ReportViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,copy)NSString*fromInviteID;
@property (weak, nonatomic) IBOutlet UITableView *reportTableView;
@property(nonatomic,copy)NSString*fromUserID;
@property(nonatomic,assign)int whereIsCome;
@end
