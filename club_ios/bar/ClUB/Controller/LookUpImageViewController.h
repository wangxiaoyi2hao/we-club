//
//  LookUpImageViewController.h
//  bar
//
//  Created by Lxrent 66 on 15/10/29.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookUpImageViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIView*_navView;
    IBOutlet UIButton*_navButton;
    IBOutlet UIScrollView*_scrollView;
    IBOutlet UIPageControl *_pageControl;
    

}
@property (nonatomic,assign)int index;
@property(nonatomic,strong)NSMutableArray*imageArray;

@end
