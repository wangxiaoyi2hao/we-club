//
//  photoCollectionCell.h
//  bar
//
//  Created by 牟志威 on 15/10/12.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface photoCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photoView;
- (void) setPhoto: (UIImage *) image;

@end
