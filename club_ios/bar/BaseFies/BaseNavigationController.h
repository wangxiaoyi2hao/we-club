//
//  BaseNavigationController.h
//  bar
//
//  Created by chen on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BaseNavigationController : UINavigationController
-(void)initNavBar:(NSString *)Middletitle withLeftTitle:(NSString *)leftTitle withRightTitle:(NSString *)rightTitle;
@end
