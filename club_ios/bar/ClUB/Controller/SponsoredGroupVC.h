//
//  ViewController.h
//  bar
//
//  Created by jeck on 15/10/27.
//  Copyright (c) 2015年 jeck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SponsoredGroupVC : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate>

@property(nonatomic,strong)NSMutableArray*fromArray;//可以用这个数组去在这个页面得到一些数据－－这样还节省流量。
@end

