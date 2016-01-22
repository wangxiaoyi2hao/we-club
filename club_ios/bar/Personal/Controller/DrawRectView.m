//
//  DrawRectView.m
//  bar
//
//  Created by chen on 15/11/29.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "DrawRectView.h"
#pragma mark - 在这里修改完成度
#define FinishValue  1.2
@implementation DrawRectView
- (void)setFromFloat:(float)fromFloat{
    _fromFloat = fromFloat;
}
- (void)drawRect:(CGRect)rect {
    //绘制线条
    // 1.获取绘制的对象（上下文）（画布、纸）
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawArc:context withInt:_fromFloat];
}
#pragma mark - 绘制圆弧
- (void)drawArc:(CGContextRef)context withInt:(float)fromint {
    
    /*
     context:上下文
     x，y ：圆心
     radius：半径
     startAngle：起始角度
     endAngle：结束角度
     clockwise:角度旋转方向 0：顺时针   1：逆时针
     */
#pragma mark - 在这里修改完成度
    CGContextAddArc(context, 42, 42,37, M_PI*3/2,M_PI*3/2+M_PI*fromint, 0);
    //设置线条的宽度
    CGContextSetLineWidth(context, 9);
    //设置线条的颜色
    [[HelperUtil colorWithHexString:@"e43f6d"] setStroke];
    
    //设置填充色
    [[UIColor clearColor] setFill];
    
    //绘制
    CGContextDrawPath(context, kCGPathFillStroke);
}



@end
