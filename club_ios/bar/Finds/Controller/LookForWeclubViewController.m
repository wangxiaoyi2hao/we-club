//
//  LookForWeclubViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "LookForWeclubViewController.h"
#import "AppDelegate.h"
#import "SearchCellTableViewCell.h"

@interface LookForWeclubViewController ()
{

    NSMutableArray*searchArray;
}
@end

@implementation LookForWeclubViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //用限制屏幕方法适配这个页面
    [AppDelegate matchAllScreenWithView:self.view];
    [AppDelegate matchAllScreenWithView:_viewFoot];
    //修改状态栏颜色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:NO];
    //我在这放的数据就是为了给数据请求用的所以就不要动啦
    
    searchArray=[NSMutableArray array];
    _tableView.tableFooterView=_viewFoot;
    
    
    // Do any additional setup after loading the view from its nib.
}
#pragma mark 取消按钮的点击
-(IBAction)dismissLastController:(id)sender{

    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark  tableView的代理事件

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return searchArray.count;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 53;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return _viewFoot;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *celled=@"cell";
    SearchCellTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:celled];
    if (cell==nil) {
        NSArray *array=[[NSBundle mainBundle] loadNibNamed:@"SearchCellTableViewCell" owner:self options:nil];
        cell=[array objectAtIndex:0];
    }

    return cell;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//这里面放着 tableview要点击的东西
    
    
}
#pragma mark  这里是做的是点击搜索酒吧的按钮
-(IBAction)searchBar:(id)sender{


}
#pragma mark  这里是搜索人的点击事件
-(IBAction)searchPeople:(id)sender{


}
-(void)viewWillAppear:(BOOL)animated{


    [_tfSearch becomeFirstResponder];
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
