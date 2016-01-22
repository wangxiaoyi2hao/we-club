//
//  CreatGroupViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "CreatGroupViewController.h"
#import "CreatGroupCollectionViewCell.h"
#import "AppDelegate.h"
#import "GroupViewController.h"

extern UserInfo*LoginUserInfo;
@interface CreatGroupViewController ()
{
    int isSelect;
    ASIFormDataRequest*_requestGroup;
    ASIFormDataRequest*_requestCorrect;
    NSMutableArray*userArray;
    NSMutableArray*friendsArray;
    NSMutableArray*nameArray;
}
@end

@implementation CreatGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    [AppDelegate matchAllScreenWithView:self.view];
    UINib*nibcell=[UINib nibWithNibName:@"CreatGroupCollectionViewCell" bundle:[NSBundle mainBundle]];
    [_collectionView registerNib:nibcell forCellWithReuseIdentifier:@"cell"];
    [_collectionView setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    //导航条
    self.title=@"发起小组";
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(returnLastView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;

}

-(void)returnLastView{
    [self.navigationController popViewControllerAnimated:YES];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    
    return userArray.count;
    
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    static NSString*str=@"cell";
    CreatGroupCollectionViewCell*cell=[collectionView dequeueReusableCellWithReuseIdentifier:str forIndexPath:indexPath];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"CityCollectionCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
     ChatUser*chatOnCollect=[userArray objectAtIndex:indexPath.row];
     [cell._imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",chatOnCollect.avatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    cell.lbName.text=chatOnCollect.username;
    NSString*userId=chatOnCollect.userid;
    NSLog(@"%@",userId);
    if (chatOnCollect.isSelected==1) {
        cell._imageHead.layer.borderWidth = 4;//边框线宽度
        cell._imageHead.layer.borderColor = [UIColor colorWithRed:220/255.0 green:66/255.0 blue:108/255.0 alpha:1.0].CGColor;
    }else{
        cell._imageHead.layer.borderWidth = 2;//边框线宽度
        cell._imageHead.layer.borderColor = [UIColor whiteColor].CGColor;
    }
    [cell.buttonSelect addTarget:self action:@selector(selectClickCreat:) forControlEvents:UIControlEventTouchUpInside];
     cell.buttonSelect.tag=indexPath.row;
    return cell;
    
}
-(void)selectClickCreat:(UIButton*)sender{
    ChatUser*chatCreat=[userArray objectAtIndex:sender.tag];

    if (chatCreat.isSelected==0) {
        [friendsArray addObject:chatCreat.userid];
        [nameArray addObject:chatCreat.username];
        chatCreat.isSelected=1;
    }else{
        [friendsArray removeObject:chatCreat.userid];
        [nameArray removeObject:chatCreat.username];
        chatCreat.isSelected=0;
    }
    [_collectionView reloadData];
}
-(void)viewWillAppear:(BOOL)animated{
    //这里是要实例化这个数组，是因为如果选中了就要添加一个userid到里面
    userArray=[NSMutableArray array];
    friendsArray=[NSMutableArray array];
    nameArray=[NSMutableArray array];
    [self requestSearchFriend];
}
#pragma mark 这个获取这个酒吧的聊天室信息
-(void)requestSearchFriend{
    userArray=nil;
    userArray=[NSMutableArray array];
    Request11004*request11004=[[Request11004 alloc]init];
    //设置请求参数
    request11004.common.userid=LoginUserInfo.user_id;
    request11004.common.userkey=LoginUserInfo.user_key;
    request11004.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request11004.common.version=@"1.0.0";//版本号
    request11004.common.platform=2;//ios  andriod
    request11004.common.cmdid=11004;
#pragma  mark  这里还要处理
    request11004.params.clubId=_fromCllubID;

    //下面还可能有上传图片的内容
    NSData*data= [request11004 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getChatroomMember",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestGroup = [ASIFormDataRequest requestWithURL:url];
    [_requestGroup setPostBody:(NSMutableData*)data];
    [_requestGroup setDelegate:self];
    //请求延迟时间
    _requestGroup.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestGroup.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestGroup.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestGroup.secondsToCache=3600;
    [_requestGroup startAsynchronous];
    
}
#pragma mark 这个是创建小组聊天室
-(void)requestCorrectThisGroup{
    Request11006*request11006=[[Request11006 alloc]init];
    //设置请求参数
    request11006.common.userid=LoginUserInfo.user_id;
    request11006.common.userkey=LoginUserInfo.user_key;
    request11006.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request11006.common.version=@"1.0.0";//版本号
    request11006.common.platform=2;//ios  andriod
    request11006.common.cmdid=11004;
#pragma  mark  这里还要处理
    request11006.params.clubId=_fromCllubID;
    request11006.params.useridsArray=friendsArray;
    request11006.params.usernamesArray=nameArray;
    //下面还可能有上传图片的内容
    NSData*data= [request11006 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/createChatTeam",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestCorrect = [ASIFormDataRequest requestWithURL:url];
    [_requestCorrect setPostBody:(NSMutableData*)data];
    [_requestCorrect setDelegate:self];
    //请求延迟时间
    _requestCorrect.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestCorrect.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestCorrect.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestCorrect.secondsToCache=3600;
    [_requestCorrect startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestGroup]){
        Response11004*reponse11004 = [Response11004 parseFromData:request.responseData error:nil];
        NSLog(@"%@",reponse11004.data_p. chatUsersArray);
        NSLog(@"%lu",(unsigned long)reponse11004.data_p. chatUsersArray_Count);
        for (int i=0; i<reponse11004.data_p.chatUsersArray.count; i++) {
            ChatUser*chatUser=[reponse11004.data_p.chatUsersArray objectAtIndex:i];
            [userArray addObject:chatUser];
        }
    
    }
    if ([request isEqual:_requestCorrect]) {
      
        Response11006*reponse11006 = [Response11006 parseFromData:request.responseData error:nil];
        if (reponse11006.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"发起小组失败" tostalTime:1];
        }
        NSLog(@"%@",reponse11006.data_p.targetDiscussionId);
        NSLog(@"%@",reponse11006.data_p.title);
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        GroupViewController * temp = [club instantiateViewControllerWithIdentifier:@"GroupViewControllerID"];
        temp.targetId = reponse11006.data_p.targetDiscussionId;
        NSLog(@"%@",reponse11006.data_p.targetDiscussionId);
        temp.conversationType = ConversationType_GROUP;// 传入讨论组类型
        temp.title =reponse11006.data_p.title;
        NSLog(@"%@",reponse11006.data_p.title);
        [self.navigationController pushViewController:temp animated:YES];
     
    }
    [_collectionView reloadData];
}
-(IBAction)correctThis:(UIButton*)sender{
   
    [self requestCorrectThisGroup];


}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{

}
-(void)viewWillDisappear:(BOOL)animated{
    [_requestGroup clearDelegatesAndCancel];
    [_requestCorrect clearDelegatesAndCancel];

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
