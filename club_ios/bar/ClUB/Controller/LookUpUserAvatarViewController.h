//
//  LookUpUserAvatarViewController.h
//  Weclub
//
//  Created by lsp's mac pro on 15/12/23.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LookUpUserAvatarViewController : UIViewController<UIScrollViewDelegate>
{
    IBOutlet UIView*_navView;
    IBOutlet UIButton*_navButton;
    IBOutlet UIScrollView*_scrollView;
    IBOutlet UIPageControl *_pageControl;
    
    
}
@property (nonatomic,assign)int index;
@property(nonatomic,strong)NSMutableArray*imageArray;
@end
