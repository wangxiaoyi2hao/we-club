//
//  decisionCell.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface decisionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *content;
@property (weak, nonatomic) IBOutlet UILabel *time;

@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
- (IBAction)segBtnClick:(UISegmentedControl *)sender;

@end
