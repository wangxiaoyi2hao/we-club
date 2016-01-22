//
//  HelperUtil.h
//  SQLite（购物）
//
//  Created by Yock Deng on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface HelperUtil : NSObject
//这个事判html语言 替换字符
+ (NSString *)htmlShuangyinhao:(NSString *)values;
//这个事选颜色
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert;
//这个默认值
+ (NSString *)isDefault:(NSString *)getStr;
//md5加密
//+ (NSString *)md5HexDigest:(NSString*)input;
//md5加密 32位大写
+ (NSString*)md532BitUpper:(NSString*)input;

//正则判断密码
+(BOOL)checkPassaword:(NSString*)passWordText;

//正则昵称
//+ (BOOL) checkNickname:(NSString *) nickname;
+ (BOOL)checkTel:(NSString *)str;






@end
