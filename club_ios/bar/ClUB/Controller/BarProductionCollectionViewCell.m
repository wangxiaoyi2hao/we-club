//
//  BarProductionCollectionViewCell.m
//  Weclub
//
//  Created by lsp's mac pro on 15/12/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BarProductionCollectionViewCell.h"
#import "AppDelegate.h"

@implementation BarProductionCollectionViewCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
}

@end
