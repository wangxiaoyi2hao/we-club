//
//  InfoTableViewController.m
//  bar
//
//  Created by chen on 15/11/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "InfoTableViewController.h"
#import "infoEditController.h"
#import "ReportViewController.h"
#import "InfoEditCollectionViewCell.h"
#import "UIView+Blur.h"
#import <RongIMKit/RongIMKit.h>
#import "LookUpUserAvatarViewController.h"
#import "ChatViewController.h"

static NSString *iden = @"InfoCollectionViewCell";
extern UserInfo*LoginUserInfo;
@interface InfoTableViewController ()<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest*_requestUser;
    ASIFormDataRequest*_requestAttenMan;
    UIButton*aTtentionbutton;
    Response10014*response10014;
    NSMutableArray*springArray;
    
    //collectionView
    NSMutableArray *_mArray;
    NSInteger _index;
    UICollectionView *_collectionView;
    UIImage*_imageCell;
}
@end

@implementation InfoTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置滚动条风格
    self.tableView.showsVerticalScrollIndicator=NO;
    //设置是否反弹
    self.tableView.bounces=NO;
    self.tableView.tableHeaderView = _infoHeadView;
    //设置边框
    _headViewIcon.layer.cornerRadius = 42;//边框圆角
    _headViewIcon.layer.borderWidth = 5;//边框线宽度
    _headViewIcon.layer.borderColor = [HelperUtil colorWithHexString:@"e43f6d"].CGColor;
    _headViewIcon.layer.masksToBounds = YES;
     NSLog(@"%@",_fromUserId);
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(tableViewReload) name:@"tablereload" object:nil];
    [_rightButton addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    
    //添加图片视图
    [self addPhoto];
    //设置毛玻璃效果
    _headBackImgView.frame = CGRectMake(0, 0, KScreenWidth, _infoHeadView.frame.size.height);
    _headBackImgView.blurTintColor=[UIColor colorWithWhite:1 alpha:0.00005];
    _headBackImgView.blurStyle=UIViewBlurLightStyle;
    
    [_headBackImgView enableBlur:YES];
    
     [self loadNav];

}
#pragma mark- 修改跳转到邀约界面
-(void)rightClick{

    
    UIStoryboard * club = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    infoEditController * controller = [club instantiateViewControllerWithIdentifier:@"infoEditControllerID"];
    controller.fromResponse10014=response10014;
    controller.urlMArray=springArray;
    [self.navigationController pushViewController:controller
                                         animated:YES];
    
    
}
#pragma mark 关注这个人－－
//关注方法
-(void)attention{
    Request12005*request12005=[[Request12005 alloc]init];
    //设置请求参数
    request12005.common.userid=LoginUserInfo.user_id;
    request12005.common.userkey=LoginUserInfo.user_key;
    request12005.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12005.common.version=@"1.0.0";//版本号
    request12005.common.platform=2;//ios  andriod
    request12005.params.followId=_fromUserId;
    request12005.params.flag=1;
    
    //获取的用户的信息显示在要显示的地方
    NSData*data= [request12005 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/followUser",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestAttenMan = [ASIFormDataRequest requestWithURL:url];
    [_requestAttenMan setPostBody:(NSMutableData*)data];
    [_requestAttenMan setDelegate:self];
    //请求延迟时间
    _requestAttenMan.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestAttenMan.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestAttenMan.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestAttenMan.secondsToCache=3600;
    [_requestAttenMan startAsynchronous];
}


//随便定义一个取消关注的按钮
-(IBAction)noAtten:(id)sender{

    [self noAttention];


}


//取消关注接口方法
-(void)noAttention{
    Request12005*request12005=[[Request12005 alloc]init];
    //设置请求参数
    request12005.common.userid=LoginUserInfo.user_id;
    request12005.common.userkey=LoginUserInfo.user_key;
    request12005.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12005.common.version=@"1.0.0";//版本号
    request12005.common.platform=2;//ios  andriod
    request12005.params.followId=_fromUserId;
    request12005.params.flag=2;
    
    //获取的用户的信息显示在要显示的地方
    NSData*data= [request12005 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/followUser",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestAttenMan = [ASIFormDataRequest requestWithURL:url];
    [_requestAttenMan setPostBody:(NSMutableData*)data];
    [_requestAttenMan setDelegate:self];
    //请求延迟时间
    _requestAttenMan.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestAttenMan.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestAttenMan.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestAttenMan.secondsToCache=3600;
    [_requestAttenMan startAsynchronous];
}

-(void)tableViewReload{

    [__tableView reloadData];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [self requestFansList];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section ==0) {
        return 5;
    }else if (section ==1) {
        return 3;
    }else if (section ==2) {
        return 2;
    }else{
        return 1;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

#pragma mark  创建邀约的导航条设置
-(void)loadNav{
     self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"] forBarMetrics: UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(backThisView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
    
//    if (_fromUserId != nil) {
//        if (![_fromUserId isEqualToString:LoginUserInfo.user_id]) {
//            _rightButton.hidden=YES;
//            _infoHeadView.frame = CGRectMake(0, 0, KScreenWidth, 368);
//            self.tableView.tableHeaderView = _infoHeadView;
//            _othersView.hidden = NO;
//        }else{
//            _infoHeadView.frame = CGRectMake(0, 0, KScreenWidth, 338);
//            self.tableView.tableHeaderView = _infoHeadView;
//            _othersView.hidden = YES;
//        }
//    }else{
//           _infoHeadView.frame = CGRectMake(0, 0, KScreenWidth, 338);
//        
//           self.tableView.tableHeaderView = _infoHeadView;
//           _othersView.hidden = YES;
//        
//    }
    
}
//左边按钮的点击事件
-(void)backThisView{
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark 获取用户信息的接口方法

-(void)requestFansList{
    springArray=nil;
    springArray=[NSMutableArray array];
    Request10014*request10014=[[Request10014 alloc]init];
    //设置请求参数
    request10014.common.userid=LoginUserInfo.user_id;
    request10014.common.userkey=LoginUserInfo.user_key;
    request10014.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request10014.common.version=@"1.0.0";//版本号
    request10014.common.platform=2;//ios  andriod
    if (_fromUserId!=nil) {
         request10014.params.userid=_fromUserId;
    }else{
         request10014.params.userid=LoginUserInfo.user_id;
    }
   //获取的用户的信息显示在要显示的地方
    NSData*data= [request10014 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getUserDetail",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestUser = [ASIFormDataRequest requestWithURL:url];
    [_requestUser setPostBody:(NSMutableData*)data];
    [_requestUser setDelegate:self];
    //请求延迟时间
    _requestUser.timeOutSeconds=10;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestUser.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestUser.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestUser.secondsToCache=3600;
    [_requestUser startAsynchronous];
    
}
//网络请求回调方法
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestUser]) {
       response10014=[Response10014 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response10014.common.code);//用这个判断是否退出成功0成功
        if (response10014.common.code!=0) {
            NSLog(@"返回错误");
        }else{
            NSLog(@"%i",response10014.data_p.hasDetailUser);//用这个值去判断是否能成功返回
            NSLog(@"%@",response10014.data_p.detailUser);//用这个值去赋值
            //年龄这里到时候问问设计是怎么回事
            NSArray*year=[response10014.data_p.detailUser.birthday componentsSeparatedByString:@"-"];
            NSString*yearAge=[year objectAtIndex:0];
            NSString* date;
            NSDateFormatter* formatter1 = [[NSDateFormatter alloc]init];
            [formatter1 setDateFormat:@"YYYY-MM-dd hh:mm:ss"];
            date = [formatter1 stringFromDate:[NSDate date]];
            NSArray*nowArray=[date componentsSeparatedByString:@"-"];
            NSString*nowYearAge=[nowArray objectAtIndex:0];
            int age=[nowYearAge intValue]-[yearAge intValue];
            if (response10014.data_p.detailUser.followed==1) {
                [_likeButton setTitle:@"已关注" forState:UIControlStateNormal];
            }else{
                [_likeButton setTitle:@"关注" forState:UIControlStateNormal];
            }
#pragma mark  需要修改后台给我一个单独的头像
            //从头像数组里面取出头像的url
            UserAvatar*userFirst=[response10014.data_p.detailUser.userAvatarArray objectAtIndex:0];
            [_headViewIcon sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",response10014.data_p.detailUser.userDetailAvatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
            NSLog(@"%@",[response10014.data_p.detailUser.userAvatarArray objectAtIndex:0]);
            if (response10014.data_p.detailUser.userAvatarArray.count != 0) {
                for (int i=0; i<response10014.data_p.detailUser.userAvatarArray.count; i++) {
                    UserAvatar*user0=[response10014.data_p.detailUser.userAvatarArray objectAtIndex:i];
                    [springArray addObject:user0];
                }
            }
            NSLog(@"%@",springArray);
            //对下面的属性进行赋值
            //这里问问设计 是不是还要有年龄，因为设计图上有年龄，现在又没有了妈妈的 这不是骗人么，好像要一个设计啊 这样我感觉效率能提升百分之200
            _lbAge.text=[NSString stringWithFormat:@"%i",age];
            //常出没地点
            self.title=[HelperUtil isDefault:response10014.data_p.detailUser.username];
            _lbArrive.text=[HelperUtil isDefault:response10014.data_p.detailUser.activeLocation];
            _lbHeart.text=[HelperUtil isDefault:response10014.data_p.detailUser.signature];
            NSLog(@"%@",response10014.data_p.detailUser.signature);
            _lbClubNumber.text=[NSString stringWithFormat:@"%lli",response10014.data_p.detailUser.vclubNumber];
            NSLog(@"%lli",response10014.data_p.detailUser.vclubNumber);
            //关系
            _lbGuanXi.text=[HelperUtil isDefault:response10014.data_p.detailUser.relationship];
            //个人签名
            _lbHeart.text=[HelperUtil isDefault:response10014.data_p.detailUser.signature];
            _lbHeartUp.text=[HelperUtil isDefault:response10014.data_p.detailUser.signature];
            _moneyLabel.text=[NSString stringWithFormat:@"%.2f",response10014.data_p.detailUser.usermoney];
            //家乡
            _lbHome.text=[HelperUtil isDefault:response10014.data_p.detailUser.hometown];
            _lbMovie.text=[HelperUtil isDefault:response10014.data_p.detailUser.movie];
            _lbMusic.text=[HelperUtil isDefault:response10014.data_p.detailUser.music];
            _lbProject.text=[HelperUtil isDefault:response10014.data_p.detailUser.job];
            _lbSchool.text=[HelperUtil isDefault:response10014.data_p.detailUser.school];
            _lbWork.text=[HelperUtil isDefault:response10014.data_p.detailUser.workLocation];
            NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:response10014.data_p.detailUser.registeTime/1000];
            NSDateFormatter*formatter=[[NSDateFormatter alloc]init];
            [formatter setDateFormat:@"yyyy-MM-dd"];
            NSString *timeStr= [formatter stringFromDate:confromTimesp];
            _lbYear.text=timeStr;
            //情感状态
            if (response10014.data_p.detailUser.emotionState==1) {
                    _lbLove.text=@"单身";
            }else if (response10014.data_p.detailUser.emotionState==2){
                    _lbLove.text=@"热恋";
            }else if (response10014.data_p.detailUser.emotionState==3){
                    _lbLove.text=@"已婚";
            }else{
                    _lbLove.text=@"离异";
            }
            //星座
            if (response10014.data_p.detailUser.constellation==1) {
                _lbConstellation.text=@"白羊座";
            }else if (response10014.data_p.detailUser.constellation==2){
                _lbConstellation.text=@"金牛座";
            }else if (response10014.data_p.detailUser.constellation==3){
                _lbConstellation.text=@"双子座";
            }else if (response10014.data_p.detailUser.constellation==4){
                _lbConstellation.text=@"巨蟹座";
            }else if (response10014.data_p.detailUser.constellation==5){
                _lbConstellation.text=@"狮子座";
            }else if (response10014.data_p.detailUser.constellation==6){
                _lbConstellation.text=@"处女座";
            }else if (response10014.data_p.detailUser.constellation==7){
                _lbConstellation.text=@"天秤座";
            }else if (response10014.data_p.detailUser.constellation==8){
                _lbConstellation.text=@"天蝎座";
            }else if (response10014.data_p.detailUser.constellation==9){
                _lbConstellation.text=@"人马座";
            }else if (response10014.data_p.detailUser.constellation==10){
                _lbConstellation.text=@"摩羯座";
            }else if (response10014.data_p.detailUser.constellation==11){
                _lbConstellation.text=@"水瓶座";
            }else if (response10014.data_p.detailUser.constellation==12){
                _lbConstellation.text=@"双鱼座";
            }
            //及时更新本地头像
            NSLog(@"%@",LoginUserInfo.user_id);
            NSLog(@"%@",_fromUserId);
            NSLog(@"%@",LoginUserInfo.user_head);
            NSLog(@"%@",userFirst.uRL);
            NSLog(@"%@",LoginUserInfo.user_name);
            NSLog(@"%@",response10014.data_p.detailUser.username);
            //这里只能用自己的名字和自己的名字做对比,
            if ([LoginUserInfo.user_id isEqualToString:_fromUserId]) {
                if ((![LoginUserInfo.user_head isEqualToString:userFirst.uRL]) ||(![LoginUserInfo.user_name isEqualToString:response10014.data_p.detailUser.username])) {
                    LoginUserInfo.user_name=response10014.data_p.detailUser.username;
                    LoginUserInfo.user_head=response10014.data_p.detailUser.userDetailAvatar;
                    [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
                    RCUserInfo *userInfo = [[RCUserInfo alloc] initWithUserId:LoginUserInfo.user_id name:LoginUserInfo.user_name portrait:LoginUserInfo.user_head];
                    [RCIMClient sharedRCIMClient].currentUserInfo = userInfo;
                    //更新融云缓存
                    [[RCIM sharedRCIM] refreshUserInfoCache:userInfo withUserId:LoginUserInfo.user_id];
                    [[ChatViewController shareChat].conversationMessageCollectionView reloadData];
                    
                }
            }
            
        }
       
    }
   
    if ([request isEqual:_requestAttenMan]) {
        Response12005*response=[Response12005 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//用这个判断是否退出成功0成功
        if (response.common.code==0) {
            [[Tostal sharTostal]tostalMesg:@"关注成功" tostalTime:1];
        }
    }
    [_collectionView reloadData];
    [[Tostal sharTostal]hiddenView];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [_requestUser clearDelegatesAndCancel];
}


- (IBAction)chatAction:(UIButton *)sender {
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = response10014.data_p.detailUser.userid; // 接收者的 targetId，这里为举例。
    conversationVC.userName = response10014.data_p.detailUser.username; // 接受者的 username，这里为举例。
    conversationVC.title = conversationVC.userName; // 会话的 title。
    self.hidesBottomBarWhenPushed = YES;
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController pushViewController:conversationVC animated:YES];
}
- (IBAction)likeAction:(UIButton *)sender {
    
    [self attention];
    
}
- (IBAction)reportAction:(UIButton *)sender {
    ReportViewController*controller=[[ReportViewController alloc]init];
    controller.whereIsCome=1;
    controller.fromUserID=_fromUserId;
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)backButton:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 10;
    flowLayOut.minimumInteritemSpacing = 10;
    
    //2.创建collectionView
    if (_fromUserId != nil) {
        if (![self.fromUserId isEqualToString:LoginUserInfo.user_id]) {
            //查看别人的信息
            _rightButton.hidden=YES;
            _othersView.hidden = NO;
            if (KScreenWidth == 320) {
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 174, KScreenWidth, 100) collectionViewLayout:flowLayOut];
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,290);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth == 375){
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 194, KScreenWidth, 120) collectionViewLayout:flowLayOut];
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,310);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth > 375){
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 194, KScreenWidth, 120) collectionViewLayout:flowLayOut];
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,310);
                self.tableView.tableHeaderView = _infoHeadView;
            }
        }else{
            //从别处查看自己的信息
            _othersView.hidden = YES;
            if (KScreenWidth == 320) {
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, KScreenWidth, 100) collectionViewLayout:flowLayOut];
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,250);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth == 375){
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, KScreenWidth, 120) collectionViewLayout:flowLayOut];
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth > 375){
                _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, KScreenWidth, 120) collectionViewLayout:flowLayOut];
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
                self.tableView.tableHeaderView = _infoHeadView;
            }

        }
    }else{
        //从信息界面查看自己的信息
        _othersView.hidden = YES;
        if (KScreenWidth == 320) {
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, KScreenWidth, 100) collectionViewLayout:flowLayOut];
            _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,250);
            self.tableView.tableHeaderView = _infoHeadView;
        }else if(KScreenWidth == 375){
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, KScreenWidth, 120) collectionViewLayout:flowLayOut];
            _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
            self.tableView.tableHeaderView = _infoHeadView;
        }else if(KScreenWidth > 375){
            _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 144, KScreenWidth, 120) collectionViewLayout:flowLayOut];
            _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
            self.tableView.tableHeaderView = _infoHeadView;
        }

    }
    _collectionView.backgroundColor = [UIColor clearColor];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //禁止滚动
    _collectionView.scrollEnabled = NO;
    [_infoHeadView addSubview:_collectionView];
    
    //注册单元格
    [_collectionView registerClass:[InfoEditCollectionViewCell class] forCellWithReuseIdentifier:iden];
    [self changeFrame];
    
}
- (void)ChangeFrame1{
    if (_fromUserId != nil) {
        if (![_fromUserId isEqualToString:LoginUserInfo.user_id]) {
            //查看别人的信息
            _rightButton.hidden=YES;
            _othersView.hidden = NO;
            if (KScreenWidth == 320) {
                _collectionView.frame = CGRectMake(0, 174, KScreenWidth, 100);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,290);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth == 375){
                _collectionView.frame = CGRectMake(0, 194, KScreenWidth, 120);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,310);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth > 375){
                _collectionView.frame = CGRectMake(0, 194, KScreenWidth, 120);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,310);
                self.tableView.tableHeaderView = _infoHeadView;
            }
        }else{
            //从别处查看自己的信息
            _othersView.hidden = YES;
            if (KScreenWidth == 320) {
                _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 100);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,250);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth == 375){
                _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 120);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth > 375){
                _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 120);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
                self.tableView.tableHeaderView = _infoHeadView;
            }
            
        }
    }else{
        //从信息界面查看自己的信息
        _othersView.hidden = YES;
        if (KScreenWidth == 320) {
            _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 100);
            _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,250);
            self.tableView.tableHeaderView = _infoHeadView;
        }else if(KScreenWidth == 375){
            _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 120);
            _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
            self.tableView.tableHeaderView = _infoHeadView;
        }else if(KScreenWidth > 375){
            _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 120);
            _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,260);
            self.tableView.tableHeaderView = _infoHeadView;
        }
        
    }
    
    
}
- (void)changeFrame{
    if (_fromUserId != nil) {
        if (![_fromUserId isEqualToString:LoginUserInfo.user_id]) {
            //查看别人的信息
            _rightButton.hidden=YES;
            _othersView.hidden = NO;
            if (springArray.count > 3) {
                if (KScreenWidth == 320) {
                    _collectionView.frame = CGRectMake(0, 200, KScreenWidth, 190);
                    _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,360);
                    self.tableView.tableHeaderView = _infoHeadView;
                }else if(KScreenWidth == 375){
                    _collectionView.frame = CGRectMake(0, 200, KScreenWidth, 250);
                    _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth, 380);
                    self.tableView.tableHeaderView = _infoHeadView;
                }else if(KScreenWidth > 375){
                    _collectionView.frame = CGRectMake(0, 200, KScreenWidth, 250);
                    _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth, 380);
                    self.tableView.tableHeaderView = _infoHeadView;
                }
            }
        }else{
            //从别处查看自己的信息
            _othersView.hidden = YES;
            if (springArray.count > 3) {
                if (KScreenWidth == 320) {
                    _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 190);
                    _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,340);
                    self.tableView.tableHeaderView = _infoHeadView;
                }else if(KScreenWidth == 375){
                    _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 250);
                    _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth, 360);
                    self.tableView.tableHeaderView = _infoHeadView;
                }else if(KScreenWidth > 375){
                    _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 250);
                    _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth, 360);
                    self.tableView.tableHeaderView = _infoHeadView;
                }
            }
        }
    }else{
        //从信息界面查看自己的信息
        _othersView.hidden = YES;
        if (springArray.count > 3) {
            if (KScreenWidth == 320) {
                _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 190);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth,340);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth == 375){
                _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 250);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth, 360);
                self.tableView.tableHeaderView = _infoHeadView;
            }else if(KScreenWidth > 375){
                _collectionView.frame = CGRectMake(0, 144, KScreenWidth, 250);
                _infoHeadView.frame = CGRectMake(0, -64, KScreenWidth, 360);
                self.tableView.tableHeaderView = _infoHeadView;
            }
        }
    }
}
#pragma mark - UICollectionViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSLog(@"%ld",springArray.count);
    if (springArray.count>3) {
        [self changeFrame];
        
    }else{
        [self ChangeFrame1];
    }
    return springArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoEditCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    UserAvatar*user0=[springArray objectAtIndex:indexPath.row];
    [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",user0.uRL]]placeholderImage:[UIImage imageNamed:@"default"]];    
    NSLog(@"%@",user0.uRL);
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
        LookUpUserAvatarViewController*controller=[[LookUpUserAvatarViewController alloc]init];
        controller.imageArray=springArray;
        controller.index=(int)indexPath.row;
        [self presentViewController:controller animated:NO completion:nil];
    }
}
-(void)setFromUserId:(NSString *)fromUserId{
    _fromUserId = fromUserId;
}
@end
