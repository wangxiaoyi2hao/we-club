//
//  LookUpUserAvatarViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 15/12/23.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "LookUpUserAvatarViewController.h"
#import "YockPhotoImgView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface LookUpUserAvatarViewController ()
{
    int page;
    BOOL isShow;

}
@end

@implementation LookUpUserAvatarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showViewTap)];
    [_scrollView addGestureRecognizer:tap];
    // Do any additional setup after loading the view from its nib.
}
-(void)showViewTap{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)backClick{
    
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
    _pageControl.numberOfPages=_imageArray.count;
    _scrollView.contentSize=CGSizeMake(_imageArray.count*WIDTH, _scrollView.bounds.size.height);
    for (int i=0; i<_imageArray.count; i++) {
            UserAvatar*invite=[_imageArray objectAtIndex:i];
    YockPhotoImgView*imgView=[[YockPhotoImgView alloc] initWithFrame:CGRectMake(WIDTH*i, 0, WIDTH, _scrollView.bounds.size.height)];
        [imgView sd_setImageWithURL:[NSURL URLWithString:invite.uRL] placeholderImage:[UIImage imageNamed:@"default"]];

        [_scrollView addSubview:imgView];
    }
    [_scrollView setContentOffset:CGPointMake(WIDTH*_index, 0) animated:YES];
    NSLog(@"%i",_index);
    NSLog(@"%@",_imageArray);
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int nowPage=scrollView.contentOffset.x/WIDTH;
    _pageControl.currentPage=nowPage;
    
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int nowPage=scrollView.contentOffset.x/WIDTH;
    _pageControl.currentPage=nowPage;
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
