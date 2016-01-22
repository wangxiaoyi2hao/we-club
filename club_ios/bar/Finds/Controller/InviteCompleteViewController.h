//
//  InviteCompleteViewController.h
//  Weclub
//
//  Created by chen on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteCompleteViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate,UITextViewDelegate,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *pleaceHoderLabel;
@property (weak, nonatomic) IBOutlet UITextView *describeView;
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (strong, nonatomic) IBOutlet UIView *footView;
@property (weak, nonatomic) IBOutlet UITableView *InviteCompleView;
//创建相册
@property(nonatomic,strong)UICollectionView *collectionViewLeft;
@property(nonatomic,copy)NSMutableArray *mArray;

@end
