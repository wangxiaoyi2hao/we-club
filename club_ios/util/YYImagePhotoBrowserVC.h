//
//  YYImagePhotoBrowserVC.h
//  lvban
//
//  Created by hou on 13-7-2.
//  Copyright (c) 2013年 syezon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageManager.h"

@interface YYImagePhotoBrowserVC : UIViewController<UIScrollViewDelegate, UIGestureRecognizerDelegate, SDWebImageManagerDelegate,UIActionSheetDelegate>

- (id)initWithContent:(id)content;
@end
