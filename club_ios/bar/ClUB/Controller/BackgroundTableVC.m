//
//  BackgroundTableVC.m
//  bar
//
//  Created by chen on 15/10/28.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "BackgroundTableVC.h"
#import "AppDelegate.h"
#import "OneBarViewController.h"
extern UserInfo*LoginUserInfo;
@interface BackgroundTableVC ()<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest*_request;
    NSString* fileName;

}
@end

@implementation BackgroundTableVC

- (void)viewDidLoad {
    [AppDelegate matchAllScreenWithView:self.view];
  [self.view setBackgroundColor:[HelperUtil colorWithHexString:@"#f8f8f8"]];
    [super viewDidLoad];
    [self initNavBar];
    
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return 2;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return 1;
    }
    return 20;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    if (indexPath.section==1) {
        if (indexPath.row==0) {
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagepicker.allowsEditing = YES;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }else{
        
            NSLog(@"拍照");
            UIImagePickerController *imagepicker = [[UIImagePickerController alloc] init];
            imagepicker.delegate = self;
            imagepicker.sourceType = UIImagePickerControllerSourceTypeCamera;
            imagepicker.allowsEditing = YES;
            [self presentViewController:imagepicker animated:YES completion:nil];
        }
    }


}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo{
    NSData *imageData=UIImagePNGRepresentation(image);//取出相册中的照片数据
   fileName = [NSString stringWithFormat:@"%@%@.jpg",[[Tostal sharTostal]getDateTimeString],  [[Tostal sharTostal]randomStringWithLength:8]];

        
        QNUploadManager *upManager = [[QNUploadManager alloc] init];
        [upManager putData:imageData
                       key:fileName
                     token:LoginUserInfo.qiNiuTOken
                  complete: ^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
                      
                      NSLog(@" --->> Info: %@  ", info);
                      NSLog(@" ---------------------");
                      NSLog(@" --->> Response: %@,  ", resp);
                      //发一个通知让上一个页面返回这个页面也返回或者是代理 我需要研究一下
                      
                  }
                    option:nil];
        
        
        
        
    
   
    [picker dismissViewControllerAnimated:YES completion:nil];//因为 UIImagePickerController为模态跳转而来，所以，用模态跳转，返回。
    
  
}
#pragma mark 选择背景图片的东西
-(void)requestUrl{
    Request11012*request=[[Request11012 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/changeChatroomBackground",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _request = [ASIFormDataRequest requestWithURL:url];
    //设置请求参数
    request.common.userid=LoginUserInfo.user_id;
    request.common.userkey=LoginUserInfo.user_key;
    request.common.cmdid=11012;//现在标注为假数据
    request.common.timestamp=2;//现在标注为真数据
    request.params.chatroomId=_fromChatId;
    //request.params.backgroundURL=fileName;
    NSData*data= [request data];
    [_request setPostBody:(NSMutableData*)data];
    [_request setDelegate:self];
    //请求延迟时间
    _request.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _request.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _request.secondsToCache=3600;
    [_request startAsynchronous];
    //（2）创建manager
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    Response11001 * response = [Response11001 parseFromData:request.responseData error:nil];
    NSLog(@"%@",response.data_p.clubsArray);
}

//设置导航栏
-(void)initNavBar{
    self.navigationItem.title = @"聊天背景";
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor whiteColor]};
    //右侧两个按钮
    UIButton * rightButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40,40)];
    rightButton.backgroundColor = [UIColor clearColor];
    rightButton.tag = 1;
    [rightButton setTitle:@"确定" forState:UIControlStateNormal];
    [rightButton addTarget:self action:@selector(NavBarButton:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem * rigthbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:rightButton];
    
    self.navigationItem.rightBarButtonItem = rigthbarbuttonitem;
    //返回按钮
    UIButton * leftButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 25, 15)];
    leftButton.tag = 2;
    [leftButton addTarget:self action:@selector(popTOViewLater) forControlEvents:UIControlEventTouchUpInside];
    leftButton.backgroundColor = [UIColor clearColor];
    //    [leftButton setTitle:@"<" forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"all_back"] forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    UIBarButtonItem * leftbarbuttonitem = [[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = leftbarbuttonitem;
  
}
-(void)popTOViewLater{

    [self.navigationController popViewControllerAnimated:YES];
 }
-(void)NavBarButton:(UIButton *)btn{
    NSInteger idnex = btn.tag;
    if(idnex == 0){
        //self.tabBarController.tabBar.hidden = NO;
        //回到club界面
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        NSLog(@"点击了确定");
       
    }
}


@end
