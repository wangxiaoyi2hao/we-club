//
//  MyFile.m
//  属性列表练习（备忘录）
//
//  Created by apple on 15/8/18.
//  Copyright (c) 2015年 com. All rights reserved.
//

#import "MyFile.h"
#import <CoreLocation/CoreLocation.h>
#import "CommonCrypto/CommonDigest.h"

@implementation MyFile

+(NSString *)fileByDocumentPath:(NSString *)filename{
    //取出Document路径
    NSArray *array=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *pathStr=[array objectAtIndex:0];
    
    return [pathStr stringByAppendingString:filename];
}
//根据经纬度算距离
+( CLLocationDistance)meterKiloHaveHowLong:(float)orginLatitude wei:(float)orginlongitude arrJing:(float)arrivewLocationJing arrWei:(float)arriLocationWei{
    CLLocation*orign=[[CLLocation alloc]initWithLatitude:orginLatitude longitude:orginlongitude];
    CLLocation*dist=[[CLLocation alloc]initWithLatitude:arrivewLocationJing longitude:arriLocationWei];
    CLLocationDistance kilometers=[orign distanceFromLocation:dist]/1000;

    return kilometers;
}
//根据日期算星期几
+ (NSString*)weekdayStringFromDate:(NSDate*)inputDate {
    NSArray *weekdays = [NSArray arrayWithObjects: [NSNull null], @"星期日", @"星期一", @"星期二", @"星期三", @"星期四", @"星期五", @"星期六", nil];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSTimeZone *timeZone = [[NSTimeZone alloc] initWithName:@"Asia/Shanghai"];
    
    [calendar setTimeZone: timeZone];
    
    NSCalendarUnit calendarUnit = NSWeekdayCalendarUnit;
    
    NSDateComponents *theComponents = [calendar components:calendarUnit fromDate:inputDate];
    
    return [weekdays objectAtIndex:theComponents.weekday];
    
}
//判断手机号的正则
+(BOOL) isValidateMobile:(NSString *)mobile
{
    //手机号以13， 15，18开头，八个 \d 数字字符
    NSString *phoneRegex = @"^((13[0-9])|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}


@end
