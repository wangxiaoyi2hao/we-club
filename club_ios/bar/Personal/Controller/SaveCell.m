//
//  SaveCell.m
//  bar
//
//  Created by chen on 15/11/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SaveCell.h"
#import "AppDelegate.h"

@implementation SaveCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    if (KScreenHeight == 480) {
        self.iconImageView.layer.cornerRadius = 20;//边框圆角
    }else if(KScreenHeight == 568){
        self.iconImageView.layer.cornerRadius = 24;//边框圆角
    }
//        else if(KScreenHeight == 667){
//        self.iconImageView.layer.cornerRadius = 24;//边框圆角
//    }else{
//        self.iconImageView.layer.cornerRadius = 24;//边框圆角
//    }
    
    self.iconImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
