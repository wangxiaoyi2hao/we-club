//
//  FinishReviseViewController.m
//  bar
//
//  Created by chen on 15/11/5.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FinishReviseViewController.h"

@interface FinishReviseViewController ()

@end

@implementation FinishReviseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _sendButton.layer.cornerRadius = 10;//边框圆角
    //_submitButton.layer.borderWidth = 1;//边框线宽度
    //给色值
    
    [_sendButton setBackgroundColor:[HelperUtil colorWithHexString:@"e43f6d"]];
    _sendButton.layer.masksToBounds = YES;
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

- (IBAction)sendAction:(UIButton *)sender {
}
@end
