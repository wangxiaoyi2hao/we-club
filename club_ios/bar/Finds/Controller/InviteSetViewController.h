//
//  InviteSetViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol findsViewDelegate<NSObject>
-(void)findsDidSelectFefresh:(UIViewController *)controller;
@end
@interface InviteSetViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UITextViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIAlertViewDelegate>
{

    IBOutlet UIView*_headerView;
    IBOutlet UITableView*_tableView;
    IBOutlet UITextField*_textFieldRedBag;
    IBOutlet UISlider*_slider;
    IBOutlet UIButton*buttonCreat;//创建按钮
    IBOutlet UILabel*_labelHongBao;
    IBOutlet UILabel*_lbJinE;
    IBOutlet UIButton*_buttonMan;
    IBOutlet UIView*downView;
    IBOutlet UIView*upView;//选择酒吧和选择时间
    IBOutlet UIView*betweenView;//红包金额那个view
    IBOutlet UIScrollView*_scrollview;
    IBOutlet UIView*paidView;//承载missView和padidandonlygirlview的view
    IBOutlet UIView*missView;//约会时长view
    IBOutlet UIView*creatView;//创建和添加图片的view
    IBOutlet UIView*paidandOnlyGirl;//支付方式和仅限女生
    IBOutlet UILabel*lbPaid;
    IBOutlet UILabel*lbBeginTime;
    IBOutlet UILabel*lbBarName;
    IBOutlet UITextView*_textView;
    IBOutlet UIImageView*_pickerImage;
    IBOutlet UILabel*lbDate;
    
    IBOutlet UIButton*imageButton1;
    IBOutlet UIButton*imageButton2;
     IBOutlet UIButton*imageButton3;
     IBOutlet UIButton*imageButton4;
    
    IBOutlet UIImageView*_imageSwich;


}

@property(nonatomic,weak)id<findsViewDelegate>delegate;
//创建照片集
@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic,copy)NSMutableArray *mArray;
@end
