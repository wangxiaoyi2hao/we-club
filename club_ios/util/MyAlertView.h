//
//  MyAlertView.h
//  Weclub
//
//  Created by 朱立佳 on 15/12/04.
//  Copyright (c) 2015年 朱立佳. All rights reserved.
//
//  自定义alertView
#import <UIKit/UIKit.h>
typedef  void(^ AlertBlcok)(NSInteger index,UIAlertView *alertView);

@interface MyAlertView : UIAlertView<UIAlertViewDelegate>
@property(nonatomic, copy)AlertBlcok block;
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
         clickBlock:(AlertBlcok)tBlock;

@end
