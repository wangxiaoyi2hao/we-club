//
//  YYPhotoBrowserVC.h
//  Test
//
//  Created by xqj on 13-6-9.
//  Copyright (c) 2013年 syezon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"



@interface YYPhotoBrowserVC : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, SDWebImageManagerDelegate,UIActionSheetDelegate>

//图片urls
- (id)initWithbigImageUrls:(NSArray *)urlArr smallImageUrls:(NSArray *)surlArr;
//图片rul 缩略图
- (id)initWithUrls:(NSArray *)urlArr thumbsImgs:(NSArray *)imgArr;
////图片rul 缩略图url
//- (id)initWithUrls:(NSArray *)urlArr thumbsUrls:(NSArray *)thumbUrlArr;
//设置图片index
- (void)setImageIndex:(NSInteger)imageIndex;



@end
