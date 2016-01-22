//
//  specificBindViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//绑定XXXXX
#import "specificBindViewController.h"

@interface specificBindViewController ()

@end

@implementation specificBindViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *title = [NSString stringWithFormat:@"绑定%@",_data.name];
    self.navigationItem.title = title;
    
    _logoField.image = _data.logo;
    _nameLabel.text = [NSString stringWithFormat:@"帮您快速添加%@好友",_data.name];
    NSInteger date = [_data.number integerValue];
    _numberLabel.text = [NSString stringWithFormat:@"已经有%ld人绑定%@",(long)date,_data.name];
    //返回按钮
    [self loadNav];
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

//把数据存到本地(导航过来的时候,调用这个方法)
- (void)setData:(bindingModel *)data {
    _data = [[bindingModel alloc] init];
    _data.logo = data.logo;
    _data.number = data.number;
    _data.name = data.name;
}

- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)bindBtnClick:(UIButton *)sender {
    NSLog(@"你点击了绑定按钮");
}
@end
