//
//  UpdateNameViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "UpdateNameViewController.h"
#import "AppDelegate.h"

@interface UpdateNameViewController ()<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest*_request;//更换酒吧聊天室名称

}
@end

@implementation UpdateNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
    _tfName.text=_myName;
    [self loadNav];
    
    // Do any additional setup after loading the view from its nib.
}
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
    
    UIButton*rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 15)];
    [rightButton addTarget:self action:@selector(success) forControlEvents:UIControlEventTouchUpInside];
    rightButton.titleLabel.tintColor=[UIColor greenColor];
    rightButton.titleLabel.font=[UIFont systemFontOfSize:16];
    [rightButton setTitle:@"保存" forState:UIControlStateNormal];
    UIBarButtonItem*rightbarButtonItem=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem=rightbarButtonItem;
}
-(void)requestUrlPhotoLike{
    Request11011*request=[[Request11011 alloc]init];
    //设置请求参数
    request.common.userid=@"1";
    request.common.userkey=@"";
    request.common.cmdid=1;//现在标注为假数据
    request.common.timestamp=2;//现在标注为真数据
    request.params.chatroomId=@"1";
    request.params.username=_tfName.text;
    
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/changeChatroomUsername",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    NSData*data= [request data];
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
    //（2）创建manager
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_request]) {
        Response11011 * response = [Response11011 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//用code判断是否成功
    }
       [self.navigationController popViewControllerAnimated:YES];
}
-(void)popView1{
    
    [self requestUrlPhotoLike];
    [self.navigationController popViewControllerAnimated:YES];

}
-(void)success{
//调用网络请求事件
     [self requestUrlPhotoLike];

}

-(void)viewDidAppear:(BOOL)animated{

    [_tfName becomeFirstResponder];

}
-(void)viewWillDisappear:(BOOL)animated{
    [_request clearDelegatesAndCancel];
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
