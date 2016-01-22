//
//  RegisterFinalViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "RegisterFinalViewController.h"
#import "UIDevice+IdentifierAddition.h"

@interface RegisterFinalViewController ()
{
    ASIFormDataRequest*_request;


}
@end

@implementation RegisterFinalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)requestUrl{
    Request10001*request=[[Request10001 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/register",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=@"1";
    request.common.userkey=@"";
    request.common.cmdid=1;//现在标注为假数据
    request.common.timestamp=2;//现在标注为真数据
    request.params.phoneNumber=_tfAccount.text;
    request.params.md5Psw=_tfPwd.text;
//    request.params.sex=1;//1是男的2是女的
//    request.params.birthday=_tfBirthday.text;
    request.params.diviceNumber=[[UIDevice currentDevice] uniqueGlobalDeviceIdentifier];
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
