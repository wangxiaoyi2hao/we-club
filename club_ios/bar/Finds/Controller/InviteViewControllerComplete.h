//
//  InviteViewControllerComplete.h
//  Weclub
//
//  Created by lsp's mac pro on 15/12/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InviteViewControllerComplete : UIViewController<UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate/*,UITextViewDelegate*/,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{

    IBOutlet UIScrollView*_scrollview;
    //红包金额
    IBOutlet UITextField*_textFieldRedBag;
    IBOutlet UISlider*_slider;

    //红包邀约的时间
    IBOutlet UILabel*lbTime1;
    //非红包邀约时间
    IBOutlet UILabel*lbTime2;
    //红包邀约酒吧
    IBOutlet UILabel*lbBar1;
    //非红包邀约的酒吧选择按钮
    IBOutlet UILabel*lbBar2;
    //红包邀约的邀约描述
    IBOutlet UITextView*textView1;
    //非红包邀约的邀约描述
    IBOutlet UITextView*textView2;
    //非红包邀约的支付方式         
    IBOutlet UILabel*lbPaid;
}
//创建相册
@property(nonatomic,strong)UICollectionView *collectionViewLeft;
@property(nonatomic,strong)UICollectionView *collectionViewRight;
@property(nonatomic,copy)NSMutableArray *mArray;
@property (weak, nonatomic) IBOutlet UIView *backViewLeft;
@property (weak, nonatomic) IBOutlet UIView *backViewRight;

@end
