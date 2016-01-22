//
//  deleteToolbar.m
//  bar
//
//  Created by 牟志威 on 15/10/7.
//  Copyright (c) 2015年 BIT. All rights reserved.
//

#import "deleteToolbar.h"

@implementation deleteToolbar



- (void)setNumber: (int) num {
    _numberBtn.title = [NSString stringWithFormat:@"%i",num];
}

- (IBAction)deleteBtnClick:(UIBarButtonItem *)sender {

}
@end
