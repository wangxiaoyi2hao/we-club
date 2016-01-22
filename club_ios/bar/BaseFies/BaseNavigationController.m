//
//  BaseNavigationController.m
//  bar
//
//  Created by chen on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseNavigationController.h"

@interface BaseNavigationController ()

@end

@implementation BaseNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
}
-(void)initNavBar:(NSString *)Middletitle withLeftTitle:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle{
    self.navigationItem.title = Middletitle;
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [rightButton setTitle:rightTitle forState:UIControlStateNormal];
    [rightButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightButton.tag = 0;
    [rightButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    rightButton.backgroundColor = [UIColor clearColor];
    UIBarButtonItem * rigthbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rigthbarbuttonitem;
    
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
    [leftButton setTitle:leftTitle forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    leftButton.tag = 1;
    [leftButton addTarget:self action:@selector(popView:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView:(UIButton *)btn{
    NSInteger idnex = btn.tag;
    if(idnex == 1)
    {        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        NSLog(@"发起小组右键点击了");
    }
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
