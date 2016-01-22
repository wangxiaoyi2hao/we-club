//
//  SearchBarViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SearchBarViewController.h"
#import "AppDelegate.h"
#import "SearchBarTableViewCell.h"
extern UserInfo*LoginUserInfo;
@interface SearchBarViewController ()
{
    ASIFormDataRequest*_requestBar;
    Response12009*reponse12009;

}
@end

@implementation SearchBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    [AppDelegate matchAllScreenWithView:self.view];
    [AppDelegate matchAllScreenWithView:_headView];
    _tableView.tableHeaderView = _headView;
    
}
-(void)viewWillAppear:(BOOL)animated{


    [self requestSearchFriend:@""];
}
-(void)loadNav{
    self.title=@"选择酒吧";
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView1{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark  获取邀约列表
-(void)requestSearchFriend:(NSString*)str{
    Request12009*request12009=[[Request12009 alloc]init];
    //设置请求参数
    request12009.common.userid=LoginUserInfo.user_id;
    request12009.common.userkey=LoginUserInfo.user_key;
    request12009.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12009.common.version=@"1.0.0";//版本号
    request12009.common.platform=2;//ios  andriod
    request12009.params.latitude=LoginUserInfo.latitude;//创建人所在的纬度
    request12009.params.longitude=LoginUserInfo.longitude;//创建人所在的经度
    request12009.params.keyword=str;//搜索的字段
    //下面还可能有上传图片的内容
    NSData*data= [request12009 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/getInviteClubs",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestBar = [ASIFormDataRequest requestWithURL:url];
    [_requestBar setPostBody:(NSMutableData*)data];
    [_requestBar setDelegate:self];
    //请求延迟时间
    _requestBar.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestBar.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestBar.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestBar.secondsToCache=3600;
    [_requestBar startAsynchronous];
    
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [_tfBarName resignFirstResponder];
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([request isEqual:_requestBar]) {
      reponse12009=[Response12009 parseFromData:request.responseData error:nil];
        NSLog(@"%i",reponse12009.common.code);//意见反馈是否成功成了提示一个窗口
        NSLog(@"%@",reponse12009.data_p.inviteClubsArray);//返回的属性
    }
      [_tableView reloadData];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    return 64*app.autoSizeScaleY;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return reponse12009.data_p.inviteClubsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str=@"cell";
    SearchBarTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"SearchBarTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    BriefInviteClub*clubBar=[ reponse12009.data_p.inviteClubsArray objectAtIndex:indexPath.row];
    cell.lbBarName.text=clubBar.clubname;
    cell.lbAddress.text=clubBar.clubLocation;
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    BriefInviteClub*clubBar=[ reponse12009.data_p.inviteClubsArray objectAtIndex:indexPath.row];
    NSDictionary*dic=[[NSDictionary alloc]initWithObjectsAndKeys:clubBar.clubid,@"clubId",clubBar.clubname,@"clubName",clubBar.clubLocation,@"clubLocation",_fromIntBag,@"isRed" ,nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"clubName" object:self userInfo:dic];
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self requestSearchFriend:textField.text];
    return YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [_requestBar clearDelegatesAndCancel];
    NSDictionary*dic=[[NSDictionary alloc]initWithObjectsAndKeys:_fromIntBag,@"isRed" ,nil];
    
    [[NSNotificationCenter defaultCenter]postNotificationName:@"isWhereScrollview" object:self userInfo:dic];
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [self requestSearchFriend:textField.text];
    
    
    return YES;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
