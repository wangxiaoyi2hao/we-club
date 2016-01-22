//
//  messageViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//我 ->设置 ->消息提醒界面
#import "messageViewController.h"
#import "LxxPlaySound.h"
#import <RongIMKit/RongIMKit.h>
#import "AppDelegate.h"

@interface messageViewController (){
    NSInteger _number1;
    NSInteger _number2;
    NSInteger _number3;
    NSInteger _number4;
    BOOL _isAllowedNotification;
}

@end

@implementation messageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIView *footView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableView.tableFooterView = footView;
    self.view.backgroundColor = BackgroundColor;
    //返回按钮
    [self loadNav];
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    //==1时有声音有震动
    _isAllowedNotification =[AppDelegate isAllowedNotification];
    if (_isAllowedNotification == YES ) {
        _notiImg.image = [UIImage imageNamed:@"reportball.jpg"];
        NSLog(@"已开启");
    }else{
        _notiImg.image = [UIImage imageNamed:@"2-4-2.png"];
        NSLog(@"已关闭");
    }
    //读取数据到各个label中
    //读取整型int类型的数据
//    NSInteger number1 = [userDefaultes integerForKey:@"_number1"];
//    if (number1 == 1) {
//        _notiImg.image = [UIImage imageNamed:@"reportball.jpg"];
//        
//    }else{
//        _notiImg.image = [UIImage imageNamed:@"2-4-2.png"];
//    }
    NSInteger number2 = [userDefaultes integerForKey:@"_number2"];
    if (number2 == 1) {
        _voiceImg.image = [UIImage imageNamed:@"reportball.jpg"];
        
    }else{
        _voiceImg.image = [UIImage imageNamed:@"2-4-2.png"];
    }
    NSInteger number3 = [userDefaultes integerForKey:@"_number3"];
    if (number3 == 1) {
        _vibrateImg.image = [UIImage imageNamed:@"reportball.jpg"];
        
    }else{
        _vibrateImg.image = [UIImage imageNamed:@"2-4-2.png"];
    }
    NSInteger number4 = [userDefaultes integerForKey:@"_number4"];
    if (number4 == 1) {
        _showConteImg.image = [UIImage imageNamed:@"reportball.jpg"];
        
    }else{
        _showConteImg.image = [UIImage imageNamed:@"2-4-2.png"];
    }
//    _number1 = number1;
    _number2 = number2;
    _number3 = number3;
    _number4 = number4;
    
    
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
}
-(void)popView1{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//消息提醒
- (IBAction)notiBtnClick:(UIButton *)sender {
    
    
//    if (_number1 ==0) {
//        
//        _notiImg.image = [UIImage imageNamed:@"reportball.jpg"];
//        /**
//         *  消息免通知，默认是NO
//         */
//        [RCIM sharedRCIM].disableMessageNotificaiton =NO;
//        _number1 = 1;
//    }else if(_number1 == 1){
//        _notiImg.image = [UIImage imageNamed:@"2-4-2.png"];
//        [RCIM sharedRCIM].disableMessageNotificaiton =YES;
//        _number1 = 0;
//    }
//    //将上述数据全部存储到NSUserDefaults中
//    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
//    [userDefaults setInteger:_number1 forKey:@"_number1"];
}
//声音提醒
- (IBAction)voiceBtnClick:(UIButton *)sender {
    if (_number2 ==0) {
//        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSystemSoundEffectWith:@"1007" ofType:@"aiff"];
//        [sound play];
        //自定义声音
        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSoundEffectWith:@"tap.aif"];
        [sound play];
        
        _voiceImg.image = [UIImage imageNamed:@"reportball.jpg"];
        /**
         *  收到消息铃声处理。用户可以自定义新消息铃声，不实现SDK会处理。
         *
         *  @param message 收到的消息实体。
         *
         *  @return 返回NO，SDK处理铃声；返回YES，App自定义通知音，SDK不再播放铃音。
         */
        [RCIM sharedRCIM].disableMessageAlertSound = NO;
        
        _number2 = 1;
    }else if(_number2 == 1){
        _voiceImg.image = [UIImage imageNamed:@"2-4-2.png"];
        _number2 = 0;
        
        [RCIM sharedRCIM].disableMessageAlertSound = YES;
    }
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_number2 forKey:@"_number2"];
    
    
}
//震动提醒
- (IBAction)vibrateBtnClick:(UIButton *)sender {
    if (_number3 ==0) {
        // 震动 首先要引入头文件
        LxxPlaySound *playSound =[[LxxPlaySound alloc]initForPlayingVibrate];
        [playSound play];
        _vibrateImg.image = [UIImage imageNamed:@"reportball.jpg"];
        _number3 = 1;
    }else if(_number3 == 1){
        _vibrateImg.image = [UIImage imageNamed:@"2-4-2.png"];
        _number3 = 0;
    }
    
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_number3 forKey:@"_number3"];
}
//提醒时显示的内容按钮
- (IBAction)showContentBtnClick:(UIButton *)sender {
    if (_number4 ==0) {
        _showConteImg.image = [UIImage imageNamed:@"reportball.jpg"];
        /**
         *  消息免通知，默认是NO
         */
        [RCIM sharedRCIM].disableMessageNotificaiton = YES;
        _number4 = 1;
    }else if(_number4 == 1){
        _showConteImg.image = [UIImage imageNamed:@"2-4-2.png"];
        /**
         *  消息免通知，默认是NO
         */
        [RCIM sharedRCIM].disableMessageNotificaiton = NO;
        _number4 = 0;
        //[[RCIMClient sharedRCIMClient] getHistoryMessages:ConversationType_CHATROOM targetId:@"1000" oldestMessageId:@"2000dd" count:1666];
    }
    //将上述数据全部存储到NSUserDefaults中
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:_number4 forKey:@"_number4"];
}
//返回按钮
- (IBAction)backBtnClick:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
    NSLog(@"点击了");
}
@end
