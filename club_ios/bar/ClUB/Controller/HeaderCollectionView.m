//
//  HeaderCollectionView.m
//  01 Movie
//
//  Created by liyoubing on 15/6/23.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "HeaderCollectionView.h"
#import "ListCell.h"
//宏定义屏幕的宽高
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height

static NSString *iden = @"cell_list";

@implementation HeaderCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    //创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置空隙
    flowLayOut.minimumLineSpacing = 0;
    //设置item的大小
    //注意：此时self.frame还没有值
//    flowLayOut.itemSize = CGSizeMake(90, self.height);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayOut];
    if (self) {
       
        //设置代理
        self.delegate = self;
        self.dataSource = self;
        
        //隐藏水平滚动条
        self.showsHorizontalScrollIndicator = NO;
        
        //设置减速方式
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        //注册item
        [self registerClass:[ListCell class] forCellWithReuseIdentifier:iden];
    }
    return self;
}

#pragma mark - UICollectionDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {

    return _data.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    
//    cell.imgName = [NSString stringWithFormat:@"1%ld@2x.png",indexPath.row];
    cell.imgName = _data[indexPath.row];
    return cell;
}

//设置单元格的宽高
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(_pageWidth, 110);
    
    return size;
}

//设置视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

// CGFloat top, left, bottom, right;
    
    CGFloat offset = (-_pageWidth)/2.0+KScreenWidth/2.0;
    
    return UIEdgeInsetsMake(0, offset, 0, offset);
    
}

/**
 *  手指将要结束拖拽的时候
 *
 *  @param scrollView          手指拖拽的视图
 *  @param velocity            x和y方向的速度
 *  @param targetContentOffset x和y方向的偏移量
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {

    CGFloat offsetX = targetContentOffset->x;
    
    NSInteger pageNum = (offsetX + _pageWidth/2.0)/_pageWidth;
    
    targetContentOffset->x = pageNum*_pageWidth;
    
    //记录下当前正在显示的视图下标
//    _currentPage = pageNum;
    self.currentPage = pageNum;
}

//点击单元格的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

    //如果视图不是在正中间显示，则滑动到中间
    //indexPath
    if (_currentPage != indexPath.row) {
        
        //滑动视图
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        
        //重新记录当前正在显示的下标
//        _currentPage = indexPath.row;
        self.currentPage = indexPath.row;
        
    }
}
//单元格结束显示的时候调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath {

    //将结束显示的cell中imgView放在最上层
    ListCell *pCell = (ListCell *)cell;

    [pCell.contentView bringSubviewToFront:pCell.imgView];
}




@end
