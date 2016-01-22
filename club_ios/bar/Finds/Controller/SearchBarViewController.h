//
//  SearchBarViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarViewController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
{

    IBOutlet UITableView*_tableView;
    IBOutlet UITextField*_tfBarName;
}
@property (strong, nonatomic) IBOutlet UIView *headView;
@property(nonatomic,copy)NSString* fromIntBag;
@end
