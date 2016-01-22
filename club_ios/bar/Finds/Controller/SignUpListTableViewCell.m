//
//  SignUpListTableViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SignUpListTableViewCell.h"
#import "AppDelegate.h"

@implementation SignUpListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    [AppDelegate matchAllScreenWithView:self.contentView];
    if (KScreenHeight == 480) {
        _imageHead.layer.cornerRadius = 25;//边框圆角
    }else if(KScreenHeight == 568){
        _imageHead.layer.cornerRadius = 25;//边框圆角
    }else if(KScreenHeight == 667){
        _imageHead.layer.cornerRadius = 28;//边框圆角
    }else{
        _imageHead.layer.cornerRadius = 40;//边框圆角
    }
    
    _imageHead.layer.masksToBounds = YES;
 
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
