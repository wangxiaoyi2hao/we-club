//
//  MyImg.m
//  MyPicSelect
//
//  Created by 蓝桥 on 15/10/17.
//  Copyright (c) 2015年 蓝桥. All rights reserved.
//

#import "MyImg.h"

@interface MyRotation : UIRotationGestureRecognizer
@end

@implementation MyRotation

-(BOOL)canBePreventedByGestureRecognizer:(UIGestureRecognizer *)preventingGestureRecognizer{
    return NO;
}
-(BOOL)canPreventGestureRecognizer:(UIGestureRecognizer *)preventedGestureRecognizer{
    return NO;
}

@end

@implementation MyImg

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        
        //添加捏合手势
        UIPinchGestureRecognizer *pincheGesture=[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinchHandler:)];
        [self addGestureRecognizer:pincheGesture];
        
        //添加旋转手势
        MyRotation *rotationGesture=[[MyRotation alloc] initWithTarget:self action:@selector(rotationHandler:)];
        [self addGestureRecognizer:rotationGesture];
        
    }
    
    return self;
}

-(void)pinchHandler:(UIPinchGestureRecognizer *)sender{
    NSLog(@"%.2f",sender.scale);
    self.transform=CGAffineTransformScale(self.transform, sender.scale, sender.scale);
    sender.scale=1.0;
}

-(void)rotationHandler:(UIRotationGestureRecognizer *)sender{
    self.transform=CGAffineTransformRotate(self.transform, sender.rotation);
    sender.rotation=0;
}

@end
