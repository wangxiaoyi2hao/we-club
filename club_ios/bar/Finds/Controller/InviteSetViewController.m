//
//  InviteSetViewController.m
//  bar
//
//  Created by lsp's mac pro on 15/11/2.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "InviteSetViewController.h"
#import "AppDelegate.h"
#import "Tostal.h"
#import "SearchBarViewController.h"
#import "NoHongBaoViewController.h"
#import "QNUploadManager.h"
#import "UIImage+ResizeMagick.h"
#import "ImageViewCell.h"
#import "InviteViewControllerComplete.h"


extern UserInfo*LoginUserInfo;

static NSString *iden = @"collectionCell";
@interface InviteSetViewController ()<ASIHTTPRequestDelegate>
{

    UILabel*offLabel;
    ASIFormDataRequest*_requestCreatInvite;
    NSMutableArray*_imagePhoteArray;
    UIButton*btnAddPhoto;
    NSString*clubNameCenter;
    UILabel*popView;
    NSTimer *timer;
    //判断是否仅限女生
    int onlyGirl;
    NSString*clubId;
    //判断是否有红包
  int isHongBao;
     NSMutableArray *_imgArray;
    UIButton*addImgBtn;
    UIImageView *imgFood;
    //约会时长
    NSString*missTime;
    //创建datepicker
    UIDatePicker *_datePicker;
    UIView *_backbackgroundView;
    //图片缓冲区
    NSData*imageData;
    //图片名字
    NSString *fileName;
    //支付方式
    int paidstyle;
    int imageNum;
    
    NSInteger _idex;
    
    UIImage*imageCdll;
}
@end

@implementation InviteSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
    [AppDelegate matchAllScreenWithView:_headerView];
    [_headerView setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    //加载导航条
    [self loadNav];
    //事例化这个图片数组
    _imgArray=[NSMutableArray array];
    //默认给的是仅限女生
    onlyGirl=1;
    //给一个入参的默认值 默认是红包
    isHongBao=2;
    //创建button
    buttonCreat.layer.cornerRadius = 5.0;
    //创建slider
    //给slider添加方法
    [_slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    //滑动条当前值
    _slider.value=0;
    //滑动条最大值
    _slider.maximumValue= 5*60*60;
    //这个调整页面完成页面效果的
    paidandOnlyGirl.hidden=YES;
    //加手势让键盘消失
    UITapGestureRecognizer*tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(handleTap)];
    [_headerView addGestureRecognizer:tapGesture];
    //约会时间的datapicker
    [self datepickerClick];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifiCaCenter:) name:@"clubName" object:nil];
    _tableView.frame = CGRectMake(0, 0, KScreenWidth, KScreenHeight);
    //创建照片集
    [self _addPhoto];
    
}
#pragma mark - 创建照片集
- (void)_addPhoto{
#pragma mark - 假数据数组,需要替换真数据
    _mArray = [[NSMutableArray alloc] init];
    for (int i =0; i<3; i++) {
        [_mArray addObject:[NSString stringWithFormat:@"%d@2x.png",i+1]];//1-3-2.png
    }
    //    [_mArray addObject:[NSString stringWithFormat:@"7@2x.png"]];
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    flowLayOut.itemSize = CGSizeMake(50, 50);
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 35;
    //设置滑动的方向,默认是垂直滑动
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置头视图的大小
    flowLayOut.headerReferenceSize = CGSizeZero;
    flowLayOut.footerReferenceSize = CGSizeZero;
    
    //2.创建collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,370, KScreenWidth, 52) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
#pragma mark - 需要添加在_headView上
    [_headerView addSubview:_collectionView];
    //关闭滑动状态
    _collectionView.scrollEnabled=NO;
    
    //注册单元格
    [_collectionView registerClass:[ImageViewCell class] forCellWithReuseIdentifier:iden];

}

#pragma mark - UICollectionViewDataSource添加照片的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _mArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    
    if (indexPath.row == _mArray.count-1) {
        cell.imgName = @"1-3-2.png";
    }else{
        cell.imgName = _mArray[indexPath.row];
    }
    return cell;
    
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(5, 5, 5, 5);
    
    return edge;
    
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==_mArray.count-1) {
        [_mArray insertObject:_mArray[indexPath.row] atIndex:_mArray.count-1];
        [_collectionView reloadData];
        
    }else{
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"删除图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        
        [actionSheet showInView:self.view];
        actionSheet.tag = 1002;
        _idex = indexPath.row;
    }
}

//-(void)notifiCaCenter:(NSNotification*)objc{
//    clubId=[objc.userInfo objectForKey:@"clubId"];
//    lbBarName.text=[objc.userInfo objectForKey:@"clubName"];
//    isHongBao=[objc.userInfo objectForKey:@"isRed"];
//}

#pragma mark - 选择约会时间
- (IBAction)birthButtonAction:(UIButton *)sender {
 
    _datePicker.hidden = NO;
    _backbackgroundView.hidden = NO;
    [_textFieldRedBag resignFirstResponder];
    
    
}

//这里一会要复制到那个写好的那个页面
-(void)datepickerClick{
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, KScreenHeight-230,KScreenWidth, 230)];
    _backbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -60, KScreenWidth, KScreenHeight)];
    _backbackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];
    [_headerView addSubview:_backbackgroundView];
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
    _backbackgroundView.hidden = YES;
    //创建DatePicker
    //设置当前显示的时间
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:-3*60*60];
    //    datePicker.date = currentDate;
    [_datePicker setDate:currentDate animated:YES];
    //设置显示的时间区域
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
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
    lbDate.text=time;
}
#pragma mark 这个是后面黑北京的view
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
#pragma mark  约会时长 slider 事件
-(NSString*)coverTime:(float)value{
    int m=value/60;
    NSString *time=[NSString stringWithFormat:@"%.0d",m];
    return time;
}
-(void)sliderAction:(UISlider*)slider{
    missTime=[self coverTime:slider.value];
    NSLog(@"%@",missTime);
}
-(void)handleTap{
    [_textView resignFirstResponder];
    [_textFieldRedBag resignFirstResponder];
}
- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
    [_textFieldRedBag resignFirstResponder];
    [_textView resignFirstResponder];
}

-(IBAction)switchClick:(UIButton*)sender{

    InviteViewControllerComplete*controller=[[InviteViewControllerComplete alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
    
}
-(void)clubNameCenter:(NSNotification*)objc{
   
}

#pragma mark  创建邀约的导航条设置
-(void)loadNav{
    self.title=@"邀约";
    self.navigationController.navigationBar.titleTextAttributes=@{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"导航栏.jpg"] forBarMetrics: UIBarMetricsDefault];
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    [leftButton addTarget:self action:@selector(popView) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setBackgroundImage:[UIImage imageNamed:@"all_back.png"] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 22, 20)];
    [rightButton addTarget:self action:@selector(refreshThisView) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setBackgroundImage:[UIImage imageNamed:@"创建邀约-重置.png"] forState:UIControlStateNormal];
    //leftButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem * rightbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
}
-(void)refreshThisView{
   lbPaid.text=@"";
   lbBeginTime.text=@"";
   lbBarName.text=@"";
}

-(IBAction)timeCatch:(id)sender{
    UIAlertView*alterView2=[[UIAlertView alloc]initWithTitle:@"请选择时长" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"30分钟",@"1小时",@"2小时",@"3小时",@"4小时",@"5小时", nil];
     [alterView2 show];
}
//创建成功
-(IBAction)creatSuccess:(id)sender{
    [self requestSearchFriend];
    [self goQiniu];
}
#pragma mark 如果是红包邀约的话就显示
-(void)requestSearchFriend{
    Request12000*request12000=[[Request12000 alloc]init];
    //设置请求参数
    request12000.common.userid=LoginUserInfo.user_id;
    request12000.common.userkey=LoginUserInfo.user_key;
    request12000.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12000.common.version=@"1.0.0";//版本号
    request12000.common.platform=2;//ios  andriod
    request12000.params.hasMoney=isHongBao;//是否红包邀约1无红包邀约 2红包邀约
    request12000.params.money=[[_textFieldRedBag text]intValue];;//红包金额
    request12000.params.duringTime=[missTime intValue];//约会时长
    
    //因为入的参数是时间戳 要转化
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateMiss =[dateFormat dateFromString:lbDate.text];
    
//    NSLog(@"%@",lbDate.text);
    request12000.params.dateTime=lbDate.text;//约会开始时间
    NSLog(@"%.0f",[dateMiss timeIntervalSince1970]);
    request12000.params.clubId=clubId;//酒吧id
    request12000.params.justFemale=onlyGirl;//1，仅限女生  2，不仅限女生
    request12000.params.inviteDescription=_textView.text;//派对内容
    request12000.params.invitePicArray=_imagePhoteArray;//派对描述的图片的数组
    request12000.params.latitude=LoginUserInfo.latitude;//创建人所在的纬度
    request12000.params.longitude=LoginUserInfo.longitude;//创建人所在的经度
    request12000.params.clubName=lbBarName.text;//酒吧名字
    request12000.params.payWay=paidstyle;//支付方式
    //下面还可能有上传图片的内容
    NSData*data= [request12000 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@inviteAction/createInvite",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestCreatInvite = [ASIFormDataRequest requestWithURL:url];
    [_requestCreatInvite setPostBody:(NSMutableData*)data];
    [_requestCreatInvite setDelegate:self];
    //请求延迟时间
    _requestCreatInvite.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestCreatInvite.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestCreatInvite.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestCreatInvite.secondsToCache=3600;
    [_requestCreatInvite startAsynchronous];
    
}
-(IBAction)onlyGirl:(UISwitch*)sender{
    if (sender.on) {
        onlyGirl=1;
    }else{
    
        onlyGirl=2;
    }
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([request isEqual:_requestCreatInvite]) {
      
        Response12000*response=[Response12000 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"创建失败" tostalTime:1];
        }else{
              [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
            [[Tostal sharTostal]tostalMesg:@"创建成功" tostalTime:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInvite" object:nil];
        }
    }
    
}

//返回事件
-(void)popView{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)pushController{
}

//添加照片功能
-(IBAction)addPhoto:(id)sender{
    UIActionSheet*actionSheet=[[UIActionSheet alloc]initWithTitle:@"拍照" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相机拍照",@"相册选择照片", nil];
    actionSheet.tag=10;
    [actionSheet showInView:self.view];
}

#pragma mark - actionSheet照相和删除照片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1002) {
        //删除照片
        if (buttonIndex == 0) {
            [_mArray removeObjectAtIndex:_idex];
            [_collectionView reloadData];
            
        }else{
            
        }
    }else{
        if (buttonIndex==0) {
            UIImagePickerController*imagePicker1=[[UIImagePickerController alloc]init];
            imagePicker1.delegate=self;
            imagePicker1.sourceType=UIImagePickerControllerSourceTypeCamera;
            imagePicker1.allowsEditing=YES;
            [self presentViewController:imagePicker1 animated:YES completion:nil];
        }else if(buttonIndex==1){
            
            UIImagePickerController*imagePicker2=[[UIImagePickerController alloc]init];
            imagePicker2.delegate=self;
            imagePicker2.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker2.allowsEditing=YES;
            [self presentViewController:imagePicker2 animated:YES completion:nil];
            
        }
    }
}
//选择照片后需要完成的功能
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
     imageData = [image resizedAndReturnData];
     fileName = [NSString stringWithFormat:@"%@%@.jpg",[[Tostal sharTostal]getDateTimeString],  [[Tostal sharTostal]randomStringWithLength:8]];
     [_imgArray addObject:image];
     [picker dismissViewControllerAnimated:YES completion:nil];
}
-(void)goQiniu{
    NSLog(@"%@",LoginUserInfo.qiNiuTOken);
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
}
//增加图片的时候
-(void)numAdd{
    if (imageNum==0) {
        imageNum++;
        [imageButton1 setImage:[_imgArray  objectAtIndex:0] forState:UIControlStateNormal];
        
    }else if (imageNum==1){
        imageNum++;
        [imageButton1 setImage:[_imgArray  objectAtIndex:0] forState:UIControlStateNormal];
        [imageButton2 setImage:[_imgArray  objectAtIndex:1] forState:UIControlStateNormal];
        
    }else if (imageNum==2){
        imageNum++;
        [imageButton1 setImage:[_imgArray  objectAtIndex:0] forState:UIControlStateNormal];
        [imageButton2 setImage:[_imgArray  objectAtIndex:1] forState:UIControlStateNormal];
        [imageButton3 setImage:[_imgArray  objectAtIndex:2] forState:UIControlStateNormal];
        
    }else{
        [[Tostal sharTostal]tostalMesg:@"图片以到上线" tostalTime:2];
    }
    [self isHidden];
}
//删除图片
- (void)numReduce{
    imageNum--;
    if (imageNum==1) {
        [imageButton1 setImage:[_imgArray  objectAtIndex:0] forState:UIControlStateNormal];
    }else if (imageNum==2){
        [imageButton1 setImage:[_imgArray  objectAtIndex:0] forState:UIControlStateNormal];
        [imageButton2 setImage:[_imgArray  objectAtIndex:1] forState:UIControlStateNormal];
    }else if (imageNum==3){
        [imageButton1 setImage:[_imgArray  objectAtIndex:0] forState:UIControlStateNormal];
        [imageButton2 setImage:[_imgArray  objectAtIndex:1] forState:UIControlStateNormal];
        [imageButton3 setImage:[_imgArray  objectAtIndex:2] forState:UIControlStateNormal];
        
    }
    [self isHidden];
}
- (void)isHidden{
    if (imageNum==0) {
        imageButton1.hidden=YES;
        imageButton2.hidden=YES;
        imageButton3.hidden=YES;
    }
    if (imageNum==1) {
        imageButton1.hidden=NO;
        imageButton2.hidden=YES;
        imageButton3.hidden=YES;
    }
    if (imageNum==2) {
        imageButton1.hidden=NO;
        imageButton2.hidden=NO;
        imageButton3.hidden=YES;
    }
    if (imageNum==3) {
        imageButton3.hidden=NO;
        imageButton2.hidden=NO;
        imageButton1.hidden=NO;
    }
}




//选择酒吧
-(IBAction)selectBar:(id)sender{
    SearchBarViewController*controller=[[SearchBarViewController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];

}
-(IBAction)selectPaid:(id)sender{
   
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
      lbPaid.text=@"";
    }

  


}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    return _headerView;
    
}
//返回页眉高度
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 618;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    static NSString*str=@"cell";
    UITableViewCell*cell=[tableView dequeueReusableCellWithIdentifier:str];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    
    return cell;



}
-(void)viewWillDisappear:(BOOL)animated{
    [_requestCreatInvite clearDelegatesAndCancel];

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
