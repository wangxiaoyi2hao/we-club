//
//  MemberTableVC.h
//  bar
//
//  Created by chen on 15/10/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberTableVC : UITableViewController<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property(weak,nonatomic)NSString* fromUserId;
@end
