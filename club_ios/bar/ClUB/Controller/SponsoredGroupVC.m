//
//  ViewController.m
//  bar
//
//  Created by jeck on 15/10/27.
//  Copyright (c) 2015年 jeck. All rights reserved.
//
//发起小组界面
#import "SponsoredGroupVC.h"
#import "SponsoredGroupTableViewCell.h"
#import "GroupViewController.h"
#import "ChatViewController.h"
#import "InfoTableViewController.h"

@interface SponsoredGroupVC () {

    NSDictionary *_dic;
    NSArray *_provinces;
    UITableView *_tableView;
    UITextField * textinput;
    NSArray*_indexArray;
    NSMutableArray *_selectButtonArray;
    NSMutableArray *_IDArray;
    
    BOOL _isSelected;

}

@end

@implementation SponsoredGroupVC

- (void)viewDidLoad {
    [super viewDidLoad];
    _selectButtonArray = [[NSMutableArray alloc] init];
    _IDArray = [[NSMutableArray alloc] init];
    //设置导航栏
    [self initNavBar];
    //添加表视图
    [self addTableView];
    //添加搜索栏
    [self addSearchView];
    //加载数据
    [self _loadData];
   
}
- (void)addTableView{
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 60, KScreenWidth, KScreenHeight-130)];
    [self.view addSubview:_tableView];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    //设置侧栏的颜色
    //字体的颜色
    _tableView.sectionIndexColor = [UIColor blackColor];
    //背景颜色
    _tableView.sectionIndexBackgroundColor = [UIColor whiteColor];
    //设置选中以后的颜色
    _tableView.sectionFooterHeight = 20.0;
    _tableView.sectionHeaderHeight = 20.0;
    UITapGestureRecognizer *tableViewGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(commentTableViewTouchInSide)];
    tableViewGesture.numberOfTapsRequired = 1;
    tableViewGesture.cancelsTouchesInView = NO;
    [_tableView addGestureRecognizer:tableViewGesture];
    
}

//滑动关闭键盘
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{

[textinput resignFirstResponder];
}
- (void)_loadData{
    //取得城市数据
    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"cities.plist" ofType:nil];
    _dic = [[NSDictionary alloc] initWithContentsOfFile:cityPath];
    
    //取得省份数据
    NSString *provincePath = [[NSBundle mainBundle] pathForResource:@"provinces.plist" ofType:nil];
    _provinces = [[NSArray alloc] initWithContentsOfFile:provincePath];
}
-(void)addSearchView{
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 60)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    //聊天室组标题
    UILabel * title = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 20)];
    title.backgroundColor =  [UIColor colorWithRed:200.0/255 green:200.0/255 blue:200.0/255 alpha:1];
    title.text = @"   选择聊天室成员";
    title.font = [UIFont systemFontOfSize:12];
    [searchView addSubview:title];
    
    //搜索栏视图
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(10, 30, 20, 20)];
    [btn setBackgroundImage:[UIImage imageNamed:@"2-4-1.png"] forState:UIControlStateNormal];
    [searchView addSubview:btn];
    UILabel * sousuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 20, 30, 40)];
    sousuoLabel.text = @"搜索";
    sousuoLabel.font = [UIFont systemFontOfSize:12];
    [searchView addSubview:sousuoLabel];
    
    //提示信息
     textinput = [[UITextField alloc]initWithFrame:CGRectMake(75, 20, KScreenWidth - 80, 40)];
    textinput.backgroundColor = [UIColor clearColor];
    textinput.placeholder = @"搜索聊天室成员";
    textinput.font = [UIFont systemFontOfSize:12];
    textinput.returnKeyType=UIReturnKeySearch;
    [searchView addSubview:textinput];
    [self.view addSubview:searchView];
}

#pragma mark - UITableViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //返回组的数量
    return 1;
    
}

//指定组中有多少个cell
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
  
    return _fromArray.count;

    
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 64;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

      static   NSString *str=@"cell";
    SponsoredGroupTableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"SponsoredGroupTableViewCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }
    ChatUser*sponsored=[_fromArray objectAtIndex:indexPath.row];
     [cell.imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",sponsored.avatar]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    cell.lbName.text=sponsored.username;
 
    [cell.buttonSelect addTarget:self action:@selector(buttonSelectAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.buttonSelect.tag = indexPath.row;
    
    return cell;
    
}
- (void)buttonSelectAction:(UIButton *)button{
    
 ChatUser*sponsored=[_fromArray objectAtIndex:button.tag];
   
    UIStoryboard * memberTableVCSB = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    InfoTableViewController * memberTableVC= [memberTableVCSB instantiateViewControllerWithIdentifier:@"infoPeronnal"];
     memberTableVC.fromUserId=sponsored.userid;
    [self.navigationController pushViewController:memberTableVC animated:NO];

}


#pragma mark- 发起小组导航栏
-(void)initNavBar{
    self.navigationItem.title = @"好友列表";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.tag = 0;
    [rightButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor = [UIColor clearColor];
    UIBarButtonItem * rigthbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rigthbarbuttonitem;
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [leftButton setTitle:@"返回" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView:(UIButton *)btn{
    NSInteger idnex = btn.tag;
    if(idnex == 1)
    {
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        // 启动讨论组，与启动单聊等类似
        UIStoryboard * club = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
        GroupViewController * temp = [club instantiateViewControllerWithIdentifier:@"GroupViewControllerID"];
        temp.targetId = @"b99758c9-ea1b-4235-ae93-ca8ce7d14225";
        temp.conversationType = ConversationType_DISCUSSION;// 传入讨论组类型
        temp.title = @"we club 讨论组";
        [self.navigationController pushViewController:temp animated:YES];
        
        NSLog(@"发起小组右键点击了");
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
      [tableView deselectRowAtIndexPath:indexPath animated:YES];
    // 您需要根据自己的 App 选择场景触发聊天。这里的例子是一个 Button 点击事件。
    ChatViewController *conversationVC = [[ChatViewController alloc]init];
    conversationVC.conversationType =ConversationType_PRIVATE; //会话类型，这里设置为 PRIVATE 即发起单聊会话。
    conversationVC.targetId = @"0cf1d5dd-79b2-4549-a910-60146249f0ca"; // 接收者的 targetId，这里为举例。
    conversationVC.userName = @"李书鹏"; // 接受者的 username，这里为举例。
    conversationVC.title = conversationVC.userName; // 会话的 title。
    self.hidesBottomBarWhenPushed = YES;
    // 把单聊视图控制器添加到导航栈。
    [self.navigationController pushViewController:conversationVC animated:YES];

}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

//在这个地方搜索

    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
