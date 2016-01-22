//
//  specificBindViewController.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//绑定XXXXX
#import <UIKit/UIKit.h>
#import "bindingModel.h"

@interface specificBindViewController : UIViewController


@property (weak, nonatomic) IBOutlet UIImageView *logoField;//绑定图片
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;//绑定数量
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;//绑定姓名
@property (strong , nonatomic) bindingModel *data;


- (IBAction)backBtnClick:(UIBarButtonItem *)sender;//返回按钮
- (IBAction)bindBtnClick:(UIButton *)sender;//绑定按钮
- (void)setData:(bindingModel *)data;

@end
