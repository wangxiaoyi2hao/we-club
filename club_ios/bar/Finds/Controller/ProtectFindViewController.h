//
//  ProtectFindViewController.h
//  Weclub
//
//  Created by lsp's mac pro on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QCSlideSwitchView.h"
#import "FindsViewController.h"

@interface ProtectFindViewController : UIViewController<QCSlideSwitchViewDelegate>
@property(nonatomic,weak)IBOutlet QCSlideSwitchView*slideSwitchView;

@end
