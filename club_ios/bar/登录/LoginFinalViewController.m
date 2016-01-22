//
//  LoginFinalViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "LoginFinalViewController.h"
#import "Tostal.h"
#import "UserInfo.h"
#import "MyFile.h"
#import "FindsViewController.h"
#import "BarTabBarController.h"



extern UserInfo*LoginUserInfo;
@interface LoginFinalViewController ()<ASIHTTPRequestDelegate>
{
  ASIFormDataRequest *_request;
    //18810278575
    //xiang2491147
    Response10002 * response10002;

}
@end

@implementation LoginFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //制作导航条
    [self loadNav];
    // Do any additional setup after loading the view from its nib.
}
//导航条方法
-(void)loadNav{
    self.title=@"登录";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView1{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];

}
//登录 ～～～～～～～～～～～～～～～～～～～
//网络请求事件
-(void)requestUrl{
    Request10002*request=[[Request10002 alloc]init];

    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/login",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
//    request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳
    request.params.md5Psw=_tfPwd.text;//密码
    request.params.account=_tfAccount.text;//账号
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
    //（2）创建manager
    
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    

    response10002 = [Response10002 parseFromData:request.responseData error:nil];
    if (response10002.common.code!=0) {
        [[Tostal sharTostal]tostalMesg:@"账号密码错误" tostalTime:1];
    }else{
        NSLog(@"%@", response10002.data_p.name);
        UserInfo*user=[[UserInfo alloc]init];
        user.user_id=response10002.data_p.userid;
        user.user_name=response10002.data_p.name;
        user.user_key=response10002.data_p.key;
        user.user_sex=response10002.data_p.sex;
        user.sessionkey=response10002.data_p.sessionkey;
        user.rongYunTOken=response10002.data_p.rongyunToken;
//        user.rongYunTOken=response10002.data_p.qiniuToken;
        LoginUserInfo=user;
        [NSKeyedArchiver archiveRootObject:user toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
        BarTabBarController *rooCtrl = [[BarTabBarController alloc] init];
        rooCtrl.view.layer.transform = CATransform3DMakeScale(.5, .5, 0);
        self.view.window.rootViewController = rooCtrl;
        [UIView animateWithDuration:.5 animations:^{
            rooCtrl.view.layer.transform = CATransform3DIdentity;
        }];
        

    }
   
}
- (void)requestFailed:(ASIHTTPRequest *)request{


    NSLog(@"%@",request.error);
}
-(IBAction)enterSucess:(id)sender{
//    NSString*accountStr=[_tfAccount text];
//    NSString*pwdStr=[_tfPwd text];
//    [self requestUrl];
       [self requestUrl];
   
 

    
  //判断此账号已经注册
    
//    if ([accountStr isEqualToString:@""]) {
//        [[Tostal sharTostal]tostalMesg:@"账号不能为空" tostalTime:1];
//    }else if ([pwdStr isEqualToString:@""]){
//        [[Tostal sharTostal]tostalMesg:@"密码不能为空" tostalTime:1];
//        
//    }else{
//        UserInfo*userInfo=[[DBUser shareDBUser]selectUserInfo:accountStr fromPwd:pwdStr];
//        if (userInfo!=nil) {
//            [[Tostal sharTostal]tostalMesg:@"登录成功" tostalTime:1];
//           =userInfo;
//            [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//            
//        }else{
//            
//            
//            [[Tostal sharTostal]tostalMesg:@"账号密码错误" tostalTime:1];
//        }
//        
//        
//    }
//    
    
    
}

- (void)didReceiveMemoryWarning {
 
    [super didReceiveMemoryWarning];
    [_request setDelegate:nil];
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
