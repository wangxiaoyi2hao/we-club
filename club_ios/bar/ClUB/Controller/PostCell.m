//
//  PosterCell.m
//  01 Movie
//
//  Created by liyoubing on 15/6/23.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "PostCell.h"
#import "UIViewExt.h"

@implementation PostCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {

        //创建子视图
        [self _initSubView];
        
    }
    
    return self;
}

//创建子视图
- (void)_initSubView {

    _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, self.width-20, self.height-20)];
    [self.contentView addSubview:_imgView];
}
- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    _imgView.image = [UIImage imageNamed:_imgName];
    
}
@end
