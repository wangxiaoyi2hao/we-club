//
//  GuideGOViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/12.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "GuideGOViewController.h"
#import "AppDelegate.h"
#import "FirstRegisterVC.h"
#import "LoginVC.h"
#import "ThirdRegisterVC.h"
@interface GuideGOViewController ()

@end

@implementation GuideGOViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //让状态栏隐藏
    [AppDelegate matchAllScreenWithView:self.view];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(dismissThisViewController) name:@"rangdengluchualai" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(regirseGo) name:@"goRegirse" object:nil];
    // Do any additional setup after loading the view from its nib.
}
-(void)regirseGo{
    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    ThirdRegisterVC * thirdRegisterVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"ThirdRegisterVCID"];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:thirdRegisterVC];
    [self  presentViewController:nav animated:YES completion:nil];
    NSLog(@"注册");
}
-(void)dismissThisViewController{
    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    LoginVC * loginVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"LoginVCID"];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"登录");
}
//注册事件
-(IBAction)regirstView:(id)sender{

    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    ThirdRegisterVC * thirdRegisterVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"ThirdRegisterVCID"];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:thirdRegisterVC];
    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"注册");
    

}
-(IBAction)loginViewCon:(id)sender{

    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    LoginVC * loginVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"LoginVCID"];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"登录");

}
-(void)viewWillAppear:(BOOL)animated{


[[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];


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
