//
//  YYPhotoBrowserVC.m
//  Test
//
//  Created by xqj on 13-6-9.
//  Copyright (c) 2013年 syezon. All rights reserved.
//

#import "YYPhotoBrowserVC.h"
#import "ProgressIndicator.h"
#import "UIImageView+WebCache.h"
#import "SVProgressHUD.h"
//#import "SDWebImageDownloader.h"
#define WIDTH 310
@interface YYPhotoBrowserVC ()


@end

@implementation YYPhotoBrowserVC
{
    //    DownLoadHander *_downloadHanlder;
    
    UIScrollView *_scrollView;
    UIImageView *_currentImageView;            //图片 ***
    
    //    NSArray *_thumImageArr;             //缩略图数组
    
    NSArray *_simageUrlArr;              //大图url数组
    NSArray *_bimageUrlArr;
    NSMutableArray *_imageViewArr;             //UIImageView数组
    NSMutableArray *_progressArr;              //进度条数组
    NSMutableArray *_scrollViewArr;
    NSInteger _currentIndex;            //当前图片序号
    UIImageView *_topBar;
    UILabel *_topLabel;
    CGFloat _offset;
}


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _progressArr=[NSMutableArray new];
        _scrollViewArr=[NSMutableArray new];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [[self view] setBackgroundColor:[UIColor blackColor]];
    
    _offset=0.0;
    
    [self addSubviews];
    [self layoutSubviews];
    [self setSubviews];
    
    [self scrollViewContentSize];       //设置scrollView的ContentSize
    
    [self scrollViewCurrentIndex:_currentIndex];
    
    for(int i=0;i<[_bimageUrlArr count];i++)
    {
        ProgressIndicator *progress=[[ProgressIndicator alloc] initWithFrame:CGRectMake(0+320*i, 0, 150, 44)];
        [progress setHidden:YES];
        [_progressArr addObject:progress];
        [_scrollView addSubview:progress];
    }
    
    [self initImageViews];      //初始化ImageView数组
    
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
    [_topLabel setText:[NSString stringWithFormat:@"%d/%d",(_currentIndex+1),[_bimageUrlArr count]]];
    _topLabel.textAlignment=NSTextAlignmentCenter;
    [_topLabel setFont:[UIFont boldSystemFontOfSize:18]];
    [_topLabel setBackgroundColor:[UIColor clearColor]];
    [_topLabel setTextColor:[UIColor whiteColor]];
    [_topBar addSubview:_topLabel];
    
    [_topBar setUserInteractionEnabled:YES];
   _topBar.alpha = 0.0;
    
}

-(void)moreAction
{
    UIActionSheet *actionSheet=[[UIActionSheet alloc] initWithTitle:@"操作" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"保存到手机", nil];
    [actionSheet showInView:self.view];
    
    UIImage *image=((UIImageView *)[_imageViewArr objectAtIndex:_currentIndex]).image;
    
    NSLog(@"%f",image.size.height);
    if (image.size.height<=150 && image.size.width<=150)
    {
        NSArray *array=[[NSArray alloc]init];
        array=actionSheet.subviews;
        for (int i=0; i<[array count]; i++)
        {
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
    if (buttonIndex!=actionSheet.cancelButtonIndex) {
        NSString *urlString=[_bimageUrlArr objectAtIndex:_currentIndex];
        UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:[NSURL URLWithString:urlString]];
        if (image.size.width==0 && image.size.height==0) {
            image=((UIImageView *)[_imageViewArr objectAtIndex:_currentIndex]).image;
        }
        
        UIImageWriteToSavedPhotosAlbum(image, self, @selector(imageSavedToPhotosAlbum: didFinishSavingWithError: contextInfo:),nil);
    }
}
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    
    if (!error) {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showSuccessWithStatus:@"保存成功" duration:1.0];
        });
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [SVProgressHUD showSuccessWithStatus:@"保存失败" duration:1.0];
        });
    }
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)back
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark
#pragma mark - Public Method

- (id)initWithbigImageUrls:(NSArray *)urlArr smallImageUrls:(NSArray *)surlArr
{
    self = [self init];
    
    if (self)
    {
        _bimageUrlArr = urlArr;
        _simageUrlArr=surlArr;
    }
    
    return self;
}

- (id)initWithUrls:(NSArray *)urlArr thumbsImgs:(NSArray *)imgArr
{
    self = [self init];
    
    if (self)
    {
        
    }
    
    return self;
}


- (void)setImageIndex:(NSInteger)imageIndex
{
    _currentIndex = imageIndex;
}

#pragma mark
#pragma mark - Subviews

- (void)addSubviews
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
    [[self view] addSubview:_scrollView];
}

- (void)layoutSubviews
{
    CGRect bounds = [[self view] bounds];
    [_scrollView setFrame:bounds];
}

- (void)setSubviews
{
    [_scrollView setPagingEnabled:YES];     //开启滚动分页功能
    [_scrollView setShowsVerticalScrollIndicator:NO];
    [_scrollView setShowsHorizontalScrollIndicator:NO];
    [_scrollView setDelegate:self];
    
}

#pragma mark
#pragma mark - Progress

- (void)progressPostionWithIndex:(NSInteger)index
{
    CGRect bounds = [[self view] bounds];
    
    UIImageView *imageview = [_imageViewArr objectAtIndex:index];
    
    CGRect imgViewFrame = [imageview frame];
    
    CGFloat px = bounds.size.width / 2;
    CGFloat py = imgViewFrame.origin.y + imgViewFrame.size.height + 30;
    
    ProgressIndicator *progress=[_progressArr objectAtIndex:index];
    [progress setCenter:CGPointMake(px+320*index, py)];
    NSLog(@"pxpy:%f,%f",px,py);
}

#pragma mark
#pragma mark - ScrollView


- (void)scrollViewContentSize
{
    CGRect bounds = [[self view] bounds];
    
    CGSize scrlContentSize = CGSizeMake(bounds.size.width * [_bimageUrlArr count], bounds.size.height);
    
    [_scrollView setContentSize:scrlContentSize];
}

- (void)scrollViewCurrentIndex:(NSInteger)index
{
    CGRect bounds = [[self view] bounds];
    
    [_scrollView setContentOffset:CGPointMake(bounds.size.width * index, 0)];
}

#pragma mark
#pragma mark - UIImageView In ScrollView

- (void)imageViewAnimation:(UIImage *)image currentIndex:(NSInteger)index
{
    UIImage *imageFirScreen = [self imageFitScreen:image];
    
    UIImageView *imageView = [_imageViewArr objectAtIndex:index];
    
    CGRect bounds=[[self view]bounds];
    CGRect r=bounds;
    r.size.width=WIDTH;
    bounds=r;
    CGRect frame = [imageView frame];
    frame.size.width = imageFirScreen.size.width;
    frame.size.height = imageFirScreen.size.height;
    frame.origin.x = (bounds.size.width - imageFirScreen.size.width) / 2;
    frame.origin.y = (bounds.size.height - imageFirScreen.size.height) / 2;
    
    [UIView beginAnimations:nil context:nil];       //动画开始
    [UIView setAnimationDuration:1];
    
    [imageView setImage:imageFirScreen];
    [imageView setFrame:frame];
     
    [UIView commitAnimations];
    [[_scrollViewArr objectAtIndex:index] setDelegate:self];    //只有大图才可以变大变小
}



- (void)imageViewSetBigImage:(UIImage *)image currentIndex:(NSInteger)index
{
    UIImage *imageFirScreen = [self imageFitScreen:image];
    
    UIImageView *imageView = [_imageViewArr objectAtIndex:index];
    
    [imageView setImage:imageFirScreen];
    
    
    [self imageViewSetFrameWithSize:[imageFirScreen size] currentIndex:index];
    
}

- (void)imageViewSetThumImage:(UIImage *)image currentIndex:(NSInteger)index
{
    UIImageView *imageView = [_imageViewArr objectAtIndex:index];
    
    [imageView setImage:image];
    
    CGFloat w=image.size.width;
    CGFloat h=image.size.height;
    if (w>150.0 || h>150.0) {
        if (w>h) {
            h=150.0*h/w;
            w=150.0;
        }
        else
        {
            w=150.0*w/h;
            h=150.0;
        }
    }
    [self imageViewSetFrameWithSize:CGSizeMake(w, h) currentIndex:index];
}


- (void)imageViewSetFrameWithSize:(CGSize)imageSize currentIndex:(NSInteger)index
{
    UIImageView *imageView = [_imageViewArr objectAtIndex:index];
    
    CGRect bounds=[[self view]bounds];
    CGRect r=bounds;
    r.size.width=WIDTH;
    bounds=r;
    CGRect frame = [imageView frame];
    frame.size.width = imageSize.width;
    frame.size.height = imageSize.height;
    frame.origin.x = (bounds.size.width- imageSize.width) / 2;
    frame.origin.y = (bounds.size.height - imageSize.height) / 2;

    [imageView setFrame:frame];
    [[_scrollViewArr objectAtIndex:index] setDelegate:self];    //只有大图才可以变大变小
}

#pragma mark
#pragma mark - Self Method

- (void)downloadContentWithIndex:(NSInteger)index
{
    
    NSString *urlStr = [_bimageUrlArr objectAtIndex:index];
    
    NSURL *url = [NSURL URLWithString:urlStr];
    
     UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:url];
    if(!image)
    {
        ProgressIndicator *progress=[_progressArr objectAtIndex:index];
        [progress setHidden:NO];
        
        [self progressPostionWithIndex:_currentIndex];
        
        [[SDWebImageManager sharedManager] downloadWithURL:url
                                                   options:SDWebImageLowPriority
                                                  progress:^(NSUInteger receivedSize, long long expectedSize)
         {
             //         if ([_progress totalSize] == 0)
             //         {
             [progress setTotalSize:expectedSize];
             //         }
             
             [progress setProgress:(receivedSize * 1.0 / expectedSize) animated:YES];
             
         }
                                                 completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished)
         {
             if (finished)
             {
                 [progress setHidden:YES];
                 [progress setProgress:0.0 animated:NO];
                 //             [self imageViewAnimation:aImage currentIndex:_currentIndex];
                 
                 [self imageViewAnimation:aImage currentIndex:index];
                 
             }
         }];
    
    
    }
}

- (void)initImageViews
{
    
    if (!_imageViewArr)
    {
        _imageViewArr = [[NSMutableArray alloc] init];
    }
    else
    {
        [_imageViewArr removeAllObjects];
    }
    
    int index=_currentIndex;
    
    for (NSInteger i = 0; i < [_bimageUrlArr count]; i++)
    {
        
        NSString *sUrlStr=@"url";
        if ([_simageUrlArr count]>i+1) {
            sUrlStr = [_simageUrlArr objectAtIndex:i];     //小图url
        }
       
        NSString *bUrlStr=[_bimageUrlArr objectAtIndex:i];
        NSURL *url = [NSURL URLWithString:bUrlStr];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        [imageView setTag:i+1];
        [imageView setUserInteractionEnabled:YES];
        
        UIScrollView *imageScrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(320*i+5, 0, WIDTH, self.view.frame.size.height)];
        imageScrollView.backgroundColor=[UIColor clearColor];
        imageScrollView.contentSize=imageView.frame.size;
        imageScrollView.maximumZoomScale=3.0;
        imageScrollView.minimumZoomScale=1.0;
        imageScrollView.showsHorizontalScrollIndicator = NO;
        imageScrollView.showsVerticalScrollIndicator = NO;
        [imageScrollView setZoomScale:1.0];
        [imageScrollView addSubview:imageView];
        [imageScrollView setTag:i+1];
        //增加手势识别 单击屏幕
        UITapGestureRecognizer *singleFingerOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleFingerEvent:)];
        singleFingerOne.numberOfTouchesRequired = 1; //手指数
        singleFingerOne.numberOfTapsRequired = 1; //tap次数
        [singleFingerOne setDelegate:self];
        [imageView addGestureRecognizer:singleFingerOne];     //imageView 增加触摸事件
        
        UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleFingerEvent:)];
        doubleTap.numberOfTouchesRequired = 1; //手指数
        doubleTap.numberOfTapsRequired = 2; //tap次数
        [doubleTap setDelegate:self];
        [imageView addGestureRecognizer:doubleTap];     //imageView 增加触摸事件
        [imageView setUserInteractionEnabled:YES];
        
        [singleFingerOne requireGestureRecognizerToFail:doubleTap];  //防止双击事件被单击拦截
        
        [_scrollView addSubview:imageScrollView];
        
        [_scrollViewArr addObject:imageScrollView];
        [_imageViewArr addObject:imageView];
        
        UIImage *image = [[SDWebImageManager sharedManager] imageWithUrl:url];
        
        if (image)
        {
            [self imageViewSetBigImage:image currentIndex:i];
        }
        else
        {
            url = [NSURL URLWithString:sUrlStr];
            
            [[SDWebImageManager sharedManager] downloadWithURL:url
                                                       options:SDWebImageCacheMemoryOnly
                                                      progress:^(NSUInteger receivedSize, long long expectedSize)
             {
                 //             NSLog(@"small %u %lld",receivedSize,expectedSize);
             }
                                                     completed:^(UIImage *aImage, NSError *error, SDImageCacheType cacheType, BOOL finished)
             {
                 if (finished)
                 {
                     
                     if (aImage==nil) {
                         aImage=[UIImage imageNamed:@"defaultPic.png"];
                     }
                     [self imageViewSetThumImage:aImage currentIndex:i];
                     [self downloadContentWithIndex:index];
                 }
             }];
            
        }
    }
}

- (UIImage *)imageFitScreen:(UIImage *)image
{
    UIImage *resultsImg;
    
    CGSize origImgSize = [image size];
    
    CGRect newRect;
    newRect.origin = CGPointZero;
//    newRect.size = [[UIScreen mainScreen] bounds].size;
    newRect.size=[[self view]bounds].size;
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

- (void)navigatioBarStatusChange
{
    
}



#pragma mark
#pragma mark - SEL Method
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
}

-(void)handleDoubleFingerEvent:(UIGestureRecognizer *)gesture{
    
    
    UIScrollView *s=[_scrollViewArr objectAtIndex:_currentIndex];
    float newScale=0 ;
    if (s.zoomScale<=1.0) {
        newScale=s.zoomScale * 2.0;
        CGRect zoomRect = [self zoomRectForScale:newScale withCenter:[gesture locationInView:gesture.view]];
        [s zoomToRect:zoomRect animated:YES];
    }
    else
    {
        //        [s setZoomScale:1.0];
        [s setZoomScale:1.0 animated:YES];
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

#pragma mark
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView*)scrollView
{

}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    
    if (scrollView==_scrollView)
    {
        NSInteger currentIndex = fabs(scrollView.contentOffset.x / self.view.frame.size.width);
        if (currentIndex == _currentIndex) { return; }

        _currentIndex = currentIndex;
        dispatch_async(dispatch_get_main_queue(), ^(void){
            [_topLabel setText:[NSString stringWithFormat:@"%d/%d",(_currentIndex+1),[_bimageUrlArr count]]];
        });
       
        
        [self downloadContentWithIndex:currentIndex];
        
        CGPoint point;
        point=scrollView.contentOffset;
        point.x=currentIndex*self.view.frame.size.width;
        scrollView.contentOffset=point;

        CGFloat x=scrollView.contentOffset.x;

        if (x!=_offset)
        {
            _offset=x;
        
            for (UIScrollView *s in scrollView.subviews)
            {
                if ([s isKindOfClass:[UIScrollView class]])
                {
                
                    
                    [s setZoomScale:1.0 animated:NO];
//                    [imageView setFrame:frame];
                    

                }
            }
        }
    }
   
    //    NSLog(@"结束滚动后结束缓冲滚动时调用");
}

-(void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView
{
    
}

#pragma mark
#pragma mark - SDWebImageManagerDelegate

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    NSLog(@"downLoad");
    //    [self currentImageViewAnimation:image currentIndex:_currentIndex];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    
}



@end
