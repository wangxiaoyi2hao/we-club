//
//  notificationModel.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface notificationModel : NSObject

@property (nonatomic , strong) UIImage *photo;
@property (nonatomic , strong) NSString *name;
@property (nonatomic , strong) NSNumber *choice;    // 0 for good result , 1 for bad result , 2 for decision
@property (nonatomic , strong) NSDate *time;
@property (nonatomic , strong) NSString *userInvolved;

@end
