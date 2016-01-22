//
//  AddFriendsVC.m
//  bar
//
//  Created by chen on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "AddFriendsVC.h"

@interface AddFriendsVC ()

@end

@implementation AddFriendsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self addSearchView];
    //返回按钮
    [self loadNav];
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(leftButtonPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)leftButtonPopView{
    
    
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)addSearchView{
    UIView * searchView = [[UIView alloc]initWithFrame:CGRectMake(0, 64, KScreenWidth, 50)];
    searchView.backgroundColor = [UIColor whiteColor];
    
    //搜索栏视图
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(17, 17, 15, 15)];
    [btn setBackgroundImage:[UIImage imageNamed:@"2-4-1.png"] forState:UIControlStateNormal];
    [searchView addSubview:btn];
//    UILabel * sousuoLabel = [[UILabel alloc]initWithFrame:CGRectMake(40, 0, 30, 40)];
//    sousuoLabel.text = @"搜索";
//    sousuoLabel.font = [UIFont systemFontOfSize:15];
//    [searchView addSubview:sousuoLabel];
    
    //提示信息
    UITextField * textinput = [[UITextField alloc]initWithFrame:CGRectMake(40, 5, KScreenWidth - 80, 40)];
    textinput.backgroundColor = [UIColor clearColor];
    textinput.placeholder = @"搜索聊天室成员";
    textinput.font = [UIFont systemFontOfSize:15];
    [searchView addSubview:textinput];
    [self.view addSubview:searchView];

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
