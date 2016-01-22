//
//  BackgroundTableVC.h
//  bar
//
//  Created by chen on 15/10/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BackgroundTableVC : UITableViewController<UINavigationControllerDelegate,UIImagePickerControllerDelegate>
@property(nonatomic,copy)NSString*fromChatId;
@end
