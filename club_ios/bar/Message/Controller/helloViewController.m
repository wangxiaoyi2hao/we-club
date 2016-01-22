//
//  helloViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "helloViewController.h"
#import "AppDelegate.h"
#import "ChatListViewController.h"
#import "ListViewController.h"
#import "NewListViewController.h"

@interface helloViewController (){
    UIButton * _helloButton;
}

@end

@implementation helloViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    _dataArray = [[NSMutableArray alloc] init];
    HelloModel *model = [[HelloModel alloc] init];
    model.name = @"suho";
    model.photo = [UIImage imageNamed:@"酒吧美女图1.png"];
    model.helloContent = [[NSMutableArray alloc] initWithObjects:@"记得那年高考后,说了考试成绩不要互相通知的", nil];
    [_dataArray addObject:model];
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:view];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self loadNav];
}
-(void)loadNav{
    
    self.title=@"有人和你打招呼";
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_dataArray count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *iden = @"helloCellIdentifier";
    //使用闲置池
    helloCell *cell = [tableView dequeueReusableCellWithIdentifier:iden];
    
    if (cell == nil) {
        //用MovieCell类创建单元格
        cell = [[helloCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:iden];
        }
    
    //helloCell *cell = [tableView dequeueReusableCellWithIdentifier:@"helloCellIdentifier" forIndexPath:indexPath];
    //取出下标为indexPath.row的model
    HelloModel *model = [_dataArray objectAtIndex:indexPath.row];
    cell.photo.image = model.photo;
    cell.name.text = model.name;
    cell.content.text = [model.helloContent objectAtIndex:[model.helloContent count] - 1];
    cell.timeLabel.text = @"15:32";
    _helloButton = cell.helloNumber;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    return 60* app.autoSizeScaleY;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    _helloButton.hidden = YES;
//    ChatListViewController * chatListViewController=[[ChatListViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)] collectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
//    self.hidesBottomBarWhenPushed = YES;
//    [self.navigationController pushViewController:chatListViewController animated:YES];
    
//    ListViewController * listViewController=[[ListViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM)] collectionConversationType:@[@(ConversationType_GROUP),@(ConversationType_DISCUSSION)]];
//    self.hidesBottomBarWhenPushed = NO;
//    [self.navigationController pushViewController:listViewController animated:YES];
    
    NewListViewController * listViewController=[[NewListViewController alloc]initWithDisplayConversationTypes:@[@(ConversationType_PRIVATE),@(ConversationType_DISCUSSION), @(ConversationType_APPSERVICE), @(ConversationType_PUBLICSERVICE),@(ConversationType_GROUP),@(ConversationType_SYSTEM),@(ConversationType_CHATROOM),@(ConversationType_CUSTOMERSERVICE)] collectionConversationType:nil/*@[@(ConversationType_GROUP),@(ConversationType_CHATROOM)]*/];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listViewController animated:YES];
//    NSLog(@"跳转到打招呼内容界面");
}
#pragma mark -编辑模式
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}


- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewRowAction *allReadRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"设为未读" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        _helloButton.hidden = NO;
        NSLog(@"点击了设置为未读");
    }];
    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除" handler:^(UITableViewRowAction *action,NSIndexPath *indexPath) {
        
        NSLog(@"点击了删除");
    }];
    NSArray *array = [[NSArray alloc] initWithObjects:deleteRowAction, allReadRowAction,  nil];
    return array;
}


 // Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {

    }
}



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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)clearBtnClick:(UIBarButtonItem *)sender {
    NSLog(@"你点击了清空按钮");
}
@end
