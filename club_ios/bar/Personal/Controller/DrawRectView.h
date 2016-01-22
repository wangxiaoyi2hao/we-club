//
//  DrawRectView.h
//  bar
//
//  Created by chen on 15/11/29.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DrawRectView : UIView
@property (nonatomic, assign)float fromFloat;
- (void)drawArc:(CGContextRef)context withInt:(float)fromint;
@end
