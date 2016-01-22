//
//  ChooseInviteVC.h
//  Weclub
//
//  Created by chen on 16/1/21.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ChooseInviteVC : UIViewController
@property (weak, nonatomic) IBOutlet UIImageView *backImageView;
- (IBAction)nearbyAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *nearbyLabel;
- (IBAction)newsSendAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *newsSendLabel;

- (IBAction)allAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *allLabel;

- (IBAction)boyAction:(UIButton *)sender;

@property (weak, nonatomic) IBOutlet UILabel *boyLabel;

- (IBAction)girlAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *girllabel;

- (IBAction)areaAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *areaLabel;


- (IBAction)commerceAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UILabel *commerceLabel;
- (IBAction)timeAction:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIView *backView;
@property (nonatomic,strong)NSMutableDictionary *chooseDictionary;

@end
