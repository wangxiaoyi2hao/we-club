//
//  MyFile.h
//  属性列表练习（备忘录）
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyFile : NSObject

//拼接Document目录中的文件路径
+(NSString *)fileByDocumentPath:(NSString *)filename;
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate;
+( CLLocationDistance)meterKiloHaveHowLong:(float)orginLatitude wei:(float)orginlongitude arrJing:(float)arrivewLocationJing arrWei:(float)arriLocationWei;
+(BOOL) isValidateMobile:(NSString *)mobile;
//md5

+(NSString*)md532BitUpper:(NSString*)password;

@end
