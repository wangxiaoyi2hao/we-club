//
//  GuideViewController.m
//  01 Movie
//
//  Created by liyoubing on 15/6/25.
//  Copyright (c) 2015年 liyoubing. All rights reserved.
//

#import "GuideViewController.h"
#import "BarTabBarController.h"
#import "RegisterFinalViewController.h"
#import "LoginFinalViewController.h"
#import "FirstRegisterVC.h"
#import "LoginVC.h"
#import "AppDelegate.h"

@interface GuideViewController ()

@end

@implementation GuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    [self _initView];
}

//创建滚动视图
- (void)_initView {
    UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    //禁止下面有道道
    scrollView.showsHorizontalScrollIndicator=NO;
    //禁止反弹
    scrollView.bounces=NO;
    scrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight);
    //设置代理
    scrollView.delegate = self;
    //设置分页效果
    scrollView.pagingEnabled = YES;
   
    //如果是退出登录的话 一退出就到了首页界面
    if (_fromOutClub==1) {
           [scrollView setContentOffset:CGPointMake(KScreenWidth*0, 0)];
    }
 
    [self.view addSubview:scrollView];
    UIImageView*_imageViewWeclub=[[UIImageView alloc]initWithFrame:CGRectMake(68, 105, 240, 85)];
    [_imageViewWeclub setImage:[UIImage imageNamed:@"logo.png"]];
    [self.view addSubview:_imageViewWeclub];
    
    NSArray *guideImgArray = @[@"background.png"];
    
    for (int i=0; i<guideImgArray.count; i++) {
//        AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
        //创建图片
        UIImageView *guideImg = [[UIImageView alloc] initWithFrame:CGRectMake(i*KScreenWidth, 0, KScreenWidth, KScreenHeight)];
        //取得图片的名字
        NSString *guideName = guideImgArray[i];
        guideImg.image = [UIImage imageNamed:guideName];
        [scrollView addSubview:guideImg];
        //注册按钮
        UIButton *but1;
        if (KScreenHeight == 480) {
            but1 = [[UIButton alloc]initWithFrame:CGRectMake(193, 603, 168, 50)];
        }else {
            
            but1 = [[UIButton alloc]initWithFrame:CGRectMake(193*KScreenWidth/320, 603*KScreenHeight/568, 168*KScreenWidth/320, 50*KScreenHeight/568)];

        }
        [but1 setTitle:@"注册" forState:UIControlStateNormal];
        but1.backgroundColor = [UIColor colorWithRed:0 green:215 blue:190 alpha:0.6];
        but1.titleLabel.textColor=[UIColor whiteColor];
        but1.alpha=0.5;
        [but1 addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
        [but1 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scrollView addSubview:but1];
        //登录按钮
        UIButton *but2;
        if (KScreenHeight == 480) {
            but2 = [[UIButton alloc]initWithFrame:CGRectMake(14, 603, 168, 50)];
        }else{
            but2 = [[UIButton alloc]initWithFrame:CGRectMake(14, 603, 168, 50)];
        }
        [but2 setTitle:@"登录" forState:UIControlStateNormal];
        but2.backgroundColor = [UIColor colorWithRed:125 green:121 blue:232 alpha:0.6];
        but2.titleLabel.textColor=[UIColor whiteColor];
        but2.alpha=0.5;
        [but2 addTarget:self action:@selector(logInAction) forControlEvents:UIControlEventTouchUpInside];
        [but2 setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [scrollView addSubview:but2];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

}

- (void)registerAction{
    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    FirstRegisterVC * firstRegisterVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"FirstRegisterVCID"];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:firstRegisterVC];
    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"注册");
    
}
- (void)logInAction{
    UIStoryboard * registerAndLogin = [UIStoryboard storyboardWithName:@"RegisterAndLogin" bundle:nil];
    LoginVC * loginVC = [registerAndLogin instantiateViewControllerWithIdentifier:@"LoginVCID"];
    UINavigationController*nav=[[UINavigationController alloc]initWithRootViewController:loginVC];
    [self presentViewController:nav animated:YES completion:nil];
    NSLog(@"登录");
    
}

@end
