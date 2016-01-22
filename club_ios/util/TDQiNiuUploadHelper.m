//
//  TDQiNiuUploadHelper.m
//  Tudur
//
//  Created by WuHai on 15/4/14.
//  Copyright (c) 2015年 LZeal Information Technology Co.,Ltd. All rights reserved.
//

#import "TDQiNiuUploadHelper.h"

@implementation TDQiNiuUploadHelper

+ (instancetype)sharedInstance
{
    static TDQiNiuUploadHelper *_sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[TDQiNiuUploadHelper alloc] init];
    });
    return _sharedInstance;
}

@end
