//
//  ChooseInviteVC.m
//  Weclub
//
//  Created by chen on 16/1/21.
//  Copyright © 2016年 BIT. All rights reserved.
//
/*
 // 1, 男性  2，女性  3，全部
 @property(nonatomic, readwrite) int32_t sex;
 
 // 1, 红包  2， 非红包
 @property(nonatomic, readwrite) int32_t hasMoney;
 
 // 城市 id
 @property(nonatomic, readwrite, copy, null_resettable) NSString *cityId;
 
 // 区域（商圈）id 例如三里屯的id，详见11021的接口
 @property(nonatomic, readwrite, copy, null_resettable) NSString *areaTownId;
 
 // 邀约最短时长
 @property(nonatomic, readwrite) int32_t duringMin;
 
 // 邀约最长时长
 @property(nonatomic, readwrite) int32_t duringMax;
 
 //客户端已经获得的总数    首次请求为0
 @property(nonatomic, readwrite) int32_t totleCount;
 
 //客户端目前的获得的邀约范围    首次请求为0
 @property(nonatomic, readwrite) float area;
 
 // 排序方式，可选 1，离我最近 2，近期发布 3(或0)，默认排序，也就是首页排序
 @property(nonatomic, readwrite) int32_t orderType;
 
 */
#import "ChooseInviteVC.h"
#import "AppDelegate.h"
#import "UIView+Blur.h"

@interface ChooseInviteVC (){
    int _selectSwitch;
    
}

@end

@implementation ChooseInviteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
    
    _chooseDictionary = [[NSMutableDictionary alloc] init];
    //设置背景为毛玻璃效果
    _backImageView.blurTintColor=[UIColor colorWithWhite:1 alpha:0.00005];
    _backImageView.blurStyle=UIViewBlurLightStyle;
    [_backImageView enableBlur:YES];
    //设置确定按钮
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(14, 520*KScreenHeight/667, 347*KScreenWidth/375, 50*KScreenHeight/667);
    button.backgroundColor = [UIColor colorWithRed:255/255.0 green:97/255.0  blue:98/255.0  alpha:1];
    [button addTarget:self action:@selector(chooseButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font=[UIFont boldSystemFontOfSize:16];
    button.layer.cornerRadius = 25;
    button.layer.masksToBounds = YES;
    [button setBackgroundImage:[UIImage imageNamed:@"tab_black.png"] forState:UIControlStateHighlighted];
    [self.view addSubview:button];
    //设置红包开关
    UISwitch *redPacketSwitch;
    if (KScreenWidth == 375) {
        redPacketSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(308, 194, 51, 31)];
        
    }else if(KScreenWidth == 320){
        redPacketSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(308*KScreenWidth/375, 194*KScreenHeight/667, 51, 31)];
    }else if(KScreenWidth > 375){
        redPacketSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(308*KScreenWidth/375, 194*KScreenHeight/667, 51, 31)];
        
    }
    [redPacketSwitch addTarget:self action:@selector(switchStateChange) forControlEvents:UIControlEventValueChanged];
    [_backView addSubview:redPacketSwitch];
    //默认为非红包邀约
    redPacketSwitch.on = NO;
    _selectSwitch = 0;
    [_chooseDictionary setObject:[NSNumber numberWithInt:2] forKey:@"isRedPacketInvite"];
    
    //性别默认值
    [_chooseDictionary setObject:[NSNumber numberWithInt:3] forKey:@"chooseSix"];
    //默认排序方式
    [_chooseDictionary setObject:[NSNumber numberWithInt:3]  forKey:@"nearbyOrnewsSend"];
    
  
}

- (void)switchStateChange{
    NSNumber *selectNumber;
    if (_selectSwitch == 0) {
        NSLog(@"红包邀约");
        _selectSwitch = 1;
        selectNumber = [NSNumber numberWithInt:1];
    }else if (_selectSwitch == 1){
        NSLog(@"非红包邀约");
        _selectSwitch = 0;
        selectNumber = [NSNumber numberWithInt:2];
    }
    [_chooseDictionary setObject:selectNumber forKey:@"isRedPacketInvite"];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//确定选择
- (void)chooseButtonAction:(UIButton *)button{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chooseInviteNotification" object:self userInfo:_chooseDictionary];
    [self.navigationController popViewControllerAnimated:YES];
}
//离我最近
- (IBAction)nearbyAction:(UIButton *)sender {
    _newsSendLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _nearbyLabel.textColor =[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    [_chooseDictionary setObject:[NSNumber numberWithInt:1] forKey:@"nearbyOrnewsSend"];
}
//近期发布
- (IBAction)newsSendAction:(UIButton *)sender {
    _nearbyLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _newsSendLabel.textColor =[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    [_chooseDictionary setObject:[NSNumber numberWithInt:2] forKey:@"nearbyOrnewsSend"];
    
    
}
//选择性别
- (IBAction)allAction:(UIButton *)sender {
    _boyLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _girllabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _allLabel.textColor =[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    [_chooseDictionary setObject:[NSNumber numberWithInt:3] forKey:@"chooseSix"];
}
- (IBAction)boyAction:(UIButton *)sender {
    _allLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _girllabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _boyLabel.textColor =[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    [_chooseDictionary setObject:[NSNumber numberWithInt:1] forKey:@"chooseSix"];
}
- (IBAction)girlAction:(UIButton *)sender {
    _boyLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _allLabel.textColor = [UIColor colorWithRed:179/255.0 green:179/255.0 blue:179/255.0 alpha:1];
    _girllabel.textColor =[UIColor colorWithRed:96/255.0 green:96/255.0 blue:96/255.0 alpha:1];
    [_chooseDictionary setObject:[NSNumber numberWithInt:2] forKey:@"chooseSix"];
}
- (IBAction)areaAction:(UIButton *)sender {
    NSLog(@"选择地区");
    
    
}
- (IBAction)commerceAction:(UIButton *)sender {
    NSLog(@"选择商圈");
    
    
}
- (IBAction)timeAction:(UIButton *)sender {
    NSLog(@"选择时长");
    
}

@end
