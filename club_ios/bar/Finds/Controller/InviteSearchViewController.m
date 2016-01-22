//
//  InviteSearchViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/22.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "InviteSearchViewController.h"

@interface InviteSearchViewController ()

@end

@implementation InviteSearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
#pragma mark seachBar的效果
- (void)beginSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)endSearch:(UISearchBar *)searchBar{
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if ([self respondsToSelector:@selector(beginSearch:)]) {
        [self beginSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            CGRect statusBarFrame = [[UIApplication sharedApplication] statusBarFrame];
            [UIView animateWithDuration:0.25 animations:^{
                [self.view setBackgroundColor:[UIColor blackColor]];
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, statusBarFrame.size.height);
                }
            }];
        }
    }
    return YES;
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    if ([self respondsToSelector:@selector(endSearch:)]) {
        [self endSearch:searchBar];
        if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0) {
            [UIView animateWithDuration:0.25 animations:^{
                for (UIView *subview in self.view.subviews){
                    subview.transform = CGAffineTransformMakeTranslation(0, 0);
                }
            } completion:^(BOOL finished) {
                [self.view setBackgroundColor:[UIColor whiteColor]];
            }];
        }
    }
    return YES;
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
