//
//  FeedbackCollectionViewCell.m
//  Weclub
//
//  Created by chen on 15/12/8.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FeedbackCollectionViewCell.h"

@implementation FeedbackCollectionViewCell
- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    
    if (self) {
        imgView = [[UIImageView alloc] initWithFrame:self.bounds];
        imgView.userInteractionEnabled = YES;

        [self.contentView addSubview:imgView];
        
    }
    return self;
}

- (void)setImgName:(UIImage *)imgName {
    _imgName = imgName;
    imgView.image= imgName;
}

@end
