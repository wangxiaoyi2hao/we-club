//
//  InfoEditCollectionViewCell.m
//  Weclub
//
//  Created by lsp's mac pro on 15/12/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "InfoEditCollectionViewCell.h"

@implementation InfoEditCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.layer.cornerRadius = 10;
        _imgView.layer.masksToBounds = YES;
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
