//
//  jiubajieshaoViewController.m
//  toclub
//
//  Created by ggao on 15/10/4.
//  Copyright © 2015年 ggao. All rights reserved.
//
//酒吧介绍
#import "SummaryViewController.h"

@interface SummaryViewController ()<UIPickerViewDataSource,UIPickerViewDelegate>
{
    NSMutableArray * jinqiHudongImg;
    NSMutableArray * livePhotoImg;
    UIView * JinQiview;
    UIImageView * JinQiimg;
    UILabel * JinQIimgNumLabel;
    NSInteger JinQiImgIndex;
    
    UIView * mainView3;
    UIPickerView * imgPicker1;
    UIPickerView * imgPicker2;
    double imgPickerWidth;
    double imgPicker2Width;
    double mainView3ChangeHeight;
    UIButton  * closeLiveButton;
    
    UILabel * livePhotoLiulanLabel;
    UILabel * livePhotoLikeLabel;
    UILabel * livePhotoZhuanfaLabel;
    
    //小助手
    UIView * xiazhushouView;
    UIView * _helperBackView;
    UIScrollView *_summaryScrollView;
}
@end

@implementation SummaryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
      [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    _summaryScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight+59)];
    //设置内容区域（大小）
    _summaryScrollView.contentSize = CGSizeMake(KScreenWidth, KScreenHeight*2);
    [self.view addSubview:_summaryScrollView];
    //近期活动
    jinqiHudongImg = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"], nil];
    JinQiImgIndex = 0;
    //活动照片集
    livePhotoImg = [[NSMutableArray alloc]initWithObjects:[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"],[UIImage imageNamed:@"1.jpg"],[UIImage imageNamed:@"2.jpg"],[UIImage imageNamed:@"3.jpg"], nil];
    self.view.backgroundColor = [UIColor colorWithRed:230.0/255 green:230.0/255 blue:230.0/255 alpha:1];
    self.tabBarController.tabBar.hidden = YES;
    [self initNavBar];
    [self initMainView];
    [self initJinQiImgSHow];
    [self initxiaozhushou];
    // Do any additional setup after loading the view.
}
//小助手
-(void)initxiaozhushou
{
    _helperBackView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    _helperBackView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];
    [self.view addSubview:_helperBackView];
    
    xiazhushouView = [[UIView alloc]initWithFrame:CGRectMake(10, 0, KScreenWidth - 20, 54)];
    xiazhushouView.backgroundColor = [UIColor whiteColor];
    xiazhushouView.layer.borderColor = [[UIColor blackColor]CGColor];
    xiazhushouView.layer.borderWidth = 0.4;
    xiazhushouView.layer.cornerRadius = 5.0;
    
    UIButton * assistant = [[UIButton alloc] initWithFrame:CGRectMake(5, 5, 80, 20)];
    assistant.backgroundColor = [UIColor purpleColor];
    assistant.titleLabel.font = [UIFont systemFontOfSize:12];
    [assistant setTitle:@"iCLub小助手" forState:UIControlStateNormal];
    [assistant setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    assistant.layer.cornerRadius = 5.0;
    
    UILabel * assInfo = [[UILabel alloc]initWithFrame:CGRectMake(5, 25, KScreenWidth - 20 - 10, 20)];
    assInfo.text = @"签到用户才可以参与Live-Photo活动哦~~";
    assInfo.textColor = [UIColor lightGrayColor];
    [xiazhushouView addSubview:assistant];
    [xiazhushouView addSubview:assInfo];
    
    _helperBackView.alpha = 0.0;
    //初始状态为隐藏
    _helperBackView.hidden = YES;
    [_helperBackView addSubview:xiazhushouView];
}

-(void)initMainView{
//    UIView * temp = [UIView new];
//    [self.view addSubview:temp];//no use
    //上半部分视图
    UIView * mainView1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight/2)];
    mainView1.backgroundColor = [UIColor whiteColor];
    [_summaryScrollView addSubview:mainView1];
    {
        double view1Heigth = KScreenHeight/2;
        double currHiehgt = 0;
        //mainView1背景图片
        UIImageView * clubPageImg = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, view1Heigth*5/9)];
        clubPageImg.image = [UIImage imageNamed:@"4@2x.png"];
        clubPageImg.backgroundColor = [UIColor redColor];
        [mainView1 addSubview:clubPageImg];
        //顶部标题
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        titleLabel.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
        titleLabel.text = [NSString stringWithFormat:@"  %@",@"满城酒吧"];
        titleLabel.textColor = [UIColor whiteColor];
        titleLabel.font = [UIFont systemFontOfSize:14];
        [mainView1 addSubview:titleLabel];
        //酒吧介绍
        currHiehgt += view1Heigth*5/9;
        UITextView * clubDesc = [[UITextView alloc]initWithFrame:CGRectMake(3, currHiehgt, KScreenWidth-6, view1Heigth*2/9)];
        clubDesc.backgroundColor = [UIColor clearColor];
        clubDesc.editable = NO;
        clubDesc.font  = [UIFont systemFontOfSize:12];
        clubDesc.textColor = [UIColor lightGrayColor];
        clubDesc.text = @"酒吧简介:2002年出，在北京娱乐市场上大奖大限有HIP_POP,R&B等音乐为主的拒了不得情况啥，CLUBMIX";
        [mainView1 addSubview:clubDesc];
        currHiehgt += view1Heigth *2/9;
        //位置图标
        UIImageView * locImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, currHiehgt + view1Heigth/9.0/2.0 - 6, 10, 12)];
        locImg.backgroundColor  = [UIColor clearColor];
        locImg.image = [UIImage imageNamed:@"2-6-1.png"];
        locImg.contentMode = UIViewContentModeScaleAspectFill;
        [mainView1 addSubview:locImg];
        UILabel * locaLabel = [[UILabel alloc]initWithFrame:CGRectMake(5+15, currHiehgt, 200, currHiehgt/9)];
        locaLabel.text = @"动车尼姑磁器口聚森茂";
        locaLabel.font = [UIFont systemFontOfSize:12];
        locaLabel.backgroundColor = [UIColor clearColor];
        locaLabel.textColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
        [mainView1 addSubview:locaLabel];
        
        //电话图标
        UIImageView * teleImg = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth - 100 - 15, currHiehgt + view1Heigth/9.0/2.0 - 5, 10, 10)];
        teleImg.backgroundColor = [UIColor clearColor];
        teleImg.image = [UIImage imageNamed:@"2-6-2.png"];
        [mainView1 addSubview:teleImg];
        UILabel * teleLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 100, currHiehgt, 100, currHiehgt/9)];
        teleLabel.text = @"1234567890654345";
        teleLabel.font= [UIFont systemFontOfSize:12];
        teleLabel.backgroundColor = [UIColor clearColor];
        teleLabel.textColor = [UIColor colorWithRed:210.0/255 green:210.0/255 blue:210.0/255 alpha:1];
        [mainView1 addSubview:teleLabel];
        
        currHiehgt += view1Heigth/9;
        
        //分割线
        UIButton * grayline = [[UIButton alloc]initWithFrame:CGRectMake(0, currHiehgt, KScreenWidth, 1)];
        grayline.backgroundColor = [UIColor lightGrayColor];
        [mainView1 addSubview:grayline];
        
        //浏览
        UIImageView * img1 = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/12-5, currHiehgt + view1Heigth/9/2-5, 10, 10)];
        img1.backgroundColor = [UIColor clearColor];;
        img1.image = [UIImage imageNamed:@"2-5-2.png"];

        [mainView1 addSubview:img1];
        UILabel * label1 = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/6, currHiehgt, KScreenWidth/6, view1Heigth/9)];
        label1.text = @"浏览411";
        label1.backgroundColor = [UIColor clearColor];
        label1.textColor = [UIColor lightGrayColor];
        label1.font = [UIFont systemFontOfSize:12];
        [mainView1 addSubview:label1];
        
        //分割线
        UIButton * grayline1 = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/3, currHiehgt + view1Heigth/9/3 , 1, view1Heigth/9/3)];
        grayline1.backgroundColor = [UIColor lightGrayColor];
        [mainView1 addSubview:grayline1];
        
        //喜欢
        UIImageView * img2 = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/12-5+KScreenWidth/3, currHiehgt + view1Heigth/9/2-5, 10, 10)];
        img2.backgroundColor = [UIColor clearColor];
        img2.image = [UIImage imageNamed:@"2-5-3.png"];
        [mainView1 addSubview:img2];
        UILabel * label2 = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/6+KScreenWidth/3, currHiehgt, KScreenWidth/6, view1Heigth/9)];
        label2.text = @"喜欢411";
        label2.backgroundColor = [UIColor clearColor];
        label2.textColor = [UIColor lightGrayColor];
        label2.font = [UIFont systemFontOfSize:12];
        [mainView1 addSubview:label2];
        
        //分割线
        UIButton * grayline2 = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth/3+KScreenWidth/3*2, currHiehgt + view1Heigth/9/3 , 1, view1Heigth/9/3)];
        grayline2.backgroundColor = [UIColor lightGrayColor];
        [mainView1 addSubview:grayline2];
        
        //转发
        UIImageView * img3 = [[UIImageView alloc]initWithFrame:CGRectMake(KScreenWidth/12-5+KScreenWidth/3*2, currHiehgt + view1Heigth/9/2-5, 10, 10)];
        img3.backgroundColor = [UIColor clearColor];
        img3.image = [UIImage imageNamed:@"2-5-4.png"];
        [mainView1 addSubview:img3];
        UILabel * label3 = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth/6+KScreenWidth/3*2, currHiehgt, KScreenWidth/6, view1Heigth/9)];
        label3.text = @"转发";
        label3.backgroundColor = [UIColor clearColor];
        label3.textColor = [UIColor lightGrayColor];
        label3.font = [UIFont systemFontOfSize:12];
        [mainView1 addSubview:label3];
    }
    double SubeHeight = KScreenHeight/2 - 64;
    //近期活动视图
    UIView * mainView2 = [[UIView alloc]initWithFrame:CGRectMake(0,KScreenHeight/2+64,KScreenWidth, SubeHeight/2)];
    mainView2.backgroundColor = [UIColor whiteColor];
    [_summaryScrollView addSubview:mainView2];
    {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        titleLabel.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
        titleLabel.text = @"  近期活动";
        titleLabel.font = [UIFont systemFontOfSize:12];
        [mainView2 addSubview:titleLabel];
        
        double ImgHiehgt = SubeHeight/2 - 30;
        for(int i = 0; i < 3; i ++)
        {
            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10*(i+1)+ImgHiehgt*i, 10 + 30, ImgHiehgt -20, ImgHiehgt-20)];
            [btn setBackgroundImage:jinqiHudongImg[i] forState:UIControlStateNormal];
            btn.tag = i;
            [btn addTarget:self action:@selector(JinQiImgChangeHidden:) forControlEvents:UIControlEventTouchUpInside];
             [mainView2 addSubview:btn];
        }
    }
    //LIVE_PHOTO部分视图
    mainView3 = [[UIView alloc]initWithFrame:CGRectMake(0, KScreenHeight/2+64+SubeHeight/2, KScreenWidth, KScreenHeight - 20)];
    //mainView3.frame = CGRectMake(0, 64+10,Width, Height);
   //mainView3.transform = CGAffineTransformMakeTranslation(0, -Height + SubeHeight/2+20);
    mainView3ChangeHeight = -KScreenHeight+20+ SubeHeight/2;
    mainView3.backgroundColor = [UIColor whiteColor];
    [_summaryScrollView addSubview:mainView3];
    {
        UILabel * titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
        titleLabel.backgroundColor = [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1];
        titleLabel.text = @"  LIVE_PHOTO";
        titleLabel.font = [UIFont systemFontOfSize:12];
        [mainView3 addSubview:titleLabel];
        
        double ImgHiehgt = SubeHeight/2 - 30;
//        for(int i = 0; i < 3; i ++)
//        {
//            UIButton * btn = [[UIButton alloc] initWithFrame:CGRectMake(10*(i+1)+ImgHiehgt*i, 10 + 30, ImgHiehgt -20, ImgHiehgt-20)];
//            [btn setBackgroundImage:jinqiHudongImg[i] forState:UIControlStateNormal];
//            btn.tag = i;
//            [btn addTarget:self action:@selector(huoDongViewSHow:) forControlEvents:UIControlEventTouchUpInside];
//            [mainView3 addSubview:btn];
//        }
        
        //将小UIPickerView添加在mainView3上
        imgPicker1 = [[UIPickerView alloc]initWithFrame:CGRectMake(KScreenWidth/2 - (ImgHiehgt - 10)/2, 75 - (KScreenWidth)/2,ImgHiehgt-10,KScreenWidth)];
        imgPicker1.backgroundColor = [UIColor clearColor];
        imgPickerWidth = ImgHiehgt - 10;
        imgPicker1.transform = CGAffineTransformMakeRotation(90*M_PI/180);
        [mainView3 addSubview:imgPicker1];
        imgPicker1.delegate =self;
        imgPicker1.dataSource =self;
        [imgPicker1 selectRow:livePhotoImg.count/2 inComponent:0 animated:NO];
        
        //将大UIPickerView添加在mainView3
        imgPicker2 = [[UIPickerView alloc]initWithFrame:CGRectMake(KScreenWidth/2 -(KScreenHeight - ImgHiehgt- 64 - 10)/2,ImgHiehgt + 30 + (KScreenHeight - ImgHiehgt - 64 - 10)/2 - KScreenWidth/2 + 15,KScreenHeight - ImgHiehgt- 64 - 10,KScreenWidth - 10)];
        imgPicker2.transform = CGAffineTransformMakeRotation(90*M_PI/180);
        imgPicker2.backgroundColor = [UIColor clearColor];
        [mainView3 addSubview:imgPicker2];
        imgPicker2.delegate =self;
        imgPicker2.dataSource =self;
        
        //关闭UIPickerView按钮
        closeLiveButton = [[UIButton alloc]initWithFrame:CGRectMake(KScreenWidth - 50, 40, 30, 30)];
        [closeLiveButton addTarget:self action:@selector(closeLiveShowView) forControlEvents:UIControlEventTouchUpInside];
        closeLiveButton.backgroundColor = [UIColor redColor];
        [mainView3 addSubview:closeLiveButton];
        closeLiveButton.hidden = YES;
        
        double subWidth = KScreenWidth - 20;
        double leftX = 10;
        
        //mainView3上的浏览
        UIImageView * liulanImg = [[UIImageView alloc]initWithFrame:CGRectMake(leftX + subWidth/12 - 5, KScreenHeight - 50, 10, 10)];
        //liulanImg.backgroundColor = [UIColor redColor];
        liulanImg.image = [UIImage imageNamed:@"2-5-2.png"];
        liulanImg.contentMode = UIViewContentModeScaleAspectFill;
        [mainView3 addSubview:liulanImg];
        
        livePhotoLiulanLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftX + subWidth/6, KScreenHeight - 50, KScreenWidth/6, 10)];
        livePhotoLiulanLabel.text = @"浏览411";
        livePhotoLiulanLabel.font = [UIFont systemFontOfSize:9];
        [mainView3 addSubview:livePhotoLiulanLabel];
        
        UIButton * liulanButton = [[UIButton alloc]initWithFrame:CGRectMake(leftX, KScreenHeight - 50, subWidth/3, 10)];
        liulanButton.backgroundColor = [UIColor clearColor];
        liulanButton.tag = 0;
        [liulanButton addTarget:self action:@selector(LivePhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [mainView3 addSubview:liulanButton];
        leftX += subWidth/3;
        //mainView3上分割线
        UIButton * grayline = [[UIButton alloc]initWithFrame:CGRectMake(leftX, KScreenHeight - 50, 1, 10)];
        grayline.backgroundColor = [UIColor lightGrayColor];
        [mainView3 addSubview:grayline];
        
        //mainView3上喜欢
        UIImageView * likeImg = [[UIImageView alloc]initWithFrame:CGRectMake(leftX + subWidth/12 - 5, KScreenHeight - 50, 10, 10)];
        //likeImg.backgroundColor = [UIColor redColor];
        likeImg.image = [UIImage imageNamed:@"2-5-3.png"];
        likeImg.contentMode = UIViewContentModeScaleAspectFill;
        [mainView3 addSubview:likeImg];
        
        livePhotoLikeLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftX + subWidth/6, KScreenHeight - 50, KScreenWidth/6, 10)];
        livePhotoLikeLabel.text = @"喜欢411";
        livePhotoLikeLabel.font = [UIFont systemFontOfSize:9];
        [mainView3 addSubview:livePhotoLikeLabel];
        
        UIButton * likeButton = [[UIButton alloc]initWithFrame:CGRectMake(leftX, KScreenHeight - 50, subWidth/3, 10)];
        likeButton.backgroundColor = [UIColor clearColor];
        likeButton.tag =    1;
        [likeButton addTarget:self action:@selector(LivePhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [mainView3 addSubview:likeButton];
        leftX += subWidth/3;
        
        //分割线
        UIButton * grayline1 = [[UIButton alloc]initWithFrame:CGRectMake(leftX, KScreenHeight - 50, 1, 10)];
        grayline1.backgroundColor = [UIColor lightGrayColor];
        [mainView3 addSubview:grayline1];
        
        //mainView3转发
        UIImageView * zhuanfaImg = [[UIImageView alloc]initWithFrame:CGRectMake(leftX + subWidth/12 - 5, KScreenHeight - 50, 10, 10)];
        //zhuanfaImg.backgroundColor = [UIColor redColor];
        zhuanfaImg.image = [UIImage imageNamed:@"2-5-4.png"];
        zhuanfaImg.contentMode = UIViewContentModeScaleAspectFill;
        [mainView3 addSubview:zhuanfaImg];

        livePhotoZhuanfaLabel = [[UILabel alloc]initWithFrame:CGRectMake(leftX + subWidth/6, KScreenHeight - 50, KScreenWidth/6, 10)];
        livePhotoZhuanfaLabel.text = @"转发411";
        livePhotoZhuanfaLabel.font = [UIFont systemFontOfSize:9];
        [mainView3 addSubview:livePhotoZhuanfaLabel];
        
        UIButton * zhuanfaButton = [[UIButton alloc]initWithFrame:CGRectMake(leftX, KScreenHeight - 50, subWidth/3, 10)];
        zhuanfaButton.backgroundColor = [UIColor clearColor];
        zhuanfaButton.tag =    2;
        [zhuanfaButton addTarget:self action:@selector(LivePhotoButton:) forControlEvents:UIControlEventTouchUpInside];
        [mainView3 addSubview:zhuanfaButton];
        leftX += subWidth/3;
        //返回主界面
    }
}

//mainView3上的三个按钮
-(void)LivePhotoButton:(UIButton *)btn{
    //livePhoto 照片
    NSInteger index = btn.tag;
    if(index == 0)//浏览
    {
        
    }else if(index == 1)//喜欢
    {
        
    }else{//转发
        
    }
}
//关闭mainView3的浏览
-(void)closeLiveShowView{
    [UIView animateWithDuration:0.5 animations:^{
        closeLiveButton.hidden = YES;
        self.navigationController.navigationBar.hidden = NO;
         mainView3.transform= CGAffineTransformMakeTranslation(0, 0);
    }];
   
}
//显示mainView3视图
-(void)showLiveShowView{
   if( mainView3.transform.ty == mainView3ChangeHeight)
       return;
    [UIView animateWithDuration:0.5 animations:^{
        closeLiveButton.hidden = NO;
        self.navigationController.navigationBar.hidden = YES;
        self.navigationController.navigationBar.hidden = YES;
         mainView3.transform= CGAffineTransformMakeTranslation(0, mainView3ChangeHeight);
    }];
    
}
//列数
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 1;
}
//行数
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    return livePhotoImg.count;
}
//行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component
{
    if(pickerView == imgPicker1)
        return imgPickerWidth;
    else
        return  KScreenWidth;
}
//完成pickerView点击时调用
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    //显示mainView3视图
    [self showLiveShowView];
    [imgPicker1 selectRow:row inComponent:0 animated:NO];
    [imgPicker2 selectRow:row inComponent:0 animated:NO];
    NSLog(@"%ld",(long)row);
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    return [NSString stringWithFormat:@"%ld",(long)row];
}
//设置自定义视图的样式
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    //小pickerView
    if(pickerView == imgPicker1)
    {
    view =[[UIImageView alloc]initWithImage:livePhotoImg[row]];
    view.frame = CGRectMake(0, 0, imgPickerWidth, imgPickerWidth);
    view.transform =  CGAffineTransformMakeRotation(-90*M_PI/180);
    return view;
    }
    else
    {
        //UIColor * color = [UIColor colorWithPatternImage:livePhotoImg[row]];
        //大pickerView
        view = [[UIImageView alloc]initWithImage:livePhotoImg[row]];
        view.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight-imgPickerWidth);
        //[view setBackgroundColor:color];
        view.transform =  CGAffineTransformMakeRotation(-90*M_PI/180);
        return view;
    }
}
//近期活动图片
-(void)initJinQiImgSHow{
    
    JinQiview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    JinQiview.backgroundColor = [UIColor blackColor];
    [_summaryScrollView addSubview:JinQiview];
    
    JinQiimg = [[UIImageView alloc]initWithFrame:CGRectMake(20, 20, KScreenWidth - 40, KScreenHeight -40)];
    JinQiimg.backgroundColor = [UIColor redColor];
    [JinQiview addSubview: JinQiimg];
    JinQiview.hidden = YES;
    
    JinQIimgNumLabel = [[UILabel alloc]initWithFrame:CGRectMake(KScreenWidth - 100, KScreenHeight - 40, 90, 40)];
    JinQIimgNumLabel.text = @"1/100";
    JinQIimgNumLabel.backgroundColor = [UIColor clearColor];
    JinQIimgNumLabel.textColor = [UIColor whiteColor];
    JinQIimgNumLabel.textAlignment = NSTextAlignmentRight;
    [JinQiview addSubview:JinQIimgNumLabel];
    UIButton * btn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, KScreenWidth, KScreenHeight)];
    [JinQiview addSubview:btn];
    btn.backgroundColor = [UIColor clearColor];
    [btn addTarget:self action:@selector(JinQiImgChangeHidden:) forControlEvents:UIControlEventTouchUpInside];
    
    //添加轻扫手势
    UISwipeGestureRecognizer * leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(leftGestureGet)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer * rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(rightGestureGet)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    
}
//向左轻扫
-(void)leftGestureGet{
    if(JinQiview.hidden)
        return;
    JinQiImgIndex += 1;
    if(JinQiImgIndex >= jinqiHudongImg.count)
        JinQiImgIndex = 0;
    JinQiimg.image = jinqiHudongImg[JinQiImgIndex];
     JinQIimgNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",(JinQiImgIndex + 1),(unsigned long)jinqiHudongImg.count];
}
//向右轻扫
-(void)rightGestureGet{
    if(JinQiview.hidden)
        return;
    JinQiImgIndex -= 1;
    if(JinQiImgIndex < 0)
        JinQiImgIndex = jinqiHudongImg.count-1;
    JinQiimg.image = jinqiHudongImg[JinQiImgIndex];
     JinQIimgNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",JinQiImgIndex + 1,(unsigned long)jinqiHudongImg.count];
}
//近期图片是否隐藏
-(void)JinQiImgChangeHidden:(UIButton *)btn{
    JinQiview.hidden = !JinQiview.hidden;
    if(JinQiview.hidden == NO)
    {
        self.navigationController.navigationBar.hidden = YES;
        JinQiImgIndex = btn.tag;
        NSLog(@"%ld",(long)JinQiImgIndex);
        JinQiimg.image = jinqiHudongImg[JinQiImgIndex];
        JinQIimgNumLabel.text = [NSString stringWithFormat:@"%ld/%lu",JinQiImgIndex + 1,(unsigned long)jinqiHudongImg.count];
    }
    else
    {
        self.navigationController.navigationBar.hidden = NO;
    }
    
}
//导航栏
-(void)initNavBar{
    //左键按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 60, 25)];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [leftButton setTitle:@"聊天室" forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * leftItem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftItem;
    //右键照相图标
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 25)];
    rightButton.backgroundColor = [UIColor clearColor];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"2-5-1.png"] forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(takeLivePhoto) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rightItem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightItem;
    
}
//照相功能
-(void)takeLivePhoto{
    
    [UIView animateWithDuration:2 animations:^{
        _helperBackView.hidden = NO;
        _helperBackView.alpha = 1.0;
    } completion:^(BOOL finished) {
        _helperBackView.alpha = 0.0;
        _helperBackView.hidden = YES;
    }];
}
//返回聊天室
-(void)popView{
    self.tabBarController.tabBar.hidden = NO;
    [self.navigationController popViewControllerAnimated:NO];
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
