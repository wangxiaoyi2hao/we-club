//
//  MyCell.m
//  02 CollectionViewDemo
//
//  Created by liyoubing on 15/6/12.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "ImageViewCell.h"

@implementation ImageViewCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

//- (void)setImgName:(NSString *)imgName {
//
//    _imgName = imgName;
//    
//    _imgView.image = [UIImage imageNamed:_imgName];
//    
//}
- (void)setImage:(UIImage *)image{
    _image = image;
    _imgView.image = image;
}
- (void)setImgView:(UIImageView *)imgView{
    _imgView = imgView;
}

@end
