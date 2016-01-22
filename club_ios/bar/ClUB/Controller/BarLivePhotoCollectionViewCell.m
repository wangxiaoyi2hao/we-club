//
//  BarLivePhotoCollectionViewCell.m
//  Weclub
//
//  Created by chen on 15/12/21.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BarLivePhotoCollectionViewCell.h"

@implementation BarLivePhotoCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)setImgName:(UIImage *)imgName {
    
    _imgName = imgName;
    _imgView.image=imgName;
    
    
    
}
- (void)setImgView:(UIImageView *)imgView{
    _imgView = imgView;
}


@end
