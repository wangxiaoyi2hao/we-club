//
//  RCListCustomCell.m
//  Weclub
//
//  Created by chen on 16/1/8.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "RCListCustomCell.h"
#define kbadageWidth 20
#define kgap 10
@implementation RCListCustomCell

/*
 
 avatarIV
 
 realNameLabel typeNameLabel timeLabel contentLabel
 
 */

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]; if (self) {
    
    //头像
    self.avatarIV = [[UIImageView alloc]initWithFrame:CGRectMake(kgap, kgap, kCellHeight-2*kgap, kCellHeight-2*kgap)];
    self.avatarIV.clipsToBounds = YES;
    self.avatarIV.layer.cornerRadius = 8;
    // self.avatarIV.image = [UIImage imageNamed:@"default_portrait_msg"];
    [self.contentView addSubview:self.avatarIV];
        //realName
    self.realNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.avatarIV.frame.origin.x+self.avatarIV.frame.size.width+kgap, self.avatarIV.frame.origin.y+7, self.avatarIV.frame.size.width+40, self.avatarIV.frame.size.height/2-kgap/2)];
        
    self.realNameLabel.font = [UIFont systemFontOfSize:18];
        //self.realNameLabel.textColor = kFontColor_333333;
    self.realNameLabel.backgroundColor = [UIColor cyanColor];
    [self.contentView addSubview:self.realNameLabel];
        //头衔
        self.typeNameLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.realNameLabel.frame.origin.x+self.realNameLabel.frame.size.width+kgap, self.realNameLabel.frame.origin.y, self.realNameLabel.frame.size.width, self.realNameLabel.frame.size.height)];
        self.typeNameLabel.font = [UIFont systemFontOfSize:15];
//        self.typeNameLabel.textColor = kColor_TintRed;
         self.typeNameLabel.backgroundColor = [UIColor magentaColor];
        [self.contentView addSubview:self.typeNameLabel];
        //时间
        self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth-90-5, self.typeNameLabel.frame.origin.y, 90, self.typeNameLabel.frame.size.height)];
        self.timeLabel.textAlignment = NSTextAlignmentRight;
        self.timeLabel.font = [UIFont systemFontOfSize:15];
        self.timeLabel.textColor = [UIColor whiteColor];
        [self.contentView addSubview:self.timeLabel];
        //内容
        self.contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.realNameLabel.frame.origin.x, self.realNameLabel.frame.origin.y+self.realNameLabel.frame.size.height+2, KScreenWidth-self.avatarIV.frame.size.width-2*kgap-5-30, self.typeNameLabel.frame.size.height)];
        // self.contentLabel.backgroundColor = [UIColor purpleColor];
        self.contentLabel.textColor = [UIColor whiteColor];
        self.contentLabel.font = [UIFont systemFontOfSize:15]; [self.contentView addSubview:self.contentLabel];
        //角标，这个用来显示每个好友的角标，实现类似QQ聊天列表中强大的拖曳角标的功能
        self.ppBadgeView = [[PPDragDropBadgeView alloc]initWithFrame:CGRectMake(self.contentLabel.frame.origin.x+self.contentLabel.frame.size.width, self.contentLabel.frame.origin.y, 25, 25)]; self.ppBadgeView.fontSize = 12;
        [self.contentView addSubview:self.ppBadgeView];
        ///分割线
        self.seprateLine =[[UILabel alloc]initWithFrame:CGRectMake(self.realNameLabel.frame.origin.x, kCellHeight-2, KScreenWidth-self.avatarIV.frame.size.width-2*kgap, 0.5)];
        // self.contentLabel.backgroundColor = [UIColor purpleColor];
        self.seprateLine.backgroundColor = [UIColor lightGrayColor];
        [self.contentView addSubview:self.seprateLine];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
    
}
@end
