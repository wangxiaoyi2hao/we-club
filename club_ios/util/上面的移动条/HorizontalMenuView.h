//
//  HorizontalMenuView.h
//  NSArrayAndNSDic
//
//  Created by 安永超 on 15/11/27.
//  Copyright © 2015年 安永超. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
   ***自定义协议
 */
@protocol HorizontalMenuProtocol <NSObject>

@optional//可选方法

@required//必须实现的-
- (void)getTag:(NSInteger)tag;//获取当前被选中下标值

@end

@interface HorizontalMenuView : UIView

{
    NSArray *_menuArray;//获取到的菜单名数组
}
- (void)setNameWithArray:(NSArray *)menuArray;//设置菜单名的方法

//协议代理
@property (nonatomic,assign)id <HorizontalMenuProtocol> myDelegate;
@end
