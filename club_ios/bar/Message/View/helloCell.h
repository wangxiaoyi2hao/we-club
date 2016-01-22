//
//  helloCell.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//打过的招呼cell
#import <UIKit/UIKit.h>

@interface helloCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *helloNumber;
@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end
