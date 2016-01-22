//
//  RoadPlanViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoadPlanViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{


    IBOutlet UITableView*_tableView;

}
@property(nonatomic,assign)float barXiao;
@property(nonatomic,assign)float barDa;

@end
