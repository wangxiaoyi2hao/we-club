//
//  LookUpImageViewController.m
//  bar
//
//  Created by Lxrent 66 on 15/10/29.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "LookUpImageViewController.h"
#import "AppDelegate.h"
#import "YockPhotoImgView.h"
#import "VIPhotoView.h"
#import "DDProgressView.h"
#define WIDTH [UIScreen mainScreen].bounds.size.width
@interface LookUpImageViewController ()
{

    int page;
    BOOL isShow;
    YockPhotoImgView*_imageView;
    DDProgressView *_progressView;
   
}
@end

@implementation LookUpImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UITapGestureRecognizer *tap=[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(showViewTap)];
    [_scrollView addGestureRecognizer:tap];
    //创建显示进度的视图
    _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10, (KScreenHeight-40)/2.0, KScreenWidth-20, 1)];
    _progressView.outerColor = [UIColor clearColor];
    _progressView.innerColor = [UIColor lightGrayColor];
    _progressView.emptyColor = [UIColor darkGrayColor];
    _progressView.hidden = YES;
    _pageControl.numberOfPages=_imageArray.count;
    _scrollView.contentSize=CGSizeMake(_imageArray.count*WIDTH, _scrollView.frame.size.height);
    InviteImages*invite=[_imageArray objectAtIndex:_index];
    _imageView=[[YockPhotoImgView alloc] initWithFrame:CGRectMake(WIDTH*_index, 0, WIDTH, _scrollView.bounds.size.height)];
    //创建显示进度的视图
    _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10, (KScreenHeight-40)/2.0, KScreenWidth-20, 40)];
    _progressView.outerColor = [UIColor clearColor];
    _progressView.innerColor = [UIColor lightGrayColor];
    _progressView.emptyColor = [UIColor darkGrayColor];
    _progressView.hidden = YES;
    [_scrollView addSubview:_progressView];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:invite.detailedimages] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //异步显示大图进度条
        _progressView.hidden = NO;
        _progressView.progress = receivedSize/(CGFloat)expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _progressView.hidden = YES;
    }];
    [_scrollView addSubview:_imageView];
    [_scrollView setContentOffset:CGPointMake(WIDTH*_index, 0) animated:YES];
}
-(void)showViewTap{
    [self dismissViewControllerAnimated:NO completion:nil];
}
-(void)backClick{

    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
}
- (void)viewWillAppear:(BOOL)animated{
        NSLog(@"%i",_index);
    NSLog(@"%@",_imageArray);
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int nowPage=scrollView.contentOffset.x/WIDTH;
    _pageControl.currentPage=nowPage;
    InviteImages*invite=[_imageArray objectAtIndex:nowPage];
    [_imageView setFrame:CGRectMake(WIDTH*nowPage, 0, WIDTH, _scrollView.bounds.size.height)];
    _progressView = [[DDProgressView alloc] initWithFrame:CGRectMake(10, (KScreenHeight-40)/2.0, KScreenWidth-20, 40)];
    _progressView.outerColor = [UIColor clearColor];
    _progressView.innerColor = [UIColor lightGrayColor];
    _progressView.emptyColor = [UIColor darkGrayColor];
    _progressView.hidden = YES;

    [_imageView addSubview:_progressView];
    [_imageView sd_setImageWithURL:[NSURL URLWithString:invite.detailedimages] placeholderImage:[UIImage imageNamed:@"default"] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
        //异步显示大图进度条
        _progressView.hidden = NO;
        _progressView.progress = receivedSize/(CGFloat)expectedSize;
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        _progressView.hidden = YES;
    }];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    int nowPage=scrollView.contentOffset.x/WIDTH;
    _pageControl.currentPage=nowPage;
}
//- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
//    int page1=scrollView.contentOffset.x/WIDTH;
//    UIImageView *imgView=[scrollView.subviews objectAtIndex:page1];
//    imgView.transform=CGAffineTransformTranslate(imgView.transform, 0, 0);
//}

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
