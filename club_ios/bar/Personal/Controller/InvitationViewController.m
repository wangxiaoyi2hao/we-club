//
//  InvitationViewController.m
//  bar
//
//  Created by chen on 15/10/30.
//  Copyright © 2015年 BIT. All rights reserved.
//
//我 - 我的邀约
#import "InvitationViewController.h"
#import "AppDelegate.h"
#import "barViewCell.h"
#import "InvarionTableViewCell2.h"
#import "AppDelegate.h"
#import "LookUpImageViewController.h"
#import "InviteTableViewCell.h"
#import "HostViewController.h"
#import "SignUpListViewController.h"
#import "InfoTableViewController.h"
extern UserInfo*LoginUserInfo;
extern float fromLongitude;
extern float fromLatitude;
@interface InvitationViewController ()<ASIHTTPRequestDelegate>
{
    UIButton * _leftbutton;
    UIButton * _rightButton;
    ASIFormDataRequest*_requestInitiate;
    ASIFormDataRequest*_requesttakePartIn;
    Response10005*response10005;
    NSMutableArray*array;
    Response10004*response10004;
    NSMutableArray*mytakepartInArray;// 我参与的邀约
    NSMutableArray*myHostInviteArray;//我发起的邀约
}

@end

@implementation InvitationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
 
    array=[NSMutableArray array];
    //初始化我的邀请
    _isMyInvitation = YES;
     [AppDelegate matchAllScreenWithView:self.view];
    _invitationTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight-(KScreenHeight*0.12))];
    [self.view addSubview:_invitationTableView];
    _invitationTableView.delegate = self;
    _invitationTableView.dataSource = self;
    [_invitationTableView setBackgroundColor:[UIColor clearColor]];
    _invitationTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //添加邀请按钮
    [self addinvitButton];
    //请求单元格数据
    [self requestInitiateInvite];
    //刷新数据
    [_invitationTableView reloadData];
    //返回按钮
    [self loadNav];
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
//设置邀请按钮
- (void) addinvitButton{
    UIView *headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 40)];
    headView.backgroundColor = [UIColor colorWithRed:191.0/255 green:192.0/255 blue:194.0/255 alpha:1];
    _leftbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth/2.0, 40)];
    _leftbutton.backgroundColor = [UIColor clearColor];
    [_leftbutton addTarget:self action:@selector(myInvite) forControlEvents:UIControlEventTouchUpInside];
    [_leftbutton setTitle:@"发起的邀约" forState:UIControlStateNormal];
    [_leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //[_leftbutton setTitleColor:[UIColor blackColor] forState:UIControlStateSelected];
    [headView addSubview:_leftbutton];
    
    _rightButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/2.0+1,0, KScreenWidth/2.0, 40)];
    _rightButton.backgroundColor = [UIColor clearColor];
    [_rightButton addTarget:self action:@selector(otherInvite) forControlEvents:UIControlEventTouchUpInside];
    [_rightButton setTitle:@"参与的邀约" forState:UIControlStateNormal];
    [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [headView addSubview:_rightButton];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(KScreenWidth/2.0, 8, 1, 20)];
    view.backgroundColor = [UIColor grayColor];
    [headView addSubview:view];
    _invitationTableView.tableHeaderView = headView;
    
   
    
}
#pragma mark 参与的邀约  从这个方法进入finished
-(void)requestTakePartIn{
    Request10005*request10005=[[Request10005 alloc]init];
    //设置请求参数
    request10005.common.userid=LoginUserInfo.user_id;
    request10005.common.userkey=LoginUserInfo.user_key;
    request10005.common.cmdid=10005;//现在标注为假数据
    request10005.common.timestamp=2;//现在标注为真数据
    request10005.common.version=@"1.0.0";//版本号
    request10005.common.platform=2;//ios  andriod
    NSData*data= [request10005 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getMyJoinInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requesttakePartIn = [ASIFormDataRequest requestWithURL:url];
    [_requesttakePartIn setPostBody:(NSMutableData*)data];
    [_requesttakePartIn setDelegate:self];
    //请求延迟时间
    _requesttakePartIn.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requesttakePartIn.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requesttakePartIn.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requesttakePartIn.secondsToCache=3600;
    [_requesttakePartIn startAsynchronous];
    
}

#pragma mark 发起的邀约  从这个方法进入finished
-(void)requestInitiateInvite{
   
    Request10004*request10004=[[Request10004 alloc]init];
    //设置请求参数
    request10004.common.userid=LoginUserInfo.user_id;
    request10004.common.userkey=LoginUserInfo.user_key;
    request10004.common.cmdid=10004;//现在标注为假数据
    request10004.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request10004.common.version=@"1.0.0";//版本号
    request10004.common.platform=2;//ios  andriod
    NSData*data= [request10004 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/getMyCreateInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestInitiate = [ASIFormDataRequest requestWithURL:url];
    [_requestInitiate setPostBody:(NSMutableData*)data];
    [_requestInitiate setDelegate:self];
    //请求延迟时间
    _requestInitiate.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestInitiate.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestInitiate.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestInitiate.secondsToCache=3600;
    [_requestInitiate startAsynchronous];

}
- (void)requestFinished:(ASIHTTPRequest *)request{
//自己发起的邀约
    if ([request isEqual:_requestInitiate]) {
       response10004=[Response10004 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response10004.data_p.inviteArray);
        NSLog(@"%ld",response10004.data_p.inviteArray_Count);
    }
    //我参与的邀约 
    if ([request isEqual:_requesttakePartIn]) {
        response10005=[Response10005 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response10005.data_p.inviteArray);
        NSLog(@"%ld",response10005.data_p.inviteArray_Count);
        
    }
    //刷新数据
    [_invitationTableView reloadData];
    [self hiddenView];

}
- (void)requestFailed:(ASIHTTPRequest *)request{
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:2];
    [self hiddenView];
}
//发起的邀请
- (void)myInvite{
    [_requesttakePartIn clearDelegatesAndCancel];
    [self requestInitiateInvite];
  
    [self changeTitleLabelState:0];
    NSLog(@"发起邀请");
   
    _isMyInvitation = YES;
    
    //刷新数据
    [_invitationTableView reloadData];
}
//参与的要邀约
- (void)otherInvite{
    [_requestInitiate clearDelegatesAndCancel];
    [self requestTakePartIn];
  
    [self changeTitleLabelState:1];
    
    NSLog(@"参与的邀约");
    _isMyInvitation = NO;
//    //刷新数据
    [_invitationTableView reloadData];
    
}

-(void)changeTitleLabelState:(int)index {
    NSLog(@"%d",index);
    if(index == 1){
        _leftbutton.selected = NO;
        [_leftbutton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _rightButton.selected = YES;
        [_rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        }else{
        _rightButton.selected = NO;
        [_rightButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        _leftbutton.selected = YES;
        [_leftbutton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (_isMyInvitation == YES) {
     return response10004.data_p.inviteArray.count;
    }else{
     return response10005.data_p.inviteArray_Count;
    }
   
}
//创建单元格
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //我发起的邀约
    if(_isMyInvitation == YES){
        static NSString *iden = @"InvarionTableViewCell2";
        InvarionTableViewCell2 *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            //需要使用Nib获得MyCell.xib中已经创建好的单元格
            cell = (InvarionTableViewCell2 *)[[[NSBundle mainBundle] loadNibNamed:@"InvarionTableViewCell2" owner:self options:nil] lastObject];//这里调用加载nib文件
        }
        
        ClubInvite*invite =[response10004.data_p.inviteArray objectAtIndex:indexPath.row];
        //用户id
        NSString *userID = invite.briefUser.userid;
        NSLog(@"%@",userID);

//        NSInteger clubNumber = invite.briefUser.clubNumber;
//        NSLog(@"%ld",clubNumber);
       
        
     
        //转换一下图片格式
        //cell.iconImageView.image = 赋值
        cell.lbAddress.text=invite.inviteLocation;
        
        cell.lbHeart.text=[HelperUtil isDefault:invite.briefUser.signature];
//        UIImage *image = [UIImage imageNamed:@""];
//        cell.myInvireMutableArray = @[];
        if (invite.briefUser.sex==1) {
            [cell.sexImageView setImage:[UIImage imageNamed:@"邀约-男性.png"]];
            
        }else{
            
            [cell.sexImageView setImage:[UIImage imageNamed:@"邀约-女性.png"]];
        }
        cell.lbtitle.text=invite.description_p;
        if (invite.hasMoney==2) {
            cell.lbHongBaoMoney.hidden=NO;
            cell.lbHongBaoMoney.text=[NSString stringWithFormat:@"%i/",invite.payMoney];
            cell.lbMissTime.text=[NSString stringWithFormat:@"%i小时",invite.during/60];
            cell.redPacketImageView.hidden=NO;
            cell.iconImageView.layer.borderWidth = 3;//边框线宽度
            cell.iconImageView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:66/255.0 blue:108/255.0 alpha:1.0].CGColor;
        }else{
            //        cell.iconImageView.layer.borderWidth = 5;//边框线宽度
            //        cell.iconImageView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:66/255.0 blue:108/255.0 alpha:1.0].CGColor;
            cell.lbHongBaoMoney.hidden=YES;
            cell.redPacketImageView.hidden=YES;
            
        }
        if (invite.justFemale==1) {
            cell._imageGirl.hidden=NO;
        }else{
            
            cell._imageGirl.hidden=YES;
        }
        //1AA制 2我请客 3男生请客 4待定
        if (invite.myState==1) {
            //1AA制
            cell.manQingKe.hidden=YES;
        }else if (invite.myState==2){
            //2我请客
            cell.manQingKe.hidden=YES;
        }else if (invite.myState==3){
            //男生请客
            cell.manQingKe.hidden=NO;
        }else if (invite.myState==4){
            //待定
            cell.manQingKe.hidden=YES;
        }
        
        if (invite.justFemale==1) {
            cell._imageGirl.hidden=NO;
        }else{
            cell._imageGirl.hidden=YES;
        }
        //
        //应该还有一个支付方式的地方
        cell.lbSignUp.text=[NSString stringWithFormat:@"报名（%i）",invite.signUpCount];
        if (LoginUserInfo.longitude!=0) {
            cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.0f米",[MyFile meterKiloHaveHowLong:fromLongitude wei:fromLatitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]];
        }else{
            cell.lbDistanceAndMintues.text=@"";
        }
        cell.lbName.text=invite.briefUser.username;
        cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.2fkm｜10分钟前",[MyFile meterKiloHaveHowLong:LoginUserInfo.longitude wei:LoginUserInfo.latitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]/1000];
        cell.lbTime.text=invite.startTime;
        NSLog(@"%@",invite.startTime);
        [cell._buttonSignUp addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        cell._buttonSignUp.tag=indexPath.row;
        [cell._buttonMyInvite addTarget:self action:@selector(MyInviteClick) forControlEvents:UIControlEventTouchUpInside];
        [cell._buttonReport addTarget:self action:@selector(ReportClick) forControlEvents:UIControlEventTouchUpInside];
        [cell._buttonShare addTarget:self action:@selector(sheraToAnyPeson) forControlEvents:UIControlEventTouchUpInside];
        cell._buttonUser.tag=indexPath.row;
        [cell._buttonUser addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",invite.briefUser.avatar]] placeholderImage:[UIImage imageNamed:@"default"]];
        //查看大图
        [cell.lookImage1 addTarget:self action:@selector(barImgShow1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookImage2 addTarget:self action:@selector(barImgShow2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookImage3 addTarget:self action:@selector(barImgShow3:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookImage4 addTarget:self action:@selector(barImgShow4:) forControlEvents:UIControlEventTouchUpInside];

        
        
        return cell;
        
    }else{
        //我参与的邀约
        static   NSString *str=@"cell";
        InviteTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
        if (cell==nil) {
            NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"InviteTableViewCell" owner:self options:nil];
            cell=[arry objectAtIndex:0];
        }
        //单元格加载数据
        //加载数据
        
        ClubInvite*invite =[response10005.data_p.inviteArray objectAtIndex:indexPath.row];
        //用户id
        NSString *userID = invite.briefUser.userid;
        NSLog(@"%@",userID);
        //club号
        NSInteger clubNumber = invite.briefUser.clubNumber;
        NSLog(@"%li",clubNumber);
        
        NSURL * url = [NSURL URLWithString:invite.briefUser.avatar];
        NSLog(@"%@",url);
        //转换一下图片格式
        //cell.iconImageView.image = 赋值
        cell.lbAddress.text=invite.inviteLocation;
 
            cell.lbHeart.text=[HelperUtil isDefault:invite.briefUser.signature];
    
        if (invite.briefUser.sex==1) {
            [cell.sexImageView setImage:[UIImage imageNamed:@"邀约-男性.png"]];
            
        }else{
            
            [cell.sexImageView setImage:[UIImage imageNamed:@"邀约-女性.png"]];
        }
        cell.lbtitle.text=invite.description_p;
        if (invite.hasMoney==2) {
            cell.lbHongBaoMoney.hidden=NO;
            cell.lbHongBaoMoney.text=[NSString stringWithFormat:@"%i/",invite.payMoney];
            cell.lbMissTime.text=[NSString stringWithFormat:@"%i小时",invite.during/60];
            cell.redPacketImageView.hidden=NO;
            cell.iconImageView.layer.borderWidth = 3;//边框线宽度
            cell.iconImageView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:66/255.0 blue:108/255.0 alpha:1.0].CGColor;
        }else{
            //        cell.iconImageView.layer.borderWidth = 5;//边框线宽度
            //        cell.iconImageView.layer.borderColor = [UIColor colorWithRed:220/255.0 green:66/255.0 blue:108/255.0 alpha:1.0].CGColor;
            cell.lbHongBaoMoney.hidden=YES;
            cell.redPacketImageView.hidden=YES;
            
        }
        if (invite.justFemale==1) {
            cell._imageGirl.hidden=NO;
        }else{
            
            cell._imageGirl.hidden=YES;
        }
        //1AA制 2我请客 3男生请客 4待定
        if (invite.myState==1) {
            //1AA制
            cell.manQingKe.hidden=YES;
        }else if (invite.myState==2){
            //2我请客
            cell.manQingKe.hidden=YES;
        }else if (invite.myState==3){
            //男生请客
            cell.manQingKe.hidden=NO;
        }else if (invite.myState==4){
            //待定
            cell.manQingKe.hidden=YES;
        }
        
        if (invite.justFemale==1) {
            cell._imageGirl.hidden=NO;
        }else{
            cell._imageGirl.hidden=YES;
        }
        //
        //应该还有一个支付方式的地方
        cell.lbSignUp.text=[NSString stringWithFormat:@"报名（%i）",invite.signUpCount];
        if (LoginUserInfo.longitude!=0) {
            cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.0f米",[MyFile meterKiloHaveHowLong:fromLongitude wei:fromLatitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]];
        }else{
            cell.lbDistanceAndMintues.text=@"";
        }
        cell.lbName.text=invite.briefUser.username;
        cell.lbDistanceAndMintues.text=[NSString stringWithFormat:@"%.2fkm｜10分钟前",[MyFile meterKiloHaveHowLong:LoginUserInfo.longitude wei:LoginUserInfo.latitude arrJing:invite.createLocationLongitude arrWei:invite.createLocationLatitude]/1000];
        cell.lbTime.text=invite.startTime;
        NSLog(@"%@",invite.startTime);
        [cell._buttonSignUp addTarget:self action:@selector(signUpClick:) forControlEvents:UIControlEventTouchUpInside];
        cell._buttonSignUp.tag=indexPath.row;
        [cell._buttonMyInvite addTarget:self action:@selector(MyInviteClick) forControlEvents:UIControlEventTouchUpInside];
        [cell._buttonReport addTarget:self action:@selector(ReportClick) forControlEvents:UIControlEventTouchUpInside];
        [cell._buttonShare addTarget:self action:@selector(sheraToAnyPeson) forControlEvents:UIControlEventTouchUpInside];
        cell._buttonUser.tag=indexPath.row;
        [cell._buttonUser addTarget:self action:@selector(userClick:) forControlEvents:UIControlEventTouchUpInside];
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",invite.briefUser.avatar]] placeholderImage:[UIImage imageNamed:@"default"]];
        //查看大图
        [cell.lookImage1 addTarget:self action:@selector(barImgShow1:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookImage2 addTarget:self action:@selector(barImgShow2:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookImage3 addTarget:self action:@selector(barImgShow3:) forControlEvents:UIControlEventTouchUpInside];
        [cell.lookImage4 addTarget:self action:@selector(barImgShow4:) forControlEvents:UIControlEventTouchUpInside];
        
        return cell;
    }
}
-(void)MyInviteClick{


}
-(void)ReportClick{
   
}
-(void)sheraToAnyPeson{

}
-(void)userClick:(UIButton*)sender{
    if (_isMyInvitation==YES) {
        ClubInvite*invite=[response10005.data_p.inviteArray objectAtIndex:sender.tag];
        UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        InfoTableViewController*controller=[storyBoard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
        controller.fromUserId=invite.briefUser.userid;
        NSLog(@"%@",invite.briefUser.userid);
        [self.navigationController pushViewController:controller animated:YES];

    }else{
        ClubInvite*invite=[response10004.data_p.inviteArray objectAtIndex:sender.tag];
        UIStoryboard*storyBoard=[UIStoryboard storyboardWithName:@"Main" bundle:[NSBundle mainBundle]];
        InfoTableViewController*controller=[storyBoard instantiateViewControllerWithIdentifier:@"infoPeronnal"];
        controller.fromUserId=invite.briefUser.userid;
        NSLog(@"%@",invite.briefUser.userid);
        [self.navigationController pushViewController:controller animated:YES];
    
    }
    
}
-(void)signUpClick:(UIButton*)sender{
    if (_isMyInvitation == NO) {
        ClubInvite*invite=[response10005.data_p.inviteArray objectAtIndex:sender.tag];
        if ([LoginUserInfo.user_id isEqualToString:invite.briefUser.userid]){
            HostViewController*controller=[[HostViewController alloc]init];
            controller.hidesBottomBarWhenPushed=YES;
            controller.fromUserId=invite.inviteId;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            
            SignUpListViewController*controller=[[SignUpListViewController alloc]init];
            controller.hidesBottomBarWhenPushed=YES;
            controller.fromUserId=invite.inviteId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    }else{
    
        ClubInvite*invite=[response10004.data_p.inviteArray objectAtIndex:sender.tag];
        if ([LoginUserInfo.user_id isEqualToString:invite.briefUser.userid]){
            HostViewController*controller=[[HostViewController alloc]init];
            controller.hidesBottomBarWhenPushed=YES;
            controller.fromUserId=invite.inviteId;
            [self.navigationController pushViewController:controller animated:YES];
        }else{
            
            SignUpListViewController*controller=[[SignUpListViewController alloc]init];
            controller.hidesBottomBarWhenPushed=YES;
            controller.fromUserId=invite.inviteId;
            [self.navigationController pushViewController:controller animated:YES];
        }
    
    }
    
    
    
    
    
    
}
- (IBAction)barImgShow1:(UIButton *)sender {
    sender.tag=0;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
    
    //    [self posterShow];
    
}

- (IBAction)barImgShow2:(UIButton *)sender {
    sender.tag=1;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (IBAction)barImgShow3:(UIButton *)sender {
    sender.tag=2;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (IBAction)barImgShow4:(UIButton *)sender {
    sender.tag=3;
    LookUpImageViewController*controller=[[LookUpImageViewController alloc]init];
    controller.index=(int)sender.tag;
    [self.navigationController presentViewController:controller animated:NO completion:nil];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    if(_isMyInvitation == NO){
     return 290* app.autoSizeScaleY;
    
    }
    return 290* app.autoSizeScaleY;
}
-(void)viewWillDisappear:(BOOL)animated{

    [_requestInitiate clearDelegatesAndCancel];
    [_requesttakePartIn clearDelegatesAndCancel];

}
//设置组头视图高度
//-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
//    return 0;
//}
@end
