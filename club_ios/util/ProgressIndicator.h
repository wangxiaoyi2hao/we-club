//
//  ProgressIndicator.h
//  Test
//
//  Created by xqj on 13-6-9.
//  Copyright (c) 2013年 syezon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProgressIndicator : UIView

//下载资源的总大小
@property CGFloat totalSize;

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end
