//
//  MemberTableVC.m
//  bar
//
//  Created by chen on 15/10/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "MemberTableVC.h"
#import "MemberCollectionCell.h"
#import "BackgroundTableVC.h"
#import "Tostal.h"
#import "UpdateNameViewController.h"
#import "SponsoredGroupVC.h"
#import "InfoTableViewController.h"
#import <RongIMKit/RongIMKit.h>

static NSString *iden = @"cell_1";
static NSString *header = @"header_1";

extern UserInfo*LoginUserInfo;
@interface MemberTableVC ()<ASIHTTPRequestDelegate>
{
    UIView *_memberListView;
    ASIFormDataRequest*_request;
    
    NSMutableArray *_mArray;
    NSArray *_imageArray;
    UICollectionView *_collectionView ;
}
@property (strong, nonatomic) IBOutlet UITableView *memberTableView;

@end

@implementation MemberTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置表示图的头视图
    [self addHeadView];
    //设置是否反弹
    self.tableView.bounces=NO;
    
    [self initNavBar];
    _memberTableView.showsVerticalScrollIndicator=NO;

}
-(void)viewWillAppear:(BOOL)animated{

    [self requestUrFriends];
}
-(void)viewWillDisappear:(BOOL)animated{
    [_request clearDelegatesAndCancel];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//聊天室成成员数据接口方法
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 0.00000001;
    }
    return 10;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (KScreenHeight == 480) {
        return 44;
    }
    return 44*KScreenHeight/568;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
       [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section == 0) {
        
        
    }else if (indexPath.section == 1) {
        
        
        if (indexPath.row==0) {
            UpdateNameViewController*controller=[[UpdateNameViewController alloc]init];
            controller.myName=_cellName.text;
            [self.navigationController pushViewController:controller animated:YES];
    }else if (indexPath.row == 1) {
        //设置conversationMessageCollectionView的背景色为透明
        //self.conversationMessageCollectionView.backgroundColor = [UIColor clearColor];
        //设置self.view.backgroundColor用自己的背景图片
        //self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"girlpicture.png"]];
            //跳转到聊天室背景
            UIStoryboard * backgroundTableVCSB = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
            BackgroundTableVC * backgroundTableVC= [backgroundTableVCSB instantiateViewControllerWithIdentifier:@"backgroundTableVCID"];
            [self.navigationController pushViewController:backgroundTableVC animated:NO];
            
        }
    }else if (indexPath.section==2){
    
        if (indexPath.row==1) {
            
            
            //清空所有聊天记录
            [[RCIMClient sharedRCIMClient] clearMessages:ConversationType_PRIVATE targetId:@"0cf1d5dd-79b2-4549-a910-60146249f0ca"];
            [[Tostal sharTostal]tostalMesg:@"清除成功" tostalTime:1];
        }else{
            //获取最新消息记录
            NSArray *array = [[RCIMClient sharedRCIMClient] getLatestMessages:ConversationType_CHATROOM targetId:@""/*聊天室id*/ count:10];
            //获取历史聊天记录
            NSArray *array1 = [[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_CHATROOM targetId:@""/*聊天室id*/ oldestMessageId:1 count:5];
            [[Tostal sharTostal]tostalMesg:@"查找聊天记录,差个界面" tostalTime:1];
            
        }
    }
}
//创建头视图
- (void)addHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 237*KScreenWidth/320)];
    _collectionView = [self addCollectionView];
    _collectionView.showsVerticalScrollIndicator=NO;
    //collectionView.frame = CGRectMake(0, 0, KScreenWidth, (237*KScreenWidth/320-27));
    _collectionView.backgroundColor = [UIColor whiteColor];
    [headView addSubview:_collectionView];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];
    
    button.frame=CGRectMake(0, 237*KScreenWidth/320-27, KScreenWidth, 27);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 237*KScreenWidth/320-27, KScreenWidth, 27)];
    label.text = @"查看全部成员(99)";
    label.textColor = [UIColor blackColor];
    label.textAlignment = NSTextAlignmentCenter;
    [headView addSubview:label];
    [headView addSubview:button];
    button.tintColor = [UIColor blackColor];
    [button addTarget:self action:@selector(openButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [headView addSubview:button];
    _memberTableView.tableHeaderView = headView;
}

#pragma mark - 跳转到查看全部成员界面
-(void)openButtonAction:(UIButton *)button{
    SponsoredGroupVC*controller=[[SponsoredGroupVC alloc]init];
#pragma mark 这里是要传入获得array  因为现在没有数据所以说我也不知道是要便利还是直接把这个数组定位实例变量
    controller.fromArray=_mArray;//网络获得
    
    [self.navigationController pushViewController:controller animated:YES];

    
}
-(void)shutButtonAction:(UIButton *)button{
    
//    _memberListView.hidden = YES;
    
}
#pragma mark - 以下内容为collectionView
//创建UICollectionView
- (UICollectionView *)addCollectionView{
  
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    flowLayOut.itemSize = CGSizeMake(64*KScreenWidth/320, 84*KScreenWidth/320);
    //设置每一个item之间的最小空隙
    flowLayOut.minimumInteritemSpacing = 20;
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 10;
    
    //2.创建collectionView
    //UICollectionViewLayout  布局对象
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 190*KScreenWidth/320) collectionViewLayout:flowLayOut];
    
    //设置代理
    collectionView.delegate = self;
    collectionView.dataSource = self;
    
    //注册单元格
    [collectionView registerClass:[MemberCollectionCell class] forCellWithReuseIdentifier:iden];
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
    
    MemberCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    ChatUser*collectUser=[_mArray objectAtIndex:indexPath.row];
    cell.imgName = collectUser.avatar;
    cell.nameLabel.text =collectUser.username;
    
    return cell;
    
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 17, 10, 17);
    
    return edge;
    
}

//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    ChatUser*collectUser=[_mArray objectAtIndex:indexPath.row];
    UIStoryboard * memberTableVCSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController * memberTableVC= [memberTableVCSB instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    memberTableVC.fromUserId=collectUser.userid;
    [self.navigationController pushViewController:memberTableVC animated:NO];
}

#pragma mark-NavBar
//导航栏
-(void)initNavBar{
    //标题
    self.navigationItem.title = @"聊天室成员";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    
    //返回聊天室
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
//返回酒吧聊天室界面
-(void)popView{
    
    [self.navigationController popViewControllerAnimated:YES];
//    [self.navigationController popToRootViewControllerAnimated:YES];
}
#pragma mark //获取聊天室成员 

-(void)requestUrFriends{
    _mArray=nil;
    _mArray=[NSMutableArray array];
    Request11004*request11004=[[Request11004 alloc]init];
    //设置请求参数
    request11004.common.userid=LoginUserInfo.user_id;
    request11004.common.userkey=LoginUserInfo.user_key;
    request11004.common.cmdid=11004;//现在标注为假数据
    request11004.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request11004.params.clubId=_fromUserId;
    NSData*data= [request11004 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getChatroomMember",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
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
   //聊天室成员返回的数组
    if ([request isEqual:_request]) {
        Response11004 * response = [Response11004 parseFromData:request.responseData error:nil];
        NSLog(@"%@", response.data_p.chatUsersArray);
        for (int i=0; i<response.data_p.chatUsersArray.count; i++) {
            ChatUser*chat=[response.data_p.chatUsersArray objectAtIndex:i];
            [_mArray addObject:chat];
        }
 
    }
    [_collectionView reloadData];
}

@end
