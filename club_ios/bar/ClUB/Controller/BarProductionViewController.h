//
//  BarProductionViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/10/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BarProductionViewController : UIViewController<UITableViewDataSource,UITabBarControllerDelegate,UIScrollViewDelegate,UIAlertViewDelegate,UIActionSheetDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{

    IBOutlet UIView*_headerView;
    IBOutlet UIScrollView*_scrollView;
    IBOutlet UILabel*lbAddress;
    IBOutlet UIView*_view1;//上面那个能拖动的
    IBOutlet UIView*_view2;//下面那个view
    IBOutlet UILabel*lbName;
    IBOutlet UILabel*lbPhone;
    IBOutlet UILabel*lbDes;
    IBOutlet UILabel*lbLikeCount;
    IBOutlet UILabel*browserCount;
    IBOutlet UITableView*_tableView;
    IBOutlet UIImageView*_imageBar;
    IBOutlet UICollectionView*_collectionView;

}
- (IBAction)livePhotoImg1:(UIButton *)sender;
- (IBAction)livePhotoImg2:(UIButton *)sender;
- (IBAction)livePhotoImg3:(UIButton *)sender;

@property(nonatomic,weak)IBOutlet UIImageView*imagepicture1;
@property(nonatomic,weak)IBOutlet UIImageView*imagepicture2;
@property(nonatomic,weak)IBOutlet UIImageView*imagepicture3;
@property(nonatomic,copy)NSString*fromUserId;
@property (weak, nonatomic) IBOutlet UIView *livePhotoView;

@end
