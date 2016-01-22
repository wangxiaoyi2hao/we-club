//
//  InviteCompleCell.h
//  Weclub
//
//  Created by chen on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCompleCell : UITableViewCell<UITextFieldDelegate>//<UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UITextField *contentText;

@end
