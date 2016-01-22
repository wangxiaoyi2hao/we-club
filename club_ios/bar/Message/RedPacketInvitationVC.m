//
//  RedPacketInvitationVC.m
//  bar
//
//  Created by chen on 15/11/21.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "RedPacketInvitationVC.h"
#import "MyAlertView.h"
extern UserInfo*LoginUserInfo;
@interface RedPacketInvitationVC ()<ASIHTTPRequestDelegate>
{
    NSTimer *_timer;
    NSTimer *_timer1;
    int _index;
    ASIFormDataRequest*_reuqestCompleteThisInvite;
}

@end

@implementation RedPacketInvitationVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _stopButton.hidden = YES;
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    if (KScreenHeight == 480) {
        _leftImageView.layer.cornerRadius = 55;//边框圆角
        _rightImageView.layer.cornerRadius = 55;//边框圆角
        _scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight*1.4);
        _scrollView.contentOffset = CGPointMake(0, 0.2*KScreenHeight);
    }else if(KScreenHeight == 568){
        _leftImageView.layer.cornerRadius = 55;//边框圆角
        _rightImageView.layer.cornerRadius = 55;//边框圆角
    }else if(KScreenHeight == 667){
        _leftImageView.layer.cornerRadius = 63;//边框圆角
        _rightImageView.layer.cornerRadius = 63;//边框圆角
    }else{
        _leftImageView.layer.cornerRadius = 70;//边框圆角
        _rightImageView.layer.cornerRadius = 70;//边框圆角
    }
    _leftImageView.layer.borderWidth = 5;//边框线宽度
    //给色值
    _leftImageView.layer.borderColor = [HelperUtil colorWithHexString:@"e43f6d"].CGColor;
    _successLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
    _timerLabel.textColor = [HelperUtil colorWithHexString:@"e43f6d"];
    _leftImageView.layer.masksToBounds = YES;
    _rightImageView.layer.borderWidth = 5;//边框线宽度
    _rightImageView.layer.borderColor = [HelperUtil colorWithHexString:@"e43f6d"].CGColor;
    _rightImageView.layer.masksToBounds = YES;
    [self loadNav];
}
//完成邀约的网络请求方法在alterview的闭包里面调用这个网络请求方法
-(void)refreshClubBanner{
    //这个是问题 如果我按照哪些排序 是不是 他就默认给我排序的下面的数据
    //banner这里的数
    Request12011*request12011=[[Request12011 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/doneInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestCompleteThisInvite = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request12011.common.userid=LoginUserInfo.user_id;
    request12011.common.userkey=LoginUserInfo.user_id;
    request12011.common.cmdid=11001;//现在标注为假数据
    request12011.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request12011.common.version=@"1.0.0";
    request12011.params.inviteid=_fromInviteID;
    request12011.params.progressTime=_index/60;
    NSData*data= [request12011 data];
    [_reuqestCompleteThisInvite setPostBody:(NSMutableData*)data];
    [_reuqestCompleteThisInvite setDelegate:self];
    //请求延迟时间_reuqestCompleteThisInvite    _reuqestClubBanner.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestCompleteThisInvite.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestCompleteThisInvite.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestCompleteThisInvite.secondsToCache=3600;
    [_reuqestCompleteThisInvite startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    Response12011*response12011 = [Response12011 parseFromData:request.responseData error:nil];
    
    if (response12011.common.code==0) {
        [[Tostal sharTostal]tostalMesg:@"顺利完成邀约" tostalTime:1];
    }





}
- (IBAction)startAction:(UIButton *)sender {
    NSDate *date1 = [[NSDate alloc]init];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:date1 forKey:@"startTime"];
    NSLog(@"%@",date1);
    [defaults synchronize];
    _startButton.hidden = YES;
    _stopButton.hidden = NO;
    if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:1
                                                  target:self
                                                selector:@selector(timeAction:)
                                                userInfo:nil
                                                 repeats:YES];
        NSLog(@"向后台传一个startTime");
        
    }else{
        
        NSLog(@"邀约已经开始");
    }
//    //开启多线程
//    dispatch_queue_t mainQueue = dispatch_get_main_queue();
//    //异步添加任务
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        if (_timer ==nil) {
//            _timer = [NSTimer timerWithTimeInterval:1.0f target:self selector:@selector(timeAction:) userInfo:nil repeats:YES];
//           
//        }else{
//            
//            NSLog(@"邀约已经开始");
//        }
//    //回到主线程
//    dispatch_async(mainQueue, ^{
//        [[NSRunLoop mainRunLoop] addTimer:_timer forMode:NSRunLoopCommonModes];
////        _timerLabel.text=[self coverTime:_index1];
//    });
//});
}
- (void)viewWillDisappear:(BOOL)animated{
    //停止定时器
    [_timer invalidate];
    [_timer1 invalidate];
}
- (IBAction)stopAction:(UIButton *)sender {
    
    MyAlertView *alertView = [[MyAlertView alloc]
                              initWithTitle:@"温馨提示"
                              message:@"确实要停止邀约吗?"
                              cancelButtonTitle:@"取消"
                              otherButtonTitles:@"确定"
                              clickBlock:^(NSInteger index, UIAlertView *alertView) {
                                  if (index == 0) {
                                      NSLog(@"取消");
                                  }else if (index == 1) {
                                      _stopButton.hidden = YES;
                                      _startButton.hidden = NO;
                                      [_timer invalidate];
                                      [self.navigationController popToRootViewControllerAnimated:YES];
                                      NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                                      [defaults setObject:nil forKey:@"startTime"];
                                      [defaults synchronize];
                                      
                                  }
                              }];
    [alertView show];
}
//定时器方法,每个1秒调用一次
- (void)timeAction:(NSTimer *)timer
{
    _index ++;
    NSLog(@"%d",_index);
    _timerLabel.text = [self timeFormatted:_index];
    if (_index == 600) {
        //停止定时器
        [timer invalidate];
    }
}

- (NSString *)timeFormatted:(int)totalSeconds
{
    
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d",hours, minutes, seconds];
}
- (void)viewWillAppear:(BOOL)animated{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDate *date1 = [defaults objectForKey:@"startTime"];
    NSLog(@"%@",date1);
    NSDate *date2 = [NSDate date];
    //获取两个日期的时间间隔:date2 - date1
    NSTimeInterval time0 = [date2 timeIntervalSinceDate:date1];
    if (date1 != nil) {
        _startButton.hidden = YES;
        _stopButton.hidden = NO;
        _index = time0;
        _timer1 = [NSTimer scheduledTimerWithTimeInterval:1
                                                   target:self
                                                 selector:@selector(timeAction:)
                                                 userInfo:nil
                                                  repeats:YES];
    }

}

-(void)loadNav{

    self.title=@"邀约ing";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(lastThisView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;

}
-(void)lastThisView{

    [self.navigationController popViewControllerAnimated:YES];
}

@end
