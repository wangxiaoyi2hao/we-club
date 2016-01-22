//
//  YockPhotoImgView.m
//  自定义图片查看器
//
//  Created by Lxrent 66 on 15/10/14.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "YockPhotoImgView.h"

@interface RotateGesture : UIRotationGestureRecognizer {}
@end

@implementation RotateGesture

- (BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer*)gesture{
    return NO;
}
- (BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
    return NO;
}
@end

@implementation YockPhotoImgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        //设置UIImageView对象支持用户交互（UIImageView默认是不支持与用户交互）
        self.userInteractionEnabled=YES;
        //缩放手势
        UIPinchGestureRecognizer *pinchGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinch:)];
        [self addGestureRecognizer:pinchGesture];
        
        //旋转手势
//        RotateGesture *rotationGesture=[[RotateGesture alloc] initWithTarget:self action:@selector(rotatePiece:)];
//        [self addGestureRecognizer:rotationGesture];
    }
    
    return self;
}

-(void)handlePinch:(UIPinchGestureRecognizer *)gesture{
    self.transform = CGAffineTransformScale(self.transform, [gesture scale], [gesture scale]);
    [gesture setScale:1.0];
}
- (void)rotatePiece:(UIRotationGestureRecognizer *)gestureRecognizer
{
    self.transform = CGAffineTransformRotate(self.transform, [gestureRecognizer rotation]);
    [gestureRecognizer setRotation:0];
}

@end
