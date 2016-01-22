//
//  MyCell.m
//  02 CollectionViewDemo
//
//  Created by liyoubing on 15/6/12.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "MyImageViewCell.h"

@implementation MyImageViewCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:imgView];
    }
    return self;
}

- (void)setImgName:(NSString *)imgName {

    _imgName = imgName;
    
    imgView.image = [UIImage imageNamed:_imgName];
    
    
}


@end
