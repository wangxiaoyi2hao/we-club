//
//  groupTableCell.m
//  bar
//
//  Created by 牟志威 on 15/10/12.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//群组聊天
#import "groupTableCell.h"
#import "AppDelegate.h"

@implementation groupTableCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

static NSString * const reuseIdentifier = @"groupPhotoCell";
//组数
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    //Items个数大于等于9,返回3组
    if ([_data count] >= 9) {
        return 3;
    } else {
        NSLog(@"section = %lu",([_data count] + 2) / 3);
        return ([_data count] + 2) / 3;
    }
}

//每组Items个数
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    //Items个数大于等于9,返回3个
    if ([_data count] >= 9) {
        return 3;
    } else {
        if (([_data count] - 3 * section) >= 3) {
            return 3;
        } else {
            NSLog(@"row = %lu",([_data count] - 3 * section));
            return ([_data count] - 3 * section);
        }
    }
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"%ld %ld",(long)indexPath.section,(long)indexPath.row);
    photoCollectionCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    //给每个Item添加图片
    [cell setPhoto:[_data objectAtIndex:(indexPath.section * 3 + indexPath.row)]];
    return cell;
}
//把数据保存到本地
- (void)setData:(NSMutableArray *)data {
    if (_data == nil) {
        _data = [[NSMutableArray alloc] init];
    }
    for (id item in data) {
        [_data addObject:item];
    }
}


@end
