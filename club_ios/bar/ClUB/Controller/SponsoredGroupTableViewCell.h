//
//  SponsoredGroupTableViewCell.h
//  bar
//
//  Created by lsp's mac pro on 15/10/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsoredGroupTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIButton*buttonSelect;
@property(nonatomic,weak)IBOutlet UIImageView*imageHead;
@property(nonatomic,weak)IBOutlet UILabel*lbName;
@property(nonatomic,assign)BOOL isSelected;
@end
