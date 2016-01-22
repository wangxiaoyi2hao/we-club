//
//  bindingViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "bindingViewController.h"

@interface bindingViewController ()

@end

@implementation bindingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    self.view.backgroundColor = BackgroundColor;
    //将数据存入model
    bindingModel *blog = [[bindingModel alloc] init];
    bindingModel *qq = [[bindingModel alloc] init];
    bindingModel *wechant = [[bindingModel alloc] init];
    blog.logo = [UIImage imageNamed:@"酒吧美女图1.png"];
    blog.name = @"新浪微博";
    blog.number = [NSNumber numberWithInt:12345];
    
    wechant.logo = [UIImage imageNamed:@"酒吧图1.png"];
    wechant.name = @"微信";
    wechant.number = [NSNumber numberWithInt:23451];

    qq.logo = [UIImage imageNamed:@"frameElement1.png"];
    qq.name = @"QQ";
    qq.number = [NSNumber numberWithInt:34512];
    
    //将model存入数组
    _array = [[NSMutableArray alloc] initWithObjects:qq , wechant , blog , nil];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
     NSString *choice = (NSString *)sender;
     //取得导航控制器
     specificBindViewController *vc = segue.destinationViewController;
     bindingModel *model;
     if ([choice isEqualToString:@"0"]) {
         model = [_array objectAtIndex:0];
     } else if ([choice isEqualToString:@"1"]) {
         model = [_array objectAtIndex:1];
     } else if ([choice isEqualToString:@"2"]) {
         model = [_array objectAtIndex:2];
     }
     //导航控制器取得model
     [vc setData:model];
 }



- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {   //绑定QQ
        [self performSegueWithIdentifier:@"bindingToBinding" sender:@"0"];
    } else if (indexPath.row == 1) {    //绑定微信
        [self performSegueWithIdentifier:@"bindingToBinding" sender:@"1"];
    } else if (indexPath.row == 2) {    //绑定微博
        [self performSegueWithIdentifier:@"bindingToBinding" sender:@"2"];
    }
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
