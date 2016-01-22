//
//  RCCustomCell.h
//  Weclub
//
//  Created by chen on 16/1/7.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>

#import "PPDragDropBadgeView.h"
@interface RCCustomCell : RCConversationBaseCell
@property (weak, nonatomic) IBOutlet UIImageView *avatarIV;
@property (weak, nonatomic) IBOutlet UILabel *ppBadgeView;
@property (weak, nonatomic) IBOutlet UILabel *realNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
///角标（UIView）这里我用了一个第三方，很好用，提供Github地址https://github.com/smallmuou/PPDragDropBadgeView
//@property (nonatomic,retain) PPDragDropBadgeView *ppBadgeView;
@property (nonatomic, strong)UIImageView *iconImageView;

@end
