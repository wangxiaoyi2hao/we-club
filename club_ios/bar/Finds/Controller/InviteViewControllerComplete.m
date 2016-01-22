//
//  InviteViewControllerComplete.m
//  Weclub
//
//  Created by lsp's mac pro on 15/12/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "InviteViewControllerComplete.h"
#import "AppDelegate.h"
#import "SearchBarViewController.h"
#import "ImageViewCell.h"
#import "UIImage+ResizeMagick.h"

extern UserInfo*LoginUserInfo;
static NSString *idenLeft = @"collectionCellLeft";
static NSString *idenRight = @"collectionCellRight";
@interface InviteViewControllerComplete ()
{

    //约会时长
    NSString*missTime;
    //支付方式
    int paidstyle;
    //酒吧的id
    NSString*clubId;
    // 邀约图片里面添加的图片数组
    NSMutableArray*_imagePhoteArray;
    ASIFormDataRequest*requestRed;
    ASIFormDataRequest*requestNoRed;
    //判断是否仅限女生
    int onlyGirl;
    UIDatePicker *_datePicker;
    
    UIDatePicker*_datePicker2;
    
    
    UIView*_backbackgroundView;
    
    UIView*_backbackgroundView2;
    NSString* isRedBag;
    NSInteger _idexLeft;
    NSInteger _idexRight;
    NSMutableArray*fileNameArray;
   //是否为红包呢
    int isRedBagPicture;

}
@end

@implementation InviteViewControllerComplete

- (void)viewDidLoad {
    [super viewDidLoad];
    //这里面是设置适配的方法
    [AppDelegate matchAllScreenWithView:self.view];
    //这里面是设置导航条的样式
    [self loadNav];
    //这里面是设置datepicker
    [self datepickerClick];
//    [self datepickerClick2];
    
    //默认给的是仅限女生
    onlyGirl=1;
#pragma mark  这里是设置约会时长的slider
    //给slider添加方法
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    //滑动条当前值
    _slider.value=0;
    //滑动条最大值
    _slider.maximumValue= 5*60*60;
#pragma mark 这里是选择了酒吧之后接受通知的地方
//    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifiCaCenter:) name:@"clubName" object:nil];//(新邀约界面要用,暂时注释掉)
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(isWhereScrollview:) name:@"isWhereScrollview" object:nil];
    //创建相册
    [self _addPhotoLeft];
    //这里面是设置随机名字的地方
    fileNameArray=[NSMutableArray array];
    
}
#pragma mark - 创建相册
- (void)_addPhotoLeft{
#pragma mark - 假数据数组,需要替换真数据
    _mArray = [[NSMutableArray alloc] init];
    //因为里面有加号  所以这里要先循环遍历一下 取到加号这个按钮
    for (int i =0; i<1; i++) {
        UIImage *image= [UIImage imageNamed:[NSString stringWithFormat:@"%d@2x.png",i+1]];
        [_mArray addObject:image];
    }
  
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    flowLayOut.itemSize = CGSizeMake(50*KScreenWidth/320, 50*KScreenWidth/320);
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 25;
    //设置滑动的方向,默认是垂直滑动
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置头视图的大小
    flowLayOut.headerReferenceSize = CGSizeZero;
    flowLayOut.footerReferenceSize = CGSizeZero;
    //2.创建左侧网格
    _collectionViewLeft = [[UICollectionView alloc] initWithFrame:CGRectMake(18,344*KScreenHeight/568, 289*KScreenWidth/320, 50*KScreenWidth/320) collectionViewLayout:flowLayOut];
    _collectionViewLeft.backgroundColor = [UIColor whiteColor];
    //设置代理
    _collectionViewLeft.delegate = self;
    _collectionViewLeft.dataSource = self;
#pragma mark - 需要添加在_headView上
    //[self.view bringSubviewToFront:_collectionView];
    [_backViewLeft addSubview:_collectionViewLeft];
    //关闭滑动状态
    _collectionViewLeft.scrollEnabled=NO;
    //注册单元格
    [_collectionViewLeft registerClass:[ImageViewCell class] forCellWithReuseIdentifier:idenLeft];
    //创建右侧网格
    _collectionViewRight = [[UICollectionView alloc] initWithFrame:CGRectMake(18,344*KScreenHeight/568, 289*KScreenWidth/320, 50*KScreenWidth/320) collectionViewLayout:flowLayOut];
    _collectionViewRight.backgroundColor = [UIColor whiteColor];
    //设置代理
    //右边的collectionview  设置代理
    _collectionViewRight.delegate = self;
     //左边的collectionview  设置代理
    _collectionViewRight.dataSource = self;
#pragma mark - 需要添加在_headView上
    [_backViewRight addSubview:_collectionViewRight];
    //关闭滑动状态
    _collectionViewRight.scrollEnabled=NO;
    //注册单元格
    [_collectionViewRight registerClass:[ImageViewCell class] forCellWithReuseIdentifier:idenRight];
    
}

#pragma mark - UICollectionViewDataSource添加照片的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _mArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    //这里是判断是左边的那个collectionview还是右边的collectionview
    if (collectionView == _collectionViewLeft) {
        
        ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenLeft forIndexPath:indexPath];
        
        if (indexPath.row == _mArray.count-1) {
            //因为这里是要加入加号 ，所以说要给一个判断赋值上这个加号的名字然后把夹伤加上面
            cell.image =  [UIImage imageNamed:@"1-3-2.png"] ;
        }else{
            cell.image = _mArray[indexPath.row];
        }
        return cell;
    }else{
        ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenRight forIndexPath:indexPath];
        
        if (indexPath.row == _mArray.count-1) {
            cell.image =  [UIImage imageNamed:@"1-3-2.png"] ;
        }else{
            cell.image = _mArray[indexPath.row];
        }
        return cell;
    }
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 17, 0, 20);    
    return edge;
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (collectionView == _collectionViewLeft) {
        //这里是左边的那个collectionview的点击事件
        if (indexPath.row ==_mArray.count-1) {

            UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"请选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"相机" , nil];
            sheet.tag=521;
            [sheet showInView:self.view];
            

            
        }else{
            //这里是点击图片的事件
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"删除图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];

            [actionSheet showInView:self.view];
            actionSheet.tag = 1002;
            _idexLeft = indexPath.row;
        }
    }else{
        if (indexPath.row ==_mArray.count-1) {
//这里是点击右边的那个collectionview的那个点击事件
            UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"请选择照片" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"相机" , nil];
            sheet.tag=521;
            [sheet showInView:self.view];
        }else{
            //右边的删除图片的事件
            UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"删除图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
            
            [actionSheet showInView:self.view];
            actionSheet.tag = 1002;
            _idexRight = indexPath.row;
        }
        
    }
}
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
//这里是显示的那个是相册的地方
    if (actionSheet.tag==521) {
        if (buttonIndex==0) {
            //相册
            UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
            imgPicker.delegate=self;
            imgPicker.allowsEditing=YES;
            imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            [self presentViewController:imgPicker animated:YES completion:nil];
        }
        if (buttonIndex==1) {
            //拍照
            UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
            imagePicker.delegate=self;
            imagePicker.allowsEditing=YES;//设置是否可编辑。
            imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置以哪种方式取照片，是从本地相册取，还是从相机拍照取。
            [self presentViewController:imagePicker animated:YES completion:nil];
        }
    }
    if (actionSheet.tag==1002) {
        if (buttonIndex==0) {
            [fileNameArray removeObjectAtIndex:_idexLeft];
            [_mArray removeObjectAtIndex:_idexLeft];
            [_collectionViewLeft reloadData];
            [_collectionViewRight reloadData];
        }

    }

}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    //给图片转化成data  为了上传七牛
        NSData* imageData = [image resizedAndReturnData];
    //给图片赋一个名字
        NSString*  fileName = [NSString stringWithFormat:@"%@%@.jpg",[[Tostal sharTostal]getDateTimeString],  [[Tostal sharTostal]randomStringWithLength:8]];
        [fileNameArray addObject:fileName];
      [_mArray insertObject:image atIndex:_mArray.count-1];
      [_collectionViewLeft reloadData];
    [_collectionViewRight reloadData];
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:imageData
                   key:fileName
                 token:LoginUserInfo.qiNiuTOken
              complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                  
                  NSLog(@" --->> Info: %@  ", info);
                  NSLog(@" ---------------------");
                  NSLog(@" --->> Response: %@,  ", resp);
              }
                option:nil];

       [self dismissViewControllerAnimated:YES completion:nil];

}
-(void)isWhereScrollview:(NSNotification*)objc{
//这里是通知事件，通知过来了之后就判断时多少然后决定scrollview的偏移量
  NSString*gogogo=[objc.userInfo objectForKey:@"isRed"];
    
    if ([gogogo isEqualToString:@"2"]) {
        _scrollview.contentOffset = CGPointMake(0, 0);
        
    }else{
        _scrollview.contentOffset = CGPointMake(KScreenWidth, 0);
    }
 
}
-(void)notifiCaCenter:(NSNotification*)objc{
    clubId=[objc.userInfo objectForKey:@"clubId"];
    
    //这里面需要给一个变量然后辨别出来是哪个页面的酒吧名字
   
    NSString*gogogo=[objc.userInfo objectForKey:@"isRed"];

    if ([gogogo isEqualToString:@"2"]) {
         _scrollview.contentOffset = CGPointMake(0, 0);
     lbBar1.text=[objc.userInfo objectForKey:@"clubName"];
    }else{
         lbBar2.text=[objc.userInfo objectForKey:@"clubName"];
      _scrollview.contentOffset = CGPointMake(KScreenWidth, 0);
    }
}

#pragma mark slider的一些事件
-(NSString*)coverTime:(float)value{
    int m=value/60;
    NSString *time=[NSString stringWithFormat:@"%.0d",m];
    return time;
}
-(void)sliderAction:(UISlider*)slider{
    missTime=[self coverTime:slider.value];
    NSLog(@"%@",missTime);

}
//设置scrollview的偏移量
- (void)viewDidLayoutSubviews{
    
    [super viewDidLayoutSubviews];
    _scrollview.contentSize = CGSizeMake(KScreenWidth*2, KScreenHeight);
}
//设置导航条
-(void)loadNav{
    self.title=@"建立邀约";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"tab_bar.png"] forBarMetrics: UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(backatgerview) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
    
}
-(void)backatgerview{

    [self.navigationController popViewControllerAnimated:YES];

}
//有红包邀约的网络请求方法
-(void)requestRedPacketBag{
    Request12000*request12000=[[Request12000 alloc]init];
    //设置请求参数
    request12000.common.userid=LoginUserInfo.user_id;
    request12000.common.userkey=LoginUserInfo.user_key;
    request12000.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12000.common.version=@"1.0.0";//版本号
    request12000.common.platform=2;//ios  andriod
    request12000.params.hasMoney=2;//是否红包邀约1无红包邀约 2红包邀约
    request12000.params.money=[[_textFieldRedBag text]intValue];;//红包金额
    request12000.params.duringTime=[missTime intValue];//约会时长
    
    //因为入的参数是时间戳 要转化
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateMiss =[dateFormat dateFromString:lbTime1.text];
    
    //    NSLog(@"%@",lbDate.text);
    request12000.params.dateTime=lbTime1.text;//约会开始时间
    NSLog(@"%.0f",[dateMiss timeIntervalSince1970]);
    request12000.params.clubId=clubId;//酒吧id
    request12000.params.inviteDescription=textView1.text;//派对内容
    request12000.params.invitePicArray=fileNameArray;//派对描述的图片的数组
    request12000.params.latitude=LoginUserInfo.latitude;//创建人所在的纬度
    request12000.params.longitude=LoginUserInfo.longitude;//创建人所在的经度
    request12000.params.clubName=lbBar1.text;//酒吧名
    //下面还可能有上传图片的内容
    NSData*data= [request12000 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/createInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    requestRed = [ASIFormDataRequest requestWithURL:url];
    [requestRed setPostBody:(NSMutableData*)data];
    [requestRed setDelegate:self];
    //请求延迟时间
    requestRed.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    requestRed.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    requestRed.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    requestRed.secondsToCache=3600;
    [requestRed startAsynchronous];
    
}
//没有红包邀约的网络请求方法
-(void)requestNoRedPacketBag{
    Request12000*request12000=[[Request12000 alloc]init];
    //设置请求参数
    request12000.common.userid=LoginUserInfo.user_id;
    request12000.common.userkey=LoginUserInfo.user_key;
    request12000.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12000.common.version=@"1.0.0";//版本号
    request12000.common.platform=2;//ios  andriod
    request12000.params.hasMoney=1;//是否红包邀约1无红包邀约 2红包邀约
    request12000.params.duringTime=[missTime intValue];//约会时长
    //因为入的参数是时间戳 要转化
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateMiss =[dateFormat dateFromString:lbTime2.text];
    //是否仅限女生
    request12000.params.justFemale=onlyGirl;
    request12000.params.dateTime=lbTime2.text;//约会开始时间
    NSLog(@"%.0f",[dateMiss timeIntervalSince1970]);
    request12000.params.clubId=clubId;//酒吧id
    request12000.params.inviteDescription=textView2.text;//派对内容
    request12000.params.invitePicArray=fileNameArray;//派对描述的图片的数组
    request12000.params.latitude=LoginUserInfo.latitude;//创建人所在的纬度
    request12000.params.longitude=LoginUserInfo.longitude;//创建人所在的经度
    request12000.params.clubName=lbBar2.text;//酒吧名
    //支付方式
    request12000.params.payWay=paidstyle;
    //下面还可能有上传图片的内容
    NSData*data= [request12000 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/createInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    requestNoRed = [ASIFormDataRequest requestWithURL:url];
    [requestNoRed setPostBody:(NSMutableData*)data];
    [requestNoRed setDelegate:self];
    //请求延迟时间
    requestNoRed.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    requestNoRed.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    requestNoRed.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    requestNoRed.secondsToCache=3600;
    [requestNoRed startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    Response12000*response=[Response12000 parseFromData:request.responseData error:nil];
    if (response.common.code!=0) {
        [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        [[Tostal sharTostal]tostalMesg:@"创建成功" tostalTime:1];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInvite" object:nil];
    }

}
-(void)datepickerClick{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, KScreenHeight-230,KScreenWidth, 230)];
    _backbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, KScreenWidth, KScreenHeight)];
    _backbackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];

    [self.view addSubview:_backbackgroundView];
    // 设置取消和确定按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, KScreenHeight-270, KScreenWidth/2.0, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backbackgroundView addSubview:cancelButton];
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    certainButton.frame = CGRectMake(KScreenWidth/2.0, KScreenHeight-270, KScreenWidth/2.0, 40);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [certainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    certainButton.backgroundColor = [UIColor whiteColor];
    [certainButton addTarget:self action:@selector(certainButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backbackgroundView addSubview:certainButton];

    //    //单击
    //    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //    [_headerView addGestureRecognizer:singleTap];
    _backbackgroundView.hidden = YES;
    //创建DatePicker
    
    //设置当前显示的时间
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:-3*60*60];
    //    datePicker.date = currentDate;
    [_datePicker setDate:currentDate animated:YES];
    //设置显示的时间区域
    //    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
    _datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //设置样式
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    //添加滑动事件
    [_datePicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_backbackgroundView addSubview:_datePicker];
    _datePicker.hidden = YES;
}
- (void)dateAction:(UIDatePicker *)datePicker {
    //取得时间
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *time = [formatter stringFromDate:date];
    lbTime1.text=time;
    lbTime2.text=time;
}
#pragma mark 这里是关闭红包事件 下面的是红包邀约的东西
-(IBAction)closeRedBag:(id)sender{
    _scrollview.contentOffset = CGPointMake(KScreenWidth, 0);
    
    isRedBagPicture=1;


}
-(void)viewWillAppear:(BOOL)animated{

    if (isRedBagPicture==1) {
        _scrollview.contentOffset = CGPointMake(KScreenWidth, 0);
    }else{
    
        _scrollview.contentOffset = CGPointMake(0, 0);
    }

}
//红包邀约 选择时间
-(IBAction)selectTime:(id)sender{
//    [self datepickerClick2];
    _datePicker.hidden = NO;
    _backbackgroundView.hidden = NO;
    [_textFieldRedBag resignFirstResponder];
}
//返回按钮
-(void)cancelButtonAction{
    
    _backbackgroundView.hidden = YES;
}
//确定按钮
-(void)certainButtonAction{
    _backbackgroundView.hidden = YES;
}
//加触摸手势
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    _backbackgroundView.hidden = YES;
}
//红包邀约 选择酒吧
-(IBAction)selectBar:(id)sender{
    isRedBag=@"2";//有钱是2.
    SearchBarViewController*controller=[[SearchBarViewController alloc]init];
    controller.fromIntBag=isRedBag;
    [self.navigationController pushViewController:controller animated:NO];
}
//红包邀约 创建邀约
-(IBAction)creatInvite:(id)sender{
    if ([lbBar1.text isEqualToString:@""]) {
        [[Tostal sharTostal]tostalMesg:@"请填写酒吧名称" tostalTime:1];
    }else if ([lbTime1.text isEqualToString:@""]){
        [[Tostal sharTostal]tostalMesg:@"请填写约会时间" tostalTime:1];
    }else if ([missTime isEqualToString:@""]){
        [[Tostal sharTostal]tostalMesg:@"请填写约会时长" tostalTime:1];
    }else{
        [self requestRedPacketBag];
    }
}
#pragma mark 这里是打开红包事件 下面跟的是非红包邀约的东西
-(IBAction)openRedBag:(id)sender{
    isRedBagPicture=2;
  _scrollview.contentOffset = CGPointMake(0, 0);
    
}
//非红包邀约的选择时间
-(IBAction)selectTime2:(id)sender{
    _datePicker.hidden = NO;
    _backbackgroundView.hidden = NO;
    [_textFieldRedBag resignFirstResponder];
    
}
//非红包邀约的 选择酒吧
-(IBAction)selectBar2:(id)sender{
    isRedBag=@"1";//没钱是1.
    SearchBarViewController*controller=[[SearchBarViewController alloc]init];
    controller.fromIntBag=isRedBag;
    [self.navigationController pushViewController:controller animated:NO];
    
}
//非红包邀约 创建邀约
-(IBAction)creatInvite2:(id)sender{
    if ([lbBar2.text isEqualToString:@""]) {
        [[Tostal sharTostal]tostalMesg:@"请填写酒吧名称" tostalTime:1];
    }else if ([lbTime2.text isEqualToString:@""]){
        [[Tostal sharTostal]tostalMesg:@"请填写约会时间" tostalTime:1];
    }else{
        [self requestNoRedPacketBag];
    }
    
}
//仅限女生按钮
-(IBAction)onlyGirl:(UIButton*)sender{
   
    if (sender.tag==0) {
        onlyGirl=2;
        [sender setImage:[UIImage imageNamed:@"创建邀约-关.png"] forState:UIControlStateNormal];
        sender.tag=1;
    }else{
        onlyGirl=1;
        [sender setImage:[UIImage imageNamed:@"创建邀约-开.png"] forState:UIControlStateNormal];
        sender.tag=0;
    }
}
//支付方式按钮
-(IBAction)paidStyle:(id)sender{
    UIAlertView*aliterView=[[UIAlertView alloc]initWithTitle:@"付款方式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"AA制",@"我请客",@"男生请客",@"待定", nil];
    [aliterView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{

    if (buttonIndex==1) { //1AA制 2我请客 3男生请客 4待定
        lbPaid.text=@"AA制";
        paidstyle=1;
    }else if (buttonIndex==2){
        lbPaid.text=@"我请客";
        paidstyle=2;
    }else if (buttonIndex==3){
        lbPaid.text=@"男生请客";
        paidstyle=3;
    }else if (buttonIndex==4){
        paidstyle=4;
        lbPaid.text=@"待定";
    }else{
        paidstyle=4;
        lbPaid.text=@"支付方式";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([textView isEqual:textView1] ) {
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionLeft:)];
        [_backViewLeft addGestureRecognizer:singleTap];
        _scrollview.contentOffset = CGPointMake(0, 70);
    }else{
        //单击
        UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionRight:)];
        [_backViewRight addGestureRecognizer:singleTap];
        _scrollview.contentOffset = CGPointMake(KScreenWidth, 70);

        
        
    }

    return YES;
}
- (void)tapActionLeft:(UITapGestureRecognizer *)tap{
    
    _scrollview.contentOffset = CGPointMake(0, 0);
    [textView1 resignFirstResponder];
    [_backViewLeft removeGestureRecognizer:tap];
}
- (void)tapActionRight:(UITapGestureRecognizer *)tap{
    
    _scrollview.contentOffset = CGPointMake(KScreenWidth, 0);
    [textView2 resignFirstResponder];
    [_backViewRight removeGestureRecognizer:tap];
}


@end
