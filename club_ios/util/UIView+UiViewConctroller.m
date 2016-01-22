//
//  UIView+UiViewConctroller.m
//  NextResbonder
//
//  Created by imac on 15/6/22.
//  Copyright (c) 2015年 misty. All rights reserved.
//

#import "UIView+UiViewConctroller.h"

@implementation UIView (UiViewConctroller)
//视图通过下一个响应者取视图控制器
-(UIViewController *)viewController{
    //取得view的下一个响应者
    UIResponder *next = self.nextResponder;
    do {
        if ([next isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)next;//如果是视图控制器则返回视图控制器类型的"next"
        }
        next = next.nextResponder;//如果不是,取下一个的下一个响应者
    } while (next != nil);//当下一个为空时,说明没有视图控制器
    
    return nil;   
}

@end
