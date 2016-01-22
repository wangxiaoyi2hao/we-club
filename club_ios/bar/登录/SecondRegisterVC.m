//
//  SecondRegisterVC.m
//  bar
//
//  Created by chen on 15/11/16.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "SecondRegisterVC.h"
#import "ThirdRegisterVC.h"
#import "UIImage+ResizeMagick.h"
#import "QiNiuClassSend.h"
#import "BarTabBarController.h"
#import "APService.h"
#import "AppDelegate.h"
extern UserInfo*LoginUserInfo;
@interface SecondRegisterVC ()<UIPickerViewDataSource,UIPickerViewDelegate>{
    
    NSInteger index;
    UIView *_backbackgroundView;
    UIDatePicker *_datePicker;
    
    UIPickerView *_pickerView;
    NSArray *_cityArray;
    UILabel *_label;
    UIPickerView *_sexPickerView;
    NSArray *_sexArray;
    UILabel *_sexLabel;
    NSString*cityText;
    NSString*province;
    NSMutableArray*mutaArray;//城市数组
    //图片
    NSData*imageData;
    //七牛token  请求实时获取
    ASIFormDataRequest*requestQiNiuToken;
    NSString*qiNiuToken;
    NSString*qiNiuZoneName;
    
    // 补全信息的就扣
    
    ASIFormDataRequest*_reuqestUserIncrease;
    
    ASIFormDataRequest*_request;
    
    NSString*putToXiangXiangName;
    
    ASIFormDataRequest*_requestHead;
    
}

@end

@implementation SecondRegisterVC

- (void)viewDidLoad {
    [super viewDidLoad];
        [self buttonColor];
    lbVclubNamber.text=[NSString stringWithFormat:@"ID:%@",_fromVclubNumber];
    //这里是下载的从那个第三方得到的图片上传到七牛
    [_imageHead sd_setImageWithURL:[NSURL URLWithString:_fromUserIcon] placeholderImage:[UIImage imageNamed:@"headImg.png"] options:SDWebImageCacheMemoryOnly progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        imageData=[image resizedAndReturnData];
        [self putSendTo];
    }];
    tfUserName.text=_fromUserName;
    //设置状态栏
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault animated:YES];
    _backbackgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, -44, KScreenWidth, KScreenHeight+64)];
    _backbackgroundView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"灰色背景.png"]];
    [self.view addSubview:_backbackgroundView];
    //设置取消和确定按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelButton.frame = CGRectMake(0, KScreenHeight-270+64, KScreenWidth/2.0, 40);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    cancelButton.titleEdgeInsets=UIEdgeInsetsMake(0, KScreenWidth/30, 0, KScreenWidth/3);
    cancelButton.backgroundColor = [UIColor whiteColor];
    [cancelButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backbackgroundView addSubview:cancelButton];
    UIButton *certainButton = [UIButton buttonWithType:UIButtonTypeCustom];
    certainButton.frame = CGRectMake(KScreenWidth/2.0, KScreenHeight-270+64, KScreenWidth/2.0, 40);
    certainButton.titleLabel.textAlignment=NSTextAlignmentRight;
    certainButton.titleEdgeInsets=UIEdgeInsetsMake(0, KScreenWidth/3, 0, KScreenWidth/30);
    [certainButton setTitle:@"确定" forState:UIControlStateNormal];
    [certainButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    certainButton.backgroundColor = [UIColor whiteColor];
    [certainButton addTarget:self action:@selector(certainButtonAction) forControlEvents:UIControlEventTouchUpInside];
    [_backbackgroundView addSubview:certainButton];
    //单击
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.view addGestureRecognizer:singleTap];
    _backbackgroundView.hidden = YES;
#pragma mark - 生日
    //创建DatePicker
    _datePicker = [[UIDatePicker alloc] initWithFrame:CGRectMake(0, KScreenHeight-230+64,KScreenWidth, 230)];
    //设置当前显示的时间
    //NSDate *currentDate = [NSDate dateWithTimeIntervalSinceNow:-3*60*60];
    NSDate *currentDate = [NSDate date];
    [_datePicker setDate:currentDate animated:YES];
    //设置显示的时间区域
    _datePicker.maximumDate = [NSDate dateWithTimeIntervalSinceNow:2*24*60*60];
    //设置样式
    _datePicker.datePickerMode = UIDatePickerModeDate;
    //添加滑动事件
    [_datePicker addTarget:self action:@selector(dateAction:) forControlEvents:UIControlEventValueChanged];
    _datePicker.backgroundColor = [UIColor whiteColor];
    [_backbackgroundView addSubview:_datePicker];
    _datePicker.hidden = YES;
#pragma mark - 家乡
    _pickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight-230+64,KScreenWidth, 230)];
    _pickerView.backgroundColor = [UIColor whiteColor];
    //设置代理
    _pickerView.dataSource = self;
    _pickerView.delegate = self;
    [_backbackgroundView addSubview:_pickerView];
    NSString *cityPath = [[NSBundle mainBundle] pathForResource:@"city.plist" ofType:nil];
    _cityArray = [[NSArray alloc] initWithContentsOfFile:cityPath];
    _pickerView.hidden = YES;
#pragma mark - 性别
    _sexPickerView = [[UIPickerView alloc] initWithFrame:CGRectMake(0, KScreenHeight-230+64,KScreenWidth, 230)];
    _sexPickerView.backgroundColor = [UIColor whiteColor];
    //设置代理
    _sexPickerView.dataSource = self;
    _sexPickerView.delegate = self;
    [_backbackgroundView addSubview:_sexPickerView];
    _sexArray = @[@"男",@"女"];
    _sexPickerView.hidden = YES;
#pragma mark  到时候要适配
    _imageHead.layer.cornerRadius=50;
    _imageHead.layer.masksToBounds=YES;
    _imageWai.layer.cornerRadius=50;
    _imageWai.layer.masksToBounds=YES;
    if (_fromUserIcon!=nil) {
        
    }
   
    
//       [obServerText addObserver:self forKeyPath:@"text" /*text为scendCtrl的属性*/options:NSKeyValueObservingOptionNew context:nil];
}
-(void)buttonColor{

    if (![tfUserName.text isEqualToString:@""]  &&  ![tfSex.text isEqualToString:@""]&&  ![tfHomeTown.text isEqualToString:@""]  &&  ![tfBrithday.text isEqualToString:@"" ]) {
    
        [_correctButton setBackgroundImage:[UIImage imageNamed:@"button_login_a.png"] forState:UIControlStateNormal];
    }else{
        [_correctButton setBackgroundImage:[UIImage imageNamed:@"tab_rectangle_gray.png"] forState:UIControlStateNormal];

    }

}
- (void)tapAction:(UITapGestureRecognizer *)tap {
    _backbackgroundView.hidden = YES;
    [self buttonColor];
}
-(void)viewWillAppear:(BOOL)animated{

    [self requstQiNiuToken];
    

}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self buttonColor];
    return YES;
}
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    [self buttonColor];
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    [self buttonColor];
    return YES;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 生日
- (IBAction)birthButtonAction:(UIButton *)sender {
    _sexPickerView.hidden = YES;
    _pickerView.hidden = YES;
    _datePicker.hidden = NO;
    _backbackgroundView.hidden = NO;
    [tfBrithday resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfSex resignFirstResponder];
    [tfHomeTown resignFirstResponder];
    [self buttonColor];
        [self buttonColor];
}

-(IBAction)popViewController:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//添加滑动事件
- (void)dateAction:(UIDatePicker *)datePicker {
    //取得时间
    NSDate *date = datePicker.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *time = [formatter stringFromDate:date];
    tfBrithday.text=time;
        [self buttonColor];
}
#pragma mark - 家乡
- (IBAction)hometownButtonAction:(UIButton *)sender {
  
    _sexPickerView.hidden = YES;
    _datePicker.hidden = YES;
    _pickerView.hidden = NO;
    _backbackgroundView.hidden = NO;
    [tfBrithday resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfSex resignFirstResponder];
    [tfHomeTown resignFirstResponder];
        [self buttonColor];
}
#pragma mark - UIPickerViewDataSource,UIPickerViewDelegate
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    if (_sexPickerView == pickerView) {
        return 1;
    }else{
        
        return 2;
    }
}
//会多次调用
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    if (_sexPickerView == pickerView) {
        return _sexArray.count;
    }else{
        
        if (component == 0) {
            
            return _cityArray.count;
            
        }else{
            
            NSArray *array = _cityArray[index][@"cities"];
            
            return array.count;
        }
    }
}
//设置行高
-(CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    if (_sexPickerView == pickerView) {
        return 30;
    }else{
        if (component == 0) {
            return 30;
        }else{
            return 30;
        }
    }
}
//设置每一行显示的视图
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (_sexPickerView == pickerView) {
        if (view == nil) {
            _sexLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth, 30)];
            _sexLabel.textAlignment = NSTextAlignmentCenter;
            view = [[UIView alloc] initWithFrame:CGRectZero];
        }
        _sexLabel.text = _sexArray[row];
        [view addSubview:_sexLabel];
        return view;
    }else{
        if (view ==nil) {
            _label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, KScreenWidth/2.0, 30)];
            _label.textAlignment = NSTextAlignmentCenter;
            view = [[UIView alloc] initWithFrame:CGRectZero];
        }
        if (component == 0) {
            
            _label.text = _cityArray[row][@"state"];
            _label.textColor = [UIColor blackColor];
            
        }else{
            _label.text = _cityArray[index][@"cities"][row];
        }
        
        [view addSubview:_label];
        
        return view;
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    [tfBrithday resignFirstResponder];
    [tfHomeTown resignFirstResponder];
    [tfSex resignFirstResponder];
    [tfUserName resignFirstResponder];
    
    [self buttonColor];
    return YES;
}
//点击出现相册的方法
-(IBAction)selectPicture:(UIButton*)sender{
    UIActionSheet*sheet=[[UIActionSheet alloc]initWithTitle:@"选取头像" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"从相册选取",@"拍照", nil];

    [sheet showInView:self.view];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
  
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
//相册相机的代理方法
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
         imageData = [image resizedAndReturnData];
         [_imageHead setImage:image];
        [self dismissViewControllerAnimated:YES completion:nil];
    _imageCamera.hidden=YES;
    _imageWai.hidden=YES;
    
}

-(void)requst10020way{
    Request10022*request10022=[[Request10022 alloc]init];
    //设置请求参数
    request10022.common.userid=LoginUserInfo.user_id;
    request10022.common.userkey=LoginUserInfo.user_key;
    request10022.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request10022.common.version=@"1.0.0";//版本号
    request10022.common.platform=2;//ios  andriod
    request10022.common.cmdid=10022;
    request10022.params.userName=tfUserName.text;
    NSLog(@"%@",tfUserName.text);
    NSLog(@"%@",tfBrithday.text);
    NSLog(@"%@",tfHomeTown.text);
    NSLog(@"%@",tfSex.text);
    
    if ([tfSex.text isEqualToString:@"男"]) {
        request10022.params.sex=1;
    }else{
      request10022.params.sex=2;
    
    }
    request10022.params.birthday=tfBrithday.text;
    request10022.params.city=tfHomeTown.text;
    if (putToXiangXiangName!=nil) {
        request10022.params.avatarKey=putToXiangXiangName;
    }
    NSData*data= [request10022 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/completeBasicInfo",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestUserIncrease = [ASIFormDataRequest requestWithURL:url];
    [_reuqestUserIncrease setPostBody:(NSMutableData*)data];
    [_reuqestUserIncrease setDelegate:self];
    //请求延迟时间
    _reuqestUserIncrease.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestUserIncrease.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestUserIncrease.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestUserIncrease.secondsToCache=3600;
    [_reuqestUserIncrease startAsynchronous];
}

//登录按钮  点击登陆按钮
-(void)requestUrl{
    Request10002*request=[[Request10002 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/login",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    //request.common.userid=@"1";//登录不用传userid
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.cmdid=10002;
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.params.md5Psw=[HelperUtil md532BitUpper:_fromPwd];//密码
    NSLog(@"%@",_fromPwd);
    NSLog(@"%@",_fromPhoneNUm);
    request.params.account=_fromPhoneNUm;//账号
    // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
    request.params.type=_fromType;
    request.params.otherId=_fromOtherId;
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=20;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
}


//这里获得融云的token
-(void)requstQiNiuToken{
    Request11015*request11015=[[Request11015 alloc]init];
    //设置请求参数
    request11015.common.userid=LoginUserInfo.user_id;
    request11015.common.userkey=LoginUserInfo.user_key;
    request11015.common.timestamp=[[NSDate date]timeIntervalSince1970];//现在标注为真数据
    request11015.common.version=@"1.0.0";//版本号
    request11015.common.platform=2;//ios  andriod
    request11015.common.cmdid=11015;
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
- (void)requestFinished:(ASIHTTPRequest *)request{
    //实验图片是否能请求下来
    if ([request isEqual:_requestHead]) {
        NSLog(@"%@",request.responseData);
    }
    
    
    
    
    
    if ([request isEqual:requestQiNiuToken]) {
        Response11015*response11015=[Response11015 parseFromData:request.responseData error:nil];
        if (response11015.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response11015.common.message tostalTime:1];
        }else{
            qiNiuToken=response11015.data_p.qiniuToken.token;
            qiNiuZoneName=response11015.data_p.qiniuToken.zoneName;
            NSLog(@"%@",response11015.data_p.qiniuToken.zoneName);
            NSLog(@"%@",response11015.data_p.qiniuToken.token);
        }
    }
    if ([request isEqual:_request]) {
        
      Response10002* response10002 = [Response10002 parseFromData:request.responseData error:nil];
        UserInfo*user=[[UserInfo alloc]init];
        user.user_id=response10002.data_p.userid;
        NSLog(@"%@",user.user_id);
        user.user_name=response10002.data_p.name;
        user.user_key=response10002.data_p.key;
        NSLog(@"%@",response10002.data_p.key);
        user.user_sex=response10002.data_p.sex;
        user.sessionkey=response10002.data_p.sessionkey;
        user.rongYunTOken=response10002.data_p.rongyunToken;
        // 1：手机号登录 2：QQ登录 3：微博登录 4：微信登录
        user.loginType=response10002.data_p.type;
        user.phoneNum=_fromPhoneNUm;
        user.user_pwd=_fromPwd;
        user.user_head=response10002.data_p.avatarurl;
        user.otherId=_fromOtherId;
        LoginUserInfo=user;
        [NSKeyedArchiver archiveRootObject:user toFile:[MyFile fileByDocumentPath:@"/isUserAll.archiver"]];
        BarTabBarController *rooCtrl = [[BarTabBarController alloc] init];
        rooCtrl.view.layer.transform = CATransform3DMakeScale(.5, .5, 0);
        self.view.window.rootViewController = rooCtrl;
        [UIView animateWithDuration:.5 animations:^{
            rooCtrl.view.layer.transform = CATransform3DIdentity;
        }];
        NSString*str=[LoginUserInfo.user_id stringByReplacingOccurrencesOfString:@"-" withString:@""];
        [APService setTags:nil alias:str callbackSelector:@selector(tagsAliasCallback:tags:alias:) target:self];
#pragma mark-手动登录后获取好友列表
        [[AppDelegate shareAppDelegate] requestFriendList];

    }
    if ([request isEqual:_reuqestUserIncrease]) {
        Response10022*response10022=[Response10022 parseFromData:request.responseData error:nil];
        if (response10022.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:response10022.common.message tostalTime:1];
        }else{

            [self requestUrl];
          
        }
    }
}
- (void)requestFailed:(ASIHTTPRequest *)request{
    
    [[Tostal sharTostal]hiddenView];
    [[Tostal sharTostal]tostalMesg:@"网络错误" tostalTime:1];
    
}
-(void)tagsAliasCallback:(int)iResCode
                    tags:(NSSet*)tags
                   alias:(NSString*)alias
{
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
-(void)putSendTo{
   NSString* fileName = [NSString stringWithFormat:@"%@%@.jpg",[[Tostal sharTostal]getDateTimeString], [[Tostal sharTostal]randomStringWithLength:8]];
    putToXiangXiangName=[NSString stringWithFormat:@"%@__%@",qiNiuZoneName,fileName];
    [[QiNiuClassSend sharQiNiuClassSend]putData:imageData key:fileName token:qiNiuToken complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
        
        NSLog(@" --->> Info: %@  ", info);
        NSLog(@"%i",info.statusCode);
        if (info.statusCode==200) {
//            [[Tostal sharTostal]tostalMesg:@"图片上传成功" tostalTime:1];
            //这里肯定要调用借口
        }
        NSLog(@"-------------------");
        NSLog(@" --->> Response: %@,  ", resp);
    }
                                         option:nil];

}
//选中某一行调用的代理方法
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_sexPickerView == pickerView) {
        NSLog(@"选择了性别");
        tfSex.text=_sexArray[row];
    }else{
        if (component == 0) {
            index = row;
            province=_cityArray[row][@"state"];
            mutaArray=_cityArray[row][@"cities"];
            [pickerView reloadComponent:1];
            cityText=@"请选择城市";
        }else{
            cityText=mutaArray[row];
        }
        if (cityText == nil) {
            cityText=@"请选择城市";
            
        }
        
        if ([province isEqualToString:@"未选择"]) {
            tfHomeTown.textColor = [UIColor lightGrayColor];
            tfHomeTown.text = @"请选择家乡";
        }else{
            tfHomeTown.text=[NSString stringWithFormat:@"%@   %@",province,cityText];
            tfHomeTown.textColor = [UIColor blackColor];
        }
        
    }
}

#pragma mark - 性别
- (IBAction)sexButtonAction:(UIButton *)sender {
    tfSex.text=@"男";
    _datePicker.hidden = YES;
    _pickerView.hidden = YES;
    _sexPickerView.hidden = NO;
    _backbackgroundView.hidden = NO;
    [tfBrithday resignFirstResponder];
    [tfUserName resignFirstResponder];
    [tfSex resignFirstResponder];
    [tfHomeTown resignFirstResponder];
        [self buttonColor];
}
//取消按钮
-(void)cancelButtonAction{
    _backbackgroundView.hidden = YES;
}
//确定按钮
-(void)certainButtonAction{
    
    [self buttonColor];
    _backbackgroundView.hidden = YES;
}
- (IBAction)nextButtonAction:(UIButton *)sender {
    if ([tfBrithday.text isEqualToString:@""]) {
        [[Tostal sharTostal]tostalMesg:@"请填写生日" tostalTime:1];
    }else if ([tfSex.text isEqualToString:@""]){
    
        [[Tostal sharTostal]tostalMesg:@"性别不能为空" tostalTime:1];
    }else if ([tfHomeTown.text isEqualToString:@""]){
    
        [[Tostal sharTostal]tostalMesg:@"家乡不能为空" tostalTime:1];
    }else{
        [self putSendTo];
        [self requst10020way];
   
    }
}
@end
