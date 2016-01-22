//
//  MyButton.h
//  Bar
//
//  Created by jeck on 15/10/24.
//  Copyright (c) 2015年 jeck. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyButton : UIControl

- (id)initWithFrame:(CGRect)frame
      withImageName:(NSString *)imgName
          withTitle:(NSString *)title withColor:(UIColor *)color;

@end
