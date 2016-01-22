//
//  groupTableCell.h
//  bar
//
//  Created by 牟志威 on 15/10/12.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//消息界面 群组聊天cell
#import <UIKit/UIKit.h>
#import "photoCollectionView.h"

@interface groupTableCell : UITableViewCell <UICollectionViewDelegate , UICollectionViewDataSource>

@property (nonatomic , strong) NSMutableArray *data;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *untroubleMarker;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet photoCollectionView *photoCollection;

- (void)setData:(NSMutableArray *)data;
@property (weak, nonatomic) IBOutlet UIButton *gropeMsgNumber;


@end
