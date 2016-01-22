//
//  CreatGroupViewController.h
//  bar
//
//  Created by lsp's mac pro on 15/11/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreatGroupViewController : UIViewController<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>
{

    IBOutlet UICollectionView*_collectionView;

}
@property(nonatomic,copy)NSString*fromCllubID;
@end
