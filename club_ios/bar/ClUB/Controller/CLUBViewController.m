//
//  CLUBViewController.m
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "CLUBViewController.h"
#import "AppDelegate.h"
#import "CLUBBarCell.h"
#import "OneBarViewController.h"
#import "NearbyTableView.h"
#import "NearbyTableViewCell.h"
#import "LookUpImageViewController.h"
#import "MBProgressHUD.h"
#import "ClubTableViewCell.h"
#import "UMSocial.h"
#import "ClubDesViewController.h"
#import "LookForWeclubViewController.h"
//头部广告视图
#import "HJCarouselViewLayout.h"
#import "FeedbackCollectionViewCell.h"
#import "HWPopTool.h"
#import "MpaViewController.h"
#import "SearchBarVC.h"
//在这里面写一个全局是因为 我钥匙不了那个view
UIView*effectBlurView;
static NSString *iden = @"CLUBViewControllerCell";
extern UserInfo*LoginUserInfo;
extern float fromLongitude;
extern float fromLatitude;
@interface CLUBViewController ()<ASIHTTPRequestDelegate>
{
    UITextField * _searchClub;
    NSMutableArray *_imageArray ;
    //广告界面
    UIScrollView *_scrollView;
    UIPageControl *_pageControl;
    NSInteger _pageCount;
    NSTimer *_timer;
    UILabel * _imageIndexlabel;
    NSInteger _imageIndex;
    //排序界面
    UIView *_choseBackgroundView;
    UIView *_choseView;
    NSMutableArray * _choseViewBtnArray;
    NSInteger _choseViewChoice;
    
    //海报界面
    UIView * _posterView;
    UIImageView *_posterImgView;
    
    //附近
    UIView *_nearbyBackgroundView;
    NearbyTableView *_nearbyTableView;
    UITapGestureRecognizer *_singleTap;
    UITableView *_nearbyNextTableView;
    //刷新默认的club列表
    ASIFormDataRequest *_request;
    //
    ASIFormDataRequest*_requestNext;
    //关注
    ASIFormDataRequest*_requestAttention;
    //取消关注
    ASIFormDataRequest*_requestAttentionCancel;
    //获取广告位的图片
    ASIFormDataRequest*_reuqestClubBanner;
    
    //
    NSMutableArray*_mutaArray;
    
    IBOutlet UITableView*_tableView;
    
    Response11001 * response11001;
    
    int orderSymbol;
    
    BriefClub*barClubIdRequest;
    //取一个..
    int clubAtten;
    //用个间接的东西去判断他到底是以什么排序在
    int orderNum;
//    NSMutableArray*nextArray;
    NSString*clubIdString;
    //创建一个搜索栏
  IBOutlet   UIView*header3View;
    
    //创建表头广告视图
    UICollectionView *_collectionView;
    NSMutableArray *_mArray;
    NSInteger _index;
    
    
    
 
   UILabel*_lbBoy;
   UILabel*_girl;
   UIButton*_buttonHidden;
    UILabel*_lbAddress;
    UILabel*_lbPhoneNumber;
   UILabel*_lbClubName;
   UIView*_contentView;
    
    
    //模糊的东西
    UIVisualEffectView*effectVIEW;
    UIImageView*_imageViewClub;
    
    UILabel*lbDistance;
    UIButton*buttonChat;
    UIButton*buttonPhone;
    
    UITapGestureRecognizer *tableViewGesture;
    UIButton*buttonAddress;
    
}

@end

@implementation CLUBViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    effectBlurView=self.view;
    [AppDelegate matchAllScreenWithView:self.view];
     _tableView.showsVerticalScrollIndicator=NO;
    [_tableView addFooterWithTarget:self action:@selector(refreshFootLoadMoreData)];
    [_tableView addHeaderWithTarget:self action:@selector(requestUrl)];
    [_tableView headerBeginRefreshing];
    _tableView.footerPullToRefreshText = @"上拉可以加载更多数据了";
    _tableView.footerReleaseToRefreshText = @"松开马上加载更多数据了";
    _tableView.footerRefreshingText =@"正在帮您加载中";
    _tableView.headerPullToRefreshText=@"下拉可以加载更多数据";
    _tableView.headerReleaseToRefreshText=@"松开马上加载更多数据了";
    _tableView.headerRefreshingText=@"宝宝正在加载中";
   
    _imageIndex = 0;
    _choseViewChoice = 0;
    _choseViewBtnArray = [[NSMutableArray alloc] init];
    
    //键盘消失
  
    //设置导航栏
    [self _initNavBar];
    
    //添加切换头视图按钮及手势
    [self addSelectButton];
    //排序界面
    [self initChoseView];
    //添加附近界面视图
    [self addNearbyView];
    //添加附近二级界面
    [self addNearbyNextView];
    //海报界面
    [self initPosterShow];
    _mutaArray=[NSMutableArray array];
    _imageArray=[NSMutableArray array];
    [self refreshClubBanner];
    
    [self addHeadCollectionView];
    [self loadFindOutView];
    
    tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(effectTapClick)];
 



}
#pragma mark 这个是分页要用的方法。
-(void)refreshFootLoadMoreData{
   //这个是问题 如果我按照哪些排序 是不是 他就默认给我排序的下面的数据
    Request11001*request=[[Request11001 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getClubs",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11001;//现在标注为假数据
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request.common.version=@"1.0.0";
    request.params.order= orderNum;
    request.params.latitude=fromLatitude;
    request.params.longitude=fromLongitude;
    BriefClub*clubOO=[_mutaArray lastObject];
    request.params.lastClubId=clubOO.clubid;
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
}

-(void)requestSearchClubBar:(NSString*)fromClubName{
    _mutaArray=nil;
    _mutaArray=[NSMutableArray array];
    Request11020*request=[[Request11020 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/searchClub",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11001;//现在标注为假数据
    request.common.version=@"1.0.0";
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.params.clubName=fromClubName;
    NSLog(@"%.0f",LoginUserInfo.latitude);
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

#pragma mark 获取酒吧列表 //离我最近
-(void)requestUrl{
    _mutaArray=nil;
    _mutaArray=[NSMutableArray array];
    Request11001*request=[[Request11001 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getClubs",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11001;//现在标注为假数据
    request.common.version=@"1.0.0";
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.params.order=orderNum;
    request.params.latitude=fromLatitude;
    NSLog(@"%.0f",LoginUserInfo.latitude);
    request.params.longitude=fromLongitude;
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
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]){
        response11001 = [Response11001 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response11001.data_p.clubsArray);
        for (int i=0; i<response11001.data_p.clubsArray.count; i++) {
            BriefClub*bar=[response11001.data_p.clubsArray objectAtIndex:i];
            [_mutaArray addObject:bar];
        }
        NSLog(@"%@",response11001.data_p.clubsArray);
        [_tableView footerEndRefreshing];
        [_tableView headerEndRefreshing];
    }
    if ([request isEqual:_requestAttention]) {
        Response11017*resonse11017=[Response11017 parseFromData:request.responseData error:nil];
        if (resonse11017.common.code==0) {
            [[Tostal sharTostal]tostalMesg:@"关注成功" tostalTime:1];
        }else{
            [[Tostal sharTostal]tostalMesg:@"操作失败" tostalTime:1];
        }
    }
    if ([request isEqual:_requestAttentionCancel]) {
        Response11017*resonse11017=[Response11017 parseFromData:request.responseData error:nil];
        if (resonse11017.common.code==0) {
             [[Tostal sharTostal]tostalMesg:@"取消关注成功" tostalTime:1];
        }else{
        
            [[Tostal sharTostal]tostalMesg:@"操作失败" tostalTime:1];
        }
        
    }
    if ([request isEqual:_reuqestClubBanner]) {
        Response11019*responser11019=[Response11019 parseFromData:request.responseData error:nil];
        if (responser11019.common.code==0) {
            for (int i=0; i<responser11019.data_p.bannersArray.count; i++) {
                NSString*bannerImage=[responser11019.data_p.bannersArray objectAtIndex:i];
                [_imageArray addObject:bannerImage];
            }
            NSLog(@"%@",_imageArray);
            //设置头视图
            //这里面现在先写一个死数据，后期会变活，就是banner这个接口，banner的接口 后台还没有写入
//            [self _initHeaderView];
        }
    }
    [_tableView reloadData];
    [[Tostal sharTostal]hiddenView];  
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}


#pragma mark  这里的接口还有问题
-(void)refreshClubBanner{
    //这个是问题 如果我按照哪些排序 是不是 他就默认给我排序的下面的数据
    //banner这里的数
    Request11019*request11019=[[Request11019 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getBanner",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestClubBanner = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request11019.common.userid=LoginUserInfo.user_id;
    request11019.common.userkey=LoginUserInfo.user_key;
    request11019.common.cmdid=11001;//现在标注为假数据
    request11019.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request11019.common.version=@"1.0.0";
    NSData*data= [request11019 data];
    [_reuqestClubBanner setPostBody:(NSMutableData*)data];
    [_reuqestClubBanner setDelegate:self];
    //请求延迟时间
    _reuqestClubBanner.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestClubBanner.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestClubBanner.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestClubBanner.secondsToCache=3600;
    [_reuqestClubBanner startAsynchronous];
}

//设置广告界面
- (void) _initHeaderView{
//        _imageArray = @[@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg"];
    
//    _imageArray=[NSMutableArray arrayWithObjects:@"1.jpg",@"2.jpg",@"3.jpg",@"4.jpg",@"5.jpg",@"6.jpg", nil];
    UIView *superView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 175)];
    _scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 175)];
    _scrollView.contentSize = CGSizeMake(KScreenWidth * _imageArray.count, 175);
    _scrollView.bounces = NO;
    _scrollView.pagingEnabled = YES;
    _scrollView.delegate = self;
    //循环创建6个UIImageView添加到_scrollView上
    for (int i = 0; i < _imageArray.count; i ++) {
        //这里是取出club主界面的广告图 banner
        Banner*bannerImage=[_imageArray objectAtIndex:i];
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth * i, 0, KScreenWidth, 175)];
//      imageView.image = [UIImage imageNamed:_imageArray[i]];
        [imageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bannerImage.bitmapURL]] placeholderImage:[UIImage imageNamed:@"default"]];

        imageView.tag = 200+i;
        [_scrollView addSubview:imageView];
    }
    //创建一个分页控制器
    _pageControl = [[UIPageControl alloc]initWithFrame:CGRectMake(0, 145, KScreenWidth, 30)];
    _pageControl.numberOfPages = _imageArray.count;
    _pageControl.currentPage = 0;
    [_pageControl addTarget:self action:@selector(selectPage:) forControlEvents:UIControlEventValueChanged];
    [superView addSubview:_scrollView];
    [superView addSubview:_pageControl];
    //设置表视图的头视图
    _CLUBTabelView.tableHeaderView = superView;
    //设置表视图分组section尾部行高
    _CLUBTabelView.sectionFooterHeight = 0;
}

//定时器方法
- (void)timeAction:(NSTimer *)timer{
    
    _pageCount++;
    if (_pageCount > 5) {
        _pageCount = 0;
    }
    _pageControl.currentPage = _pageCount;
    [self selectPage:_pageControl];
}
//滑动视图结束减速时调用,改变分页控制器的页数
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (_scrollView == scrollView) {
        _pageControl.currentPage  = _scrollView.contentOffset.x/KScreenWidth;
    }
}




#pragma mark - 添加切换头视图按钮
- (void)addSelectButton{
    //切换图片按钮
    //轻扫手势
    UISwipeGestureRecognizer * left  = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imageIndexP)];
    left.direction = UISwipeGestureRecognizerDirectionLeft;
    UISwipeGestureRecognizer * right = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(imageIndexD)];
    right.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:left];
    [self.view addGestureRecognizer:right];
    
}
- (void)selectPage:(UIPageControl *)pageC{
    
    NSInteger page = pageC.currentPage;
    
    [_scrollView scrollRectToVisible:CGRectMake(KScreenWidth * page, 0, KScreenWidth, 200) animated:YES];
}
//下一张
-(void)imageIndexP{
    [self changeImageview:1];
}
//上一张
-(void)imageIndexD{
    [self changeImageview:-1];
}
//选择图片
-(void)changeImageview:(NSInteger)num{
    _imageIndex += num;
    NSInteger lastItem = _imageArray.count-1;
    if(_imageIndex < 0)
        _imageIndex = lastItem;
    if(_imageIndex > lastItem)
        _imageIndex = 0;
}

#pragma mark  tableView协议方法

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == _nearbyTableView) {
        return 1;
    }else if (tableView == _nearbyNextTableView) {
        return 1;
    }

    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == _nearbyTableView) {
        return 6;
    }else if (tableView == _nearbyNextTableView) {
        return 6;
    }

    return _mutaArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (tableView == _nearbyTableView) {
        return 30 * app.autoSizeScaleY;
    }else if(tableView == _nearbyNextTableView){
        return 30 * app.autoSizeScaleY;
    }
         return 132 * app.autoSizeScaleY;
    
}
- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    
    return header3View;
    
}
//不设置头视图高度,不显示第0组头视图
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return 30* app.autoSizeScaleY;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == _nearbyTableView ) {
        static NSString *iden = @"nearbyCell";
        //使用闲置池
        NearbyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];

        if (cell == nil) {
            //用MovieCell类创建单元格
            cell = [[NearbyTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
            //设置单元格的辅助图标
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            //取消分割线
            //tableView.separatorStyle = NO;
            //cell.contentView.backgroundColor = [UIColor greenColor];
            
        }
        return cell;
    }else if(tableView == _nearbyNextTableView){
        static NSString *iden = @"nearbyNextCell";
        //使用闲置池
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell == nil) {
            //用MovieCell类创建单元格
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
            //取消分割线
            //tableView.separatorStyle = NO;
            
        }
        return cell;
    }
    else{
        static   NSString *str=@"cell";
        //使用闲置池
        ClubTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];

        if (cell == nil) {
            NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"ClubTableViewCell" owner:self options:nil];
            cell=[arry objectAtIndex:0];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        BriefClub*bar;
        if (_mutaArray.count!=0) {
            bar=[_mutaArray objectAtIndex:indexPath.row];
        }
        NSLog(@"%i",bar.followState);
        cell.lbClub.text=bar.clubname;
        cell.lbAddress.text=bar.clubLocation;
        cell.lbDistance.text=[NSString stringWithFormat:@"%.2fkm",[MyFile meterKiloHaveHowLong:fromLongitude wei:fromLatitude arrJing:bar.clubLongitude arrWei:bar.clubLatitude]];
        NSLog(@"%2f",bar.clubLongitude);
        NSLog(@"%f",bar.clubLatitude);
        NSLog(@"%f",fromLongitude);
        NSLog(@"%f",fromLatitude);
        cell.lbBoy.text=[NSString stringWithFormat:@"%i",bar.maleCount];
        cell.girl.text=[NSString stringWithFormat:@"%i",bar.famaleCount];
        if (bar.followState==0) {
               [cell.attentionButAction setImage:[UIImage imageNamed:@"酒吧-未关注.png"] forState:UIControlStateNormal];
                 [cell.attentionButAction setTitle:@"关注" forState:UIControlStateNormal];
        }else{
                [cell.attentionButAction setImage:[UIImage imageNamed:@"酒吧-关注.png"] forState:UIControlStateNormal];
                 [cell.attentionButAction setTitle:@"已关注" forState:UIControlStateNormal];
     }
  
        [cell.imageBarIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bar.clubAvatar]] placeholderImage:[UIImage imageNamed:@"feedback_bg.png"]];
        [cell.attentionButAction addTarget:self action:@selector(attentionButAction:) forControlEvents:UIControlEventTouchUpInside];
        cell.attentionButAction.tag=indexPath.row;
        cell.lbPhoneNumber.text=bar.phone;
        [cell.buttonDesCribe addTarget:self action:@selector(desCribeClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonDesCribe.tag=indexPath.row;
       
        return cell;
    }
}
-(void)loadFindOutView{
    _contentView=[[UIView alloc]initWithFrame:CGRectMake(25, 88, 323, 438)];
    [_contentView setBackgroundColor:[UIColor whiteColor]];
    _contentView.layer.cornerRadius=10;
    _contentView.layer.masksToBounds=YES;
    _imageViewClub=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 323, 193)];
    [_imageViewClub  setImage:[UIImage imageNamed:@"酒吧图1.png"]];
    _buttonHidden=[[UIButton alloc]initWithFrame:CGRectMake(269, 4, 46, 44)];
    [_buttonHidden addTarget:self action:@selector(deccribeHiddenClick) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*_imageHidden=[[UIImageView alloc]initWithFrame:CGRectMake(286, 16, 20, 20)];
    [_imageHidden setImage:[UIImage imageNamed:@"icon_delete_white.png"]];
    _lbClubName=[[UILabel alloc]initWithFrame:CGRectMake(12, 205, 270, 21)];
    [_lbClubName setFont:[UIFont systemFontOfSize:15]];
    _lbClubName.textColor=[UIColor colorWithRed:96/255.0  green:96/255.0  blue:96 /255.0 alpha:1];
    UILabel*_lbHuoYue=[[UILabel alloc]initWithFrame:CGRectMake(12, 234, 66, 21)];
    _lbHuoYue.textColor=[UIColor colorWithRed:195/255.0  green:195/255.0  blue:195/255.0  alpha:1];
    _lbHuoYue.text=@"当前活跃";
    [_lbHuoYue setFont:[UIFont systemFontOfSize:14]];
    UIImageView*_imageBoy=[[UIImageView alloc]initWithFrame:CGRectMake(93, 238.5, 11.5, 11.5)];
    [_imageBoy setImage:[UIImage imageNamed:@"icon_man.png"]];
    UIImageView*_imageGirl=[[UIImageView alloc]initWithFrame:CGRectMake(157, 239, 10, 12)];
    [_imageGirl setImage:[UIImage imageNamed:@"icon_girl.png"]];
    _lbBoy=[[UILabel alloc]initWithFrame:CGRectMake(112, 236, 37, 17)];
    _lbBoy.textColor=[UIColor colorWithRed:170/255.0  green:170/255.0  blue:170 /255.0 alpha:1];
    [_lbBoy setFont:[UIFont systemFontOfSize:14]];
    _lbBoy.text=@"5366";
    _girl=[[UILabel alloc]initWithFrame:CGRectMake(172, 235, 60, 18)];
    _girl.textColor=[UIColor colorWithRed:170/255.0 green:170/255.0  blue:170/255.0  alpha:1];
    [_girl setFont:[UIFont systemFontOfSize:14]];
    _girl.text=@"321312";
    UIImageView*_imagePhone=[[UIImageView alloc]initWithFrame:CGRectMake(13, 268, 15, 15)];
    [_imagePhone setImage:[UIImage imageNamed:@"icon_phone12.png"]];
    _lbPhoneNumber=[[UILabel alloc]initWithFrame:CGRectMake(40, 265, 206, 21)];
    _lbPhoneNumber.textColor=[UIColor colorWithRed:92/255.0 green:160/255.0 blue:229/255.0 alpha:1];
    _lbPhoneNumber.text=@"010-118998 9822";
    [_lbPhoneNumber setFont:[UIFont systemFontOfSize:14]];
    buttonPhone=[[UIButton alloc]initWithFrame:CGRectMake(40, 265, 210, 40)];
    [buttonPhone addTarget:self action:@selector(phoneClick:) forControlEvents:UIControlEventTouchUpInside];
    UIImageView*_imageAddress=[[UIImageView alloc]initWithFrame:CGRectMake(13, 304, 15, 15)];
    [_imageAddress setImage:[UIImage imageNamed:@"icon_add.png"]];
    _lbAddress=[[UILabel alloc]initWithFrame:CGRectMake(40, 294, 242, 36)];
    [_lbAddress setFont:[UIFont systemFontOfSize:14]];
    _lbAddress.textColor=[UIColor colorWithRed:92/255.0 green:160/255.0 blue:229/255.0 alpha:1];
    _lbAddress.text=@"北京市三里屯soho12号公寓2503";
    [_lbAddress setNumberOfLines:0];
   buttonAddress=[[UIButton alloc]initWithFrame:CGRectMake(40, 294, 242, 40)];
    [buttonAddress addTarget: self action:@selector(addressClick:) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIImageView*_imageViewBiao=[[UIImageView alloc]initWithFrame:CGRectMake(13, 342, 15, 15)];
    [_imageViewBiao setImage:[UIImage imageNamed:@"icon_Label.png"]];
    //两个标签放到这里先不写可能要动态  不过可以规定标签有多少个
     buttonChat=[[UIButton alloc]initWithFrame:CGRectMake(208, 389, 107, 30)];
    [buttonChat addTarget:self action:@selector(chatClick:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel*lbGoIn=[[UILabel alloc]initWithFrame:CGRectMake( 245, 394, 70, 20)];
    lbGoIn.textColor=[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    lbGoIn.font=[UIFont systemFontOfSize:14];
    lbGoIn.text=@"进入聊天室";
    UIImageView*_imageCHat=[[UIImageView alloc]initWithFrame:CGRectMake(217, 384, 29, 30)];
    [_imageCHat setImage:[UIImage imageNamed:@"icon_chat.png"]];
    
    [_contentView addSubview:buttonPhone];
    [_contentView addSubview:_lbAddress];
    [_contentView addSubview:_imageCHat];
    [_contentView addSubview:lbGoIn];
    [_contentView addSubview:buttonChat];
    [_contentView addSubview:_imageAddress];
    [_contentView addSubview:_lbPhoneNumber];
    [_contentView addSubview:_imageViewClub];
    [_contentView addSubview:_imageHidden];
    [_contentView addSubview:_lbClubName];
    [_contentView addSubview:_buttonHidden];
    [_contentView addSubview:_lbHuoYue];
    [_contentView addSubview:_imageBoy];
    [_contentView addSubview:_imageGirl];
    [_contentView addSubview:_lbBoy];
    [_contentView addSubview:_girl];
    [_contentView addSubview:_imagePhone];
    [_contentView addSubview:buttonAddress];

}

//点击地址跳转到地图
-(void)addressClick:(UIButton*)sender{
    for (UIView *view in self.view.window.subviews
         ) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            [view removeFromSuperview];
        }
    }

    [[HWPopTool sharedInstance] closeWithBlcok:^{
     
    }];
    BriefClub*bar;
    if (_mutaArray.count!=0) {
        bar=[_mutaArray objectAtIndex:sender.tag];
    }
    MpaViewController*controller=[[MpaViewController alloc]init];
    controller.barAddress=bar.clubLocation;
    controller.barCity=bar.clubLocation;
    [self.navigationController pushViewController:controller animated:YES];
}
//点击电话跳转到打电话
-(void)phoneClick:(UIButton*)sender{
    BriefClub*bar;
    if (_mutaArray.count!=0) {
        bar=[_mutaArray objectAtIndex:sender.tag];
    }
    UIAlertView *alertView=[[UIAlertView alloc] initWithTitle:nil message:[NSString stringWithFormat:@"确定要向%@拨号",bar.phone] delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"好的", nil];
    alertView.tag=sender.tag;
    [alertView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    BriefClub*barAlter=[_mutaArray objectAtIndex:alertView.tag];
    if (buttonIndex==1) {
        //判断字符串中是否有／
        if ([barAlter.phone rangeOfString:@"/"].location!=NSNotFound ) {
            NSArray*phoenArray=[barAlter.phone componentsSeparatedByString:@"/"];
            NSString*phoneNum=[phoenArray objectAtIndex:0];
            NSString*phoneNumber2=[NSString stringWithFormat:@"tel://%@",phoneNum];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber2]];
        }else{
            NSString*phone=barAlter.phone;
            NSString*phoneNumber=[NSString stringWithFormat:@"tel://%@",phone];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:phoneNumber]];
        }
      
    }
}
//点击聊天室按钮
-(void)chatClick:(UIButton*)sender{
    for (UIView *view in self.view.window.subviews
         ) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            [view removeFromSuperview];
        }
    }

    BriefClub*bar;
    if (_mutaArray.count!=0) {
        bar=[_mutaArray objectAtIndex:sender.tag];
    }
    // 启动聊天室，与启动单聊等类似
    UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
    OneBarViewController * temp = [club instantiateViewControllerWithIdentifier:@"OneBarViewControllerID"];
    temp.fromDistance=[MyFile meterKiloHaveHowLong:fromLongitude wei:fromLatitude arrJing:bar.clubLongitude arrWei:bar.clubLatitude];
    temp.targetId = bar.clubid;
    NSLog(@"%@",bar.clubid);
    temp.conversationType = ConversationType_CHATROOM;// 传入聊天室类型
    temp.title = bar.clubname;
    //temp.hidesBottomBarWhenPushed = YES;
    temp.fromClubId=bar.clubid;
    [self.navigationController pushViewController:temp animated:YES];
    [[HWPopTool sharedInstance] closeWithBlcok:^{
      
    }];

   

}
//详情点击事件
-(void)desCribeClick:(UIButton*)sender{
    BriefClub*bar= [_mutaArray objectAtIndex:sender.tag];
    buttonChat.tag=sender.tag;
    buttonPhone.tag=sender.tag;
    buttonAddress.tag=sender.tag;
    _lbAddress.text=bar.clubLocation;
    _lbClubName.text=bar.clubname;
    _lbPhoneNumber.text=bar.phone;
    _lbBoy.text=[NSString stringWithFormat:@"%i",bar.maleCount];
    _girl.text=[NSString stringWithFormat:@"%i",bar.famaleCount];
    [_imageViewClub sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",bar.clubAvatar]] placeholderImage:[UIImage imageNamed:@""]];
    UIBlurEffect*blur=[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    effectVIEW=[[UIVisualEffectView alloc]initWithEffect:blur];
    effectVIEW.tag=19940812;
    effectVIEW.alpha=1.0f;
    effectVIEW.frame=self.view.window.bounds;
    [self.view.window addSubview:effectVIEW];
    [HWPopTool sharedInstance].shadeBackgroundType = ShadeBackgroundTypeSolid;
    [HWPopTool sharedInstance].closeButtonType = ButtonPositionTypeRight;
    [[HWPopTool sharedInstance] showWithPresentView:_contentView animated:YES];
}
-(void)effctButtonCLICK{
    for (UIView *view in self.view.window.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            [view removeFromSuperview];
        }
    }

}
-(void)deccribeHiddenClick{
    for (UIView *view in self.view.window.subviews) {
        if ([view isKindOfClass:[UIVisualEffectView class]]) {
            [view removeFromSuperview];
        }
    }
    [[HWPopTool sharedInstance] closeWithBlcok:^{
     
    }];
}
#pragma mark  关注－－
-(void)requestAttention{
    Request11017*request=[[Request11017 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/followClub",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestAttention = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11017;//现在标注为假数据
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.common.version=@"1.0.0";
    request.params.flag=1;//关注
    request.params.clubid=barClubIdRequest.clubid;
    NSData*data= [request data];
    [_requestAttention setPostBody:(NSMutableData*)data];
    [_requestAttention setDelegate:self];
    //请求延迟时间
    _requestAttention.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestAttention.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestAttention.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestAttention.secondsToCache=3600;
    [_requestAttention startAsynchronous];

}
#pragma mark 取消关注
-(void)requestAttentionCancel{
    Request11017*request=[[Request11017 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/followClub",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestAttentionCancel = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11017;//现在标注为假数据
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.common.version=@"1.0.0";
    request.params.flag=2;//取消关注
    request.params.clubid=barClubIdRequest.clubid;
    NSLog(@"%@",barClubIdRequest.clubid);
    
    NSData*data= [request data];
    [_requestAttentionCancel setPostBody:(NSMutableData*)data];
    [_requestAttentionCancel setDelegate:self];
    //请求延迟时间
    _requestAttentionCancel.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestAttentionCancel.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestAttentionCancel.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestAttentionCancel.secondsToCache=3600;
    [_requestAttentionCancel startAsynchronous];
    
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    BriefClub*bar;
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (_mutaArray.count!=0) {
       bar=[_mutaArray objectAtIndex:indexPath.row];
    }
    
    if (tableView == _nearbyTableView) {
        _nearbyNextTableView.hidden = NO;
        
    }else if(tableView == _nearbyNextTableView){
        //此出调用搜索接口
        [self nearbyBackgroundViewtapAction];
    }else{
        
        // 启动聊天室，与启动单聊等类似
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        OneBarViewController * temp = [club instantiateViewControllerWithIdentifier:@"OneBarViewControllerID"];
        temp.fromDistance=[MyFile meterKiloHaveHowLong:fromLongitude wei:fromLatitude arrJing:bar.clubLongitude arrWei:bar.clubLatitude];
        temp.targetId = bar.clubid;
        NSLog(@"%@",bar.clubid);
        temp.conversationType = ConversationType_CHATROOM;// 传入聊天室类型
        temp.userName = bar.clubname;
        temp.title = bar.clubname;
        //temp.hidesBottomBarWhenPushed = YES;
        temp.fromClubId=bar.clubid;
        [self.navigationController pushViewController:temp animated:YES];
  
        
    }
}
//关注按钮点击事件
- (void)attentionButAction:(UIButton *)button{
   barClubIdRequest=[_mutaArray objectAtIndex:button.tag];
    NSLog(@"%i",barClubIdRequest.followState);

    if (barClubIdRequest.followState==0) {
       [self requestAttention];
        barClubIdRequest.followState=1;
    }else{
         [self requestAttentionCancel];
         barClubIdRequest.followState=0;
    }
    [_tableView reloadData];
   
}

//点击分享
- (void)shareButtonAction{
    [self sheraToAnyPeson];
}

#pragma mark - 调用此方法进行分享
- (void)sheraToAnyPeson{
    //设置微信和qq(分享代码前设置)
    [self settingWechatAndQQ];
    //使用默认UI
    [UMSocialSnsService presentSnsIconSheetView:self
                                         appKey:@"56443b13e0f55a9d3200117e"
                                      shareText:nil
                                     shareImage:nil
                                shareToSnsNames:[NSArray arrayWithObjects:UMShareToWechatTimeline,UMShareToWechatSession,UMShareToQQ,UMShareToQzone,UMShareToTencent,UMShareToSina,nil]
                                       delegate:self];
}
//自定义分享的UI界面,对应的分享平台分别调用一下方法//暂未调用
- (void)addAnyUI{
    //使用UMShareToWechatSession,UMShareToWechatTimeline,UMShareToWechatFavorite分别代表微信好友、微信朋友圈、微信收藏
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToWechatSession] content:@"微信分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    //qq好友
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQQ] content:@"QQ分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    //qq空间,Qzone分享文字与图片缺一不可，否则会出现错误码10001
    [[UMSocialDataService defaultDataService]  postSNSWithTypes:@[UMShareToQzone] content:@"Qzone分享文字" image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response){
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功！");
        }
    }];
    
}
#pragma mark - 微信和qq分享配置
- (void) settingWechatAndQQ{
    //注意设置的链接必须为http链接
    //当分享消息类型为图文时，点击分享内容会跳转以下链接
    [UMSocialData defaultData].extConfig.wechatSessionData.url = @"http://baidu.com";
    //如果是朋友圈，则替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.url = @"http://baidu.com";
    //qq好友
    [UMSocialData defaultData].extConfig.qqData.url = @"http://baidu.com";
    //qqQzone
    [UMSocialData defaultData].extConfig.qzoneData.url = @"http://baidu.com";
    
    //微信朋友圈分享消息只显示title
    //设置微信好友title方法为
    [UMSocialData defaultData].extConfig.wechatSessionData.title = @"微信好友title";
    //设置微信朋友圈title方法替换平台参数名即可
    [UMSocialData defaultData].extConfig.wechatTimelineData.title = @"微信朋友圈title";
    //qq title
    [UMSocialData defaultData].extConfig.qqData.title = @"QQ分享title";
    //Qzone title
    [UMSocialData defaultData].extConfig.qzoneData.title = @"Qzone分享title";
    
    //微信分享消息类型分为图文、纯图片、纯文字、应用四种类型，默认分享类型为图文分享，即展示分享文字及图片缩略图，点击后跳转到预设链接
    //纯图片分享类型没有文字，点击图片可以查看大图
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeImage;
    //纯文字分享类型没有图片，点击不会跳转
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeText;
    //应用分享类型点击分享内容后跳转到应用下载页面，下载地址自动抓取开发者在微信开放平台填写的应用地址，如果用户已经安装应用，则打开APP
    [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeApp;
    
    //QQ分享消息类型分为图文、纯图片，QQ空间分享只支持图文分享（图片文字缺一不可）
    //QQ分享消息默认为图文类型，设置纯图片类型方法为
    [UMSocialData defaultData].extConfig.qqData.qqMessageType = UMSocialQQMessageTypeImage;
    //在调用分享代码前调用即可
    
}
//实现回调方法（可选）：
-(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response
{
    //根据`responseCode`得到发送结果,如果分享成功
    if(response.responseCode == UMSResponseCodeSuccess)
    {
        //得到分享到的微博平台名
        NSLog(@"share to sns name is %@",[[response.data allKeys] objectAtIndex:0]);
    }
}


#pragma mark- 设置导航栏
-(void)_initNavBar{
//    [self.navigationController.navigationBar setBarTintColor:[UIColor blackColor]];
//
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"] forBarMetrics: UIBarMetricsDefault];
    //左侧按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 18, 20)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"icon_choose.png"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.titleLabel.font=[UIFont systemFontOfSize:16];
    //附近点击事件
    [leftButton addTarget:self action:@selector(nearbyAction:) forControlEvents:UIControlEventTouchUpInside];
//    UIView*leftView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 80, 25)];
//    UIImageView*nearImage=[[UIImageView alloc]initWithFrame:CGRectMake(48, -1, 16, 23)];
//    [nearImage setImage:[UIImage imageNamed:@"near_1.png"]];
//    [leftView addSubview:nearImage];
//    [leftView addSubview:leftButton];
    UIBarButtonItem * leftitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftitem;
    
    //右侧按钮
    UIButton* rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [rightButton setImage:[UIImage imageNamed:@"icon_search.png"] forState:UIControlStateNormal];
      rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
//    UIImageView*imageTitle=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 1, 14)];
    UIImageView*imageTitle=[[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/3.5,14, 70, 18)];
//    imageTitle.a
    [imageTitle setImage:[UIImage imageNamed:@"logo_1.png"]];
    UIView*titleView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];
    [titleView addSubview:imageTitle];
    self.navigationItem.titleView = titleView;
    UIBarButtonItem * rightitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
   
    self.navigationItem.rightBarButtonItem = rightitem;
    [rightButton addTarget:self action:@selector(sequenceAction:) forControlEvents:UIControlEventTouchUpInside];
    
}
//tf监听键盘
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    NSString*searchStr=[textField text];
    [self requestSearchClubBar:searchStr];
    //网络请求
   
    [_CLUBTabelView reloadData];
    [_searchClub resignFirstResponder];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([textField.text isEqualToString:@""]) {
        [self requestUrl];
    }
    return YES;
}
-(void)SerchBtnPress{
    
  //给上面的方法里面的东西大致一样
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [_searchClub resignFirstResponder];
}
#pragma mark - 排序界面
-(void)initChoseView{
    _choseBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -44, KScreenWidth, KScreenHeight)];
    _choseBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];
    
    [self.view addSubview:_choseBackgroundView];
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(choseBackgroundViewtapAction)];
    
    [_choseBackgroundView addGestureRecognizer:singleTap];

    _choseView = [[UIView alloc]initWithFrame:CGRectMake(0, 44, KScreenWidth, 90)];
    _choseView.backgroundColor = [UIColor whiteColor];
    _choseView.layer.cornerRadius = 5.0;
    //[_choseBackgroundView addSubview:_choseView];
    
    NSArray * titleArray = [NSArray arrayWithObjects:@"离我最近",@"人气最高",@"消费最高", nil];
    for(int i = 0; i < 3; i ++)
    {
        NSString * title = titleArray[i];
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15,30*i, KScreenWidth, 30)];
        titleLabel.text = title;
        titleLabel.font = [UIFont systemFontOfSize:12];
        [_choseView addSubview: titleLabel];
        UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 30*i, KScreenWidth, 30)];
        [btn addTarget:self action:@selector(choseViewBtnPress:) forControlEvents:UIControlEventTouchUpInside];
        [_choseView addSubview:btn];
        [btn setBackgroundImage:[UIImage imageNamed:@"灰色背景.png"] forState:UIControlStateHighlighted];
        btn.tag = i;
        btn.selected = NO;
        if(_choseViewChoice == i)
        {
            btn.selected = YES;
        }
        [_choseViewBtnArray addObject:btn];
    }
    [_choseBackgroundView addSubview:_choseView];
     _choseBackgroundView.hidden = YES;
}
#pragma mark 点击排序事件
-(void)choseViewBtnPress:(UIButton *)btn{
    NSInteger index = btn.tag;
    for(int i = 0; i < _choseViewBtnArray.count; i ++)
    {
        UIButton * b = _choseViewBtnArray[i];
        if(index == i)
            b.selected = YES;
        else
            b.selected = NO;
    }
    if (btn.tag==0) {
        orderNum=1;
        [_tableView headerBeginRefreshing];
//        [self requestUrl];
        [[Tostal sharTostal]showLoadingView:@"正在加载数据"];
        [_tableView reloadData];
    }else if (btn.tag==1){
        orderNum=2;
       [_tableView headerBeginRefreshing];
        [_tableView setContentOffset:CGPointMake(0,0) animated:NO];
        [[Tostal sharTostal]showLoadingView:@"正在加载数据"];
        [_tableView reloadData];
        NSLog(@"人气最高");
    }else if (btn.tag==2){
         orderNum=3;
        [_tableView headerBeginRefreshing];
         [_tableView setContentOffset:CGPointMake(0,0) animated:NO];
         [[Tostal sharTostal]showLoadingView:@"正在加载数据"];
         [_tableView reloadData];
         NSLog(@"消费最高");
    }
    _choseBackgroundView.hidden = YES;
    
}
#pragma mark 跳转动画
//这里是点击页面跳转到搜索页面的动画
-(void)sequenceAction:(UIButton *)button{
    // 启动聊天室，与启动单聊等类似
    UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
    SearchBarVC * searchBarVC = [club instantiateViewControllerWithIdentifier:@"SearchBarVCID"];
    //初始化一个转场动画
    CATransition *transition = [[CATransition alloc] init];
    //设置转场动画风格
    //transition.type = @"cube";
    transition.duration = 0.3;
    //设置动画的方向
    transition.subtype = kCATransitionFromTop;
    //把动画添加到导航控制器视图的图层上
    [self.navigationController.view.layer addAnimation:transition forKey:nil];
    [self.navigationController pushViewController:searchBarVC animated:NO];
}
//排序背景点击手势
- (void)choseBackgroundViewtapAction{
    _choseBackgroundView.hidden = YES;
}
#pragma mark - 创建查看附近视图
- (void)addNearbyView{
    _nearbyBackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0,-44, KScreenWidth, KScreenHeight)];
    _nearbyBackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];
    [self.view addSubview:_nearbyBackgroundView];
    _nearbyTableView = [[NearbyTableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth/2.0, 180*KScreenHeight/568.0)];
    _nearbyTableView.backgroundColor = [UIColor redColor];
    //设置代理
    _nearbyTableView.delegate = self;
    _nearbyTableView.dataSource = self;
    //单击
    _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(nearbyBackgroundViewtapAction)];
    [_nearbyBackgroundView addGestureRecognizer:_singleTap];
    [self.view addSubview:_nearbyTableView];
    _nearbyBackgroundView.hidden = YES;
    _nearbyTableView.hidden = YES;
}
#pragma mark- 添加附近二级视图
- (void)addNearbyNextView{
    _nearbyNextTableView = [[UITableView alloc] initWithFrame:CGRectMake(KScreenWidth/2.0, 0, KScreenWidth/2.0, 180*KScreenHeight/568.0)];
    _nearbyNextTableView.delegate = self;
    _nearbyNextTableView.dataSource = self;
    [self.view addSubview:_nearbyNextTableView];
    _nearbyNextTableView.hidden = YES;

}

//查看附近单击手势
- (void)nearbyBackgroundViewtapAction{
    _nearbyBackgroundView.hidden = YES;
    _nearbyTableView.hidden = YES;
    _nearbyNextTableView.hidden = YES;
    
}
//查看附近
-(void)nearbyAction:(UIButton *)button{
    
    if (!button.selected) {
        _choseBackgroundView.hidden = YES;
        _nearbyBackgroundView.hidden = NO;
        _nearbyTableView.hidden = NO;
        
    }else{
        _nearbyBackgroundView.hidden = YES;
        _nearbyTableView.hidden = YES;
        _nearbyNextTableView.hidden = YES;
    }
    button.selected = !button.selected;
        
}
//酒吧图片点击方法
- (IBAction)barImgShow1:(UIButton *)sender {
        sender.tag=0;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
//    [self posterShow];
    
}
 
- (IBAction)barImgShow2:(UIButton *)sender {
    sender.tag=1;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (IBAction)barImgShow3:(UIButton *)sender {
    sender.tag=2;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (IBAction)barImgShow4:(UIButton *)sender {
    sender.tag=3;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

//弹出海报视图
- (void)initPosterShow{
    _posterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _posterView.backgroundColor = [UIColor blackColor];
    _posterView.alpha = 0.5;
    [self.view addSubview:_posterView];
    //图片
    _posterImgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, KScreenWidth-20, KScreenHeight-89)];
    _posterImgView.backgroundColor = [UIColor greenColor];
    [self.view addSubview:_posterImgView];
    //设置是否响应触摸事件
    _posterImgView.userInteractionEnabled=YES;
    
    //添加单击手势
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [_posterImgView addGestureRecognizer:singleTap];
    //隐藏海报
    _posterView.hidden = YES;
    _posterImgView.hidden = YES;
    
}
//单击手势
- (void)tapAction{
    [self posterHidden];
    
}
//显示海报视图
- (void)posterShow{
    _posterView.hidden = NO;
    _posterImgView.hidden = NO;
    
    self.tabBarController.tabBar.hidden = YES;
  
}
//隐藏海报视图
- (void)posterHidden{
    _posterView.hidden = YES;
    _posterImgView.hidden = YES;
    self.tabBarController.tabBar.hidden = NO;
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_request clearDelegatesAndCancel];
    [_requestAttention clearDelegatesAndCancel];
    [_requestAttentionCancel clearDelegatesAndCancel];
    [_CLUBTabelView headerEndRefreshing];
    [_CLUBTabelView footerEndRefreshing];
}
- (void)viewWillAppear:(BOOL)animated{
    //让导航栏隐藏
      [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
     [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent animated:YES];
    NSLog(@"%@",LoginUserInfo.user_head);
    NSLog(@"%@",LoginUserInfo.user_name);
    NSLog(@"%@",LoginUserInfo.user_key);
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSLog(@"%@",LoginUserInfo.phoneNum);
    self.navigationController.interactivePopGestureRecognizer.delegate=(id)self;
   
    self.tabBarController.tabBar.hidden = NO;
    self.navigationController.navigationBarHidden=NO;
    //隐藏提示框
    [[Tostal sharTostal] hiddenView];
    //添加定时器
    [self addNSTimer];
}

- (void)viewDidDisappear:(BOOL)animated{
    //删除定时器
    [self removeNSTimer];
}
#pragma mark- 广告视图
- (void)addHeadCollectionView{
    //创建布局对象
    HJCarouselViewLayout *flowLayOut = [[HJCarouselViewLayout alloc] initWithAnim:HJCarouselAnimCarousel];
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    flowLayOut.itemSize = CGSizeMake(144, 189);
    
    //2.创建collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 199) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.showsHorizontalScrollIndicator = NO;
    _collectionView.showsVerticalScrollIndicator = NO;
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    
    UIView *superView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 199)];
    [superView addSubview:_collectionView];
    //设置表视图的头视图
    _CLUBTabelView.tableHeaderView = superView;
    //设置表视图分组section尾部行高
    _CLUBTabelView.sectionFooterHeight = 0;
    
    //注册单元格
    [_collectionView registerClass:[FeedbackCollectionViewCell class] forCellWithReuseIdentifier:iden];
}
-(NSMutableArray *)mArray
{
    if (_mArray==nil) {
        _mArray=[NSMutableArray array];
        for (int i= 0; i<9; i++) {
            NSString *str = [NSString stringWithFormat:@"000%d.png",i+1];
            UIImage *imag = [UIImage imageNamed:str];
            [_mArray addObject:imag];
        }
    }
    return _mArray;
}
//添加定时器
-(void)addNSTimer
{
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    //添加到runloop中
    //    [[NSRunLoop mainRunLoop]addTimer:timer forMode:NSRunLoopCommonModes];
    self.timer=timer;
}

//删除定时器
-(void)removeNSTimer
{
    [self.timer invalidate];
    self.timer=nil;
}

//自动滚动
-(void)nextPage
{
    _index++;
    NSLog(@"-----%ld",_index);
    CGPoint point = CGPointMake(_collectionView.contentOffset.x +375/2.6, 0);
    [_collectionView setContentOffset:point animated:YES];
    
    if (_collectionView.contentOffset.x/375 >= 1) {
        
        //如果到了第5页,再滚动就让坐标设置为0
        CGPoint point;
        if (KScreenWidth == 375) {
            point = CGPointMake(25, 0);
        }else if(KScreenWidth == 320){
            point = CGPointMake(55, 0);
        }else if(KScreenWidth>375){
            point = CGPointMake(10, 0);
        }
        //将滚动视图坐标设置为这个点坐标,并且不设置动画
        [_collectionView setContentOffset:point animated:YES];
        
    }
    
}
#pragma mark-UICollectionViewDelegate
//当用户开始拖拽的时候就调用
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    //删除定时器
    [self removeNSTimer];
}
//当用户停止拖拽的时候调用
-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    //添加定时器
    [self addNSTimer];
}
#pragma mark - UICollectionViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.mArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    FeedbackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    if (indexPath.row >= _mArray.count-1) {
        [_collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionLeft animated:YES];
        
    }else if(indexPath.row == 0){
        
    }
    cell.imgName = _mArray[indexPath.row];
    
    return cell;
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"点击了第%ld个item",indexPath.row);
    _index = indexPath.row;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
