//
//  FeedbackViewController.h
//  bar
//
//  Created by chen on 15/11/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedbackViewController : UIViewController<UITextViewDelegate , UITextFieldDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIView *headView;
- (IBAction)leftbutton:(id)sender;
- (IBAction)submitClick:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *submitButton;

//@property (weak, nonatomic) IBOutlet UITextField *proposalText;
@property(weak,nonatomic)IBOutlet UITextView*textView;

@end
