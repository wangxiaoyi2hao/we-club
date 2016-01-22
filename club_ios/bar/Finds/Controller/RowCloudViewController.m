//
//  RowCloudViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/4.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "RowCloudViewController.h"

extern UserInfo*LoginUserInfo;
@interface RowCloudViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestBarList;
}
@end

@implementation RowCloudViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 获取酒吧列表
-(void)requestSearchFriend{
    NSMutableDictionary*dictionary=[[NSMutableDictionary alloc]init];
    [dictionary setObject:@"111" forKey:@"weclub"];
    [dictionary writeToFile:[MyFile fileByDocumentPath:@"loginIsOk.plist"] atomically:YES];

    Request12009*request12009=[[Request12009 alloc]init];
    //设置请求参数
    request12009.common.userid=LoginUserInfo.user_id;
    request12009.common.userkey=LoginUserInfo.user_key;
    request12009.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12009.common.version=@"1.0.0";//版本号
    request12009.common.platform=2;//ios  andriod
    request12009.params.latitude=LoginUserInfo.latitude;
    request12009.params.longitude=LoginUserInfo.longitude;//举报的内容
    //下面还可能有上传图片的内容
    NSData*data= [request12009 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/getInviteClubs",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestBarList = [ASIFormDataRequest requestWithURL:url];
    [_requestBarList setPostBody:(NSMutableData*)data];
    [_requestBarList setDelegate:self];
    //请求延迟时间
    _requestBarList.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestBarList.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestBarList.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestBarList.secondsToCache=3600;
    [_requestBarList startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestBarList]) {
        Response12009*response=[Response12009 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//是否成功成了提示一个窗口
        NSLog(@"%@",response.data_p.inviteClubsArray);
        [[Tostal sharTostal]tostalMesg:@"举报成功" tostalTime:1];
    }
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
