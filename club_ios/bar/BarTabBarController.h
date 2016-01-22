//
//  BarTabBarController.h
//  bar
//
//  Created by chen on 15/10/23.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
//给block方法改名
@protocol findDelegate <NSObject>

-(void)loadThisViewController;

@end
//typedef  void(^BarTabBarBlock)(int count);
@interface BarTabBarController : UITabBarController//<RCIMReceiveMessageDelegate>
//@property (nonatomic, copy)BarTabBarBlock barTabBarBlock;

@property(nonatomic,assign)id<findDelegate>delegate1;
//未读消息数
@property (nonatomic, strong)UILabel *numberLabel;

+(BarTabBarController *)shareBarTabBarController;

@end
