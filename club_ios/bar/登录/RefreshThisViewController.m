//
//  RefreshThisViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/14.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "RefreshThisViewController.h"

@interface RefreshThisViewController ()
{

    NSTimer*_timer;
    int  seconds;

}
@end

@implementation RefreshThisViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    seconds=3;
    
    // Do any additional setup after loading the view from its nib.
}
-(void)viewDidAppear:(BOOL)animated{

 _timer=[NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeBegin) userInfo:nil repeats:YES];
}
-(void)timeBegin{
    seconds--;
    lbHowToSecond.text=[NSString stringWithFormat:@"%i秒后跳转登录页",seconds];
    if (seconds==0) {
        [self dismissViewControllerAnimated:NO completion:nil];
        [_timer invalidate];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"gobackLogin" object:nil];
    }

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
