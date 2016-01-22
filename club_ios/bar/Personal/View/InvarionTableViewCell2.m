//
//  InvarionTableViewCell2.m
//  bar
//
//  Created by lsp's mac pro on 15/11/12.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "InvarionTableViewCell2.h"
#import "AppDelegate.h"
#import "MyInviteImageViewCell.h"

#import "UIView+UiViewConctroller.h"
static NSString *iden = @"MyInviteImageViewCell";
/** 表格的边框宽度 */
#define TableBorder 10
/** cell的边框宽度 */
#define CellBorder 10
@implementation InvarionTableViewCell2{
    //网格视图
    NSMutableArray *_mArray;
    int _index;
    UICollectionView *_collectionView;
}


- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
   
    self.layer.cornerRadius = 5.0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self setNeedsLayout];
    
    UICollectionView *collectionView = [self _addImgView];
    [self.myBackImageView addSubview:collectionView];
}

- (void)layoutSubviews {
    //使用mvc一定要注意:给值前一定要确保值已经传过来了
    //一定要先调用父类的方法
    [super layoutSubviews];
    if (KScreenHeight == 480) {
        [self.iconImageView setFrame:CGRectMake(10, 17, 50, 50)];
        self.iconImageView.layer.cornerRadius = 25;//边框圆角
    }else if(KScreenHeight == 568){
        self.iconImageView.layer.cornerRadius = 30;//边框圆角
    }else if(KScreenHeight == 667){
        self.iconImageView.layer.cornerRadius = 35;//边框圆角
    }else{
        self.iconImageView.layer.cornerRadius = 40;//边框圆角
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
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0,270*(KScreenWidth/320), 270*(KScreenWidth/320)/4.0+30) collectionViewLayout:flowLayOut];
    collectionView.backgroundColor = [HelperUtil colorWithHexString:@"#efefef"];
    
    //设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    //[self.view addSubview:collectionView];
    
    //注册单元格
    [collectionView registerClass:[MyInviteImageViewCell class] forCellWithReuseIdentifier:iden];
    //设置头视图的大小
    // flowLayOut.headerReferenceSize = CGSizeMake(60, 375);
    return collectionView;
}

#pragma mark - UICollectionViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _mArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    MyInviteImageViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
//    InviteImages*inviteImage = [_myInvireMutableArray objectAtIndex:indexPath.row];
//    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",inviteImage.thumbnailimages]] placeholderImage:[UIImage imageNamed:@"fsfsd"]];
    cell.imgName = _mArray[indexPath.row];
    
    return cell;
    
}

//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 10, 10, 10);
    
    return edge;
    
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
//    controller.imageArray=_mutableArray;
//    controller.index=(int)indexPath.row;
//    [self.viewController presentViewController:controller animated:NO completion:nil];
    
    
}


- (IBAction)mySignUpAction:(UIButton *)sender {
}

- (IBAction)sheraAction:(UIButton *)sender {
}

@end
