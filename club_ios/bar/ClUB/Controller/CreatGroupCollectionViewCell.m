//
//  CreatGroupCollectionViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/11/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "CreatGroupCollectionViewCell.h"
#import "AppDelegate.h"

@implementation CreatGroupCollectionViewCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    if (KScreenHeight == 480) {
        self._imageHead.layer.cornerRadius = 30;//边框圆角
    }else if(KScreenHeight == 568){
       self._imageHead.layer.cornerRadius = 32;//边框圆角
    }else if(KScreenHeight == 667){
        self._imageHead.layer.cornerRadius = 32;//边框圆角
    }else{
        self._imageHead.layer.cornerRadius = 32;//边框圆角
    }
    
    self._imageHead.layer.masksToBounds = YES;
}

@end
