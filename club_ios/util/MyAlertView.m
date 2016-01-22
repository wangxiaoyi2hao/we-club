//
//  MyAlertView.m
//  Weclub
//
//  Created by 朱立佳 on 15/12/04.
//  Copyright (c) 2015年 朱立佳. All rights reserved.
//

#import "MyAlertView.h"

@implementation MyAlertView
- (id)initWithTitle:(NSString *)title
            message:(NSString *)message
  cancelButtonTitle:(NSString *)cancelButtonTitle
  otherButtonTitles:(NSString *)otherButtonTitles
         clickBlock:(AlertBlcok)tBlock {
    self = [super initWithTitle:title
                        message:message
                       delegate:self
              cancelButtonTitle:cancelButtonTitle
              otherButtonTitles:otherButtonTitles,nil];
    if (self) {
    _block = tBlock;
    }
    
    return self;
    
}
//alertView按照下标点击按钮时调用
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (_block != nil) {
        _block(buttonIndex,self);
    }
    
}





@end
