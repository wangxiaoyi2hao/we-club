//
//  ReportSuccessViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "ReportSuccessViewController.h"

@interface ReportSuccessViewController ()

@end

@implementation ReportSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self loadNav];
    // Do any additional setup after loading the view from its nib.
}
-(void)loadNav{

    self.title=@"举报成功";
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    //    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView1{

    [self.navigationController popToRootViewControllerAnimated:YES];

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
