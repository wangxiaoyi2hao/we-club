//
//  ClubTableViewCell.h
//  bar
//
//  Created by lsp's mac pro on 15/11/13.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol TermCellDelegate <NSObject>

- (void)choseAttention:(UIButton *)button;

@end
@interface ClubTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIButton *attentionButAction;
@property(weak,nonatomic)IBOutlet UIImageView*imageViewAttention;
@property(weak,nonatomic)IBOutlet UILabel*lbClub;
@property(weak,nonatomic)IBOutlet UILabel*lbAddress;
@property(weak,nonatomic)IBOutlet UILabel*lbDistance;
@property(weak,nonatomic)IBOutlet UILabel*lbBoy;
@property(weak,nonatomic)IBOutlet UILabel*girl;
@property(weak,nonatomic)IBOutlet UIImageView*imageBarIcon;
@property(weak,nonatomic)IBOutlet UILabel*lbPhoneNumber;
//@property(weak,nonatomic)IBOutlet UIButton*shareButton;

@property (assign, nonatomic) BOOL  isChecked;
@property (assign, nonatomic) id<TermCellDelegate> delegate;
//- (IBAction)attentionButActionClick:(UIButton *)sender;
@property(weak,nonatomic)IBOutlet UILabel*lbDownBackgroud;


@property(nonatomic,weak)IBOutlet UIButton*buttonDesCribe;


@end
