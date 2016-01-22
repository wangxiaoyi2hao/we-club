//
//  massageModel.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//消息界面model
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface massageModels: NSObject

@property (nonatomic , strong) NSMutableArray *photo;
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSDate *lastTime;
@property (nonatomic , strong) NSMutableArray *unreadMessage;


@end
