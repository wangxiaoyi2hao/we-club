//
//  chatCell.h
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

//消息界面 个人聊天cell
#import <UIKit/UIKit.h>

@interface chatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *photo;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet UIImageView *untroubleMark;//防打扰图标
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;//最近消息时间
@property (weak, nonatomic) IBOutlet UILabel *messageNumber;


@end
