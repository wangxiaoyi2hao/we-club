//
//  SignUpListViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SignUpListViewController.h"
#import "SignUpListTableViewCell.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "InfoTableViewController.h"
#import "InviteCompleteViewController.h"

extern UserInfo*LoginUserInfo;
@interface SignUpListViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestHost;
    ASIFormDataRequest*_requestSignUpThisInvite;
    NSMutableArray*friendsArray;
}
@end

@implementation SignUpListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [AppDelegate matchAllScreenWithView:self.view];
  
    [self requestSearchFriend];
    [_tableView addFooterWithTarget:self action:@selector(requestSearchLoadThisFoot)];
}
-(void)initNavBar{
    self.navigationItem.title = @"报名成员";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)rightClick{
    



}
-(void)popView1{

    [self.navigationController popViewControllerAnimated:YES];
}

-(IBAction)signUpThisInvie:(id)sender{

    [self requestSignUpThisInvite];

}

#pragma mark  //获取邀约报名人员
-(void)requestSearchFriend{
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
    _requestHost = [ASIFormDataRequest requestWithURL:url];
    [_requestHost setPostBody:(NSMutableData*)data];
    [_requestHost setDelegate:self];
    //请求延迟时间
    _requestHost.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestHost.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestHost.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestHost.secondsToCache=3600;
    [_requestHost startAsynchronous];
    
}
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
    _requestHost = [ASIFormDataRequest requestWithURL:url];
    [_requestHost setPostBody:(NSMutableData*)data];
    [_requestHost setDelegate:self];
    //请求延迟时间
    _requestHost.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestHost.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestHost.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestHost.secondsToCache=3600;
    [_requestHost startAsynchronous];
    
}

#pragma mark  报名啦
-(void)requestSignUpThisInvite{
    Request12008*request12008=[[Request12008 alloc]init];
    //设置请求参数
    request12008.common.userid=LoginUserInfo.user_id;
    request12008.common.userkey=LoginUserInfo.user_key;
    request12008.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12008.common.version=@"1.0.0";//版本号
    request12008.common.platform=2;//ios  andriod
    request12008.params.inviteId=_fromUserId;//邀约人的id
    //下面还可能有上传图片的内容
    NSData*data= [request12008 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/signUpInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestSignUpThisInvite = [ASIFormDataRequest requestWithURL:url];
    [_requestSignUpThisInvite setPostBody:(NSMutableData*)data];
    [_requestSignUpThisInvite setDelegate:self];
    //请求延迟时间
    _requestSignUpThisInvite.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestSignUpThisInvite.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestSignUpThisInvite.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestSignUpThisInvite.secondsToCache=3600;
    [_requestSignUpThisInvite startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestHost]) {
        Response12002*response=[Response12002 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
        }
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        NSLog(@"%@",response.data_p.inviteUsersArray);//返回的数组
        for (int i=0; i<response.data_p.inviteUsersArray.count; i++) {
            BriefUserInInvite*signUpThisInvite=[response.data_p.inviteUsersArray objectAtIndex:i];
            [friendsArray addObject:signUpThisInvite];
        }
    }
    if ([request isEqual:_requestSignUpThisInvite]) {
        Response12008*response=[Response12008 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
        }else{
            [[Tostal sharTostal]tostalMesg:@"您已经报名成功" tostalTime:1];
            [self requestSearchFriend];
        }

    }

    [_tableView footerEndRefreshing];
    [_tableView reloadData];
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
     cell.lbHeart.text=[HelperUtil isDefault:friendsOO.briefUser.signature];
     [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",friendsOO.briefUser.avatar]] placeholderImage:[UIImage imageNamed:@"default"]];
    if ([friendsOO.briefUser.userid  isEqualToString:LoginUserInfo.user_id]) {
        cell._imageViewMessage.hidden=YES;
    }
    [cell.buttonHead addTarget:self action:@selector(headClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonHead.tag=indexPath.row;
    [cell.buttonMessage addTarget:self action:@selector(messageClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonMessage.tag=indexPath.row;
    return cell;
}
-(void)headClick:(UIButton*)sender{
    BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:sender.tag];
    UIStoryboard *redStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *redVC = [redStoryboard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    redVC.fromUserId=friendsOO.briefUser.userid;
    [self.navigationController pushViewController:redVC animated:YES];
    
}
-(void)messageClick:(UIButton*)sender{
    
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
    // Dispose of any resources that can be recreated.
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_requestHost clearDelegatesAndCancel];
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
