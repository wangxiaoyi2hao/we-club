//
//  BarProductionViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/10/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BarProductionViewController.h"
#import "AppDelegate.h"
#import "MpaViewController.h"
#import "Clubuser.pbobjc.h"
#import "Common.pbobjc.h"
#import "HeaderCollectionView.h"
#import "PosterCollectionView.h"
#import "LookUpImageViewController.h"
//#import "BarProductionCollectionViewCell.h"
#import "BarLivePhotoCollectionViewCell.h"

extern UserInfo*LoginUserInfo;
static NSString *iden = @"LivePhotoCollectionViewCell";
@interface BarProductionViewController ()<ZYQAssetPickerControllerDelegate>
{
    NSMutableArray*_imageArray;
    //小助手
    UIView * xiazhushouView;
    UIView * _helperBackView;
    UIScrollView *_summaryScrollView;
    
    ASIFormDataRequest*_request;//获取介绍
    ASIFormDataRequest*_requestLivePhoto;//获取livephoto
    ASIFormDataRequest*_requestLike;//酒吧点赞
    ASIFormDataRequest*_requestPhotoLike;//livephoto点赞

    PosterCollectionView *_posterListView;
    UISwipeGestureRecognizer *_swipe;
    UIControl *_maskView;
    HeaderCollectionView *_listView;
    NSArray *_data;
    NSMutableArray *_mData;
    
    Response11007 * response11007;

    //网格视图
    NSMutableArray *_mArray;
    NSInteger _index;
    UICollectionView *_livePhotoCollectionView;
    UIImage*_imageCell;
}
@end

@implementation BarProductionViewController

-(void)viewWillDisappear:(BOOL)animated{
    [_request clearDelegatesAndCancel];
    [_requestLivePhoto clearDelegatesAndCancel];
    [_requestPhotoLike clearDelegatesAndCancel];
    [_requestLike clearDelegatesAndCancel];
    

}
-(void)dealloc{
    //移除响应
    [_listView removeObserver:self forKeyPath:@"currentPage"];
    //移除响应
    [_posterListView removeObserver:self forKeyPath:@"currentPage"];
}
- (void)viewDidLoad {
    [super viewDidLoad];
     [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    [AppDelegate matchAllScreenWithView:self.view];
    [AppDelegate matchAllScreenWithView:_headerView];
    //禁止滚动
    _tableView.scrollEnabled = NO;
    //一个图片数组，供用到时候调借口用 livePhotoArray
    _imageArray=[NSMutableArray array];
    //小助手
    [self initxiaozhushou];
    //加载导航条
    [self loadNavController];
    //[self loadScrolleview];

    [self addLivePhoto];
    _posterListView.currentPage = 2;
    //_listView.currentPage = 2;

    [self requestUrl];
    [[Tostal sharTostal]showLoadingView:@"正在加载中"];
    //collectionview的必须 要有的注册方法
    UINib*nibcell=[UINib nibWithNibName:@"BarProductionCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nibcell forCellWithReuseIdentifier:@"cell"];
    
    [self addPhoto];

}
-(void)viewWillAppear:(BOOL)animated{
    
}


-(void)addLivePhoto{

    [self _initHeaderListView];
    [self _initPosterView];
    _view1.userInteractionEnabled = YES;
    
    _data = @[@"酒吧图1.png",@"酒吧图2.png",@"酒吧图3.png",@"酒吧美女图1.png",@"酒吧美女图2.png",@"酒吧美女图3.png",@"酒吧图4.png",@"酒吧图5.png",@"酒吧图6.png",@"酒吧图7.png",];
    _mData = [[NSMutableArray alloc] init];
    [_mData addObjectsFromArray:_data];
    [self loadData:_data];
    
    //监听headerListView的currentPage属性
    [_listView addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:nil];
    //监听posterListView的currentPage属性
    [_posterListView addObserver:self forKeyPath:@"currentPage" options:NSKeyValueObservingOptionNew context:nil];

}
////监听触发的方法
////触发的方法如果不执行：有两个情况：（1）改变属性值的时候没有使用setter或者KVC、（2）添加监听的时候，使用的对象是nil
///**
// *  @param keyPath 监听的属性名
// *  @param object  监听的对象
// *  @param change  存放监听的对象的属性值
// *  @param context 传递的数据
// */
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    //取得滑动的视图变化后的下标
    NSInteger selectIndex = [[change objectForKey:@"new"] integerValue]; //0   5
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:selectIndex inSection:0];
    
    if (object == _listView && selectIndex != _posterListView.currentPage) {
        //将下边的海报视图滑动到相对象的地方
        [_posterListView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES]; // 5
        _posterListView.currentPage = selectIndex; //5
    }else if (object == _posterListView && selectIndex != _listView.currentPage) {
        
        [_listView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
        _listView.currentPage = selectIndex;
    }

}
#pragma mark
//创建小视图
- (void)_initHeaderListView {
    
    _listView = [[HeaderCollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth,120)];
    //设置宽度
    _listView.pageWidth = KScreenWidth/5.0;
    _listView.backgroundColor = [HelperUtil colorWithHexString:@"efefef"];
    [_view1 addSubview:_listView];
    
}
//创建下方大图
- (void)_initPosterView {
    
    _posterListView = [[PosterCollectionView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, 320)];
    //设置每一页的宽度
    _posterListView.pageWidth = KScreenWidth;
    _posterListView.backgroundColor = [HelperUtil colorWithHexString:@"efefef"];
    [_view2 addSubview:_posterListView];
    
}
//加载数据
- (void)loadData:(NSArray *)data1 {
    _posterListView.data = data1;
    _listView.data = data1;
    [_posterListView reloadData];
    [_listView reloadData];
}


#pragma mark 获取酒吧详情
//酒吧详情请求方法
-(void)requestUrl{
    Request11007*request=[[Request11007 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getClubDetail",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11007;
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.common.version=@"1.0.0";
    
    request.params.clubId=_fromUserId;
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
    //（2）创建manager
    
}
#pragma mark 获取酒吧live photo
-(void)requestUrlLivePhoto{
    Request11008*request=[[Request11008 alloc]init];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11008;
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.params.clubId=_fromUserId;
    NSData*data= [request data];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getClubLivePhoto",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestLivePhoto = [ASIFormDataRequest requestWithURL:url];
        [_requestLivePhoto setPostBody:(NSMutableData*)data];
    [_requestLivePhoto setDelegate:self];
    //请求延迟时间
    _requestLivePhoto.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestLivePhoto.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestLivePhoto.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestLivePhoto.secondsToCache=3600;
    [_requestLivePhoto startAsynchronous];
    //（2）创建manager
    
}
#pragma mark 获取酒吧点赞
-(void)requestUrlLike{
    Request11009*request=[[Request11009 alloc]init];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11009;
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request.params.clubId=_fromUserId;
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/likeClub",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestLivePhoto = [ASIFormDataRequest requestWithURL:url];
    NSData*data= [request data];
    [_requestLike setPostBody:(NSMutableData*)data];
    [_requestLike setDelegate:self];
    //请求延迟时间
    _requestLike.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestLike.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestLike.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestLike.secondsToCache=3600;
    [_requestLike startAsynchronous];
    //（2）创建manager
    
}
#pragma mark 获取livephoto点赞
-(void)requestUrlPhotoLike{
    Request11010*request=[[Request11010 alloc]init];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11010;//现在标注为假数据
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.params.livePhotoId=@"";
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/likeClubLivePhoto",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestPhotoLike = [ASIFormDataRequest requestWithURL:url];
    NSData*data= [request data];
    [_requestPhotoLike setPostBody:(NSMutableData*)data];
    [_requestPhotoLike setDelegate:self];
    //请求延迟时间
    _requestPhotoLike.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestPhotoLike.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestPhotoLike.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestPhotoLike.secondsToCache=3600;
    [_requestPhotoLike startAsynchronous];
    //（2）创建manager
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]) {
        response11007 = [Response11007 parseFromData:request.responseData error:nil];
        NSString*clubId=response11007.data_p.club.clubId;
        NSLog(@"备用的%@",clubId);
        int likestate=response11007.data_p.club.likeState;
        NSLog(@"备用的%i",likestate);
        lbAddress.text=response11007.data_p.club.clubLocation;
        lbName.text=response11007.data_p.club.clubName;
        lbPhone.text=response11007.data_p.club.clubPhone;
        lbDes.text=response11007.data_p.club.clubDescription;
        browserCount.text=[NSString stringWithFormat:@"浏览:%i",response11007.data_p.club.browserCount];
        lbLikeCount.text=[NSString stringWithFormat:@"喜欢:%i",response11007.data_p.club.likeCount];
         [_imageBar sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",response11007.data_p.club.clubCover]] placeholderImage:[UIImage imageNamed:@"default"]];
#pragma mark  这里不封装是因为这样好实现业务逻辑 
        
        for (int i=0; i<response11007.data_p.club.livePhotoArray.count; i++) {
            LivePhoto*livephote=[response11007.data_p.club.livePhotoArray objectAtIndex:i];
            [_imageArray addObject:livephote];
            
        }
        #pragma mark  这样是会越界的  先像这样放到这里
         ClubActivityBrief*clubInvite1=[response11007.data_p.club.clubActivitysArray objectAtIndex:0];
         ClubActivityBrief*clubInvite2=[response11007.data_p.club.clubActivitysArray objectAtIndex:1];
         ClubActivityBrief*clubInvite3=[response11007.data_p.club.clubActivitysArray objectAtIndex:2];
        [_imagepicture1 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",clubInvite1.activityURL]]  placeholderImage:[UIImage imageNamed:@"default"]];
        [_imagepicture2 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",clubInvite2.activityURL]] placeholderImage:[UIImage imageNamed:@"default"]];
          [_imagepicture3 sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@", clubInvite3 .activityURL]] placeholderImage:[UIImage imageNamed:@"default"]];
           NSLog(@"%@",response11007.data_p.club);
        }
    if ([request isEqual:_requestLivePhoto]) {
        Response11008 * response = [Response11008 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response.data_p.livePhotosArray);
    }
    //酒吧点赞
    if ([request isEqual:_requestLike]) {
        Response11009*response=[Response11009 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//用code判断是否点赞成功
    }
    //livePhoto点赞
    if ([request isEqual:_requestPhotoLike]) {
        Response11010*response=[Response11010 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//用code判断是否点赞成功
    }
    [[Tostal sharTostal]hiddenView];
    [_collectionView reloadData];
}


-(void)initxiaozhushou
{
    _helperBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _helperBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];
    [self.view addSubview:_helperBackView];
    xiazhushouView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 54)];
    xiazhushouView.backgroundColor = [UIColor whiteColor];
    xiazhushouView.layer.borderColor = [[UIColor blackColor]CGColor];
    xiazhushouView.layer.borderWidth = 0.4;
    xiazhushouView.layer.cornerRadius = 5.0;
    
    UIButton * assistant = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
    assistant.backgroundColor = [UIColor purpleColor];
    assistant.titleLabel.font = [UIFont systemFontOfSize:12];
    [assistant setTitle:@"iCLub小助手" forState:UIControlStateNormal];
    [assistant setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    assistant.layer.cornerRadius = 5.0;
    
    UILabel * assInfo = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, KScreenWidth - 20 - 10, 20)];
    assInfo.text = @"签到用户才可以参与Live-Photo活动哦~~";
    assInfo.textColor = [UIColor lightGrayColor];
    [xiazhushouView addSubview:assistant];
    [xiazhushouView addSubview:assInfo];
    
    _helperBackView.alpha = 0.0;
    //初始状态为隐藏
    _helperBackView.hidden = YES;
    [_helperBackView addSubview:xiazhushouView];
}


-(IBAction)mapDingTest:(id)sender{

    MpaViewController*controller=[[MpaViewController alloc]init];
    controller.title=lbAddress.text;
   
    controller.barCity=lbAddress.text;
    [self.navigationController pushViewController:controller animated:YES];
    


}
-(IBAction)phoneCall:(id)sender{

    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:@"确定要拨号吗？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    [alertView show];

}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        NSString*phone=@"123123123";
        NSString*phoneNumber=[NSString stringWithFormat:@"tel://%@",phone];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
    }
}
    
#pragma mark collectionview的方法

-(void)takeLivePhoto{
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:@"拍照" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选择照片", nil];
    actionSheet.tag=10;
    [actionSheet showInView:self.view];

 
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    if (buttonIndex==0) {
        UIImagePickerController*imagePicker1=[[UIImagePickerController alloc]init];
        imagePicker1.delegate=self;
        imagePicker1.sourceType=UIImagePickerControllerSourceTypeCamera;
        imagePicker1.allowsEditing=YES;
        [self presentViewController:imagePicker1 animated:YES completion:nil];
    }else if(buttonIndex==1){
        
        ZYQAssetPickerController *picker = [[ZYQAssetPickerController alloc] init];
        picker.maximumNumberOfSelection = 10;
        picker.assetsFilter = [ALAssetsFilter allPhotos];
        picker.showEmptyGroups=NO;
        picker.delegate=self;
        picker.selectionFilter = [NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
            if ([[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyType] isEqual:ALAssetTypeVideo]) {
                NSTimeInterval duration = [[(ALAsset*)evaluatedObject valueForProperty:ALAssetPropertyDuration] doubleValue];
                return duration >= 5;
            } else {
                return YES;
            }
        }];
        
        [self presentViewController:picker animated:YES completion:NULL];
        
    }
    
}
//自定义相册的代理方法
-(void)assetPickerController:(ZYQAssetPickerController *)picker didFinishPickingAssets:(NSArray *)assets{
     NSLog(@"%@",assets);
}
-(void)loadNavController{

    //左键按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"聊天室" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(popToOneBar) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右键照相图标
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"2-5-1.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(takeLivePhoto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;

}
-(void)popToOneBar{

    [self.navigationController popViewControllerAnimated:YES];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _headerView;
    
}
//返回页眉高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return 568*app.autoSizeScaleY;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString*str=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    return cell;

}
- (IBAction)livePhotoImg1:(UIButton *)sender{
    NSLog(@"这里面要不要改 是改几张呢");

}
- (IBAction)livePhotoImg2:(UIButton *)sender{
    NSLog(@"这里面要不要改 是改几张呢");
}
- (IBAction)livePhotoImg3:(UIButton *)sender{

    NSLog(@"这里面要不要改 是改几张呢");
}
#pragma mark- UICollectionView网格视图
- (void)addPhoto{
    
    
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    if (KScreenWidth == 320) {
        flowLayOut.itemSize = CGSizeMake(80, 80);
    }else if(KScreenWidth >= 375){
        
        flowLayOut.itemSize = CGSizeMake(90, 90);
    }
    //水平滚动
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 10;
    flowLayOut.minimumInteritemSpacing = 10;
    //    //设置头视图的大小
    //    flowLayOut.headerReferenceSize = CGSizeZero;
    //    flowLayOut.footerReferenceSize = CGSizeZero;
    
    //2.创建collectionView
    _livePhotoCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 100) collectionViewLayout:flowLayOut];
    _livePhotoCollectionView.backgroundColor = [UIColor clearColor];
    
    //设置代理
    _livePhotoCollectionView.delegate = self;
    _livePhotoCollectionView.dataSource = self;
    //禁止滚动
    //_livePhotoCollectionView.scrollEnabled = NO;
    
    [_livePhotoView addSubview:_livePhotoCollectionView];
    
    //注册单元格
    [_livePhotoCollectionView registerClass:[BarLivePhotoCollectionViewCell class] forCellWithReuseIdentifier:iden];
    _mArray = [[NSMutableArray alloc] init];
    

    for (int i =0; i<8; i++) {
        [_mArray addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",i+1]]];
    }

}
#pragma mark - UICollectionViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _imageArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    BarLivePhotoCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    
    LivePhoto*liveUser=[_imageArray objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",liveUser.thumbnail]] placeholderImage:[UIImage imageNamed:@"default"]];

    
    return cell;
    
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 20,10, 20);
    
    return edge;
    
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==_mArray.count-1) {

    }else{
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"删除图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [actionSheet showInView:self.view];
        actionSheet.tag = 1003;
        _index = indexPath.row;
    }
}
@end
