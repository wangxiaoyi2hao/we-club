//
//  deleteToolbar.h
//  bar
//
//  Created by 牟志威 on 15/10/7.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//删除 工具栏
#import <UIKit/UIKit.h>

@protocol deleteTableViewDelegate <NSObject>

@required - (void)deleteMethod;

@end

@interface deleteToolbar : UIToolbar

@property (weak, nonatomic) IBOutlet UIBarButtonItem *numberBtn;
@property (weak, nonatomic) NSObject<deleteTableViewDelegate>* delegate;

- (IBAction)deleteBtnClick:(UIBarButtonItem *)sender;
- (void)setNumber: (int) num;


@end
