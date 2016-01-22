//
//  TDQiNiuUploadHelper.h
//  Tudur
//
//  Created by WuHai on 15/4/14.
//  Copyright (c) 2015年 LZeal Information Technology Co.,Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TDQiNiuUploadHelper : NSObject

@property (copy, nonatomic) void (^singleSuccessBlock)(NSString *);
@property (copy, nonatomic)  void (^singleFailureBlock)();

+ (instancetype)sharedInstance;
@end
