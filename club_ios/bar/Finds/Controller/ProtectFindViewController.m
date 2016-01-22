//
//  ProtectFindViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "ProtectFindViewController.h"
#import "FindsViewController.h"
#import "LookForWeclubViewController.h"
#import "InviteViewControllerComplete.h"
#import "InviteCompleteViewController.h"

@interface ProtectFindViewController ()
{
    NSMutableArray*_controllerArray;

}
@end

@implementation ProtectFindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    //设置未选中时的颜色
//    _slideSwitchView.tabItemNormalColor = [UIColor blackColor];
//    //设置选中时的颜色
//    _slideSwitchView.tabItemSelectedColor = [UIColor lightGrayColor];
//    _slideSwitchView.shadowImage = [[UIImage imageNamed:@"UMS_qq_icon@2x"]
//                                    stretchableImageWithLeftCapWidth:59.0f topCapHeight:0.0f];
//     _slideSwitchView.slideSwitchViewDelegate=self;
//    NSArray *titleArray1=@[@"要闻",@"娱乐",@"生活"];
//        _controllerArray=[NSMutableArray array];
//        for (int i=0; i<titleArray1.count; i++) {
////            FindsViewController *controller=[[FindsViewController alloc] init];
//             UIStoryboard * view2sb = [UIStoryboard storyboardWithName:@"Finds" bundle:nil];
//            FindsViewController * controller = [view2sb instantiateViewControllerWithIdentifier:@"FindsViewControllerID"];
//          //controller.delegate=self;
//            controller.title=[titleArray1 objectAtIndex:i];
//    //        controller.fromType=i;
//            [_controllerArray addObject:controller];
//        }
//    
//        [_slideSwitchView buildUI];

    
}

-(void)viewDidAppear:(BOOL)animated{
//    self.title=@"Weclub";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
   [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
   UIButton*btn=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 20, 20)];
   [btn setBackgroundImage:[UIImage imageNamed:@"1-1-1.png"] forState:UIControlStateNormal];
   [btn setTitle:@"+" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(rightClick) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*rightItem=[[UIBarButtonItem alloc]initWithCustomView:btn];
    self.navigationItem.rightBarButtonItem = rightItem;
    
    UIButton*leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 30)];
        [leftButton setBackgroundImage:[UIImage imageNamed:@""]forState:UIControlStateNormal];
    [leftButton setTitle:@"搜索" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(leftClickButTON) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem*leftItem=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=leftItem;

}
#pragma MARK  点击左边的按钮的事件，以后每个页面这个东西都不消失
-(void)leftClickButTON{
    LookForWeclubViewController*controller=[[LookForWeclubViewController alloc]init];
    [self.navigationController presentViewController:controller animated:YES completion:nil];
}

-(void)rightClick{
    
    InviteCompleteViewController*controller=[[InviteCompleteViewController alloc]init];
    controller.hidesBottomBarWhenPushed=YES;
    
    [self.navigationController pushViewController:controller animated:YES];
    
    
    
}

//该方法返回值决定返回个数
- (NSUInteger)numberOfTab:(QCSlideSwitchView *)view
{
    return _controllerArray.count;
}
//该方法返回值决定每一个模块下的视图控制器对象
- (UIViewController *)slideSwitchView:(QCSlideSwitchView *)view viewOfTab:(NSUInteger)number
{
    return [_controllerArray objectAtIndex:number];
}
//当用户切换tab的时候会激发该方法
- (void)slideSwitchView:(QCSlideSwitchView *)view didselectTab:(NSUInteger)number
{
    FindsViewController *controller=[_controllerArray objectAtIndex:number];//    [controller viewDidCurrentView];
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
