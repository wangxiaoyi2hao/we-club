//
//  HostFriendsViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "HostFriendsViewController.h"
#import "AppDelegate.h"
#import "RedPacketInvitationVC.h"
#import "HostFriendsTableViewCell.h"
extern UserInfo*LoginUserInfo;
@interface HostFriendsViewController ()
{

    ASIFormDataRequest*_requestHostLokk;
    ASIFormDataRequest*_requestList;
//    int isSelect;
    NSMutableArray*friendsArray;
    long currentIndex;
    int isFollow;
    NSString*chooseIdStr;
    NSMutableArray*selectArray;
    NSMutableArray*boolArray;
    NSString*isSelect;
    // 测试array
    NSMutableArray*array1;
}
@end

@implementation HostFriendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initNavBar];
    [AppDelegate matchAllScreenWithView:self.view];
//    [_tableView addHeaderWithTarget:self action:@selector(requestSearchFriendList)];
    [self requestSearchFriendList];
    [_tableView addFooterWithTarget:self action:@selector(requestSearchLoadThisFoot)];
    //事例化选中数组
    selectArray=[NSMutableArray array];
    isFollow=0;
       isSelect=@"0";
   
    array1=[NSMutableArray arrayWithObjects:@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1",@"1", nil];
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{
    
   [self requestSearchFriendList];
}
-(void)initNavBar{
    self.navigationItem.title =@"报名成员";
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
-(void)requestSearchTiao{
    Request12003*request12003=[[Request12003 alloc]init];
    //设置请求参数
    request12003.common.userid=LoginUserInfo.user_id;
    request12003.common.userkey=LoginUserInfo.user_key;
    request12003.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12003.common.version=@"1.0.0";//版本号
    request12003.common.platform=2;//ios  andriod
    request12003.params.inviteId=_fromUserId;//邀约人的id
    request12003.params.choosedUserid=chooseIdStr;//选中人的id
    
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
        if (response.common.code==0) {
            UIStoryboard * memberTableVCSB = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
            RedPacketInvitationVC * memberTableVC= [memberTableVCSB instantiateViewControllerWithIdentifier:@"RedPacketInvitationVCID"];
            [self.navigationController pushViewController:memberTableVC animated:NO];

        }else{
        
            [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
        }
        
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
   
    [_tableView footerEndRefreshing];
}

-(void)popView1{

    [self.navigationController popViewControllerAnimated:YES];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    return 72*app.autoSizeScaleY;
}

//tableview
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return friendsArray.count;

}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    HostFriendsTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"HostFriendsTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    
    BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:indexPath.row];
    cell.lbName.text=friendsOO.briefUser.username;

    cell.lbHeart.text=[HelperUtil isDefault:friendsOO.briefUser.signature];
    [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",friendsOO.briefUser.avatar]] placeholderImage:[UIImage imageNamed:@"default"]];
    [cell.buttonSelect addTarget:self action:@selector(selectClick:) forControlEvents:UIControlEventTouchUpInside];
    if (friendsOO.isSelected==1 ) {
        [cell.buttonSelect setImage:[UIImage imageNamed:@"c.png"] forState:UIControlStateNormal];
    }else{
        [cell.buttonSelect setImage:[UIImage imageNamed:@"A.png"] forState:UIControlStateNormal];
    }
  cell.buttonSelect.tag=indexPath.row;
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
}
-(void)selectClick:(UIButton*)sender{
    
    for (int i=0; i<friendsArray.count; i++) {
          BriefUserInInvite*friendsOO=[friendsArray objectAtIndex:i];
        if (i==sender.tag) {
            friendsOO.isSelected=1;
            chooseIdStr=friendsOO.briefUser.userid;
        }else{
            friendsOO.isSelected=0;
        }
    }
    [_tableView reloadData];
}
-(IBAction)springRed:(UIButton*)sender{
    if ([chooseIdStr isEqualToString:@""]) {
        [[Tostal sharTostal]tostalMesg:@"请选择邀约人" tostalTime:1];
    }else{
        UIAlertView*aliter=[[UIAlertView alloc]initWithTitle:@"确定发送红包" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [aliter show];
    }
   
    
    
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==1) {
        [self requestSearchTiao];
    }


}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_requestHostLokk clearDelegatesAndCancel];
    [_requestList clearDelegatesAndCancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
