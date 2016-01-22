//
//  HostViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "HostViewController.h"
#import "SignUpListTableViewCell.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "HostFriendsViewController.h"
#import "InfoTableViewController.h"
#import "InviteCompleteViewController.h"

extern UserInfo*LoginUserInfo;
@interface HostViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestHostLokk;
    ASIFormDataRequest*_requestList;
    int isSelect;
    NSMutableArray*friendsArray;
}
@end

@implementation HostViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建导航条
    [self initNavBar];
    [AppDelegate matchAllScreenWithView:self.view];

    [_tableView addFooterWithTarget:self action:@selector(requestSearchLoadThisFoot)];

    lbMoney.text=[NSString stringWithFormat:@"%i元",_fromPayMoney];
    // Do any additional setup after loading the view from its nib.
}

-(void)initNavBar{
     self.navigationItem.title = @"报名成员";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    //    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}

-(void)viewDidAppear:(BOOL)animated{

    [self requestSearchFriendList];
}
-(void)popView1{
    [self.navigationController popViewControllerAnimated:YES];
}
-(IBAction)springRed:(id)sender{
    if (_fromPayMoney==0) {
        UIAlertView*alertView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请创建红包邀约" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alertView show];
    }else{
        HostFriendsViewController*controller=[[HostFriendsViewController alloc]init];
        controller.fromUserId=_fromUserId;
        [self.navigationController pushViewController:controller animated:YES];
    }
    


}
-(void)rightClick{
    


}
#pragma mark  挑选报名
-(void)requestSearchTiao{
    Request12003*request12003=[[Request12003 alloc]init];
    //设置请求参数
    request12003.common.userid=LoginUserInfo.user_id;
    request12003.common.userkey=LoginUserInfo.user_key;
    request12003.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12003.common.version=@"1.0.0";//版本号
    request12003.common.platform=2;//ios  andriod
    request12003.params.inviteId=_fromUserId;//邀约人的id
    request12003.params.choosedUserid=@"";//选中人的id
    
    //下面还可能有上传图片的内容
    NSData*data= [request12003 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/selectSignUpUsers",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestHostLokk = [ASIFormDataRequest requestWithURL:url];
    [_requestHostLokk setPostBody:(NSMutableData*)data];
    [_requestHostLokk setDelegate:self];
    //请求延迟时间
    _requestHostLokk.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestHostLokk.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestHostLokk.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestHostLokk.secondsToCache=3600;
    [_requestHostLokk startAsynchronous];
    
}
#pragma mark  报名好友列表
//获取好友列表
-(void)requestSearchFriendList{
    friendsArray=nil;
    friendsArray=[NSMutableArray array];
    Request12002*request12002=[[Request12002 alloc]init];
    //设置请求参数
    request12002.common.userid=LoginUserInfo.user_id;
    request12002.common.userkey=LoginUserInfo.user_key;
    request12002.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12002.common.version=@"1.0.0";//版本号
    request12002.common.platform=2;//ios  andriod
    request12002.params.inviteId=_fromUserId;//邀约人的id
    //下面还可能有上传图片的内容
    NSData*data= [request12002 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/getInviteSignUpUsers",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestList = [ASIFormDataRequest requestWithURL:url];
    [_requestList setPostBody:(NSMutableData*)data];
    [_requestList setDelegate:self];
    //请求延迟时间
    _requestList.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestList.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestList.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestList.secondsToCache=3600;
    [_requestList startAsynchronous];
    
}
#pragma mark 分页用的上拉加载
-(void)requestSearchLoadThisFoot{
    Request12002*request12002=[[Request12002 alloc]init];
    //设置请求参数
    request12002.common.userid=LoginUserInfo.user_id;
    request12002.common.userkey=LoginUserInfo.user_key;
    request12002.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12002.common.version=@"1.0.0";//版本号
    request12002.common.platform=2;//ios  andriod
    request12002.params.inviteId=_fromUserId;//邀约人的id
    BriefUserInInvite*briefOO=[friendsArray lastObject];
    request12002.params.lastUserid=briefOO.briefUser.userid;
    //下面还可能有上传图片的内容
    NSData*data= [request12002 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/getInviteSignUpUsers",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestList = [ASIFormDataRequest requestWithURL:url];
    [_requestList setPostBody:(NSMutableData*)data];
    [_requestList setDelegate:self];
    //请求延迟时间
    _requestList.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestList.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestList.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestList.secondsToCache=3600;
    [_requestList startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([request isEqual:_requestHostLokk]) {
        Response12003*response=[Response12003 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        [[Tostal sharTostal]tostalMesg:@"选择成功" tostalTime:1];
        
    }
    if ([request isEqual:_requestList]) {
        Response12002*response=[Response12002 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        NSLog(@"%@",response.data_p.inviteUsersArray);//返回的数组
        for (int i=0; i<response.data_p.inviteUsersArray.count; i++) {
            BriefUserInInvite*briefBar=[response.data_p.inviteUsersArray objectAtIndex:i];
            [friendsArray addObject:briefBar];
        }
        
    }
    [_tableView reloadData];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
- (void)requestFailed:(ASIHTTPRequest *)request{

    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    [_tableView headerEndRefreshing];
    [_tableView footerEndRefreshing];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    return 68*app.autoSizeScaleY;
}

//tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friendsArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    SignUpListTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"SignUpListTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
        cell.selectionStyle=UITableViewCellAccessoryNone;
    }
    BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:indexPath.row];
    cell.lbName.text=friendsOO.briefUser.username;
    if ([friendsOO.briefUser.userid  isEqualToString:LoginUserInfo.user_id]) {
        cell._imageViewMessage.hidden=YES;
    }
    cell.lbHeart.text=[HelperUtil isDefault:friendsOO.briefUser.signature];
    [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",friendsOO.briefUser.avatar]] placeholderImage:[UIImage imageNamed:@"default"]];
    [cell.buttonHead addTarget:self action:@selector(buttonHeadClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonHead.tag=indexPath.row;
    [cell.buttonMessage addTarget:self action:@selector(buttonMessageClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonMessage.tag=indexPath.row;
    return cell;
}
-(void)buttonHeadClick:(UIButton*)sender{
    BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:sender.tag];
    UIStoryboard *redStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *redVC = [redStoryboard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    redVC.fromUserId=friendsOO.briefUser.userid;
    [self.navigationController pushViewController:redVC animated:YES];

}
-(void)buttonMessageClick:(UIButton*)sender{

    BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:sender.tag];
    if (![friendsOO.briefUser.userid isEqualToString:LoginUserInfo.user_id]) {
        ChatViewController *conversationVC = [[ChatViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = friendsOO.briefUser.userid; // 接收者的 targetId，这里为举例。
        conversationVC.userName = friendsOO.briefUser.username; // 接受者的 username，这里为举例。
        conversationVC.title = conversationVC.userName; // 会话的 title。
        self.hidesBottomBarWhenPushed = YES;
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:indexPath.row];
    if (![friendsOO.briefUser.userid isEqualToString:LoginUserInfo.user_id]) {
        ChatViewController *conversationVC = [[ChatViewController alloc]init];
        conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
        conversationVC.targetId = friendsOO.briefUser.userid; // 接收者的 targetId，这里为举例。
        conversationVC.userName = friendsOO.briefUser.username; // 接受者的 username，这里为举例。
        conversationVC.title = conversationVC.userName; // 会话的 title。
        self.hidesBottomBarWhenPushed = YES;
        // 把单聊视图控制器添加到导航栈。
        [self.navigationController pushViewController:conversationVC animated:YES];
    }else {
    
        NSLog(@"这是一个傻逼");
    }
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
-(void)viewWillDisappear:(BOOL)animated{

    [_requestHostLokk clearDelegatesAndCancel];
    [_requestList clearDelegatesAndCancel];
}


@end
