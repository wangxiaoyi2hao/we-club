//
//  settingViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//设置 界面
#import "settingViewController.h"
#import "UserInfo.h"
#import "Tostal.h"
#import "MyFile.h"
#import "LoginVC.h"
#import "GuideViewController.h"
#import "AppDelegate.h"
#import "CreatGroupViewController.h"
#import "UIView+UiViewConctroller.h"
#import "ChatViewController.h"
#import "GroupViewController.h"
#import "OneBarViewController.h"
#import "GuideGOViewController.h"

extern UserInfo*LoginUserInfo;
@interface settingViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_request;

}
@end

@implementation settingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    //取消单元格分割线
    self.tableView.separatorStyle = NO;
    NSString*downLoadCacheTex=[NSString stringWithFormat:@"%.0fM",            [[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
    _cacheLabel.text=downLoadCacheTex;
    NSLog(@"%@",downLoadCacheTex);
    //返回按钮
    [self loadNav];
}

-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(settingPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)settingPopView{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Navigation


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 10;
    }else if(section == 4){
        return 100;
    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return 44*app.autoSizeScaleY;
}

- (IBAction)securityBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"settingToSetting" sender:nil];
}

- (IBAction)bindingBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"settingToBinding" sender:nil];
}

- (IBAction)messageBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"settingToMessage" sender:nil];
}

- (IBAction)blackListBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"settingToBlackList" sender:nil];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   
    if (indexPath.section==3) {
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
            [[ASIDownloadCache sharedCache]clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
            NSString*downLoadCacheTex2=[NSString stringWithFormat:@"%.0fM",  [[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
            _cacheLabel.text=downLoadCacheTex2;
            [self.tableView reloadData];
            [[Tostal sharTostal]tostalMesg:@"清楚缓存成功" tostalTime:1];
        }];

    }

}
#pragma mark 这是退出登录要调用的接口方法
-(void)requestFansList{
    Request10011*request10011=[[Request10011 alloc]init];
    //设置请求参数
    request10011.common.userid=LoginUserInfo.user_id;
    request10011.common.userkey=LoginUserInfo.user_key;
    request10011.common.timestamp=2;//现在标注为真数据
    request10011.common.version=@"1.0.0";//版本号
    request10011.common.platform=2;//ios  andriod
    request10011.params.md5Psw=LoginUserInfo.user_pwd;//退出登录的时候要传进去一个密码
    NSData*data= [request10011 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/logout",REQUESTURL];
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
        Response10011*response=[Response10011 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//用这个判断是否退出成功0成功
    }
}
- (IBAction)exitBtnClick:(UIButton *)sender {

    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:@"确定退出？" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"确定退出", nil];
    actionSheet.tag=20;
    [actionSheet showInView:self.view];
    NSLog(@"你点击了退出按钮");
}
+(settingViewController *)shareSetting{
    
    static settingViewController* shareSetting = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        shareSetting = [[[self class] alloc] init];
    });
    
    return shareSetting;
    
}

/**
 网络状态变化。
 @param status 网络状态。
 */
-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status {
    NSLog(@"RCConnectionStatus = %ld",(long)status);
    if (status == ConnectionStatus_KICKED_OFFLINE_BY_OTHER_CLIENT) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"您的帐号已在别的设备上登录，\n您被迫下线！" delegate:self cancelButtonTitle:nil otherButtonTitles:@"知道了",nil, nil];
        [alert show];
        
    }
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0) {
        LoginUserInfo=nil;
        [[Tostal sharTostal]tostalMesg:@"注销成功" tostalTime:1];
        [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
        [self.view.viewController.navigationController  popToRootViewControllerAnimated:YES] ;
        GuideViewController*controller=[[GuideViewController alloc]init];
        controller.fromOutClub=1;
        [self.view.viewController presentViewController:controller animated:NO completion:nil];
        self.tabBarController.selectedIndex=0;
        }
}
//清楚缓存事件放到这个位置 留着备用
-(void)downLoadCache{
    NSString*downLoadCacheTex=[NSString stringWithFormat:@"%.0fM",            [[SDImageCache sharedImageCache]getSize]/1024.0/1024.0];
    NSLog(@"%@",downLoadCacheTex);
        [[SDImageCache sharedImageCache]clearDiskOnCompletion:^{
        [[ASIDownloadCache sharedCache]clearCachedResponsesForStoragePolicy:ASICacheForSessionDurationCacheStoragePolicy];
        [[Tostal sharTostal]tostalMesg:@"清楚缓存成功" tostalTime:1];
    }];

    

}
//actionSheet要监听的事件
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag==20) {
        if (buttonIndex==0) {
            LoginUserInfo=nil;
            [[Tostal sharTostal]tostalMesg:@"注销成功" tostalTime:1];
            [NSKeyedArchiver archiveRootObject:LoginUserInfo toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
            [self.navigationController popToRootViewControllerAnimated:YES] ;
            GuideGOViewController*controller=[[GuideGOViewController alloc]init];
//            controller.fromOutClub=1;
            [self.navigationController presentViewController:controller animated:NO completion:nil];
            self.tabBarController.selectedIndex=0;
//            [[ChatViewController shareChat].conversationDataRepository removeAllObjects];
//            [[GroupViewController shareGroup].conversationDataRepository removeAllObjects];
//            [[OneBarViewController shareChatRoom].conversationDataRepository removeAllObjects];

            //退出融云
            [[RCIM sharedRCIM] logout];
        }
        
    }


}
@end
