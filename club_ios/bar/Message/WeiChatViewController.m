//
//  WeiChatViewController.m
//  bar
//
//  Created by chen on 15/11/5.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "WeiChatViewController.h"
#import "WXApi.h"

@interface WeiChatViewController ()

@end

@implementation WeiChatViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //微信支付
    UIButton *but2 = [[UIButton alloc]initWithFrame:CGRectMake(200, 100, 100, 40)];
    self.view.backgroundColor = [UIColor greenColor];
    
    [but2 setTitle:@"微信支付" forState:UIControlStateNormal];
    but2.backgroundColor = [UIColor lightGrayColor];
    [but2 addTarget:self action:@selector(wxpay) forControlEvents:UIControlEventTouchUpInside];
    [but2 setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [self.view addSubview:but2];
}
//调起止付
- (void) wxpay{
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp = @"1397527777";
    request.sign= @"582282D72DD2B03AD892830965F428CB16E7A256";
    [WXApi sendReq:request];
}
-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            caseWXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
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
