//
//  HostFriendsTableViewCell.h
//  bar
//
//  Created by lsp's mac pro on 15/11/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HostFriendsTableViewCell : UITableViewCell
@property(nonatomic,weak)IBOutlet UIImageView*imageHead;
@property(nonatomic,weak)IBOutlet UILabel*lbName;
@property(nonatomic,weak)IBOutlet UILabel*lbHeart;
@property(nonatomic,weak)IBOutlet UIImageView*imageHeadFront;
@property(nonatomic,weak)IBOutlet UIImageView*imageRight;
@property(nonatomic,weak)IBOutlet UIButton*buttonSelect;
@end
