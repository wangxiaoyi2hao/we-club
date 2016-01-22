//
//  ListCell.m
//  01 Movie
//
//  Created by liyoubing on 15/6/23.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "ListCell.h"
#import "UIViewExt.h"

@implementation ListCell

- (id)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        //创建imgView
        _imgView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 5, self.width-10, self.height-10)];
        
        [self.contentView addSubview:_imgView];
        
    }
    
    return self;
}
- (void)setImgName:(NSString *)imgName{
    _imgName = imgName;
    _imgView.image = [UIImage imageNamed:_imgName];
}


@end
