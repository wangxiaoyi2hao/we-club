//
//  SearchBarTableViewCell.h
//  bar
//
//  Created by lsp's mac pro on 15/11/11.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchBarTableViewCell : UITableViewCell


 @property(nonatomic,weak)   IBOutlet UILabel*lbBarName;
  @property(nonatomic,weak)   IBOutlet UILabel*lbAddress;
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;

@end
