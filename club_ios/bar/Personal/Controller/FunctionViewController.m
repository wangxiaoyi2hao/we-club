//
//  FunctionViewController.m
//  bar
//
//  Created by chen on 15/11/13.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FunctionViewController.h"

@interface FunctionViewController ()

@end

@implementation FunctionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(90, 90, 200, 90);
    [button setTitle:@"功能介绍,点击返回按钮" forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(buttonAction) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
}
- (void)buttonAction{
    [self dismissViewControllerAnimated:YES completion:nil];
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
