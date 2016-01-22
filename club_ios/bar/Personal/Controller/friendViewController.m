//
//  friendViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "friendViewController.h"
#import "FrindsTableViewCell.h"
#import "AddFriendsVC.h"
#import "ChatViewController.h"
#import "AppDelegate.h"

extern UserInfo*LoginUserInfo;
@interface friendViewController ()<ASIHTTPRequestDelegate>
{
    NSArray *_sectionIndexArray;
    NSArray *_friendsArray;
    
    ASIFormDataRequest*_request;//获取好友列表
    ASIFormDataRequest*_requestSearch;//获取搜索好友的
    Response10006*response10006;
    Response10007*_responseSearch;
    UITextField * textinput;
    
}

@end

@implementation friendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    self.tableView.backgroundColor = [HelperUtil colorWithHexString:@"#f8f8f8"];
    UIView *view = [UIView new];
    self.tableView.tableFooterView = view;
    //设置是否反弹
    self.tableView.bounces=NO;
    //设置是否显示竖向滚动条
    self.tableView.showsVerticalScrollIndicator=NO;
    
    //设置侧栏的颜色
    //字体的颜色
    self.tableView.sectionIndexColor = [UIColor blackColor];
    self.tableView.sectionIndexMinimumDisplayRowCount = 10;
//    //背景颜色
//    self.tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    //设置选中以后的颜色
    //_tableView.sectionIndexTrackingBackgroundColor = [UIColor yellowColor];
    //_tableView.sectionIndexMinimumDisplayRowCount=10;
    self.tableView.sectionFooterHeight = 20.0;
    self.tableView.sectionHeaderHeight = 20.0;
    //添加头视图
    [self addHeadView];
    //获取好友列表
    
    //刷新数据
    [_friendTableView reloadData];
    [self loadNav];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [textinput resignFirstResponder];
}
-(void)viewWillAppear:(BOOL)animated{
    [self requestFriendList];
}
//添加头视图
-(void) addHeadView{
    //无添加第三方好友
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, 45*KScreenWidth/320)];
    UIView *searchView = [self addSearchView];
    [headView addSubview:searchView];
    _headView.backgroundColor = [HelperUtil colorWithHexString:@"#f8f8f8"];
    self.tableView.tableHeaderView = _headView;
    
    //包含添加第三方好友(第二版本)
//    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0,KScreenWidth, 89*KScreenWidth/320)];
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(17, 44*KScreenWidth/320, KScreenWidth-27, 0.5)];
//    lineView.backgroundColor = [UIColor lightGrayColor];
//    headView.backgroundColor = [HelperUtil colorWithHexString:@"#f8f8f8"];
//    [headView addSubview:lineView];
//    UIView *addFriendView = [[UIView alloc] initWithFrame:CGRectMake(0, 45, KScreenWidth, 44)];
//    [headView addSubview:addFriendView];
//    UIImageView *imgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"4-4-1.png"]];
//    imgView.frame = CGRectMake(17, 5, 30, 30);
//    [addFriendView addSubview:imgView];
//    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.frame = CGRectMake(0, 0, KScreenWidth-57, 44);
//    button.backgroundColor = [UIColor clearColor];
//    [button setTitle:@"添加好友" forState:UIControlStateNormal];
//    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
//    [addFriendView addSubview:button];
//    UIView *searchView = [self addSearchView];
//    [headView addSubview:searchView];
//    self.tableView.tableHeaderView = headView;
}
//- (void)buttonAction{
//    //点击第一个单元格跳转到添加好友界面
//    AddFriendsVC *addFriendsVC = [[AddFriendsVC alloc] init];
//    [self.navigationController pushViewController:addFriendsVC animated:YES];
//}

#pragma mark 获取我的好友列表
-(void)requestFriendList{
    [[Tostal sharTostal]showLoadingView:@"好友列表正在加载"];
    Request10006*request10006=[[Request10006 alloc]init];
    //设置请求参数
    request10006.common.userid=LoginUserInfo.user_id;
    request10006.common.userkey=LoginUserInfo.user_key;
    request10006.common.timestamp=2;//现在标注为真数据
    request10006.common.version=@"1.0.0";//版本号
    request10006.common.platform=2;//ios  andriod
    request10006.common.cmdid=10006;
    NSData*data= [request10006 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getMyFriends",REQUESTURL];
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
    
}
#pragma mark 搜索好友的时候调用这个方法
-(void)requestSearchFriend{
    [[Tostal sharTostal]showLoadingView:@"好友正在搜索中"];
    Request10007*request10007=[[Request10007 alloc]init];
    //设置请求参数
    request10007.common.userid=LoginUserInfo.user_id;
    request10007.common.userkey=LoginUserInfo.user_key;
    request10007.common.timestamp=2;//现在标注为真数据
    request10007.common.version=@"1.0.0";//版本号
    request10007.common.platform=2;//ios  andriod
    request10007.params.clubNumber=44;//根据clubNumber搜索好友
    NSData*data= [request10007 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/searchUser",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestSearch = [ASIFormDataRequest requestWithURL:url];
    [_requestSearch setPostBody:(NSMutableData*)data];
    [_requestSearch setDelegate:self];
    //请求延迟时间
    _requestSearch.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestSearch.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestSearch.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestSearch.secondsToCache=3600;
    [_requestSearch startAsynchronous];
}
#pragma mark - 返回数据结果
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]) {
        response10006=[Response10006 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response10006.data_p.userAvatarAndNameArray);
        NSLog(@"%li",response10006.data_p.userAvatarAndNameArray_Count);
    }
    if ([request isEqual:_requestSearch]) {
        _responseSearch=[Response10007 parseFromData:request.responseData error:nil];
        NSLog(@"%i",_responseSearch.data_p.hasBriefUser);//用这个判断是否生成了这个对象
        NSLog(@"%@",_responseSearch.data_p.briefUser);//用这个对象来进行赋值
    }
    [_friendTableView reloadData];
    [[Tostal sharTostal]hiddenView];

}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:2];
    [[Tostal sharTostal]hiddenView];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return response10006.data_p.userAvatarAndNameArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置一个静态变量
    static NSString *iden = @"friendListIdentifier";
    FrindsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        //需要使用Nib获得MyCell.xib中已经创建好的单元格
        cell = (FrindsTableViewCell *)[[[NSBundle mainBundle] loadNibNamed:@"FrindsTableViewCell" owner:self options:nil] lastObject];//这里调用加载nib文件
    }
    UserAvatarAndName*fridensName=  [response10006.data_p.userAvatarAndNameArray objectAtIndex:indexPath.row];
    cell.contentView.backgroundColor = [UIColor clearColor];
    cell.backgroundColor = [UIColor clearColor];
    cell.nameLable.text = fridensName.username;
    [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:@"http://pic14.nipic.com/20110522/7411759_164157418126_2.jpg"]];
    NSLog(@"%@",fridensName.avatar);
    return cell;
    
}
//点击单元格调用的方法
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = @"1"; // 接收者的 targetId，这里为举例。
    conversationVC.userName = _friendsArray[indexPath.row]; // 接受者的 username，这里为举例。
    conversationVC.title = conversationVC.userName; // 会话的 title。
    //self.hidesBottomBarWhenPushed = YES;
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController pushViewController:conversationVC animated:YES];
}
#pragma mark - 搜索栏视图
-(UIView *)addSearchView{
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 2*KScreenWidth/320, KScreenWidth, 44*KScreenWidth/320)];
    searchView.backgroundColor = [UIColor clearColor];
    //搜索栏视图
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(17, 15*KScreenWidth/320, 15, 15)];
    [btn setBackgroundImage:[UIImage imageNamed:@"2-4-1.png"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    [searchView addSubview:btn];
    UILabel * sousuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 2*KScreenWidth/320, 30, 40)];
    sousuoLabel.text = @"搜索";
    sousuoLabel.font = [UIFont systemFontOfSize:15];
    [searchView addSubview:sousuoLabel];
    //提示信息
     textinput = [[UITextField alloc]initWithFrame:CGRectMake(75, 2*KScreenWidth/320, KScreenWidth - 80, 40)];
    textinput.backgroundColor = [UIColor clearColor];
    textinput.placeholder = @"搜索聊天室成员";
    textinput.returnKeyType=UIReturnKeySearch;
    textinput.font = [UIFont systemFontOfSize:15];
    [searchView addSubview:textinput];
    
    return searchView;
}
//搜索好友点击方法
- (void)btnAction{
    
    [self requestSearchFriend];
    //刷新数据
    [_friendTableView reloadData];
    
}


//此方法返回每个分组的标题，有多少分组调用多少次,设置组的头视图
-(NSString*)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return _sectionIndexArray[section];
}
//此方法设置组索引
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return _sectionIndexArray;
}
//设置组头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.0000001;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return 60* app.autoSizeScaleY;
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(leftPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)leftPopView{    
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated{
    [_request clearDelegatesAndCancel];
    [_requestSearch clearDelegatesAndCancel];
}
@end
