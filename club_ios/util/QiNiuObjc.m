//
//  QiNiuObjc.m
//  bar
//
//  Created by lsp's mac pro on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "QiNiuObjc.h"
static QiNiuObjc *singleInstance;
@implementation QiNiuObjc
+(QiNiuObjc *)shareQiNiuObjc{
    @synchronized (self){
        if (singleInstance==nil) {
            singleInstance=[[QiNiuObjc alloc] init];
        }
    }
    return singleInstance;
}
-(void)sevenCows:(NSString*)token data:(NSData*)imgData key:(NSString*)imagKey{

//    NSString *token = @"7XCCETRyC5OEr0PMAJYmAC9UK6cqnrOgKW59tahN:DCM23d_QL-4tv0ywnyM4Z00t97Q=:eyJzY29wZSI6IndlY2x1YiIsImRlYWRsaW5lIjoxNDQ3NjY2NzUxfQ==";
    QNUploadManager *upManager = [[QNUploadManager alloc] init];
//    NSData *data = [@"Hello, World!" dataUsingEncoding : NSUTF8StringEncoding];3
    [upManager putData:imgData key:imagKey token:token
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  NSLog(@"%@", info);
                  NSLog(@"%@", resp);
              } option:nil];
}
@end
