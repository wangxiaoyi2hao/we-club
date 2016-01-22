//
//  SponsoredGroupTableViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/10/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SponsoredGroupTableViewCell.h"

@implementation SponsoredGroupTableViewCell

- (void)awakeFromNib {
    if (KScreenHeight == 480) {
        self.imageHead.layer.cornerRadius = 20;//边框圆角
    }else if(KScreenHeight == 568){
        self.imageHead.layer.cornerRadius = 25;//边框圆角
    }else if(KScreenHeight == 667){
        self.imageHead.layer.cornerRadius = 25;//边框圆角
    }else{
        self.imageHead.layer.cornerRadius = 35;//边框圆角
    }
    
    self.imageHead.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
