//
//  infoEditController.m
//  bar
//
//  Created by 牟志威 on 15/10/3.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//编辑资料  相册拍照等
#import "infoEditController.h"
#import "InfoEditCollectionViewCell.h"
#import "QNUploadManager.h"
#import "QiNiuClassSend.h"
#import "UIImage+ResizeMagick.h"
#import "UIView+Blur.h"
#import "MBProgressHUD.h"


static NSString *iden = @"InfoEditCollectionViewCell";
extern UserInfo*LoginUserInfo;
@interface infoEditController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestInfo;
    NSString*constellationState;
    //collectionView
    NSMutableArray *_mArray;
    NSInteger _index;
    UICollectionView *_collectionView;
    UIImage*_imageCell;
    NSData*imagdata;
    NSMutableArray*nameArray;
    Request10016*request10016;
    NSString* fileName;
    
    NSMutableArray*qiNiuArray;
    NSString*qiniuToken;
    
    ASIFormDataRequest*requestQiNiuToken;
    
    
#pragma  mark  这里是判断是否从相册中调取了图片
    int isPictureRightOrWrong;
    
   //可变的数据缓冲区
    NSMutableData*mutData;
    NSString*qiNiuZoneName;
    

}
@end

@implementation infoEditController

- (void)viewDidLoad {
    [super viewDidLoad];
    //设置边框
    _headIconView.layer.cornerRadius = 42;//边框圆角
    _headIconView.layer.borderWidth = 5;//边框线宽度
    _headIconView.layer.borderColor = [HelperUtil colorWithHexString:@"e43f6d"].CGColor;
    _headIconView.layer.masksToBounds = YES;
    self.tableView.tableHeaderView = _headView;
    //设置是否反弹
    self.tableView.bounces=NO;
    //返回按钮
    [self loadNav];
    [self addPhoto];
    [self addValue];
     nameArray=[NSMutableArray array];
    [nameArray addObjectsFromArray:_urlMArray];
    qiNiuArray=[NSMutableArray array];
    // 设置毛玻璃效果
    _headBackImgView.frame = CGRectMake(0, 0, KScreenWidth, _headView.frame.size.height);
   
    mutData=[NSMutableData data];
}
-(void)requstQiNiuToken{
    Request11015*request11015=[[Request11015 alloc]init];
    //设置请求参数
    request11015.common.userid=LoginUserInfo.user_id;
    request11015.common.userkey=LoginUserInfo.user_key;
    request11015.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request11015.common.version=@"1.0.0";//版本号
    request11015.common.platform=2;//ios  andriod
    request11015.params.tokenType=1;
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
-(void)viewWillAppear:(BOOL)animated{
     //实时获取token
    [self requstQiNiuToken];
}
-(void)loadNav{
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popView1) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 20)];
    [rightButton addTarget:self action:@selector(comebackLasterView) forControlEvents:UIControlEventTouchUpInside];
    [rightButton setTitle:@"完成" forState:UIControlStateNormal];
        //leftButton.backgroundColor = [UIColor redColor];
    rightButton.titleLabel.textColor=[UIColor whiteColor];
    UIBarButtonItem * rightbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    self.navigationItem.rightBarButtonItem = rightbarbuttonitem;
}


-(void)comebackLasterView{
    if (isPictureRightOrWrong==1) {
        [self loadQINiuPicture];
    }else{
        [self requestEditInfo];
    }
}
#pragma mark 编辑个人资料
-(void)requestEditInfo{

    request10016=[[Request10016 alloc]init];
    //设置请求参数
    request10016.common.userid=LoginUserInfo.user_id;
    request10016.common.userkey=LoginUserInfo.user_key;
    request10016.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request10016.common.version=@"1.0.0";//版本号
    request10016.common.platform=2;//ios  andriod
    request10016.params.detailUser.userid=LoginUserInfo.user_id;
    request10016.params.detailUser.username=_lbName.text;
    //情感状态
    if ( [_lbLove.text isEqualToString:@"单身"] ) {
         request10016.params.detailUser.emotionState=1;
    }else if ([_lbLove.text isEqualToString:@"热恋"]){
         request10016.params.detailUser.emotionState=2;
    }else if ([_lbLove.text isEqualToString:@"已婚"]){
         request10016.params.detailUser.emotionState=3;
    }else{
         request10016.params.detailUser.emotionState=4;
    }
    request10016.params.detailUser.userAvatarArray=nameArray;
    NSLog(@"%@",nameArray);
    //星座
    if ([_lbConstellation.text isEqualToString:@"白羊座"]) {
        request10016.params.detailUser.constellation=1;
    }else if ([_lbConstellation.text isEqualToString:@"金牛座"]){
        request10016.params.detailUser.constellation=2;
    }else if ([_lbConstellation.text isEqualToString:@"双子座"]){
        request10016.params.detailUser.constellation=3;
    }else if ([_lbConstellation.text isEqualToString:@"巨蟹座"]){
       request10016.params.detailUser.constellation=4;
    }else if ([_lbConstellation.text isEqualToString:@"狮子座"]){
        request10016.params.detailUser.constellation=5;
    }else if ([_lbConstellation.text isEqualToString:@"处女座"]){
        request10016.params.detailUser.constellation=6;
    }else if ([_lbConstellation.text isEqualToString:@"天枰座"]){
        request10016.params.detailUser.constellation=7;
    }else if ([_lbConstellation.text isEqualToString:@"天蝎座"]){
        request10016.params.detailUser.constellation=8;
    }else if ([_lbConstellation.text isEqualToString:@"人马座"]){
        request10016.params.detailUser.constellation=9;
    }else if ([_lbConstellation.text isEqualToString:@"摩羯座"]){
        request10016.params.detailUser.constellation=10;
    }else if ([_lbConstellation.text isEqualToString:@"水平座"]){
        request10016.params.detailUser.constellation=11;
    }else if ([_lbConstellation.text isEqualToString:@"双鱼座"]){
        request10016.params.detailUser.constellation=12;
    }
    //赋值
    request10016.params.detailUser.job=_lbJob.text;
    request10016.params.detailUser.hometown=_lbHomeTown.text;
    request10016.params.detailUser.signature=_lbHeart.text;
    request10016.params.detailUser.movie=_lbMovie.text;
    request10016.params.detailUser.music=_lbMusic.text;
    request10016.params.detailUser.workLocation=_lbWorkLocation.text;
    request10016.params.detailUser.activeLocation=_lbMoreLocation.text;
    //获取的用户的信息显示在要显示的地方
    NSData*data = [request10016 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/updateUserDetail",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestInfo = [ASIFormDataRequest requestWithURL:url];
    [_requestInfo setPostBody:(NSMutableData*)data];
    [_requestInfo setDelegate:self];
    //请求延迟时间
    _requestInfo.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestInfo.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestInfo.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestInfo.secondsToCache=3600;
    [_requestInfo startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestInfo]) {
        Response10016*response10016=[Response10016 parseFromData:request.responseData error:nil];
        if (response10016.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response10016.common.message tostalTime:1];
        }else{
            [[NSNotificationCenter defaultCenter]postNotificationName:@"tablereload" object:nil];
            [self.navigationController popViewControllerAnimated:YES];
        }
       
    }
    if ([request isEqual:requestQiNiuToken]) {
         Response11015*response11015=[Response11015 parseFromData:request.responseData error:nil];
        if (response11015.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response11015.common.message tostalTime:1];
        }else{
            qiniuToken=response11015.data_p.qiniuToken.token;
            qiNiuZoneName=response11015.data_p.qiniuToken.zoneName;
            NSLog(@"%@",response11015.data_p.qiniuToken.zoneName);
            NSLog(@"%@",response11015.data_p.qiniuToken.token);
        }
    }
    [[Tostal sharTostal]hiddenView];
}

- (void)requestFailed:(ASIHTTPRequest *)request{
 [[Tostal sharTostal]hiddenView];
 [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];

}
-(void)popView1{
    UIAlertView*alter=[[UIAlertView alloc]initWithTitle:@"确认放弃编辑" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    alter.tag=912;
    [alter show];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//设置组头视图高度
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 30;
}
//返回按钮
- (IBAction)cancelBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    //设置第一响应者
    [textField resignFirstResponder];
    return YES;
}
//文本视图
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}
//选择弹窗
- (void)alertChoice:(NSString *) title {
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:title message:nil preferredStyle:UIAlertControllerStyleAlert];

    [alertController addAction:[UIAlertAction actionWithTitle:@"相册" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self selectFromAlbum];
    }]];
    
    [alertController addAction:[UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self takingPhoto];
    }]];

    [alertController addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action)  {
    }]];
    
    [self presentViewController:alertController animated:YES completion:NULL];
}
//从相册选择
- (void)selectFromAlbum{
    UIImagePickerController *imgPicker = [[UIImagePickerController alloc] init];
    imgPicker.delegate=self;
    imgPicker.allowsEditing=YES;
    imgPicker.sourceType=UIImagePickerControllerSourceTypePhotoLibrary;
    [self presentViewController:imgPicker animated:YES completion:nil];
}
//拍照
- (void)takingPhoto{
    UIImagePickerController *imagePicker=[[UIImagePickerController alloc] init];
    imagePicker.delegate=self;
    imagePicker.allowsEditing=YES;//设置是否可编辑。
    imagePicker.sourceType=UIImagePickerControllerSourceTypeCamera;//设置以哪种方式取照片，是从本地相册取，还是从相机拍照取。
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo  {
     isPictureRightOrWrong=1;
     #pragma mark   上传图片
     imagdata = [image resizedAndReturnData];

     [qiNiuArray addObject:imagdata];
    
     #pragma mark   添加图片
                [_mArray insertObject:image atIndex:_mArray.count-1];
                [_collectionView reloadData];
                if (_mArray.count > 3) {
                    if (KScreenWidth == 320) {
                    _collectionView.frame = CGRectMake(0, 140, KScreenWidth, 190);
                    _headView.frame = CGRectMake(0, -64, KScreenWidth,340);
                    self.tableView.tableHeaderView = _headView;
                    }else if(KScreenWidth >= 375)
                    _collectionView.frame = CGRectMake(0, 140, KScreenWidth, 210);
                    _headView.frame = CGRectMake(0, -64, KScreenWidth, 360);
                    self.tableView.tableHeaderView = _headView;
                }
  
    [self dismissViewControllerAnimated:YES completion:nil];
}
-(void)loadQINiuPicture{
    for (int i = 0; i < qiNiuArray.count; i ++) {
            NSData*liuDate=[qiNiuArray objectAtIndex:i];
            fileName = [NSString stringWithFormat:@"%@%@.jpg",[[Tostal sharTostal]getDateTimeString], [[Tostal sharTostal]randomStringWithLength:8]];
            NSLog(@"%@",fileName);
            UserAvatar *userA = [[UserAvatar alloc] init];
            userA.fileName = [NSString stringWithFormat:@"%@__%@",qiNiuZoneName,fileName];
            userA.option=1;
            [nameArray addObject:userA];
            [[QiNiuClassSend sharQiNiuClassSend]putData:liuDate key:fileName token:qiniuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                
//                NSLog(@"%@",LoginUserInfo.qiniuUserToken);
                NSLog(@" --->> Info: %@  ", info);
                NSLog(@"%i",info.statusCode);
                if (info.statusCode==200) {
                    if (i==qiNiuArray.count-1) {
                        [self requestEditInfo];
                    }
                }
            
                NSLog(@"-------------------");
                NSLog(@" --->> Response: %@,  ", resp);
            }
                                                 option:nil];
        }

  
}
//设置Alert标题和内容
- (void)AlertTitle : (NSString *) title AlertMessage : (NSString *) msg {
    UIAlertController *alertVc = [UIAlertController alertControllerWithTitle:title message:msg preferredStyle:UIAlertControllerStyleAlert];
    [alertVc addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVc animated:YES completion:nil];
}

#pragma mark ----
/*
 * source is a piece of picture from camera or photo library
 * update data in core
 */
//处理图片
- (void)processImage : (UIImage *)image {
    if (_propose == changeBackGround) {
        NSLog(@"背景已经更换");
        
    } else {
        NSLog(@"图片已经添加");
    }
}

//选择感情状态
-(IBAction)loveState:(id)sender{
    UIAlertView*altrerView=[[UIAlertView alloc]initWithTitle:@"请选择感情状态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"单身",@"热恋",@"已婚",@"离异", nil];
    altrerView.tag=0;
    [altrerView show];
}
//选择星座
-(IBAction)constellation:(id)sender{
    UIAlertView*altrerView=[[UIAlertView alloc]initWithTitle:@"请选择感情状态" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"",@"",@"",@"", nil];
       altrerView.tag=1;
    [altrerView show];
}
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag==0) {
        if (buttonIndex==1) {
         _lbLove.text=@"单身";
        }else if (buttonIndex==2){
          _lbLove.text=@"热恋";
        }else if (buttonIndex==3){
          _lbLove.text=@"已婚";
        }else if (buttonIndex==4){
          _lbLove.text=@"离异";
        }
    }
    if (alertView.tag==912) {
        if (buttonIndex==1) {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
}
#pragma mark ----
/*
 * 1.code the deledate to reload data
 * 2.update the data in the core
 *
 */
//返回
- (IBAction)saveBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
//更换背景
- (IBAction)changeBg:(UIButton *)sender {
    [self alertChoice:@"更换背景"];
    _propose =  changeBackGround;
}
//添加图片
- (IBAction)addBtnClick:(UIButton *)sender {
    [self alertChoice:@"添加图片"];
    _propose = AddPicture;
}
-(void)viewWillDisappear:(BOOL)animated{

    [_requestInfo clearDelegatesAndCancel];
}
-(void)addValue{
    _lbName.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.username];
    _lbHeart.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.signature];
    _lbJob.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.job];
    _lbHomeTown.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.hometown];
    _lbMovie.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.movie];
    _lbMusic.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.music];
    _lbWorkLocation.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.workLocation];
    _lbMoreLocation.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.activeLocation];
    _lbHobby.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.hobby];
    if (_fromResponse10014.data_p.detailUser.emotionState==1) {
        _lbLove.text=@"单身";
    }else if (_fromResponse10014.data_p.detailUser.emotionState==2){
        _lbLove.text=@"热恋";
    }else if (_fromResponse10014.data_p.detailUser.emotionState==3){
        _lbLove.text=@"已婚";
    }else if(_fromResponse10014.data_p.detailUser.emotionState==4) {
        _lbLove.text=@"离异";
    }else{
        _lbLove.text=@"未填写";
    }
    if (_fromResponse10014.data_p.detailUser.userAvatarArray!=nil) {
        UserAvatar*userHead=[_fromResponse10014.data_p.detailUser.userAvatarArray objectAtIndex:0];
         [_imageHead sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",userHead.uRL]] placeholderImage:[UIImage imageNamed:@"headImg.png"]];
    }else{
        [_imageHead setImage:[UIImage imageNamed:@"headImg.png"]];
    }
    NSLog(@"%@",_fromResponse10014.data_p.detailUser.userAvatarArray);
    _lbUserDES.text=[HelperUtil isDefault:_fromResponse10014.data_p.detailUser.selfIntro];
}

#pragma mark- UICollectionView网格视图
- (void)addPhoto{
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    if (KScreenWidth == 320) {
        flowLayOut.itemSize = CGSizeMake(80, 80);
    }else if(KScreenWidth >= 375){
        
        flowLayOut.itemSize = CGSizeMake(90, 90);
    }
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 10;
    flowLayOut.minimumInteritemSpacing = 10;
    //2.创建collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 140, KScreenWidth, 100) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = [UIColor clearColor];
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    //禁止滚动
    _collectionView.scrollEnabled = NO;
    [_headView addSubview:_collectionView];
    //注册单元格
    [_collectionView registerClass:[InfoEditCollectionViewCell class] forCellWithReuseIdentifier:iden];
    if (_urlMArray.count >=3) {
        if (KScreenWidth == 320) {
            _collectionView.frame = CGRectMake(0, 140, KScreenWidth, 190);
            _headView.frame = CGRectMake(0, -64, KScreenWidth,340);
            self.tableView.tableHeaderView = _headView;
        }else if(KScreenWidth >= 375)
            _collectionView.frame = CGRectMake(0, 140, KScreenWidth, 210);
        _headView.frame = CGRectMake(0, -64, KScreenWidth, 360);
        self.tableView.tableHeaderView = _headView;
    }
    _mArray = [[NSMutableArray alloc] init];
    for (int i =0; i<_urlMArray.count; i++) {
        UserAvatar *user = _urlMArray[i];
        [_mArray addObject:user.uRL];
    }
    for (int i =0; i<1; i++) {
        [_mArray addObject:[UIImage imageNamed:@"1-3-2.png"]];
    }
}
#pragma mark - UICollectionViewDataSource
//指定有多少组
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return _mArray.count;
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    InfoEditCollectionViewCell*cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    
    if (indexPath.row == _mArray.count-1) {
        cell.imgName =[UIImage imageNamed:@"1-3-2.png"];
    }else{
        if (indexPath.row <_urlMArray.count) {
          [cell.imgView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@",_mArray[indexPath.row]]] placeholderImage:[UIImage imageNamed:@"default"]];
        }else{
            
            cell.imgName = _mArray[indexPath.row];
        }
    }
    
    return cell;
    
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 20,10, 20);
    
    return edge;
}
//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==_mArray.count-1) {
        if (_mArray.count>8) {
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"您上传的太多啦" message:nil delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            [alertView show];
        }else{
            [self alertChoice:@"请选择照片"];
        }
        
    }else{
        UIActionSheet *actionSheet=[[UIActionSheet alloc]initWithTitle:@"删除图片?" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [actionSheet showInView:self.view];
        actionSheet.tag = 1003;
        _index = indexPath.row;
    }
}
#pragma mark - actionSheet照相和删除照片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1003) {
        //删除照片
        if (buttonIndex == 0) {
          if (_index < _urlMArray.count) {
                [_urlMArray removeObjectAtIndex:_index];
            }
            
            [self deleteAvatar:_index];

            [_mArray removeObjectAtIndex:_index];
            [_collectionView reloadData];
        }
    }
    
}

//删除图片方法－－。
-(void) deleteAvatar:(long)index{
    int found_count = 0;
    for(int i = 0; i < nameArray.count; i++){
        UserAvatar*userAvatar=[nameArray objectAtIndex:i];
        if(userAvatar.option != 2){
            if(found_count == index){
                //delete
                userAvatar.option = 2;
                return;
            }
            found_count ++;
        }
    }
    int sendIndex=(int)index-found_count;
    [qiNiuArray removeObjectAtIndex:sendIndex];
}



@end
