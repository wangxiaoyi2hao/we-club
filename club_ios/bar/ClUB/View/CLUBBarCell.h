//
//  CLUBBarCell.h
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CLUBBarCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *attentionButAction;
@property(weak,nonatomic)IBOutlet UILabel*lbClub;
@property(weak,nonatomic)IBOutlet UILabel*lbAddress;
@property(weak,nonatomic)IBOutlet UILabel*lbDistance;
@property(weak,nonatomic)IBOutlet UILabel*lbBoy;
@property(weak,nonatomic)IBOutlet UILabel*girl;
- (IBAction)attentionButton:(UIButton *)sender;

@end
