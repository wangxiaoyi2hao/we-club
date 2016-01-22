//
//  NoHongBaoViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/9.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "NoHongBaoViewController.h"

@interface NoHongBaoViewController ()

@end

@implementation NoHongBaoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(IBAction)switchClick:(id)sender{

    [self.navigationController popViewControllerAnimated:NO];



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
