//
//  BarTabBarController.m
//  bar
//
//  Created by chen on 15/10/23.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BarTabBarController.h"
#import "FindsViewController.h"
#import "CLUBViewController.h"
#import "selfViewController.h"
#import "MyFile.h"
#import "UserInfo.h"
#import "LoginFinalViewController.h"
#import "MessageVC.h"
#import "AppDelegate.h"
#import "ProtectFindViewController.h"
//#import "RenewalViewController.h"
#import "GuideGOViewController.h"



extern UserInfo*LoginUserInfo;
@interface BarTabBarController ()
{
    UIView *_selectVew;
    int _tabSelectIndex;
    UIButton *_selectedButton;
    UIImageView *_selectImg;
    
    FindsViewController * view1;
}

@end

@implementation BarTabBarController{
    NSInteger _count;
}
+(BarTabBarController *)shareBarTabBarController{
    
    static BarTabBarController* barTabBarController = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        barTabBarController = [[[self class] alloc] init];
    });
    
    return barTabBarController;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //创建视图控制器
    [self _initViewControllers];
    //设置标签栏
    [self _initTabBars];
    //获取未读消息总数
    _count = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
    if (_count > 0) {
        _numberLabel.hidden = NO;
        _numberLabel.font = [UIFont systemFontOfSize:7];
        _numberLabel.textColor = [UIColor whiteColor];
        _numberLabel.textAlignment = NSTextAlignmentCenter;
        _numberLabel.layer.cornerRadius = 5;
        _numberLabel.layer.masksToBounds = YES;
        NSString *str = nil;
        if (_count >99) {
            _numberLabel.font = [UIFont systemFontOfSize:4];
            str = [NSString stringWithFormat:@"99+"];
        }else{
            str = [NSString stringWithFormat:@"%ld",_count];
        }
        _numberLabel.text = str;
    }else{
        _numberLabel.hidden = YES;
    }
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    //取得标签栏
    UITabBar *tabbar = self.navigationController. tabBarController.tabBar;
    //1.移除系统默认生成的item
    //    NSLog(@"tabbar.subviews:%@",tabbar.subviews);
    for (UIView *subView in tabbar.subviews) {
        //将string->class
        Class class = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:class]) {
            [subView removeFromSuperview];
        }
    }

}
//创建视图控制器//
- (void)_initViewControllers{
    UIStoryboard * view1sb = [UIStoryboard storyboardWithName:@"Finds" bundle:nil];
    view1 = [view1sb instantiateViewControllerWithIdentifier:@"FindsViewControllerID"];
        UINavigationController * viewcon1 = [[UINavigationController alloc]initWithRootViewController:view1];
//    IntroductionViewController*controller=[[IntroductionViewController alloc]init];
//    UINavigationController*introduction=[[UINavigationController alloc]initWithRootViewController:controller];
    FindsViewController*controller=[[FindsViewController alloc]init];
//    UINavigationController*find=[[UINavigationController alloc]initWithRootViewController:controller];
    
    
    UIStoryboard * view2sb = [UIStoryboard storyboardWithName:@"CLUB" bundle:nil];
    CLUBViewController * view2 = [view2sb instantiateViewControllerWithIdentifier:@"CLUBViewControllerID"];
        UINavigationController * viewcon2 = [[UINavigationController alloc]initWithRootViewController:view2];
//    viewcon2.navigationBar.translucent = NO;
    
    UIStoryboard * Message = [UIStoryboard storyboardWithName:@"Message" bundle:nil];
     MessageVC* view3 = [Message instantiateViewControllerWithIdentifier:@"MessageVCID"];
    UINavigationController * viewcon3 = [[UINavigationController alloc]initWithRootViewController:view3];
    UIStoryboard * sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    selfViewController * view4 = [sb instantiateViewControllerWithIdentifier:@"4thIndex"];
    UINavigationController * viewcon4 = [[UINavigationController alloc]initWithRootViewController:view4];
    self.viewControllers = [[NSArray alloc]initWithObjects:viewcon1,viewcon2,viewcon3,viewcon4,nil];
}
//设置标签栏
- (void)_initTabBars{
    [self.tabBar setBackgroundImage:[UIImage imageNamed:@"tab_jianbian.png"]];
    self.tabBar.layer.borderWidth = 0;
    self.tabBar.layer.borderColor = self.tabBar.tintColor.CGColor;
//  self.tabBar.shadowImage
    //1.移除标签栏上的默认按钮
    NSArray *array = self.tabBar.subviews;
    for (UIView *subView in array) {
        //判断subView是否属于UITabBarButton这个类
        //将字符串转换成类
        Class class = NSClassFromString(@"UITabBarButton");
        if ([subView isKindOfClass:class]) {
            [subView removeFromSuperview];
        }
    }

    //2.添加按钮、添加点击事件
    for (int i=0; i<4; i++) {
        NSString *imgName;
        NSString *selectImg;
        //设置显示的图片
        imgName = [NSString stringWithFormat:@"0%d.png",i+1];
        selectImg = [NSString stringWithFormat:@"00%d.png",i+1];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(KScreenWidth/4.0*i, 0, KScreenWidth/4.0, 45);
        [button setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        [button setImage:[UIImage imageNamed:selectImg] forState:UIControlStateSelected];
        if (KScreenWidth ==375) {
            [button setImageEdgeInsets:UIEdgeInsetsMake(1,25,1,25)];
        }else if (KScreenWidth >375){
            [button setImageEdgeInsets:UIEdgeInsetsMake(7,35,7,35)];
            
        }else
        {
            [button setImageEdgeInsets:UIEdgeInsetsMake(10,25,10,25)];
        }
        
        [button setSelected:NO];
        button.tag = i+1000;
        //添加提示标志
        //小红点
        if(i == 2){
            _numberLabel = [[UILabel alloc] init];
            _numberLabel.font = [UIFont systemFontOfSize:7];
            _numberLabel.textColor = [UIColor whiteColor];
            _numberLabel.textAlignment = NSTextAlignmentCenter;
            _numberLabel.layer.cornerRadius = 5;
            _numberLabel.layer.masksToBounds = YES;
            if (KScreenWidth ==320) {
                
                _numberLabel.frame = CGRectMake(KScreenWidth*3/4-30, 0, 10, 10);
            }else if(KScreenWidth ==375){
                
                _numberLabel.frame = CGRectMake(KScreenWidth*3/4-30, 0, 10, 10);
            }else{
                _numberLabel.frame = CGRectMake(KScreenWidth*3/4-40, 0, 10, 10);
            }
            [_numberLabel setBackgroundColor:[HelperUtil colorWithHexString:@"e43f6d"]];
        [self.tabBar addSubview:_numberLabel];
        }
        //添加点击事件
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBar addSubview:button];
    }
        //4.添加选中图标,设置默认显示位置
        _selectImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"001.png"]];
        //让图标在按钮上居中显示
    if (KScreenWidth==375) {
        _selectImg.frame =CGRectMake(30, 7, KScreenWidth/4.0-60, 35);
    }else if (KScreenWidth >375){
        _selectImg.frame =CGRectMake(35, 7, KScreenWidth/4.0-70, 35);
        
    }else{
        
        _selectImg.frame =CGRectMake(25, 10, KScreenWidth/4.0-50, 29);
    }
    [self.tabBar addSubview:_selectImg];
}

- (void)buttonAction:(UIButton *)button {
    
    _selectImg.hidden = YES;
    _selectedButton.selected =NO;
    button.selected = YES;
    _selectedButton = button;
    
    //切换视图控制器
    self.selectedIndex = button.tag-1000;
    if (self.selectedIndex==2) {
        
    }else if (self.selectedIndex==3) {

    }
    //调用视图的翻转方法
    //[self AnimationTransition:button];
    //调用视图的缩放方法
    [self scaleAnimation:button];
    //设置点击高亮状态
    //button.showsTouchWhenHighlighted = YES;
    //取得动画
    CABasicAnimation *basiction = (CABasicAnimation *) [button.layer animationForKey:@"rotation"];
    if (basiction == nil) {
        //调用视图的旋转方法
        //[self rotationAnimation:button];
    }else{
        if (button.layer.speed == 0) {
            //开始动画
            [self startAnimation:button];
        }else{
            //暂停动画
            [self pauseAnimation:button];
        }
    }
}

#pragma mark- 动画效果
//视图的旋转
-(void)rotationAnimation:(UIButton *)button{
    //(1)创建动画对象
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    //(2)设置属性
    basicAnimation.fromValue = 0;
    basicAnimation.toValue = @(M_PI*2);
    //设置动画时间
    basicAnimation.duration = 0.5;
    //设置重复次数
    basicAnimation.repeatCount =1;//HUGE_VALF
    //设置锚点(旋转点)
    button.layer.anchorPoint = CGPointMake(0.5, 0.5);
    //(3)添加动画
    [button.layer addAnimation:basicAnimation forKey:@"rotation"];
    
}
//开始动画
-(void)startAnimation:(UIButton *)button{
    //0  ---   3  1.5
    CFTimeInterval time = CACurrentMediaTime() - button.layer.timeOffset;
    //设置time作为开始时间
    button.layer.beginTime = time;
    //将timeOffdet归零
    button.layer.timeOffset = 0;
    button.layer.speed = 1;
    
}
//暂停动画
-(void)pauseAnimation:(UIButton *)button{
    //取得当前暂停时间点
    CFTimeInterval pauseTime = [button.layer convertTime:CACurrentMediaTime() fromLayer:nil];
    button.layer.timeOffset = pauseTime;
    button.layer.speed = 0;
    
}
//视图的缩放
-(void)scaleAnimation:(UIButton *)button{
    //实现视图的缩放
    //1.创建动画对象
    CABasicAnimation *basicAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];//(设置缩放)
    
    //2.设置相关属性(这里是缩放值)
    basicAnimation.fromValue = @1;
    basicAnimation.toValue = @1.3;
    //设置动画时间
    basicAnimation.duration = 0.2;
    
    //设置视图恢复原型时也有动画效果
    basicAnimation.autoreverses = YES;
    //设置动画结束以后不移除动画,下面两句实现了动画结束后保持动画结束的最后状态
    //    basicAnimation.removedOnCompletion = NO;
    //    basicAnimation.fillMode = kCAFillModeForwards;
    
    //将动画添加到动图层
    [button.layer addAnimation:basicAnimation forKey:nil];
    
}
//视图翻转动画
- (void)AnimationTransition:(UIButton *)button{
    //单个视图的翻转
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:.1];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:button cache:YES];
    [UIView commitAnimations];
}
#pragma mark - 融云接收消息监听
/**
 接收消息到消息后执行。
 @param message 接收到的消息。
 @param left    剩余消息数.
 */
//- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
//    //    NSLog(@"%@,%d",message,left);
//    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
//    NSInteger number3 = [userDefaultes integerForKey:@"_number3"];
//    if (number3 ==1) {
//        // 震动 首先要引入头文件
//        LxxPlaySound *playSound =[[LxxPlaySound alloc]initForPlayingVibrate];
//        [playSound play];
//        
//    }
////    NSInteger number2 = [userDefaultes integerForKey:@"_number2"];
////    if (number2 ==1) {
////        //自定义声音
////        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSoundEffectWith:@"tap.aif"];
////        [sound play];
////        //        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSystemSoundEffectWith:@"1007" ofType:@"aiff"];
////        //        [sound play];
////        
////    }
//}
/**
 *  收到消息Notifiction处理。用户可以自定义通知，不实现SDK会处理。
 *
 *  @param message    收到的消息实体。
 *  @param senderName 发送者的名字
 *
 *  @return 返回NO，SDK处理通知；返回YES，App自定义通知栏，SDK不再展现通知。
 */
-(BOOL)onRCIMCustomLocalNotification:(RCMessage*)message withSenderName:(NSString *)senderName{
    return NO;
}

/**
 *  收到消息铃声处理。用户可以自定义新消息铃声，不实现SDK会处理。
 *
 *  @param message 收到的消息实体。
 *
 *  @return 返回NO，SDK处理铃声；返回YES，App自定义通知音，SDK不再播放铃音。
 */
//-(BOOL)onRCIMCustomAlertSound:(RCMessage*)message{
//    return YES;
//}

@end
