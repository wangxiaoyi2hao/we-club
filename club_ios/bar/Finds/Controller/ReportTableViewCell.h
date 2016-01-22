//
//  ReportTableViewCell.h
//  bar
//
//  Created by lsp's mac pro on 15/11/6.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReportTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *statusImageView;
@property(nonatomic,weak)IBOutlet UILabel*lbWhy;
@property(nonatomic,weak)IBOutlet UIButton*buttonWhy;
@end
