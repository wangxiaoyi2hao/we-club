//
//  ClubDesViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/18.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "ClubDesViewController.h"

@interface ClubDesViewController ()
{

    IBOutlet UIView*backgroundView;

}
@end

@implementation ClubDesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
  backgroundView.layer.cornerRadius=10;
   backgroundView.layer.masksToBounds=YES;
    // Do any additional setup after loading the view from its nib.
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
