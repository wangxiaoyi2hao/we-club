//
//  SecondRegisterVC.h
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BaseViewController.h"

@interface SecondRegisterVC : BaseViewController<UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UITextFieldDelegate>

{
    
    IBOutlet UITextField*tfBrithday;
    IBOutlet UITextField*tfHomeTown;
    IBOutlet UITextField*tfSex;
    IBOutlet UITextField*tfUserName;
    IBOutlet UILabel*lbVclubNamber;
    
    
    IBOutlet UITextField*obServerText;
    
    
    IBOutlet UIImageView*_imageCamera;
    IBOutlet UIImageView*_imageWai;
    
}
- (IBAction)birthButtonAction:(UIButton *)sender;
- (IBAction)hometownButtonAction:(UIButton *)sender;
- (IBAction)sexButtonAction:(UIButton *)sender;

- (IBAction)nextButtonAction:(UIButton *)sender;

@property(nonatomic,weak)IBOutlet UIImageView*imageHead;
@property(nonatomic,weak)IBOutlet UIButton*buttonClickHead;

@property(nonatomic,copy)NSString*fromUserName;
@property(nonatomic,copy)NSString*fromBirthDay;
@property(nonatomic,copy)NSString*fromHomeTown;
@property(nonatomic,copy)NSString*fromUserIcon;
@property(nonatomic,copy)NSString*fromUserId;//这个是我们自己的id
@property(nonatomic,copy)NSString*fromUserkey;
@property(nonatomic,copy)NSString*fromVclubNumber;
@property(nonatomic,copy)NSString*fromPhoneNUm;
@property(nonatomic,copy)NSString*fromPwd;
@property(nonatomic,assign)int fromType;
@property(nonatomic,copy)NSString*fromOtherId;


@property(nonatomic,weak)IBOutlet UIButton*correctButton;





@end
