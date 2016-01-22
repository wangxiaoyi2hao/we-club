//
//  followViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "followViewController.h"
#import "AppDelegate.h"
#import "FollowTableViewCell.h"
#import "InfoTableViewController.h"
extern UserInfo*LoginUserInfo;
@interface followViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestBar;//获取我关注的酒吧
    ASIFormDataRequest*_requestMan;//获取我关注的人
    Response10009*response10009;
    Response10010*response10010;

}
@end

@implementation followViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // _barOrPeople = NO;
    UIView *view = [UIView new];
    self.tableView.tableFooterView = view;
//    NSArray *array=@[@"关注的酒吧",@"关注的人"];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    //获取关注的人列表
    [self requestManList];
    [[Tostal sharTostal]showLoadingView:@"客官不要着急"];
    //返回按钮
    [self loadNav];
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(followPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)followPopView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//获取关注的人
-(void)requestManList{
     [_requestBar clearDelegatesAndCancel];
    Request10010*request10010=[[Request10010 alloc]init];
    //设置请求参数
    request10010.common.userid=LoginUserInfo.user_id;
    request10010.common.userkey=LoginUserInfo.user_key;
    request10010.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request10010.common.version=@"1.0.0";//版本号
    request10010.common.platform=2;//ios  andriod
    request10010.common.cmdid=10010;
    
    NSData*data= [request10010 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getMyFollowUser",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestMan = [ASIFormDataRequest requestWithURL:url];
    [_requestMan setPostBody:(NSMutableData*)data];
    [_requestMan setDelegate:self];
    //请求延迟时间
    _requestMan.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestMan.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestMan.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestMan.secondsToCache=3600;
    [_requestMan startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{

       response10010=[Response10010 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response10010.data_p.briefUsersArray);
        NSLog(@"%li",response10010.data_p.briefUsersArray_Count);
        NSLog(@"%i",response10010.common.code);//每一次请求都可以用这个属性判断是否返回成功
        if (response10010.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"网络出现错误" tostalTime:1];
        }
//    }
    [[Tostal sharTostal]hiddenView];
    [_tableView reloadData];
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:2];
       [[Tostal sharTostal]hiddenView];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    
     NSLog(@"%ld",response10010.data_p.briefUsersArray.count);
        return response10010.data_p.briefUsersArray.count;
    

 
}

//
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

#pragma mark 写到这个位置了
        //设置一个静态变量
        static NSString *iden = @"FollowTableViewCell";
        FollowTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            cell = [[FollowTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:iden];
        }
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        BriefUser*user=[response10010.data_p.briefUsersArray objectAtIndex:indexPath.row];
        [cell.picture sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",user.avatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
        cell.nickname.text =user.username;
        cell.message.text = [HelperUtil isDefault:user.signature];
        if (user.sex==1) {
            [cell._imageViewSex setImage:[UIImage imageNamed:@"邀约-男性.png"]];
        }else{
            [cell._imageViewSex setImage:[UIImage imageNamed:@"邀约-女性.png"]];
        }
       [cell.buttonHead addTarget:self action:@selector(buttonHeadClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.buttonHead.tag=indexPath.row;
        return cell;
}
-(void)buttonHeadClick:(UIButton*)sender{
    BriefUser*friendsOO=[response10010.data_p.briefUsersArray objectAtIndex:sender.tag];
    UIStoryboard *redStoryboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *redVC = [redStoryboard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    redVC.fromUserId=friendsOO.userid;
    [self.navigationController pushViewController:redVC animated:YES];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{

        return 60.0;
}
-(void)viewWillDisappear:(BOOL)animated{

    [_requestBar clearDelegatesAndCancel];
    [_requestMan clearDelegatesAndCancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
