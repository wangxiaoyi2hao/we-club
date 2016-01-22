//
//  LookForWeclubViewController.h
//  Weclub
//
//  Created by lsp's mac pro on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookForWeclubViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
{

    IBOutlet UIView*_viewFoot;
    IBOutlet UITableView*_tableView;
    IBOutlet UITextField*_tfSearch;
}

@end
