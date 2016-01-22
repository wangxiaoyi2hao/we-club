//
//  HelperUtil.m
//  SQLite（购物）
//
//  Created by Yock Deng on 15/8/22.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "HelperUtil.h"
#import <CommonCrypto/CommonDigest.h>
@implementation HelperUtil
+(BOOL)checkAccoundName:(NSString*)accountName{




    return YES;
}
+ (NSString *)htmlShuangyinhao:(NSString *)values{
    if (values == nil) {
        return @"";
    }
    /*
     字符串的替换
     注：将字符串中的参数进行替换
     参数1：目标替换值
     参数2：替换成为的值
     参数3：类型为默认：NSLiteralSearch
     参数4：替换的范围
     */
    NSMutableString *temp = [NSMutableString stringWithString:values];
    [temp replaceOccurrencesOfString:@"\"" withString:@"'" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\n" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    [temp replaceOccurrencesOfString:@"\r" withString:@"" options:NSLiteralSearch range:NSMakeRange(0, [temp length])];
    return temp;
}
//判断是否为空
+ (NSString *)isDefault:(NSString *)getStr{
    if ([getStr isEqualToString:@""] || [getStr isEqualToString:NULL] || [getStr isEqualToString:nil] || [getStr isEqualToString:@"null"] || [getStr isEqualToString:@"<null>"] || [getStr isEqualToString:@"(null)"] || [getStr isEqualToString:@"nil"] || [getStr isEqualToString:@"<nil>"] || [getStr isKindOfClass:[NSNull class]]||getStr==nil) {
        NSString *defaultStr=@"未填写";
        return defaultStr;
    }else{
        return getStr;
    }
}

//可以计算颜色的rgb的类方法
+ (UIColor *) colorWithHexString: (NSString *) stringToConvert
{
    NSString *cString = [[stringToConvert stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    
    // String should be 6 or 8 characters
    if ([cString length] < 6) return [UIColor colorWithWhite:1.0 alpha:0.5];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"]) cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"]) cString = [cString substringFromIndex:1];
    if ([cString length] != 6) return [UIColor colorWithWhite:1.0 alpha:0.5];
    // Separate into r, g, b substrings
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    
    // Scan values
    unsigned int r, g, b;
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}
//md5 加密的代码
+ (NSString*)md532BitUpper:(NSString*)input{
    
    const char *cStr = [input UTF8String];

    unsigned char result[16];

    NSNumber *num = [NSNumber numberWithUnsignedLong:strlen(cStr)];

    CC_MD5( cStr,[num intValue], result );
 
    return [[NSString stringWithFormat:
          
             @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
           
             result[0], result[1], result[2], result[3],
            
             result[4], result[5], result[6], result[7],
            
             result[8], result[9], result[10], result[11],
            
             result[12], result[13], result[14], result[15]
            
             ] uppercaseString];
  
}
//判断密码的正则表达式
+(BOOL)checkPassaword:(NSString*)passWordText{
    NSString *pattern = @"[A-Za-z0-9]{6,16}";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:passWordText];
    return isMatch;

}
//正则表达式  判断昵称
+ (BOOL)checkUserName : (NSString *) userName
{
    NSString *pattern = @"^[A-Za-z0-9]{6,20}+$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    BOOL isMatch = [pred evaluateWithObject:userName];
    return isMatch;
    
}
#pragma mark  判断昵称的正则表达式
//正则表达式  判断昵称
//+ (BOOL)chec : (NSString *) userName
//{
//    NSString *pattern = @"^[A-Za-z0-9]{6,20}+$";
//    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
//    BOOL isMatch = [pred evaluateWithObject:userName];
//    return isMatch;
//    
//}

//判断手机号的正则表达式
+(BOOL)checkTel:(NSString *)str{
    NSString *regex = @"^((13[0-9])|(147)|(15[^4,\\D])|(18[0,0-9]))\\d{8}$";
    
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    BOOL isMatch = [pred evaluateWithObject:str];
   
    
    return isMatch;
}
@end
