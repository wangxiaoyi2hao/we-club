//
//  CLUBViewController.h
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UMSocial.h"


@interface CLUBViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate,UITextFieldDelegate,UMSocialUIDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *CLUBTabelView;
- (IBAction)barImgShow1:(UIButton *)sender;
- (IBAction)barImgShow2:(UIButton *)sender;
- (IBAction)barImgShow3:(UIButton *)sender;
- (IBAction)barImgShow4:(UIButton *)sender;
@property(weak,nonatomic)IBOutlet UIView*headerView;
@property(nonatomic,strong)NSMutableArray *mArray;
@property(nonatomic,strong)NSTimer *timer;

@property (nonatomic,weak) IBOutlet UIImageView *backgroundImageView;




@end
