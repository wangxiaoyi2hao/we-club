//
//  notificationViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

//通知提醒及进入编辑模式界面
#import "notificationViewController.h"
#import "AppDelegate.h"

@interface notificationViewController ()

@end

@implementation notificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    //将数据存入model中
    _dataArray = [[NSMutableArray alloc] init];
    notificationModel *model1 = [[notificationModel alloc] init];
    model1.photo = [UIImage imageNamed:@"酒吧美女图1.png"];
    model1.name = @"suho";
    model1.choice = [NSNumber numberWithInt:0];
    model1.userInvolved = @"d.o";
    [_dataArray addObject:model1];
    
    notificationModel *model2 = [[notificationModel alloc] init];
    model2.photo = [UIImage imageNamed:@"酒吧美女图5.png"];
    model2.name = @"d.o.";
    model2.choice = [NSNumber numberWithInt:1];
    model2.userInvolved = @"lay";
    [_dataArray addObject:model2];
    
    notificationModel *model3 = [[notificationModel alloc] init];
    model3.photo = [UIImage imageNamed:@"酒吧美女图6.png"];
    model3.name = @"lay";
    model3.choice = [NSNumber numberWithInt:2];
    model3.userInvolved = @"luhan";
    [_dataArray addObject:model3];
    
    _deleteDic = [[NSMutableDictionary alloc] init];
    _deleteTool.hidden = YES;
    _deleteTool.delegate = self;
    //开启编辑模式
    self.tableView.allowsMultipleSelectionDuringEditing = YES;
    //添加删除工具
    _deleteTool.frame = CGRectMake(0, self.view.frame.size.height - _deleteTool.frame.size.height - 64, self.view.frame.size.width, _deleteTool.frame.size.height);
    [self.view addSubview:_deleteTool];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:view];
    //表示图分割线风格
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView setEditing:NO animated:YES];
    [self loadNav];
}
-(void)loadNav{
    
    self.title=@"通知提醒";
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


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//组数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return _dataArray.count;
}
//每组单元格数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}

//设置单元格内容
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    notificationModel *model = [_dataArray objectAtIndex:indexPath.section];
    if ([model.choice intValue] == 0 || [model.choice intValue] == 1) {
        static NSString *iden = @"notificationCellIdentifier";
        //使用闲置池
        notificationCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        if (cell == nil) {
            //用MovieCell类创建单元格
            cell = [[notificationCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        }
        //notificationCell *cell = [tableView dequeueReusableCellWithIdentifier:@"notificationCellIdentifier" forIndexPath:indexPath];
        cell.photo.image = model.photo;
        cell.name.text = model.name;
        cell.time.text = @"3小时前";
        if ([model.choice intValue] == 0) {
            cell.content.text = [NSString stringWithFormat:@"你已成功申请加入%@的邀约",model.userInvolved];
        } else if ([model.choice intValue] == 1) {
            cell.content.text = [NSString stringWithFormat:@"你被拒绝申请加入%@的邀约",model.userInvolved];
        }
        return cell;
    } else {
        static NSString *iden = @"decisionCellIdentifier";
        //使用闲置池
        decisionCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
        
        if (cell == nil) {
            //用MovieCell类创建单元格
            cell = [[decisionCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        }
        //decisionCell *cell = [tableView dequeueReusableCellWithIdentifier:@"decisionCellIdentifier" forIndexPath:indexPath];
        cell.photo.image = model.photo;
        cell.name.text = model.name;
        cell.time.text = @"3小时前";
        cell.content.text = [NSString stringWithFormat:@"%@申请加入您的邀约",model.userInvolved];
        NSDictionary* unselectedTextAttributes = @{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName: [UIColor lightGrayColor]};
        [cell.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateNormal];
        [cell.segmentControl setTitleTextAttributes:unselectedTextAttributes forState:UIControlStateSelected];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return 99* app.autoSizeScaleY;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 0;
    } else {
        return 10;
    }
}

#pragma mark - 以下为进入编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_rightBtn.title isEqualToString:@"取消"]) {
        
        int num = [[[[_deleteTool items] objectAtIndex:0] title] intValue];
        num = num + 1;
        [_deleteTool setNumber:num];
        [_deleteDic setObject:@"1" forKey:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([_rightBtn.title isEqualToString:@"取消"]) {
        int num = [[[[_deleteTool items] objectAtIndex:0] title] intValue];
        num = num - 1;
        [_deleteTool setNumber:num];
        [_deleteDic removeObjectForKey:indexPath];
    }
}

- (UITableViewCellEditingStyle) tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleNone;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}

- (IBAction)deleteBtnClick:(UIButton *)sender {
    [self.tableView setEditing:NO animated:YES];
    [self.deleteTool setNumber:0];
    _deleteTool.hidden = YES;
    _rightBtn.title = @"编辑";
}

- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)editBtnClick:(UIBarButtonItem *)sender {
    if ([_rightBtn.title isEqualToString:@"编辑"]) {
        _rightBtn.title = @"取消";
        [self.tableView setEditing:YES animated:NO];
        _deleteTool.hidden = NO;
    } else {
        _rightBtn.title = @"编辑";
        [self.tableView setEditing:NO animated:YES];
        [self.deleteTool setNumber:0];
        _deleteTool.hidden = YES;
    }
}
#pragma mark - 删除栏代理方法
- (void)deleteMethod{
    
}
@end
