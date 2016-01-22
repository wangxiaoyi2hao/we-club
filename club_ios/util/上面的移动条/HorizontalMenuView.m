//
//  HorizontalMenuView.m
//  NSArrayAndNSDic
//
//  Created by 安永超 on 15/11/27.
//  Copyright © 2015年 安永超. All rights reserved.
//

#import "HorizontalMenuView.h"

@implementation HorizontalMenuView

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)setNameWithArray:(NSArray *)menuArray{
   _menuArray = menuArray;
   
   //一个间隔
   CGFloat SPACE = (self.frame.size.width)/[_menuArray count];
   
   for (int i = 0; i<menuArray.count; i++) {
      UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
      btn.frame = CGRectMake(SPACE*i, 0, SPACE, self.frame.size.height);
      
      btn.tag = i;
      if (btn.tag == 0) {
         btn.enabled = NO;
      }
      //设置按钮字体大小，颜色，状态
      
      NSMutableAttributedString *str = [[NSMutableAttributedString alloc] initWithString:menuArray[i]];
      [str addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:14],NSForegroundColorAttributeName:[UIColor grayColor]} range:NSMakeRange(0, [str length])];
      [btn setAttributedTitle:str forState:UIControlStateNormal];
      
      NSMutableAttributedString *selStr = [[NSMutableAttributedString alloc] initWithString:menuArray[i]];
      [selStr addAttributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:18],NSForegroundColorAttributeName:[UIColor orangeColor]} range:NSMakeRange(0, [str length])];
      [btn setAttributedTitle:selStr forState:UIControlStateDisabled];
      
      [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
      [self addSubview:btn];
      
      //分割线
      if (i>0 && self.frame.size.height>16) {
         UIView *line = [[UIView alloc] initWithFrame:CGRectMake(SPACE*i, 0, 1, self.frame.size.height-16)];
         line.backgroundColor = [UIColor grayColor];
         [self addSubview:line];
      }
      
   }
   //底部划线
   UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-2.5, self.frame.size.width, 1.5)];
   line.backgroundColor=[UIColor grayColor];
   [self addSubview:line];
   
   //标识当选被选中下划线
   UIView *markLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.frame.size.height-1, SPACE+1, 3)];
   markLine.tag=999;
   markLine.backgroundColor=[UIColor orangeColor];
   [self addSubview:markLine];
}

#pragma mark - 菜单按钮点击事件
- (void)btnClick:(UIButton *)sender{
   for (UIView *subView in self.subviews) {
      if ([subView isKindOfClass:[UIButton class]]) {
         UIButton *subBtn = (UIButton *)subView;
         if (subBtn.tag == sender.tag) {
            [subBtn setEnabled:NO];
         }else{
            [subBtn setEnabled:YES];
         }
      }
   }
   //计算每个按钮间隔
   CGFloat SPACE = (self.frame.size.width)/[_menuArray count];
   UIView *markView = [self viewWithTag:999];
   [UIView animateWithDuration:0.2f animations:^{
      CGRect markFrame =markView.frame;
      markFrame.origin.x = sender.tag*SPACE;
      markView.frame = markFrame;
   }];
   
   if ([self.myDelegate respondsToSelector:@selector(getTag:)]) {
      [self.myDelegate getTag:sender.tag];
   }
}

@end
