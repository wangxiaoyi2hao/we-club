//
//  PosterCollectionView.h
//  01 Movie
//
//  Created by liyoubing on 15/6/23.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PosterCollectionView : UICollectionView<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong)NSArray *data;
@property(nonatomic, assign)CGFloat pageWidth;


@property(nonatomic, assign)NSInteger currentPage;


@end
