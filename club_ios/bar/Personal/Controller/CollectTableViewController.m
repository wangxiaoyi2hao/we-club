//
//  CollectTableViewController.m
//  bar
//
//  Created by chen on 15/11/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "CollectTableViewController.h"
#import "SaveCell.h"
#import "AppDelegate.h"

@interface CollectTableViewController (){
    
}

@end

@implementation CollectTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    self.title = @"收藏";
//    设置是否反弹
    self.tableView.bounces=NO;
    
//    设置是否显示竖向滚动条
    self.tableView.showsVerticalScrollIndicator=NO;
    //返回按钮
    [self loadNav];
}
-(void)loadNav{
    
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(CollectPopView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)CollectPopView{
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 10;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *iden = @"saveCell";
    SaveCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell == nil) {
        //需要使用Nib获得MyCell.xib中已经创建好的单元格
        cell = (SaveCell *)[[[NSBundle mainBundle] loadNibNamed:@"SaveCell" owner:self options:nil] lastObject];//这里调用加载nib文件
    }
    //头像
    cell.iconImageView.image = [UIImage imageNamed:@"酒吧美女图6.png"];
    cell.nameLabel.text = @"范冰冰";
    cell.timeLabel.text = @"3天前";
    //cell.contentLabel.text = @"这里添加内容数据";
    cell.collectImgView.image = [UIImage imageNamed:@"酒吧图6.png"];
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog(@"单元格被点击了");
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    AppDelegate *app = (AppDelegate*)[UIApplication sharedApplication].delegate;
    return 185*app.autoSizeScaleY;}


@end
