//
//  OneBarViewController.m
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "OneBarViewController.h"
#import "SponsoredGroupVC.h"//发起小组
#import "SummaryViewController.h"//酒吧简介
#import "MemberTableVC.h"//聊天室成员
#import "BarProductionViewController.h"
#import "ASIFormDataRequest.h"
#import "GPBMessage.h"
#import "ASIDownloadCache.h"
#import "ClubVclub.pbobjc.h"
#import "Common.pbobjc.h"
#import "CreatGroupViewController.h"
#import "InfoTableViewController.h"
extern UserInfo*LoginUserInfo;
@interface OneBarViewController ()<ASIHTTPRequestDelegate>
{

     ASIFormDataRequest *_request;
    //签到之后所要返回的事件
     ASIFormDataRequest *_requestLater;
    UIButton * RegistrationBtn ;//签到的按钮
    UILabel * RegistrationLabel ;//签到的label
}
@end

@implementation OneBarViewController
+(OneBarViewController *)shareChatRoom{
    
    static OneBarViewController* shareChatRoom = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        shareChatRoom = [[[self class] alloc] init];
    });
    
    return shareChatRoom;
    
}
- (void)viewWillAppear:(BOOL)animated{
    //设置头像样式
    [self setMessageAvatarStyle:RC_USER_AVATAR_CYCLE];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
   [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    //设置是否显示竖向滚动条
    self.conversationMessageCollectionView.showsVerticalScrollIndicator=NO;
    self.conversationMessageCollectionView.frame = CGRectMake(0, 108, KScreenWidth, KScreenHeight-108-49);

    [self initNavBar];
    //发起小组和签到
    [self sponsoredGroupAndRegistration];
    [self requestUrlafterLater];
//       [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(refreshUserHead) name:@"refreshUserHeadThanks" object:nil];
}
//-(void)refreshUserHead{
//    [self.conversationMessageCollectionView reloadData];
//
//}
#pragma mark-Navbar
//设置导航栏
-(void)initNavBar{
//    self.navigationItem.title = @"满城酒吧";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //右侧两个按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25,25)];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.tag = 0;
    [rightButton setBackgroundImage:[UIImage imageNamed:@"2-3-1.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(popView1:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rigthbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    UIButton * rightButton2 = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    rightButton2.backgroundColor = [UIColor clearColor];
    [rightButton2 setBackgroundImage:[UIImage imageNamed:@"2-3-2.png"] forState:UIControlStateNormal];
    rightButton2.tag = 1;
    [rightButton2 addTarget:self action:@selector(popView1:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * rightbarbuttonitem2 = [[UIBarButtonItem alloc]initWithCustomView:rightButton2];
    
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:rigthbarbuttonitem,rightbarbuttonitem2, nil];

    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1:) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView1:(UIButton *)btn{
    NSInteger idnex = btn.tag;
    if(idnex == 2){
        
        
//        //退出聊天室
//        [[RCIMClient sharedRCIMClient] quitChatRoom:self.targetId success:^{
//            NSLog(@"退出聊天室成功");
//        } error:^(RCErrorCode status) {
//            NSLog(@"退出聊天室失败");
//        }];
        
        
    
        //回到club界面
        [self.navigationController popViewControllerAnimated:YES];
        
    }else if(idnex == 1){

        //跳转到聊天室成员界面
        UIStoryboard * memberTableVCSB = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        MemberTableVC * memberTableVC= [memberTableVCSB instantiateViewControllerWithIdentifier:@"MemberTableVCID"];
        memberTableVC.fromUserId=_fromClubId;
        [self.navigationController pushViewController:memberTableVC animated:NO];
    }else{
        //跳转到酒吧介绍界面
//        SummaryViewController * view= [[SummaryViewController alloc]init];
        BarProductionViewController*controller=[[BarProductionViewController alloc]init];
        controller.fromUserId=_fromClubId;
        [self.navigationController pushViewController:controller animated:NO];
    }
}
/**
 *  获取最新消息记录。
 *
 *  @param conversationType 会话类型。
 *  @param targetId         目标 Id。
 *  @param count            要获取的消息数量。
 *
 *  @return 最新消息记录，按照时间顺序从新到旧排列。
 */
//- (NSArray *)getLatestMessages:(RCConversationType)conversationType
//                      targetId:(NSString *)targetId
//                         count:(int)count;
//
/**
 *  获取历史消息记录。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *  @param oldestMessageId  最后一条消息的 Id，获取此消息之前的 count 条消息。
 *  @param count            要获取的消息数量。
 *
 *  @return 历史消息记录，按照时间顺序新到旧排列。
 */
//- (NSArray *)getHistoryMessages:(RCConversationType)conversationType
//                       targetId:(NSString *)targetId
//                oldestMessageId:(long)oldestMessageId
//                          count:(int)count;
/**
 *  清空某一会话的所有聊天消息记录。
 *
 *  @param conversationType 会话类型。不支持传入 RCConversationType.CHATROOM。
 *  @param targetId         目标 Id。根据不同的 conversationType，可能是聊天 Id、讨论组 Id、群组 Id。
 *
 *  @return 是否清空成功。
 */
- (BOOL)clearMessages:(RCConversationType)conversationType
             targetId:(NSString *)targetId{
    return YES;
}
-(void)sponsoredGroupAndRegistration{
    //发起小组视图
    UIView * subNavBar = [[UIView alloc] initWithFrame:CGRectMake(0, 64, KScreenWidth, 44)];
    subNavBar.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:subNavBar];
    
    //发起小组按钮
    UIButton * sponsoredGroupBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 22 - 12.5, 80, 25)];
    sponsoredGroupBtn.backgroundColor = [UIColor clearColor];
    sponsoredGroupBtn.layer.borderColor = [[UIColor blackColor]CGColor];
    sponsoredGroupBtn.layer.borderWidth = 0.4;
    sponsoredGroupBtn.layer.cornerRadius = 5.0;
    [sponsoredGroupBtn addTarget:self action:@selector(sponsoredGroupPress) forControlEvents:UIControlEventTouchUpInside];
    UIImageView* plusImgView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 22-12.5, 80, 25)];
    plusImgView.contentMode = UIViewContentModeScaleAspectFill;
    
    plusImgView.image = [UIImage imageNamed:@"2-3-3.png"];
    [subNavBar addSubview:plusImgView];
    
    UILabel * sponsoredGroupLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 22-12.5, 55, 25)];
    sponsoredGroupLabel.text = @"发起小组";
    sponsoredGroupLabel.font = [UIFont systemFontOfSize:11];
    [subNavBar addSubview:sponsoredGroupLabel];
    
    [subNavBar addSubview:sponsoredGroupBtn];
    
    //签到按钮
    RegistrationBtn = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 80, 22 - 12.5, 60, 25)];
    RegistrationBtn.backgroundColor = [UIColor clearColor];
    RegistrationBtn.layer.cornerRadius = 5.0;
    RegistrationBtn.layer.borderWidth = 0.4;
    RegistrationBtn.layer.borderColor = [[UIColor blackColor]CGColor];
    [RegistrationBtn addTarget:self action:@selector(qiandaoPress) forControlEvents:UIControlEventTouchUpInside];
    [subNavBar addSubview:RegistrationBtn];
    
    UIImageView * RegistrationImgView = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 80, 22-12.5, 60, 25)];
    
    RegistrationImgView.image = [UIImage imageNamed:@"2-3-4.png"];
    RegistrationImgView.contentMode = UIViewContentModeScaleAspectFill;
    [subNavBar addSubview:RegistrationImgView];
    
     RegistrationLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 80 + 23, 22 - 12.5, 55, 25)];
    RegistrationLabel.text = @"签到";
    [RegistrationLabel setTextAlignment:NSTextAlignmentLeft];
    RegistrationLabel.font = [UIFont systemFontOfSize:11];
    [subNavBar addSubview:RegistrationLabel];
}
//跳转到发起小组界面
-(void)sponsoredGroupPress{
    
    CreatGroupViewController * groupVC = [[CreatGroupViewController alloc]init];
    groupVC.fromCllubID=_fromClubId;
    groupVC.hidesBottomBarWhenPushed=YES;
    [self.navigationController pushViewController:groupVC animated:NO];
}
#pragma mark 签到
//签到所要的接口方法,后期要封装出来
-(void)requestUrl{
    Request11002*request11002=[[Request11002 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/signUp",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request11002.common.userid=LoginUserInfo.user_id;
    request11002.common.userkey=LoginUserInfo.user_key;
    request11002.common.cmdid=11002;//现在标注为假数据
    request11002.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request11002.params.clubId=_fromClubId;
    NSData*data= [request11002 data];
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
#pragma mark 签到之后返回的签到的状态
//签到之后返回的签到的状态//_requestLater
-(void)requestUrlafterLater{
    Request11003*request11003=[[Request11003 alloc]init];
    //设置请求参数
    request11003.common.userid=LoginUserInfo.user_id;
    request11003.common.userkey=LoginUserInfo.user_key;
    request11003.common.cmdid=11003;//现在标注为假数据
    request11003.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request11003.params.clubId=_fromClubId;
    NSData*data= [request11003 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/signUpState",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestLater = [ASIFormDataRequest requestWithURL:url];
    [_requestLater setPostBody:(NSMutableData*)data];
    [_requestLater setDelegate:self];
    //请求延迟时间
    _requestLater.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestLater.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestLater.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestLater.secondsToCache=3600;
    [_requestLater startAsynchronous];
    //（2）创建manager
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([request isEqual:_request]) {
        Response11002*response=[Response11002 parseFromData:request.responseData error:nil];
        if (response.common.code==0) {
            [[Tostal sharTostal]tostalMesg:@"签到成功" tostalTime:1];
            RegistrationLabel.text=@"已签到";
        }
    }
       //签到之后返回的参数
    if ([request isEqual:_requestLater]) {
        Response11003 * response11003= [Response11003 parseFromData:request.responseData error:nil];
        NSLog(@"%i", response11003.data_p.state);
        //1签到  2未签到
        if (response11003.data_p.state==1) {
            RegistrationLabel.text=@"已签到";
        }else{
        
           RegistrationLabel.text=@"签到";
        }
    }
 
}

-(void)qiandaoPress{
    
    if ([RegistrationLabel.text isEqualToString:@"已经签到"]) {
        [[Tostal sharTostal]tostalMesg:@"已经签到过不要重复签到" tostalTime:1];
    }else{
        if (_fromDistance<=0.5) {
            [self requestUrl];
        }else{
            UIAlertView*alterView=[[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"您距离此酒吧过远不允许签到" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alterView show];
        }
    
    }

    //要调用签到的方法
}
-(void)viewWillDisappear:(BOOL)animated{

    [_request clearDelegatesAndCancel];
    [_requestLater clearDelegatesAndCancel];
    

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
/**
 *  点击头像事件
 *
 *  @param userId 用户的ID
 */
- (void)didTapCellPortrait:(NSString *)userId{
    UIStoryboard *storyBd = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController *infoTVC = [storyBd instantiateViewControllerWithIdentifier:@"infoPeronnal"];
    infoTVC.fromUserId =  userId;
    [self.navigationController pushViewController:infoTVC animated:YES];
    NSLog(@"%@ \n %@",infoTVC.fromUserId,userId);
    
}
@end
