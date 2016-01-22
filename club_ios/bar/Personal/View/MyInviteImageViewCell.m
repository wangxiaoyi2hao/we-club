//
//  MyInviteImageViewCell.m
//  Weclub
//
//  Created by chen on 15/12/21.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "MyInviteImageViewCell.h"

@implementation MyInviteImageViewCell
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        _imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        _imgView.backgroundColor = [UIColor greenColor];
        [self.contentView addSubview:_imgView];
    }
    return self;
}

- (void)setImgName:(NSString *)imgName {

    _imgName = imgName;

    _imgView.image = [UIImage imageNamed:_imgName];


}
- (void)setImgView:(UIImageView *)imgView{
    _imgView = imgView;
}

@end
