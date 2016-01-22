//
//  blackListViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//黑名单返回按钮
#import "blackListViewController.h"
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"

@interface blackListViewController (){
    NSArray *_array;
}

@end

@implementation blackListViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //返回按钮
    [self loadNav];
    /**
     *  获取黑名单列表
     *
     *  @param successBlock 黑名单列表，多个id以回车分割
     *  @param errorBlock      获取用户黑名单状态失败
     */

    [[RCIMClient sharedRCIMClient] getBlacklist:^(NSArray *blockUserIds) {
        _array = blockUserIds;
        NSLog(@"%@",_array);
        [self.tableView reloadData];
        
    } error:^(RCErrorCode status) {
        NSLog(@"获取状态失败");
    }];
    
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return _array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //设置一个静态变量
    static NSString *iden = @"cell_US";
    //设置闲置池
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    //如果闲置池中单元格为空
    if (cell == nil) {
        //用MovieCell类创建单元格
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
    }
    cell.textLabel.text = _array[indexPath.row];
    
    return cell;
    
    
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ///**
    // *  获取用户黑名单状态
    // *
    // *  @param userId     用户id
    // *  @param successBlock 获取用户黑名单状态成功。bizStatus：0-在黑名单，101-不在黑名单
    // *  @param errorBlock      获取用户黑名单状态失败。
    // */
    [[RCIMClient sharedRCIMClient] getBlacklistStatus:@"1001" success:^(int bizStatus) {
        if (bizStatus ==0) {
            //移除某id黑名单
            [[RCIMClient sharedRCIMClient] removeFromBlacklist:@"1001" success:^{
                NSLog(@"移除成功");
                [self.tableView reloadData];
            } error:^(RCErrorCode status) {
                NSLog(@"移除失败");
            }];
            
        }else{
            NSLog(@"不在黑名单");
            
        }
    } error:^(RCErrorCode status) {
        NSLog(@"获取用户黑名单状态失败");
    }];
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return 44*app.autoSizeScaleY;
}

- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
