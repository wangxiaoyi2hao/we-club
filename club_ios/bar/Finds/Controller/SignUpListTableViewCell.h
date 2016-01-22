//
//  SignUpListTableViewCell.h
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignUpListTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView*imageHead;
@property(nonatomic,weak)IBOutlet UILabel*lbName;
@property(nonatomic,weak)IBOutlet UILabel*lbHeart;
@property(nonatomic,weak)IBOutlet UIButton*buttonHead;
@property(nonatomic,weak)IBOutlet UIButton*buttonMessage;
@property(nonatomic,weak)IBOutlet UIImageView*_imageViewMessage;

@end
