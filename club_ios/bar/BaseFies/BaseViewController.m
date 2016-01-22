//
//  BaseViewController.m
//  bar
//
//  Created by chen on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"
#import "AppDelegate.h"
#import "MBProgressHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//显示加载视图
- (void)showLoadingView:(NSString *)title {
    
    if (_hud == nil) {
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
                _hud.mode = MBProgressHUDModeIndeterminate;
                //_hud.animationType = MBProgressHUDAnimationFade;
    }
    
    //设置显示的标题
    _hud.labelText = title;
    
    //设置子标题
    //    _hud.detailsLabelText =
    
    //设置灰色视图覆盖屏幕
    _hud.dimBackground = YES;
}

//隐藏加载视图
- (void)hiddenView {
    
    [_hud hide:YES];
    
}
@end
