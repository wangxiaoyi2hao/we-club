//
//  resetPasswordViewController.m
//  bar
//
//  Created by 牟志威 on 15/10/6.
//  Copyright (c) 2015年 BIT. All rights reserved.
//
//修改密码界面
#import "resetPasswordViewController.h"
extern UserInfo*LoginUserInfo;
@interface resetPasswordViewController ()<ASIHTTPRequestDelegate>
{

    ASIFormDataRequest*_requestUpdate;

}
@end

@implementation resetPasswordViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //接收键盘通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate:) name:UITextFieldTextDidChangeNotification object:_originPwdInput];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate:) name:UITextFieldTextDidChangeNotification object:_tempPwdInputAgain];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(validate:) name:UITextFieldTextDidChangeNotification object:_tempPwdInput];
    //返回按钮
    [self loadNav];
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
#pragma mark 修改密码调用的接口方法
-(void)requestFansList{
    Request10012*request10012=[[Request10012 alloc]init];
    //设置请求参数
    request10012.common.userid=LoginUserInfo.user_id;
    request10012.common.userkey=LoginUserInfo.user_key;
    request10012.common.timestamp=[[NSDate date]timeIntervalSince1970];;//现在标注为真数据
    request10012.common.version=@"1.0.0";//版本号
    request10012.common.platform=2;//ios  andriod
    request10012.params.odlMd5Psw=[HelperUtil md532BitUpper:_originPwdInput.text];//退出登录的时候要传进去一个旧密码密码
    request10012.params.newMd5Psw=[HelperUtil md532BitUpper:_tempPwdInput.text];//退出登录的时候要传进去一个新密码密码
    NSData*data= [request10012 data];
    NSString*strUrl=[NSString stringWithFormat:@"%@userAction/modifyPassword",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _requestUpdate = [ASIFormDataRequest requestWithURL:url];
    [_requestUpdate setPostBody:(NSMutableData*)data];
    [_requestUpdate setDelegate:self];
    //请求延迟时间
    _requestUpdate.timeOutSeconds=5;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _requestUpdate.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _requestUpdate.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _requestUpdate.secondsToCache=3600;
    [_requestUpdate startAsynchronous];
    
}

- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_requestUpdate]) {
        Response10012*response=[Response10012 parseFromData:request.responseData error:nil];
        NSLog(@"%i",response.common.code);
        if (response.common.code!=0) {
            [[Tostal sharTostal]tostalMesg:@"修改失败" tostalTime:1];
        }else{
            [[Tostal sharTostal]tostalMesg:@"修改成功" tostalTime:1];
        }
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    BOOL flag = NO;
    if (textField == _originPwdInput) {
        //设置为第一响应者
        [_tempPwdInput becomeFirstResponder];
    } else if (textField == _tempPwdInput) {
        [_tempPwdInputAgain becomeFirstResponder];
    } else {
        flag = YES;
    }
    //取消作为第一响应者
    [textField resignFirstResponder];
    return flag;
}
//输入位数的判断????
- (BOOL)fulfil:(NSString *)str  {
    int conLChar = 0 , conHChar = 0 , conNumber = 0, conOther = 0;
    for (int i = 0 ; i < str.length ; i++) {
        if (conLChar == 0 &&  'a' <= [str characterAtIndex:i] && [str characterAtIndex:i] <= 'z')  {
            conLChar = 1;
        } else if (conHChar == 0 && 'A' <= [str characterAtIndex:i] && [str characterAtIndex:i] <= 'Z')   {
            conHChar = 1;
        } else if (conNumber == 0 && '0' <= [str characterAtIndex:i] && [str characterAtIndex:i] <= '9')  {
            conNumber = 1;
        } else if (conOther == 0)   {
            conOther = 1;
        }
    }
    if (conLChar + conHChar + conNumber + conOther >= 2)    {
        return YES;
    } else {
        return NO;
    }
}

- (IBAction)validate:(UITextField *)sender {
    //三组密码都有
    if (_originPwdInput.text.length && _tempPwdInput.text.length && _tempPwdInputAgain.text.length) {
        //新密码位数8位以上
        if (_tempPwdInput.text.length >= 8 && [self fulfil:_tempPwdInput.text])   {
            //两次新密码相同
            if ([_tempPwdInput.text isEqualToString:_tempPwdInputAgain.text]) {
                //完成按钮可点击
                _completeBtn.enabled = YES;
                return ;
            }
        }
    }
    //完成按钮不可点击
    _completeBtn.enabled = NO;
}
//返回按钮
- (IBAction)backBtnClick:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)completeBtnClick:(id)sender {
    NSLog(@"你点击了完成按钮");
    [self requestFansList];
}
//忘记密码点击事件
- (IBAction)forgetBtnClick:(UIButton *)sender {
    //此方法已废弃,跳转到的类也该删掉(赞留)
    //[self performSegueWithIdentifier:@"resetToForget" sender:nil];
}

- (IBAction)touchBlack:(id)sender {
    //取消作为第一响应者
    [_originPwdInput resignFirstResponder];
    [_tempPwdInput resignFirstResponder];
    [_tempPwdInputAgain resignFirstResponder];
}
@end
