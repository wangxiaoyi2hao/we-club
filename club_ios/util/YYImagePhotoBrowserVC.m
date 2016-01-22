//
//  YYImagePhotoBrowserVC.m
//  lvban
//
//  Created by hou on 13-7-2.
//  Copyright (c) 2013年 syezon. All rights reserved.
//

#import "YYImagePhotoBrowserVC.h"
#import "SVProgressHUD.h"
#define WIDTH 310
@interface YYImagePhotoBrowserVC ()

@end

@implementation YYImagePhotoBrowserVC
{
    UIImageView *_imageView;
    UIScrollView *_scrollView;
    UIImageView *_topBar;
    UILabel *_topLabel;
    NSArray *_scrollViewArr;
    UIImage *_image;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    _scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(5, 0, 310, 480)];
    _scrollView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:_scrollView];
    
    [_scrollView addSubview:_imageView];
    
    _scrollView.contentSize=_imageView.frame.size;
    _scrollView.maximumZoomScale=3.0;
    _scrollView.minimumZoomScale=1.0;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate=self;
    
    
    //增加手势识别 单击屏幕
    UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
    singleFingerOne.numberOfTouchesRequired = 1; //手指数
    singleFingerOne.numberOfTapsRequired = 1; //tap次数
    [singleFingerOne setDelegate:self];
    [_scrollView addGestureRecognizer:singleFingerOne];     //imageView 增加触摸事件
    
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleFingerEvent:)];
    doubleTap.numberOfTouchesRequired = 1; //手指数
    doubleTap.numberOfTapsRequired = 2; //tap次数
    [doubleTap setDelegate:self];
    [_scrollView addGestureRecognizer:doubleTap];     //imageView 增加触摸事件
    
    [singleFingerOne requireGestureRecognizerToFail:doubleTap];  //防止双击事件被单击拦截

    
    
    _topBar=[[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, 44)];
    [_topBar setImage:[UIImage imageNamed:@"topBack.png"]];
    [self.view addSubview:_topBar];
    
    UIButton* backButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setImage:[UIImage imageNamed:@"backButton.png"] forState:UIControlStateNormal];
    [backButton setImage:[UIImage imageNamed:@"backButtonSt.png"] forState:UIControlStateHighlighted];
    [backButton setImageEdgeInsets:UIEdgeInsetsMake(8, 7, 8, 5)];
    [backButton setFrame:CGRectMake(0, 0, 60, 44)];
    [backButton addTarget:self action:@selector(back) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* backIcon=[[UIImageView alloc] initWithFrame:CGRectMake(25, 15, 21, 15)];
    [backIcon setImage:[UIImage imageNamed:@"backImage.png"]];
    
    UIButton* moreButton=[UIButton buttonWithType:UIButtonTypeCustom];
    [moreButton setImage:[UIImage imageNamed:@"topDone.png"] forState:UIControlStateNormal];
    [moreButton setImage:[UIImage imageNamed:@"topDoneSelected.png"] forState:UIControlStateHighlighted];
    [moreButton setImageEdgeInsets:UIEdgeInsetsMake(8, 0, 7, 0)];
    [moreButton setFrame:CGRectMake(267, 0, 45, 44)];
    [moreButton addTarget:self action:@selector(moreAction) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView* moreIcon=[[UIImageView alloc]initWithFrame:CGRectMake(276, 18, 27, 8)];
    [moreIcon setImage:[UIImage imageNamed:@"chat_more.png"]];

    
    [_topBar addSubview:backButton];
    [_topBar addSubview:backIcon];
    [_topBar addSubview:moreButton];
    [_topBar addSubview:moreIcon];
    
    _topLabel=[[UILabel alloc] initWithFrame:CGRectMake(100, 5, 120, 34)];
    [_topLabel setText:@"1/1"];
    _topLabel.textAlignment=NSTextAlignmentCenter;
    [_topLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [_topLabel setBackgroundColor:[UIColor clearColor]];
    [_topLabel setTextColor:[UIColor whiteColor]];
    [_topBar addSubview:_topLabel];
    
    [_topBar setUserInteractionEnabled:YES];
//    [_topBar setHidden:YES];
    _topBar.alpha=0.0;
    
    
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithContent:(id)content
{
    self = [self init];
    
    if (self)
    {
        if ([content isKindOfClass:[UIImage class]]) {
            _image=(UIImage *)content;
        }
        else if([content isKindOfClass:[NSString class]]){
            _image=[UIImage imageWithContentsOfFile:content];
        
        }
        _imageView=[[UIImageView alloc]init];
        UIImage *image= [self imageFitScreen:_image];
        _imageView.image=image;
        _imageView.frame=CGRectMake(0, 0, image.size.width, image.size.height);

    }
    return self;
}



-(UIImage *)imageFitScreen:(UIImage *)image
{
    UIImage *resultsImg;
    
    CGSize origImgSize = [image size];
    
    CGRect newRect;
    newRect.origin = CGPointZero;
    newRect.size = [[self view] bounds].size;
    CGRect r=newRect;
    r.size.width=WIDTH;
    newRect=r;
    //确定缩放倍数
    float ratio = MIN(newRect.size.width / origImgSize.width, newRect.size.height / origImgSize.height);
    
//    UIGraphicsBeginImageContext(newRect.size);
    UIGraphicsBeginImageContextWithOptions(newRect.size, YES, 1.0);

    CGRect rect;
    rect.size.width = ratio * origImgSize.width;
    rect.size.height = ratio * origImgSize.height;
    rect.origin.x = (newRect.size.width - rect.size.width) / 2.0;
    rect.origin.y = (newRect.size.height - rect.size.height) / 2.0;
    
    [image drawInRect:rect];
    
    resultsImg = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return resultsImg;
    
}

-(void)moreAction
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    [actionSheet showInView:self.view];
    
    UIImage *image=_imageView.image;
    if (image.size.height<=150 && image.size.width<=150) {
        NSArray *array=[[NSArray alloc]init];
        array=actionSheet.subviews;
        for (int i=0; i<[array count]; i++) {
            if([array[i] isKindOfClass:[UIButton class]])
            {
                UIButton *btn=array[i];
                if ([btn.titleLabel.text isEqualToString:@"保存到手机"]) {
                    btn.enabled=NO;
                }
            }
        }
        
    }
    
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    //    UIImage *image=[[UIImage alloc]init];
    //    image=[  objectAtIndex:_currentIndex];
    if(buttonIndex!=actionSheet.cancelButtonIndex)
    {
        if (_image.size.width==0 && _image.size.height==0) {
            _image=_imageView.image;
        }
        
        UIImageWriteToSavedPhotosAlbum(_image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:),nil);
    }
}


- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1.0];
        
    }
    else
    {
        [SVProgressHUD showSuccessWithStatus:@"保存失败" duration:1.0];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)handleSingleFingerEvent:(UIGestureRecognizer *)gesture{

    if (_topBar.alpha == 0.0) {
        // fade in navigation
        
        [UIView animateWithDuration:0.4 animations:^{
            _topBar.alpha = 1.0;
        } completion:^(BOOL finished) {
        }];
    }
    else {
        
        [UIView animateWithDuration:0.4 animations:^{
            _topBar.alpha = 0.0;
        } completion:^(BOOL finished) {
        }];
    }


//    if (_topBar.hidden==YES) {
//        [_topBar setHidden:NO];
//    }
//    else
//    {
//        [_topBar setHidden:YES];
//    }
}

-(void)handleDoubleFingerEvent:(UIGestureRecognizer *)gesture{
    
    NSLog(@"双击。。。。。。。。");
    
    float newScale=0 ;
    if (_scrollView.zoomScale<=1.0) {
        newScale=_scrollView.zoomScale * 2.0;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [_scrollView zoomToRect:zoomRect animated:YES];
    }
    else
    {
        //        [s setZoomScale:1.0];
        [_scrollView setZoomScale:1.0 animated:YES];
    }
}

- (CGRect)zoomRectForScale:(float)scale withCenter:(CGPoint)center
{
    CGRect zoomRect;
    zoomRect.size.height = self.view.frame.size.height / scale;
    zoomRect.size.width  = self.view.frame.size.width  / scale;
    zoomRect.origin.x = center.x - (zoomRect.size.width  / 2.0);
    zoomRect.origin.y = center.y - (zoomRect.size.height / 2.0);
    return zoomRect;
}



- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(float)scale
{
    [scrollView setZoomScale:scale animated:NO];
}






-(UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    //    return _imageViewArr[_currentIndex];
    
    for (UIView *v in scrollView.subviews){
        return v;
    }
    return nil;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
     //滑出改页面后自动回到原来大小
    if (scrollView==_scrollView) {
        for (UIScrollView *s in scrollView.subviews){
            if ([s isKindOfClass:[UIScrollView class]]){
                [s setZoomScale:1.0];
                
            }
        }
    }
    
    
    
    //    NSLog(@"结束滚动后结束缓冲滚动时调用");
}


@end
