//
//  InviteTableViewCell.m
//  bar
//
//  Created by lsp's mac pro on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "InviteTableViewCell.h"
#import "AppDelegate.h"
#import "InviteImageViewCell.h"
#import "LookUpImageViewController.h"
#import "UIView+UiViewConctroller.h"
#import "STPhotoBrowserController.h"
//#import "ZLPhotoPickerBrowserViewController.h"

static NSString *iden = @"InviteImageViewCell";
/** 表格的边框宽度 */
#define TableBorder 10
/** cell的边框宽度 */
#define CellBorder 10
@implementation InviteTableViewCell{
    //网格视图
    NSMutableArray *_mArray;
    int _index;
    UICollectionView *_collectionView;
}

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
//    self.layer.cornerRadius = 5.0;
//    self.selectionStyle = UITableViewCellSelectionStyleNone;
    UICollectionView *collectionView = [self _addImgView];
    [self.changeImgView addSubview:collectionView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    if (KScreenHeight == 480) {
        [self.iconImageView setFrame:CGRectMake(10, 17, 50, 50)];
        self.iconImageView.layer.cornerRadius = 10;//边框圆角
    }else if(KScreenHeight == 568){
        self.iconImageView.layer.cornerRadius = 10;//边框圆角
    }else if(KScreenHeight == 667){
        self.iconImageView.layer.cornerRadius = 25;//边框圆角
    }else{
        self.iconImageView.layer.cornerRadius = 50;//边框圆角
    }
        self.iconImageView.layer.masksToBounds = YES;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
#pragma mark- 网格视图
- (UICollectionView *)_addImgView{
    _mArray = [[NSMutableArray alloc] init];
    for (int i =0; i<4; i++) {
        [_mArray addObject:[NSString stringWithFormat:@"%d@2x.png",i+1]];
    }
    //    [_mArray addObject:[NSString stringWithFormat:@"7@2x.png"]];
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    flowLayOut.itemSize = CGSizeMake(270*(KScreenWidth/320)/4.0-15, 270*(KScreenWidth/320)/4.0-20+30);
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 1;
    //设置滑动的方向,默认是垂直滑动
    //flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置头视图的大小
    flowLayOut.headerReferenceSize = CGSizeZero;
    flowLayOut.footerReferenceSize = CGSizeZero;
    
    //2.创建collectionView
    
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(10,149,355, 101) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = [HelperUtil colorWithHexString:@"#efefef"];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //[self.view addSubview:collectionView];
    
    //注册单元格
    [_collectionView registerClass:[InviteImageViewCell class] forCellWithReuseIdentifier:iden];
    //设置头视图的大小
    // flowLayOut.headerReferenceSize = CGSizeMake(60, 375);
    return _collectionView;
}

#pragma mark - UICollectionViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _mutableArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InviteImageViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    InviteImages*inviteImage = [_mutableArray objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",inviteImage.thumbnailimages]] placeholderImage:[UIImage imageNamed:@"fsfsd"]];
    return cell;
    
}

//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 10, 10, 10);
    return edge;
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.imageArray=_mutableArray;
    controller.index=(int)indexPath.row;
    [self.viewController presentViewController:controller animated:NO completion:nil];
}




@end
