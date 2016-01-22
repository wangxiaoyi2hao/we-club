//
//  FeedbackViewController.m
//  bar
//
//  Created by chen on 15/11/3.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedbackCollectionViewCell.h"

extern UserInfo*LoginUserInfo;
static NSString *iden = @"FeedbackViewControllerCell";
@interface FeedbackViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestFeed;
    UICollectionView *_collectionView;
    NSMutableArray *_mArray;
    NSInteger _index;
}
@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //返回按钮
    [self loadNav];
    _mArray = [[NSMutableArray alloc] init];
    for (int i = 0; i<1; i++) {
        NSString *str = [NSString stringWithFormat:@"%d@2x.png",i+1];
        UIImage *imag = [UIImage imageNamed:str];
        [_mArray addObject:imag];
    }
    
    //1.创建布局对象
    UICollectionViewFlowLayout *flowLayOut = [[UICollectionViewFlowLayout alloc] init];
    //设置单元格的大小
    flowLayOut.itemSize = CGSizeMake(70, 70);
    //设置每一个item之间的最小空隙
    flowLayOut.minimumInteritemSpacing = 15;
    //设置每行之间的最小空隙
    flowLayOut.minimumLineSpacing = 15;
    //设置滑动的方向,默认是垂直滑动
    flowLayOut.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    //设置头视图的大小
    flowLayOut.headerReferenceSize = CGSizeMake(0, 290);
    
    //2.创建collectionView
    _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 110, 290*KScreenWidth/320, 90) collectionViewLayout:flowLayOut];
    _collectionView.backgroundColor = [UIColor whiteColor];
    
    //设置代理
    _collectionView.delegate = self;
    _collectionView.dataSource = self;
    [_headView addSubview:_collectionView];
    
    //注册单元格
    [_collectionView registerClass:[FeedbackCollectionViewCell class] forCellWithReuseIdentifier:iden];
    
      [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#efefef"]];
    //单击
//    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
//    [self.view addGestureRecognizer:singleTap];
    //成为第一响应者
    [_textView becomeFirstResponder];
    
    _submitButton.layer.cornerRadius = 10;//边框圆角
    //_submitButton.layer.borderWidth = 1;//边框线宽度
    //给色值
    
    [_submitButton setBackgroundColor:[HelperUtil colorWithHexString:@"e43f6d"]];
    _submitButton.layer.masksToBounds = YES;

    
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
    
    FeedbackCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:iden forIndexPath:indexPath];
    if (indexPath.row == _mArray.count-1) {
        cell.imgName =[UIImage imageNamed:@"1-3-2.png"];
    }else{
        cell.imgName = _mArray[indexPath.row];
    }
    return cell; 
}
//设置每一组视图的停靠位置
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // CGFloat top, left, bottom, right;
    UIEdgeInsets edge = UIEdgeInsetsMake(10, 10, 10, 10);    
    return edge;
}

//点击单元格调用的代理方法
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row ==_mArray.count-1) {
        if (_mArray.count>4) {
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
        //[self.navigationController popViewControllerAnimated:YES];
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
    NSLog(@"添加相册图片");
    [_mArray insertObject:image atIndex:_mArray.count-1];
    [_collectionView reloadData];
    [self dismissViewControllerAnimated:YES completion:nil];

}
#pragma mark - actionSheet照相和删除照片
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (actionSheet.tag == 1003) {
        //删除照片
        if (buttonIndex == 0) {
            [_mArray removeObjectAtIndex:_index];
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
}
-(void)popView1{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)tapAction{
    //取消第一响应者
    [_textView resignFirstResponder];
    
}
//左边按钮的返回事件
- (IBAction)leftbutton:(id)sender{
    [self.navigationController popViewControllerAnimated:YES];
}
//提交按钮
- (IBAction)submitClick:(UIButton *)sender{
    NSLog(@"提交成功");
    [self requestSearchFriend];
}
#pragma mark 提交意见反馈
-(void)requestSearchFriend{
    Request10015*request10015=[[Request10015 alloc]init];
    //设置请求参数
    request10015.common.userid=LoginUserInfo.user_id;
    request10015.common.userkey=LoginUserInfo.user_key;
    request10015.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request10015.common.version=@"1.0.0";//版本号
    request10015.common.platform=2;//ios  andriod
    //NSLog(@"%@",_proposalText.text);
    request10015.params.content=_textView.text;//提交意见内容
    //下面还可能有上传图片的内容
    
    NSData*data= [request10015 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/sendSuggestion",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    
    _requestFeed = [ASIFormDataRequest requestWithURL:url];
    [_requestFeed setPostBody:(NSMutableData*)data];
    [_requestFeed setDelegate:self];
    //请求延迟时间
    _requestFeed.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestFeed.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestFeed.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestFeed.secondsToCache=3600;
    [_requestFeed startAsynchronous];
    
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    
    if ([request isEqual:_requestFeed]) {
        Response10015*response=[Response10015 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);//意见反馈是否成功成了提示一个窗口
        [self.navigationController popViewControllerAnimated:YES];
        [[Tostal sharTostal]tostalMesg:@"意见上传成功" tostalTime:1];
    }    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
