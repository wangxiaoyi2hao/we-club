//
//  infoEditController.h
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface infoEditController : UITableViewController <UITextViewDelegate , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UIActionSheetDelegate>

@property enum getMethod{changeBackGround, AddPicture} propose;

- (IBAction)cancelBtnClick:(UIBarButtonItem *)sender;//返回按钮
- (IBAction)saveBtnClick:(UIBarButtonItem *)sender;//保存按钮
@property (weak, nonatomic) IBOutlet UIView *headView;
@property (weak, nonatomic) IBOutlet UIImageView *headIconView;
- (IBAction)changeBg:(UIButton *)sender;//更换背景
- (IBAction)addBtnClick:(UIButton *)sender;//添加图片
//各种控件赋值
@property(weak,nonatomic)IBOutlet UITextField*lbName;
@property(weak,nonatomic)IBOutlet UITextField*lbAge;
@property(weak,nonatomic)IBOutlet UITextField*lbHeart;
@property(weak,nonatomic)IBOutlet UITextField*lbLove;
@property(weak,nonatomic)IBOutlet UITextField*lbJob;
@property(weak,nonatomic)IBOutlet UITextField*lbHomeTown;
@property(weak,nonatomic)IBOutlet UITextField*lbMovie;
@property(weak,nonatomic)IBOutlet UITextField*lbMusic;
@property(weak,nonatomic)IBOutlet UITextField*lbWorkLocation;
@property(weak,nonatomic)IBOutlet UITextField*lbMoreLocation;
@property(weak,nonatomic)IBOutlet UITextField*lbHobby;
@property(weak,nonatomic)IBOutlet UITextField*lbUserDES;
@property(weak,nonatomic)IBOutlet UITextField*lbConstellation;
@property(weak,nonatomic)IBOutlet UIImageView*imageHead;
@property(weak,nonatomic)IBOutlet UIImageView*imageBackground;
@property(strong,nonatomic)Response10014*fromResponse10014;
@property(strong,nonatomic) NSMutableArray *mArray;
@property(strong,nonatomic) NSMutableArray *urlMArray;
@property (weak, nonatomic) IBOutlet UIImageView *headBackImgView;

@end
