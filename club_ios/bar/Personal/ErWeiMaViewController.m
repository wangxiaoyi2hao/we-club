//
//  ErWeiMaViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/18.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "ErWeiMaViewController.h"
#import "CIFilterTools.h"
#import "QRViewController.h"
@interface ErWeiMaViewController ()
@property (strong, nonatomic) IBOutlet UIImageView *qrcodeView;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (IBAction)creat:(id)sender;
- (IBAction)scan:(id)sender;
@end

@implementation ErWeiMaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.textField.placeholder = @"输入字符串生成二维码";
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction)];
    [self.view addGestureRecognizer:singleTap];
    // Do any additional setup after loading the view from its nib.
}

-(void)tapAction{

    [self.textField resignFirstResponder];

}
/**
 *  生成二维码
 */
- (IBAction)creat:(id)sender {
    
    
    //退出键盘
    [self.view endEditing:YES];
    
    //0.创建单例对象
    CIFilterTools *cifilter = [CIFilterTools shareInstance];
    
    //1.二维码的生成
    CIImage *image = [cifilter createQRForString:self.textField.text];
    
    //2.转换成需要大小的UIImage
    UIImage *qrcode = [cifilter createNonInterpolatedUIImageFormCIImage:image withSize:250.0f];
    
    //3.颜色填充,并转换为透明背景
    UIImage *customQrcode = [cifilter imageBlackToTransparent:qrcode withRed:60.0f andGreen:74.0f andBlue:89.0f];
    self.qrcodeView.image = customQrcode;
    
    // 4.添加阴影
    self.qrcodeView.layer.shadowOffset = CGSizeMake(0, 2);
    self.qrcodeView.layer.shadowRadius = 2;
    self.qrcodeView.layer.shadowColor = [UIColor blackColor].CGColor;
    self.qrcodeView.layer.shadowOpacity = 0.5;
    
}

/**
 *  扫描二维码
 */
- (IBAction)scan:(id)sender {
    
    if ([[CIFilterTools shareInstance] validateCamera]) {//有摄像头并且可用
        
        QRViewController *qrVC = [[QRViewController alloc] init];
        [self.navigationController pushViewController:qrVC animated:YES];
        
    } else {//没摄像头或者摄像头不可用
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"没有摄像头或摄像头不可用" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    }
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
