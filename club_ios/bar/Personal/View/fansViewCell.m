//
//  fansViewCell.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "fansViewCell.h"

@implementation fansViewCell

- (void)awakeFromNib {
    if (KScreenHeight == 480) {
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }else if(KScreenHeight == 568){
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }else if(KScreenHeight == 667){
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }else{
        self.picture.layer.cornerRadius = 22.5;//边框圆角
    }
    
    self.picture.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)addFriends:(UIButton *)sender {
}
@end
