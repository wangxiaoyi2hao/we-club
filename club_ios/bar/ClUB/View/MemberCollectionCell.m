//
//  MyCell.m
//  02 CollectionViewDemo
//
//  Created by liyoubing on 15/6/12.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "MemberCollectionCell.h"

@implementation MemberCollectionCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 64*KScreenWidth/320, 64*KScreenWidth/320)];
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64*KScreenWidth/320, 64*KScreenWidth/320, 20)];
        _nameLabel.font = [UIFont systemFontOfSize:13];
        _nameLabel.textAlignment=NSTextAlignmentCenter;
        imgView.layer.cornerRadius = 32*KScreenWidth/320;//边框圆角
        imgView.layer.borderWidth = 1;//边框线宽度
        imgView.layer.masksToBounds = YES;
        imgView.layer.borderColor = [UIColor clearColor].CGColor;
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:imgView];
    }
    return self;
}

- (void)setImgName:(NSString *)imgName {

    _imgName = imgName;
    [imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",imgName]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    
    
}
- (void)setNameLabel:(UILabel *)nameLabel{
    _nameLabel = nameLabel;
    
}


@end
