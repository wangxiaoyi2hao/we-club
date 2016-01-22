//
//  GroupViewController.m
//  bar
//
//  Created by chen on 15/11/13.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "GroupViewController.h"
#import "MyImageViewCell.h"
#import "InfoTableViewController.h"

static NSString *iden1 = @"photoCollectionCell";
@interface GroupViewController (){
    NSInteger _idex;
    UIView *_headView;
}


@end

@implementation GroupViewController
+(GroupViewController *)shareGroup{
    
    static GroupViewController* shareGroup = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        shareGroup = [[[self class] alloc] init];
    });
    
    return shareGroup;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    //设置是否显示竖向滚动条
    self.conversationMessageCollectionView.showsVerticalScrollIndicator=NO;
    self.conversationMessageCollectionView.frame = CGRectMake(0, 64, KScreenWidth, KScreenHeight-64-49);
    _mArray = [[NSMutableArray alloc] init];
    for (int i =0; i<3; i++) {
        [_mArray addObject:[NSString stringWithFormat:@"%d@2x.png",i+1]];//1-3-2.png
    }
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 36)];
    //[self.view addSubview:_headView];
    _headView.backgroundColor = [UIColor grayColor];
    //设置代理
//    _photoCollectionView.delegate = self;
//    _photoCollectionView.dataSource = self;
//    [self _addPhoto];
    [self loadNav];
}
- (void)viewWillAppear:(BOOL)animated{
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
}
/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    UIStoryboard *storyBd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *infoTVC = [storyBd instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    infoTVC.fromUserId =  userId;
    [self.navigationController pushViewController:infoTVC animated:YES];
}
-(void)loadNav{
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(lastThisView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
    
//    UIButton*rightButton=[]
    
    
}
-(void)lastThisView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//- (void)_addPhoto{
//#pragma mark - 假数据数组,需要替换真数据
//    //1.创建布局对象
//    UICollectionViewFlowLayout *flowLayOut1 = [[UICollectionViewFlowLayout alloc] init];
//    //设置单元格的大小
//    flowLayOut1.itemSize = CGSizeMake(36, 36);
//    //设置每行之间的最小空隙
//    flowLayOut1.minimumLineSpacing = 1;
//    //设置滑动的方向,默认是垂直滑动
//    flowLayOut1.scrollDirection = UICollectionViewScrollDirectionHorizontal;
//    //设置头视图的大小
//    flowLayOut1.headerReferenceSize = CGSizeZero;
//    flowLayOut1.footerReferenceSize = CGSizeZero;
//    
//    //2.创建collectionView
//    _photoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,0, KScreenWidth, 36) collectionViewLayout:flowLayOut1];
//    _photoCollectionView.backgroundColor = [UIColor whiteColor];
//    
//    //注册单元格
//    [_photoCollectionView registerClass:[MyImageViewCell class] forCellWithReuseIdentifier:iden1];
//    
//    [_headView addSubview:_photoCollectionView];
//}
//
//#pragma mark - UICollectionViewDataSource添加照片的代理方法
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
//    
//    return 1;
//}
//
//- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
//    
//    //return 5;
//    NSLog(@"%ld",_mArray.count);
//    return 1;
//    
//}
//
//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    
//    MyImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden1 forIndexPath:indexPath];
//    
//    if (indexPath.row == _mArray.count-1) {
//        cell.imgName = @"1-3-2.png";
//    }else{
//        cell.imgName = _mArray[indexPath.row];
//    }
//    return cell;
//    
//}
//
////设置每一组视图的停靠位置
//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
//    // CGFloat top, left, bottom, right;
//    UIEdgeInsets edge = UIEdgeInsetsMake(5, 5, 5, 5);
//    
//    return edge;
//    
//}
////点击单元格调用的代理方法
//- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    if (indexPath.row ==_mArray.count-1) {
//        [_mArray insertObject:_mArray[indexPath.row] atIndex:_mArray.count-1];
//        [_photoCollectionView reloadData];
//        
//    }else{
////        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"删除图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
////        
////        [actionSheet showInView:self.view];
////        actionSheet.tag = 1002;
//        _idex = indexPath.row;
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
 
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

