//
//  QiNiuClassSend.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/7.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "QiNiuClassSend.h"
static QiNiuClassSend *singleInstance;
@implementation QiNiuClassSend
+(QiNiuClassSend *)sharQiNiuClassSend{
    @synchronized (self){
        if (singleInstance==nil) {
            singleInstance=[[QiNiuClassSend alloc] init];
        }
    }
    return singleInstance;

}

@end
