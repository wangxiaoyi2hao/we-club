//
//  PosterCollectionView.m
//  01 Movie
//
//  Created by liyoubing on 15/6/23.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "PosterCollectionView.h"
#import "PostCell.h"
//宏定义屏幕的宽高
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height
static NSString *iden = @"cell_Poster";

@implementation PosterCollectionView

- (instancetype)initWithFrame:(CGRect)frame
{
    //创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置滑动方向
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置最小距离
    flowLayOut.minimumLineSpacing = 0;
    //设置item的大小,错误
//    flowLayOut.itemSize = CGSizeMake(220, self.height);
    
    self = [super initWithFrame:frame collectionViewLayout:flowLayOut];
    
    if (self) {
        
        _currentPage = 0;
        //设置代理
        self.dataSource = self;
        self.delegate = self;
        
        //设置减速方式
        self.decelerationRate = UIScrollViewDecelerationRateFast;
        
        //注册单元格
        [self registerClass:[PostCell class] forCellWithReuseIdentifier:iden];
    }
    return self;
}

#pragma mark - UICollectionViewDataSource
//返回单元格的个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _data.count;
}
//取得每一个单元格
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    PostCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];

//    cell.imgName = [NSString stringWithFormat:@"1%ld@2x.png",indexPath.row];
    cell.imgName = _data[indexPath.row];
    return cell;
}

//设置单元格大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {

    CGSize size = CGSizeMake(_pageWidth, 320);
    return size;
}

//设置collectionView的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {

//        CGFloat top, left, bottom, right;
    
    //计算左右的偏移量
    CGFloat offset = (KScreenWidth - _pageWidth)/2.0;
    
    return UIEdgeInsetsMake(0, offset-5, 0, offset);
}

/**
 *  手指结束拖拽调用的代理方法
 *
 *  @param scrollView          手指滑动的视图
 *  @param velocity            x和y方向的速度
 *  @param targetContentOffset x和y方向的偏移量
 */
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView
                     withVelocity:(CGPoint)velocity
              targetContentOffset:(inout CGPoint *)targetContentOffset {
    NSLog(@"targetContentOffset->x:%f",targetContentOffset->x);
    
    //计算X方向的偏移量
    CGFloat offsetX = targetContentOffset->x;
    
    NSInteger pageNum = (offsetX+_pageWidth/2.0)/_pageWidth;
    
    targetContentOffset->x = _pageWidth*pageNum;
    
    //记录当前正在显示的页数
    self.currentPage = pageNum;
    
}

//点击cell的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {

        //滑动到视图中间
        [collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];

        //记录当前正在显示的页数
        self.currentPage = indexPath.row;

}



@end
