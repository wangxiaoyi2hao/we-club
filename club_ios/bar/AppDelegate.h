//
//  AppDelegate.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WXApi.h"
#import <RongIMKit/RongIMKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate,WXApiDelegate,UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign,nonatomic)float autoSizeScaleX;
@property (assign,nonatomic)float autoSizeScaleY;
@property (nonatomic, assign) double latitude;
@property (nonatomic, assign) double longitude;

//群组
@property(nonatomic,retain)RCGroup*groupUserInfo;
//想适配屏幕，调用这句话就行
+ (void)matchAllScreenWithView:(UIView *)allView;
+ (BOOL)isAllowedNotification;
+(AppDelegate *)shareAppDelegate;
-(void)requestFriendList;
@end

