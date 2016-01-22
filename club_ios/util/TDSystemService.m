//
//  TDSystemService.m
//  Tudur
//
//  Created by WuHai on 15/3/10.
//  Copyright (c) 2015年 LZeal Information Technology Co.,Ltd. All rights reserved.
//

#import "TDSystemService.h"
#import "TDSystemStorage.h"
#import "NSDate+Formatting.h"
#import "TDAccount.h"
#import "UIImage+Resize.h"
#import "TDQiNiuUploadHelper.h"

@implementation TDSystemService

+ (void)saveIntroShowed
{
    [TDSystemStorage saveIntroShowed];
}

+ (BOOL)hasIntroShowed
{
    return [TDSystemStorage getIntroShowed].length;
}

+ (void)uploadImage:(UIImage *)image progress:(QNUpProgressHandler)progress success:(void (^)(NSString *url))success failure:(void (^)())failure
{
    [TDSystemService getQiniuUploadToken:^(NSString *token) {
        UIImage *sizedImage = [image resizedImageWithMaximumSize:CGSizeMake(1000, 1000)];
        NSData *data = UIImageJPEGRepresentation(sizedImage, 0.7);
        if (!data) {
            if (failure) {
                failure();
            }
            return;
        }
        
        QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:progress params:nil checkCrc:NO cancellationSignal:nil];
        QNUploadManager *uploadManager = [QNUploadManager sharedInstanceWithRecorder:nil recorderKeyGenerator:nil];
        [uploadManager putData:data key:nil token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            if (info.statusCode == 200 && resp) {
                NSString *urlBase = [TDAccountService currentAccountObject].image_base;
                NSString *url;
                if (urlBase.length) {
                    url = [NSString stringWithFormat:@"%@%@", urlBase, resp[@"key"]];
                }
                else {
                    url = resp[@"key"];
                }
                if (success) {
                    success(url);
                }
            }
            else {
                if (failure) {
                    failure();
                }
            }
        } option:opt];
    } failure:^{
        if (failure) {
            failure();
        }
    }];
}

+ (void)uploadImages:(NSArray *)imageArray progress:(void (^)(CGFloat))progress success:(void (^)(NSArray *))success failure:(void (^)())failure
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    __block float totalProgress = 0.0f;
    __block float partProgress = 1.0f / [imageArray count];
    __block NSUInteger currentIndex = 0;
    
    TDQiNiuUploadHelper *uploadHelper = [TDQiNiuUploadHelper sharedInstance];
    __weak typeof(uploadHelper) weakHelper = uploadHelper;
    
    uploadHelper.singleFailureBlock = ^() {
        failure();
        return;
    };
    uploadHelper.singleSuccessBlock  = ^(NSString *url) {
        [array addObject:url];
        totalProgress += partProgress;
        progress(totalProgress);
        currentIndex++;
        if ([array count] == [imageArray count]) {
            success([array copy]);
            return;
        }
        else {
            [TDSystemService uploadImage:imageArray[currentIndex] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
        }
    };

    [TDSystemService uploadImage:imageArray[0] progress:nil success:weakHelper.singleSuccessBlock failure:weakHelper.singleFailureBlock];
}

+ (void)getQiniuUploadToken:(void (^)(NSString *))success failure:(void (^)())failure
{
    NSDictionary *tokenDict = [TDSystemStorage getUploadToken];
    NSString *expireDate = tokenDict[@"expire"];
    BOOL expired;
    if (expireDate.length) {
        NSDate *tokenExpireDate = [NSDate dateFromString:expireDate withFormat:@"yyyy-MM-dd HH:mm:ss"];
        NSDate *now = [NSDate date];
        if ([tokenExpireDate compare:now] == NSOrderedAscending) { // qiniu token时间已经过期
            expired = YES;
        }
        else {
            expired = NO;
        }
    }
    else {
        expired = YES;
    }
    
    __block NSString *uploadToken;
    if (expired) {
        [TDHttpClient postWithPath:kTDApiUploadToken parameters:@{@"function": @"0"} prepareExecute:nil success:^(NSString *path, id responseJson) {
            uploadToken = responseJson[@"token"];
            NSTimeInterval expire = [responseJson[@"expire"] doubleValue];
            NSDate *now = [NSDate date];
            now = [now dateByAddingTimeInterval:expire];
            NSString *expireDateString = [now stringForFormat:@"yyyy-MM-dd HH:mm:ss"];
            [TDSystemStorage saveUploadToken:@{@"expire": expireDateString, @"token": uploadToken}];
            if (success) {
                success(uploadToken);
            }
        } failure:^(NSString *path, NSError *error) {
            if (failure) {
                failure();
            }
        }];
    }
    else {
        uploadToken = tokenDict[@"token"];
        if (success) {
            success(uploadToken);
        }
    }
}

+ (void)requestVersionUpdate:(void (^)(NSDictionary *))success failure:(void (^)())failure
{
    NSDictionary *parameters = @{@"version": [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"],
                                 @"platform": @"ios"};
    [TDHttpClient postWithPath:kTDApiVersionUpdate parameters:parameters prepareExecute:nil success:^(NSString *path, id responseJson) {
        if (success) {
            success(responseJson);
        }
    } failure:^(NSString *path, NSError *error) {
        if (failure) {
            failure();
        }
    }];
}


@end
