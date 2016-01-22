//
//  RCListCustomCell.h
//  Weclub
//
//  Created by chen on 16/1/8.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <RongIMKit/RongIMKit.h>
#import "PPDragDropBadgeView.h"
#define kCellHeight 80
@interface RCListCustomCell : RCConversationBaseCell

///头像
@property (nonatomic,retain) UIImageView *avatarIV;
///真实姓名
@property (nonatomic,retain) UILabel *realNameLabel;
///头衔
@property (nonatomic,retain) UILabel *typeNameLabel;
///时间
@property (nonatomic,retain) UILabel *timeLabel; ///内容
@property (nonatomic,retain) UILabel *contentLabel;
///分割线
@property (nonatomic,retain) UILabel *seprateLine;
///角标（UIView）这里我用了一个第三方，很好用，提供Github地址https://github.com/smallmuou/PPDragDropBadgeView
@property (nonatomic,retain) PPDragDropBadgeView *ppBadgeView;
@end
