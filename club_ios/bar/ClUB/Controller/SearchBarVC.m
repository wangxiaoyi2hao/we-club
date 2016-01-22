//
//  SearchBarVC.m
//  Weclub
//
//  Created by chen on 16/1/20.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "SearchBarVC.h"
#import "AppDelegate.h"
#import "DBSearch.h"
#import "SearchBarCell.h"
extern  UserInfo*LoginUserInfo;
@interface SearchBarVC ()
{
    //这个是搜索出来的array要传过去的值
    NSMutableArray*_mutArray;
    ASIFormDataRequest*_reuqestSearch;
    UISearchBar*seachBar;
    
    
    
    NSMutableArray*seachHistoryArray;
    

}
@end

@implementation SearchBarVC

- (void)viewDidLoad {
    [super viewDidLoad];
    seachHistoryArray=[NSMutableArray array];
    [AppDelegate matchAllScreenWithView:self.view];
    
#pragma mark  这里是备用的东西
//    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 44)];;
//    _searchHistoryTableView.backgroundColor = [UIColor clearColor];
//    UIButton*buttonClear=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 18)];
//    [buttonClear addTarget:self action:@selector(clearHistoryClick) forControlEvents:UIControlEventTouchUpInside];
//    [buttonClear setTitle:@"清除历史纪录" forState:UIControlStateNormal];
//    
//    [footView addSubview:buttonClear];

    _searchHistoryTableView.tableFooterView = _footerView;
      _searchHistoryTableView.tableHeaderView = _headerView;
    //1.隐藏导航栏
    self.navigationController.navigationBarHidden = YES;
    //seachbar
    seachBar=[[UISearchBar alloc]initWithFrame:CGRectMake(0, 20, KScreenWidth-76, 44)];
    seachBar.barTintColor=[UIColor clearColor];
    [seachBar setBackgroundImage:[UIImage imageNamed:@"tb_bar.png"]];
    [seachBar setScopeBarBackgroundImage:[UIImage imageNamed:@"tb_bar.png"]];
    [seachBar setPlaceholder:@"搜索酒吧/地点"];
    seachBar.delegate=self;
    [self.view addSubview:seachBar];
    
    
    //页眉的view
    

    
    
}
-(IBAction)clearHistoryClick:(UIButton*)sender{

    [[DBSearch sharedInfo]deleteSearchHistory];
    seachHistoryArray=[[DBSearch sharedInfo]AllSearchHistory];
    [_searchHistoryTableView reloadData];

}
-(void)viewWillAppear:(BOOL)animated{
    seachHistoryArray=[[DBSearch sharedInfo]AllSearchHistory];
     [_searchHistoryTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return seachHistoryArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static   NSString *str=@"cell";
    SearchBarCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"SearchBarCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    cell.lbBarName.text=[seachHistoryArray objectAtIndex:indexPath.row];
    
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

   NSString*searchClubName=  [seachHistoryArray objectAtIndex:indexPath.row];
   [self requestSearchClubBar:searchClubName];

}
-(void)requestSearchClubBar:(NSString*)clubName{
    _mutArray=nil;
    _mutArray=[NSMutableArray array];
    Request11020*request=[[Request11020 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/searchClub",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestSearch = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11001;//现在标注为假数据
    request.common.version=@"1.0.0";
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request.params.clubName=clubName;
    NSLog(@"%.0f",LoginUserInfo.latitude);
    NSData*data= [request data];
    [_reuqestSearch setPostBody:(NSMutableData*)data];
    [_reuqestSearch setDelegate:self];
    //请求延迟时间
    _reuqestSearch.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestSearch.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestSearch.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestSearch.secondsToCache=3600;
    [_reuqestSearch startAsynchronous];
    //（2）创建manager
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_reuqestSearch]){
      Response11001*  response11001 = [Response11001 parseFromData:request.responseData error:nil];
        NSLog(@"%@",response11001.data_p.clubsArray);
        for (int i=0; i<response11001.data_p.clubsArray.count; i++) {
            BriefClub*bar=[response11001.data_p.clubsArray objectAtIndex:i];
            [_mutArray addObject:bar];
        }
     //这里要给佳哥传值
    }
}
//seachbar  的代理方法
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    [self requestSearchClubBar:searchBar.text];
    [[DBSearch sharedInfo]InsertSearchHistory:searchBar.text];
    
}
-(void)viewDidAppear:(BOOL)animated{
    [seachBar becomeFirstResponder];

}
#pragma mark- 创建和打开数据库,查询数据的增删改查


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)backButton:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:NO];
}
- (void)viewDidDisappear:(BOOL)animated{
    
}
@end
