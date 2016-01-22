//
//  ReportViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/6.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ReportViewController.h"
#import "ReportTableViewCell.h"
#import "Tostal.h"
#import "AppDelegate.h"
#import "ReportSuccessViewController.h"
extern UserInfo*LoginUserInfo;
@interface ReportViewController ()<ASIHTTPRequestDelegate>
{

    NSMutableArray*_reportArray;
    int isSelect;
    ASIFormDataRequest*_reuqesReport;
    ASIFormDataRequest*_requestReportMan;
    NSMutableArray*sendArray;
    NSString*sendSTR;//举报要传的内容，，这里还有问题，可能现在是传过去的是选择的最后一个或者是第一个，如果要是改变的话再说。

}
@end

@implementation ReportViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
       [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    _reportArray=[NSMutableArray arrayWithObjects:@"诽谤辱骂",@"淫秽色情",@"垃圾广告",@"血腥暴力",@"欺诈（酒托，话费托等骗钱行为）",@"违法行为（涉毒，暴恐，违禁品等）", nil];
    isSelect=0;
    [self loadNav];
    sendArray=[NSMutableArray array];
    

}
-(void)loadNav{
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
-(void)popView1{


    [self.navigationController popViewControllerAnimated:YES];
}
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{


     return @"请告诉我们您想举报的理由";

}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    
    return 47.5*app.autoSizeScaleY;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{


    return _reportArray.count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    ReportTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"ReportTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    NSString*reportStr=[_reportArray objectAtIndex:indexPath.row];
    cell.lbWhy.text=reportStr;
  
    [cell.buttonWhy setImage:[UIImage imageNamed:@"2-4-2.png"] forState:UIControlStateNormal];
    //选中状态图片
    [cell.buttonWhy setImage:[UIImage imageNamed:@"reportball.jpg"] forState:UIControlStateSelected];
 
    [cell.buttonWhy addTarget:self action:@selector(whyClick:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonWhy.tag=indexPath.row;
    return cell;
    
    
}
-(void)whyClick:(UIButton*)sender{
    sender.selected=!sender.selected;
    if (sender.selected) {
        
      [ sendArray addObject:[_reportArray objectAtIndex:sender.tag]];
    }else{
    
        [sendArray removeObject:[_reportArray objectAtIndex:sender.tag]];
    }
    
}
-(IBAction)reportClick:(id)sender{
    if (_whereIsCome==1) {
        [self requestManReport];
      
    }else{
        [self requestSearchReport];
    }
  
}
#pragma mark 举报方法
-(void)requestSearchReport{
    
    //这里写的这些东西是为了把我们选中的举报人传给后台
    if (sendArray.count==1) {
        sendSTR=[NSString stringWithFormat:@"%@",[sendArray objectAtIndex:0]];
    }else if (sendArray.count==2){
    sendSTR=[NSString stringWithFormat:@"%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1]];
    }else if (sendArray.count==3){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2]];

    }else if (sendArray.count==4){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3]];
        
    }else if (sendArray.count==5){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:4]];
        
    }else if (sendArray.count==6){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:3],[sendArray objectAtIndex:5]];
        
    }else if (sendArray.count==7){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:3],[sendArray objectAtIndex:5],[sendArray objectAtIndex:6]];
        
    }else if (sendArray.count==8){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:3],[sendArray objectAtIndex:5],[sendArray objectAtIndex:6],[sendArray objectAtIndex:7]];
        
    }
 
    Request12006*request12006=[[Request12006 alloc]init];
    //设置请求参数
    request12006.common.userid=LoginUserInfo.user_id;
    request12006.common.userkey=LoginUserInfo.user_key;
    request12006.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12006.common.version=@"1.0.0";//版本号
    request12006.common.platform=2;//ios  andriod
    request12006.params.inviteId=_fromInviteID;//举报人的id'
    request12006.params.reason=sendSTR;//举报的内容
    //下面还可能有上传图片的内容
    NSData*data= [request12006 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/reportInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqesReport = [ASIFormDataRequest requestWithURL:url];
    [_reuqesReport setPostBody:(NSMutableData*)data];
    [_reuqesReport setDelegate:self];
    //请求延迟时间
    _reuqesReport.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqesReport.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqesReport.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqesReport.secondsToCache=3600;
    [_reuqesReport startAsynchronous];
    
}

-(void)requestManReport{
    
    //这里写的这些东西是为了把我们选中的举报人传给后台
    if (sendArray.count==1) {
        sendSTR=[NSString stringWithFormat:@"%@",[sendArray objectAtIndex:0]];
    }else if (sendArray.count==2){
        sendSTR=[NSString stringWithFormat:@"%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1]];
    }else if (sendArray.count==3){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2]];
        
    }else if (sendArray.count==4){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3]];
        
    }else if (sendArray.count==5){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:4]];
        
    }else if (sendArray.count==6){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:3],[sendArray objectAtIndex:5]];
        
    }else if (sendArray.count==7){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:3],[sendArray objectAtIndex:5],[sendArray objectAtIndex:6]];
        
    }else if (sendArray.count==8){
        sendSTR=[NSString stringWithFormat:@"%@,%@,%@,%@,%@,%@,%@,%@",[sendArray objectAtIndex:0],[sendArray objectAtIndex:1],[sendArray objectAtIndex:2],[sendArray objectAtIndex:3],[sendArray objectAtIndex:3],[sendArray objectAtIndex:5],[sendArray objectAtIndex:6],[sendArray objectAtIndex:7]];
        
    }
    
    Request12004*request12004=[[Request12004 alloc]init];
    //设置请求参数
    request12004.common.userid=LoginUserInfo.user_id;
    request12004.common.userkey=LoginUserInfo.user_key;
    request12004.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12004.common.version=@"1.0.0";//版本号
    request12004.common.platform=2;//ios  andriod
    request12004.params.userIdReported=_fromUserID;//举报人的id'
    request12004.params.content=sendSTR;//举报的内容
    //下面还可能有上传图片的内容
    NSData*data= [request12004 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/reportUser",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestReportMan = [ASIFormDataRequest requestWithURL:url];
    [_requestReportMan setPostBody:(NSMutableData*)data];
    [_requestReportMan setDelegate:self];
    //请求延迟时间
    _requestReportMan.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestReportMan.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestReportMan.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestReportMan.secondsToCache=3600;
    [_requestReportMan startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([request isEqual:_reuqesReport]) {
        Response12006*response=[Response12006 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        ReportSuccessViewController*controller=[[ReportSuccessViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        [[Tostal sharTostal]tostalMesg:@"举报成功" tostalTime:1];
        
    }
    if ([request isEqual:_requestReportMan]) {
        Response12004*reponse=[Response12004 parseFromData:request.responseData error:nil];
        NSLog(@"%i",reponse.common.code);
        ReportSuccessViewController*controller=[[ReportSuccessViewController alloc]init];
        [self.navigationController pushViewController:controller animated:YES];
        [[Tostal sharTostal]tostalMesg:@"举报成功" tostalTime:1];
    }
    
}
-(void)viewWillDisappear:(BOOL)animated{

    [_reuqesReport clearDelegatesAndCancel];
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
