
//

#import <UIKit/UIKit.h>
#import "LazyPageScrollView.h"

@interface RenewalViewController : UIViewController<UITableViewDataSource,UITableViewDelegate,LazyPageScrollViewDelegate,UIActionSheetDelegate>

@property (strong, nonatomic) IBOutlet LazyPageScrollView *pageView;
@end
