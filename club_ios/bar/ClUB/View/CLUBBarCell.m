//
//  CLUBBarCell.m
//  bar
//
//  Created by chen on 15/10/26.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "CLUBBarCell.h"
#import "AppDelegate.h"

/** 表格的边框宽度 */
#define TableBorder 10

/** cell的边框宽度 */
#define CellBorder 10
@implementation CLUBBarCell

- (void)awakeFromNib {
    [AppDelegate matchAllScreenWithView:self.contentView];
//    self.layer.cornerRadius = 5.0;
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    [self.attentionButAction setTitle:@"关注" forState:UIControlStateNormal];
    [self.attentionButAction setTitle:@"已关注" forState:UIControlStateSelected];
    self.attentionButAction.backgroundColor = [UIColor whiteColor];
    [self.attentionButAction setBackgroundImage:[UIImage imageNamed:@"2-2-1"] forState:UIControlStateSelected];
    [self.attentionButAction setImage:[UIImage imageNamed:@"2-1-7"] forState:UIControlStateNormal];
    [self.attentionButAction setImage:[UIImage imageNamed:@"2-1-6"] forState:UIControlStateSelected];
    self.attentionButAction.titleLabel.font = [UIFont systemFontOfSize:12];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


/** 在自定义cell的类里面
   *  拦截frame的设置
    */
//- (void)setFrame:(CGRect)frame
//{
//         //表格Y值增加5
//         frame.origin.y += TableBorder;
//    //表格高度减去5
//        frame.size.height -= TableBorder;
//    
//         //表格X值增加5
//         frame.origin.x = TableBorder;
//         //表格宽度减去左右两边的5
//         frame.size.width -= 2 * TableBorder;
//    
//         [super setFrame:frame];
//}

- (IBAction)attentionButton:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (sender.selected == YES) {
        NSLog(@"关注成功");
        
    }else{
          NSLog(@"关注失败");
        
    }
  
    
    
    
}
@end
