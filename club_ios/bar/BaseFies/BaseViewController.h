//
//  BaseViewController.h
//  bar
//
//  Created by chen on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MBProgressHUD;
@interface BaseViewController : UIViewController
{
    
    MBProgressHUD *_hud;
}
/*
 {   UIVisualEffectView *_visualEffectView;
 UIActivityIndicatorView *_indicatorView;
 }*/

//显示加载视图
//- (void)showLoadingView:(BOOL)isShow;

//显示加载视图
- (void)showLoadingView:(NSString *)title;

//隐藏加载视图
- (void)hiddenView;


@end
