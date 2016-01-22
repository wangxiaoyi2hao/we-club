//
//  MyCell.h
//  02 CollectionViewDemo
//
//  Created by liyoubing on 15/6/12.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCell : UICollectionViewCell

@property(nonatomic, copy)NSString *imgName;
@property(nonatomic, strong)UIImageView *imgView;
@property(nonatomic, strong)UIImage *image;

@end
