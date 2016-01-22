//
//  TopUpViewController.m
//  Weclub
//
//  Created by lsp's mac pro on 15/12/21.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "TopUpViewController.h"
#import "WXApi.h"
#import "AppDelegate.h"

@interface TopUpViewController ()

@end

@implementation TopUpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [AppDelegate matchAllScreenWithView:self.view];
}

- (IBAction)topUpAction:(UIButton *)sender {
    //这里需要的是跳转到 充值金额那个页面之后再调用微信支付 //topupviewcontroller
    PayReq *request = [[PayReq alloc] init];
    request.partnerId = @"10000100";
    request.prepayId= @"1101000000140415649af9fc314aa427";
    request.package = @"Sign=WXPay";
    request.nonceStr= @"a462b76e7436e98e0ed6e13c64b4fd1c";
    request.timeStamp = [[NSDate date]timeIntervalSince1970];
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
