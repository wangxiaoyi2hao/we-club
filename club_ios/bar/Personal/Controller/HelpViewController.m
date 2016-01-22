//
//  HelpViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/4.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//帮助界面
#import "HelpViewController.h"
#import "FunctionViewController.h"
#import "AboutViewController.h"
#import "AppDelegate.h"
extern UserInfo*LoginUserInfo;
@interface HelpViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestCheck;
    NSString*updateUrl;
    NSString*updateNumber;

}
@end

@implementation HelpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    [self.tableView setBackgroundColor:[HelperUtil colorWithHexString:@"efefef"]];
    //添加头视图
    [self addHeadView];
    //返回按钮
    [self loadNav];
    self.tableView.scrollEnabled=NO;
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(HellpPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)HellpPopView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

//添加头视图
- (void) addHeadView{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 135)];
    headView.backgroundColor = BackgroundColor;
    UIImageView *headImgView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"背景图.png"]];
    headImgView.frame = CGRectMake(0, 0, KScreenWidth, 135);
//    //版本号
//    UILabel *editionLabel = [[UILabel alloc] initWithFrame:CGRectMake((KScreenWidth-90)/2.0, 100, 90, 20)];
//    NSString *str = [NSString stringWithFormat:@"WECLUB 1.0.0"];
//    
//    editionLabel.text = str;
//    editionLabel.textAlignment = NSTextAlignmentCenter;
//    editionLabel.font = [UIFont systemFontOfSize:10];
//    [headView addSubview:editionLabel];
    [headView addSubview:headImgView];
    self.tableView.tableHeaderView = headView;
    self.view.backgroundColor = BackgroundColor;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return 44*app.autoSizeScaleY;
}

//检查版本更新的网络请求方法
-(void)requestUrlCheckVersion{
    Request14001*request14001=[[Request14001 alloc]init];
    //设置请求参数
    request14001.common.userid=LoginUserInfo.user_id;
    request14001.common.userkey=LoginUserInfo.user_key;
    request14001.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request14001.common.version=@"1.0.0";//版本号
    request14001.common.platform=2;//ios  andriod
    //NSLog(@"%@",_proposalText.text);
        //下面还可能有上传图片的内容
    
    NSData*data= [request14001 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@appAction/checkUpdate",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    _requestCheck = [ASIFormDataRequest requestWithURL:url];
    [_requestCheck setPostBody:(NSMutableData*)data];
    [_requestCheck setDelegate:self];
    //请求延迟时间
    _requestCheck.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestCheck.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestCheck.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestCheck.secondsToCache=3600;
    [_requestCheck startAsynchronous];

}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestCheck]) {
        Response14001*response=[Response14001 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        updateUrl=response.data_p.downloadURL;
        updateNumber=response.data_p.lastedVersion;
        
        NSLog(@"%@,%@,%i",updateUrl,updateNumber,response.data_p.updateState);
    }



}
- (IBAction)evaluateBtnClick:(id)sender {
    NSString *str = [NSString stringWithFormat:@"https://itunes.apple.com/cn/app/ga-kua-jie/id%@?l=en&mt=8",@"885728331"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
    NSLog(@"你点击了评分按钮");
    //ios8之后
 
}

- (IBAction)introductionBtnClick:(UIButton *)sender {
    FunctionViewController *functionVC = [[FunctionViewController alloc] init];
    [self presentViewController:functionVC animated:YES completion:nil];
}

- (IBAction)commentBtnClick:(UIButton *)sender {
    [self performSegueWithIdentifier:@"HelpToFeedback" sender:nil];
    
}

- (IBAction)updateBtnClick:(UIButton *)sender {
//版本更新  思路 取我们xcode的version－－
    NSLog(@"你点击了版本更新按钮");
    [self requestUrlCheckVersion];
    //ios应用版本更新
    [self versionButton];
}

- (IBAction)aboutBtnClick:(UIButton *)sender {
    AboutViewController *aboutVC = [[AboutViewController alloc] init];
    [self presentViewController:aboutVC animated:YES completion:nil];
    
    NSLog(@"你点击了关于按钮");
}



//版本更新的地方有两种方法  我也不知道哪一种方法好 ，所以现在也不能肯定的去用哪一种方法，那么现在就是十分的难受 卧槽 

#pragma mark - 版本更新
- (void)versionButton{
    //获取发布版本的Version
    NSString *string = [NSString stringWithContentsOfURL:[NSURL URLWithString:updateUrl] encoding:NSUTF8StringEncoding error:nil];
    
    if (string !=nil && string.length >0 &&[string rangeOfString:@"version"].length ==7) {
        [self checkAppUpDate:string];
    }
}
- (void)checkAppUpDate:(NSString *)appInfo{
    //获取当前版本
    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBbudleVersion"];
    NSString *appInfo1 = [appInfo substringFromIndex:[appInfo rangeOfString:@"\"version\":"].location+10];
    appInfo1 = [[appInfo1 substringToIndex:[appInfo1 rangeOfString:@","].location] stringByReplacingOccurrencesOfString:@"\"" withString:@""];
    //网络请求方法得到app版本～～－－－－－－用网络请求得到的app版本与当前版本匹配结合 判断也就是appinfo1参数的判断
    //判断,如果当前版本与发布的版本不相同,则进入更新,如果相等,那么当前就是最高版本
    if (![appInfo1 isEqualToString:version]) {
        NSLog(@"新版本:%@,当前版本%@",appInfo1,version);
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:[NSString stringWithFormat:@"新版本%@已发布!",appInfo1] delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        alert.delegate = self;
        [alert addButtonWithTitle:@"前往更新"];
        [alert show];
        alert.tag = 20;
        
    }else{
        UIAlertView *alertView =[[UIAlertView alloc] initWithTitle:nil message:@"已是最新版本" delegate:self cancelButtonTitle:@"知道了" otherButtonTitles:nil];
        [alertView show];
    }
}
- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex{
    if (buttonIndex ==1&alertView.tag == 20) {
        NSString *url =updateUrl;
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    }
}

@end
