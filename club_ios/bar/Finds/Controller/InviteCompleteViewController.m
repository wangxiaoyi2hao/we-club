//
//  InviteCompleteViewController.m
//  Weclub
//
//  Created by chen on 16/1/4.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "InviteCompleteViewController.h"
#import "AppDelegate.h"
#import "InviteCompleCell.h"
#import "ImageViewCell.h"
#import "SearchBarViewController.h"
#import "UIImage+ResizeMagick.h"
#import "QiNiuClassSend.h"

extern UserInfo*LoginUserInfo;
static NSString *idenLeft = @"InviteCompleCell";
@interface InviteCompleteViewController (){
    UIDatePicker *_datePicker;
    UIView*_backbackgroundView;
    UILabel *_lbTime;
    NSInteger _idexLeft;
    //邀约时间
    NSString *_time;
    //酒吧的id
    NSString*_clubId;
    //酒吧名称
    NSString *_barName;
    //随机图片名
    NSMutableArray*fileNameArray;
    // 邀约图片里面添加的图片数组
    NSMutableArray*_imagePhoteArray;
    ASIFormDataRequest*requestRed;
    ASIFormDataRequest*requestNoRed;
    //这里是要请求如果token没有得到再次得到议会
    ASIFormDataRequest*requestQiNiuToken;
    //要上传到七牛的数组
    NSMutableArray*qiniuArray;
    
    //这里是多少钱
    int yuan;
    
    //判断是否有图片
    int isSendPicture;
    NSString*qiNiuToken;
    NSString*qiNiuZoneName;
    
#pragma mark 这个变量来判断是不是红包邀约
    int  weclubHasMoney;
}

@end

@implementation InviteCompleteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置表视图
    [AppDelegate matchAllScreenWithView:_InviteCompleView];
    [AppDelegate matchAllScreenWithView:_headView];
    _headView.frame = CGRectMake(0, 0, KScreenWidth, 150*KScreenHeight/568);
//    UIView *footView = [[UIView alloc] init];
    _InviteCompleView.tableFooterView = _footView;
    _InviteCompleView.tableHeaderView = _headView;
    _InviteCompleView.delegate = self;
    _InviteCompleView.dataSource = self;
    _pleaceHoderLabel.enabled = NO;
    //创建时间选择器
    [self datepickerClick];
    //设置导航栏
    [self loadNav];
    //创建网格视图
    [self _addPhotoLeft];
    //这里面是设置随机名字的地方
    fileNameArray=[NSMutableArray array];
    #pragma mark 这里是选择了酒吧之后接受通知的地方
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(notifiCaCenter:) name:@"clubName" object:nil];
    qiniuArray=[NSMutableArray array];
}
//调用七牛 实时获取token
-(void)viewWillAppear:(BOOL)animated{

    [self requstQiNiuToken];
}
//获取酒吧名字和id
-(void)notifiCaCenter:(NSNotification*)objc{
    _clubId=[objc.userInfo objectForKey:@"clubId"];
    _barName=[objc.userInfo objectForKey:@"clubName"];
    [_InviteCompleView reloadData];
}
#pragma mark- tabelView代理方法
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView;{
    return 1;
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *iden = @"InviteCompleCell";
    InviteCompleCell*cell=[tableView dequeueReusableCellWithIdentifier:iden];
    if (cell==nil) {
        NSArray*arry=[[NSBundle mainBundle]loadNibNamed:@"InviteCompleCell" owner:self options:nil];
        cell=[arry objectAtIndex:0];
    }

    if (indexPath.row == 0) {
        
        cell.titleLabel.text = @"邀约时间";
        cell.contentText.placeholder = @"请选择邀约的时间";
        cell.contentText.text = _time;
        cell.contentText.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
        
    }else if(indexPath.row == 1){
        cell.titleLabel.text = @"邀约酒吧";
        cell.contentText.placeholder = @"请选择邀约的酒吧";
        cell.contentText.text = _barName;
        cell.contentText.enabled = NO;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        
    }else if(indexPath.row == 2){
        cell.titleLabel.text = @"红包邀约";
        cell.contentText.hidden = YES;
        UISwitch *inviteSwitch = [[UISwitch alloc] initWithFrame:CGRectMake(KScreenWidth -60, 5, 20, 20)];
        [inviteSwitch addTarget:self action:@selector(switchClick:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:inviteSwitch];
    }else if(indexPath.row == 3){
        cell.titleLabel.text = @"邀约金额";
        cell.contentText.backgroundColor = [UIColor lightTextColor];
        yuan=[cell.contentText.text intValue];
        cell.contentText.placeholder = @"请输入邀约金额,单位(元)";
    }else if(indexPath.row == 4){
        cell.titleLabel.text = @"邀约人数";
        cell.contentText.backgroundColor = [UIColor lightTextColor];
        cell.contentText.placeholder = @"请输入邀约人数,非红包邀约只能1人";
    }
    return cell;
}
//get  qiNiu TOKEN
#pragma mark 这里是写上如果七牛的token 获取失败的时候
-(void)requstQiNiuToken{
    Request11015*request11015=[[Request11015 alloc]init];
    //设置请求参数
    request11015.common.userid=LoginUserInfo.user_id;
    request11015.common.userkey=LoginUserInfo.user_key;
    request11015.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request11015.common.version=@"1.0.0";//版本号
    request11015.common.platform=2;//ios  andriod
    request11015.params.tokenType=2;
    NSData*data= [request11015 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getQiniuToken",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    requestQiNiuToken = [ASIFormDataRequest requestWithURL:url];
    [requestQiNiuToken setPostBody:(NSMutableData*)data];
    [requestQiNiuToken setDelegate:self];
    //请求延迟时间
    requestQiNiuToken.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    requestQiNiuToken.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    requestQiNiuToken.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    requestQiNiuToken.secondsToCache=3600;
    [requestQiNiuToken startAsynchronous];
}

#pragma mark switch的变化方法 先放到这里
-(void)switchClick:(UISwitch*)sender{
    if (sender.on) {
        weclubHasMoney=2;
    }else{
    
        weclubHasMoney=1;
    }

}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    
    return 10;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [_describeView resignFirstResponder];
    //取消选中状态,写在表视图点击方法中
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.row == 0) {
        _datePicker.hidden = NO;
        _backbackgroundView.hidden = NO;
    }else if(indexPath.row == 1){
//        isRedBag=@"2";//有钱是2.
        SearchBarViewController*controller=[[SearchBarViewController alloc]init];
//        controller.fromIntBag=isRedBag;
        [self.navigationController pushViewController:controller animated:YES];
        
    }else if(indexPath.row == 2){
        
    }
}
#pragma mark- 创建时间选择器
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
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [_backbackgroundView addGestureRecognizer:singleTap];
    _backbackgroundView.hidden = YES;
    //创建DatePicker
//    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:-3*60*60];
    NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:0];
    //    datePicker.date = currentDate;
    [_datePicker setDate:currentDate animated:YES];
    //设置显示的时间区域
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:30*24*60*60];
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
    _time = [formatter stringFromDate:date];
//    _lbTime.text = time;
}
//取消按钮
-(void)cancelButtonAction{
    _backbackgroundView.hidden = YES;
}
//确定按钮
-(void)certainButtonAction{
    [_InviteCompleView reloadData];
    _backbackgroundView.hidden = YES;
}
//加触摸手势
- (void)tapAction:(UITapGestureRecognizer *)tap {
    
    _backbackgroundView.hidden = YES;
}

#pragma mark-导航栏
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
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 30)];
    [rightButton addTarget:self action:@selector(refreshThisView) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"发布" forState:UIControlStateNormal];
//    [rightButton setBackgroundImage:[UIImage imageNamed:@"创建邀约-重置.png"] forState:UIControlStateNormal];
    //leftButton.backgroundColor = [UIColor redColor];
    UIBarButtonItem * rightbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
}
//返回酒吧聊天室界面
-(void)popView{
    
    [self.navigationController popViewControllerAnimated:YES];
}
//发布邀约
#pragma mark  这里一定要记住的要给一个加载框  给图片一个上传的时间   有时间去封装一个好看的能用的
-(void)refreshThisView{
    if (isSendPicture==1) {
        [self loadQINiuPicture];
    }else{
        [self requestRedPacketBag];
    }
    
}
#pragma mark-创建网格视图
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
    _collectionViewLeft = [[UICollectionView alloc] initWithFrame:CGRectMake(18,80*KScreenHeight/568, KScreenWidth, 70*KScreenWidth/320) collectionViewLayout:flowLayOut];
    _collectionViewLeft.backgroundColor = [UIColor whiteColor];
    //设置代理
    _collectionViewLeft.delegate = self;
    _collectionViewLeft.dataSource = self;
#pragma mark - 需要添加在_headView上
    //[self.view bringSubviewToFront:_collectionView];
    [_headView addSubview:_collectionViewLeft];
    //关闭滑动状态
//    _collectionViewLeft.scrollEnabled=NO;
    //注册单元格
    [_collectionViewLeft registerClass:[ImageViewCell class] forCellWithReuseIdentifier:idenLeft];
}

#pragma mark - UICollectionViewDataSource添加照片的代理方法
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return _mArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ImageViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:idenLeft forIndexPath:indexPath];
    if (indexPath.row == _mArray.count-1) {
        //因为这里是要加入加号 ，所以说要给一个判断赋值上这个加号的名字然后把加号加上面
        cell.image =  [UIImage imageNamed:@"1-3-2.png"] ;
    }else{
        cell.image = _mArray[indexPath.row];
    }
    return cell;
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(0, 17, 0, 20);
    return edge;
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [_describeView resignFirstResponder];
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
}
#pragma mark- 图片处理
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
        }
    }
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo {
    isSendPicture=1;
    //给图片转化成data  为了上传七牛
    NSData* imageData = [image resizedAndReturnData];
    [qiniuArray addObject:imageData];
    //给图片赋一个名字
    [_mArray insertObject:image atIndex:_mArray.count-1];
    [_collectionViewLeft reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadQINiuPicture{
    for (int i = 0; i < qiniuArray.count; i ++) {
        NSData*liuDate=[qiniuArray objectAtIndex:i];
      NSString*  fileName = [NSString stringWithFormat:@"%@%@.jpg",[[Tostal sharTostal]getDateTimeString],  [[Tostal sharTostal]randomStringWithLength:8]];
        
        NSString*sendToXiangXiang=[NSString stringWithFormat:@"%@__%@",qiNiuZoneName,fileName];
        [fileNameArray addObject:sendToXiangXiang];
        NSLog(@"%@",fileName);
        [[QiNiuClassSend sharQiNiuClassSend]putData:liuDate key:fileName token:qiNiuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
            NSLog(@" --->> Info: %@  ", info);
            NSLog(@"%i",info.statusCode);
            if (info.statusCode==200) {
                if (i==qiniuArray.count-1) {
                    [self requestRedPacketBag];
                }
            }
            NSLog(@"-------------------");
            NSLog(@" --->> Response: %@,  ", resp);
        }
                                             option:nil];
        
    }
    
    [self requestRedPacketBag];
}

#pragma mark-编辑文字
- (void)textViewDidChange:(UITextView *)textView{
    if (textView.text.length == 0) {
        _pleaceHoderLabel.hidden = NO;
    }else{
        _pleaceHoderLabel.hidden = YES;
    }
}
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    _InviteCompleView.contentOffset = CGPointMake(0, 0);
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapActionLeft:)];
    [_InviteCompleView addGestureRecognizer:singleTap];
    return YES;
}

//点击事件
- (void)tapActionLeft:(UITapGestureRecognizer *)tap{
    [_describeView resignFirstResponder];
    [_InviteCompleView removeGestureRecognizer:tap];
}

#pragma mark-网络请求数据(点击创建时再调用)
//有红包邀约的网络请求方法
-(void)requestRedPacketBag{
    Request12000*request12000=[[Request12000 alloc]init];
    //设置请求参数
    request12000.common.userid=LoginUserInfo.user_id;
    request12000.common.userkey=LoginUserInfo.user_key;
    request12000.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request12000.common.version=@"1.0.0";//版本号
    request12000.common.platform=2;//ios  andriod
    request12000.params.hasMoney=weclubHasMoney;//是否红包邀约1无红包邀约 2红包邀约
    request12000.params.money=yuan;//红包金额
    //因为入的参数是时间戳 要转化
    NSDateFormatter* dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *dateMiss =[dateFormat dateFromString:_time];
    request12000.params.dateTime=_time;//约会开始时间
    NSLog(@"%.0f",[dateMiss timeIntervalSince1970]);
    request12000.params.clubId=_clubId;//酒吧id
    request12000.params.inviteDescription=_describeView.text;//派对内容
    request12000.params.invitePicArray=fileNameArray;//派对描述的图片的数组
    request12000.params.latitude=LoginUserInfo.latitude;//创建人所在的纬度
    request12000.params.longitude=LoginUserInfo.longitude;//创建人所在的经度
    request12000.params.clubName=_barName;//酒吧名
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
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:requestRed]) {
        Response12000*response=[Response12000 parseFromData:request.responseData error:nil];
        if (response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response.common.message tostalTime:1];
        }else{
            [self.navigationController popViewControllerAnimated:YES];
            NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
            [[Tostal sharTostal]tostalMesg:@"创建成功" tostalTime:1];
            [[NSNotificationCenter defaultCenter]postNotificationName:@"refreshInvite" object:nil];
        }
    }
  if ([request isEqual:requestQiNiuToken]) {
        Response11015*response11015=[Response11015 parseFromData:request.responseData error:nil];
        if (response11015.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response11015.common.message tostalTime:1];
        }else{
            qiNiuToken=response11015.data_p.qiniuToken.token;
            qiNiuZoneName=response11015.data_p.qiniuToken.zoneName;
         
        }
    }
}


//asi  人为的bug  必须要在这个页面完了之后清楚这个代理。。。。。
-(void)viewWillDisappear:(BOOL)animated{

    [requestRed clearDelegatesAndCancel];
    [requestNoRed clearDelegatesAndCancel];
    [requestQiNiuToken clearDelegatesAndCancel];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
