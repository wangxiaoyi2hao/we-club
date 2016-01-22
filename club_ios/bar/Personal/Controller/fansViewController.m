//
//  fansViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//粉丝列表
#import "fansViewController.h"
#import "AppDelegate.h"
#import "InfoTableViewController.h"
extern UserInfo*LoginUserInfo;
@interface fansViewController ()<ASIHTTPRequestDelegate>
{
    NSArray *_fansCountArray;
    ASIFormDataRequest*_request;//获取我的粉丝列表
    Response10008*response10008;
}

@end

@implementation fansViewController
-(void)viewWillAppear:(BOOL)animated{
    [self requestFansList];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    [self.tableView setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
//    _fansCountArray = @[@"秦始皇",@"卫庄",@"天明",@"石兰",@"盖聂",@"秦始皇",@"卫庄",@"天明",@"石兰",@"盖聂",@"秦始皇",@"卫庄",@"天明",@"石兰",@"盖聂"];
    
//    NSString *str = [NSString stringWithFormat:@"我的粉丝(%ld)",(unsigned long)_fansCountArray.count];
    self.navigationItem.title = @"我的粉丝";
    [self loadNav];
    //获取粉丝列表
    //[self requestFansList];
}
#pragma mark 获取粉丝的时候调用这个接口
-(void)requestFansList{
    [[Tostal sharTostal]showLoadingView:@"正在加载您的粉丝"];
    Request10008*request10008=[[Request10008 alloc]init];
    //设置请求参数
    request10008.common.userid=LoginUserInfo.user_id;
    request10008.common.userkey=LoginUserInfo.user_key;
    request10008.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request10008.common.version=@"1.0.0";//版本号
    request10008.common.platform=2;//ios  andriod

    NSData*data= [request10008 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getMyFollower",REQUESTURL];
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

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]) {
        response10008=[Response10008 parseFromData:request.responseData error:nil];
      }
    [[Tostal sharTostal]hiddenView];
    [_tableView reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:2];
    [[Tostal sharTostal]hiddenView];
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(leftButtonPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)leftButtonPopView{
    
    [self.navigationController popViewControllerAnimated:YES];
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

    return response10008.data_p.briefUsersArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //设置一个静态变量
    static NSString *iden = @"fansListIdentifier";
    fansViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    if (cell == nil) {
        cell = [[fansViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    BriefUser*user=[response10008.data_p.briefUsersArray objectAtIndex:indexPath.row];
    [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",user.avatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    cell.nickname.text = user.username;
    cell.message.text = user.signature;
    if (user.sex==1) {
        [cell._imageViewSex setImage:[UIImage imageNamed:@"邀约-男性.png"]];
    }else{
        [cell._imageViewSex setImage:[UIImage imageNamed:@"邀约-女性.png"]];
    }
    [cell.buttonHead addTarget:self action:@selector(buttonHeadClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonHead.tag=indexPath.row;
    
    return cell;
}
//点击头像
-(void)buttonHeadClick:(UIButton*)sender{
    BriefUser*friendsOO=[response10008.data_p.briefUsersArray objectAtIndex:sender.tag];
    UIStoryboard *redStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *redVC = [redStoryboard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    redVC.fromUserId=friendsOO.userid;
    [self.navigationController pushViewController:redVC animated:YES];

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return 60*app.autoSizeScaleY;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
 [  tableView deselectRowAtIndexPath:indexPath animated:NO];
}
-(void)viewWillDisappear:(BOOL)animated{
    
    [_request clearDelegatesAndCancel];
   
}

@end
