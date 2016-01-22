//
//  HelloModel.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//打过的招呼
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelloModel : NSObject

@property (nonatomic , strong) UIImage *photo;
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSDate *time;
@property (nonatomic , strong) NSMutableArray *helloContent;

@end
