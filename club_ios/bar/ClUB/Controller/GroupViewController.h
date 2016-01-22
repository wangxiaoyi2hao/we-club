//
//  GroupViewController.h
//  bar
//
//  Created by chen on 15/11/13.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RongIMKit/RongIMKit.h>
#import "BaseRCConversationViewController.h"

@interface GroupViewController : BaseRCConversationViewController//<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>
//创建照片集
@property(nonatomic,strong)UICollectionView *photoCollectionView;
@property(nonatomic,strong)NSMutableArray *mArray;
@property(nonatomic,copy)NSString*fromGroupId;

+(GroupViewController *)shareGroup;
@end
