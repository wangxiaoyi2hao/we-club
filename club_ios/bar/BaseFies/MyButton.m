//
//  MyButton.h
//  Bar
//
//  Created by jeck on 15/10/24.
//  Copyright (c) 2015年 jeck. All rights reserved.
//

#import "MyButton.h"

@implementation MyButton

- (id)initWithFrame:(CGRect)frame
      withImageName:(NSString *)imgName
          withTitle:(NSString *)title withColor:(UIColor *)color{

    self = [super initWithFrame:frame];
    
    if (self) {
        
        //创建子视图
        UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 0, CGRectGetWidth(frame)-20, CGRectGetHeight(frame)-5-10)];
        //imgView.userInteractionEnabled = YES;
        //设置imgView的填充方式
        imgView.contentMode = UIViewContentModeScaleAspectFit;
        imgView.image = [UIImage imageNamed:imgName];
        [self addSubview:imgView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(imgView.frame), CGRectGetWidth(frame), 20)];
        titleLabel.text = title;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        titleLabel.font = [UIFont systemFontOfSize:13];
        titleLabel.textColor = color;
        [self addSubview:titleLabel];
        
    }
    
    return self;
}

@end
