//
//  Tostal.m
//  自定义提示框
//
//  Created by apple on 15/7/14.
//  Copyright (c) 2015年 jl. All rights reserved.
//

#import "Tostal.h"
#import "AppDelegate.h"
#import "Clubuser.pbobjc.h"
#import "Common.pbobjc.h"
#import "MBProgressHUD.h"



int initCount;
static Tostal *singleInstance;
@implementation Tostal


- (void)tostalMesg:(NSString *)mesgStr tostalTime:(int)disTime{
    _mesgStr=mesgStr;
    _disTime=disTime;



    if (!isShow) {
        isShow=YES;
        UIFont *font=[UIFont systemFontOfSize:16];
        CGRect rect=[_mesgStr boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        _lbmesg=[[UILabel alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, rect.size.height)];
        _lbmesg.font=font;
        _lbmesg.text=_mesgStr;
        _lbmesg.numberOfLines=0;
        _lbmesg.textColor=[UIColor whiteColor];
        _mesgView=[[UIView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width+20, rect.size.height+20)];
        _mesgView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        _lbmesg.center=CGPointMake(_mesgView.bounds.size.width/2, _mesgView.bounds.size.height/2);
        _mesgView.backgroundColor=[UIColor blackColor];
        _mesgView.alpha=0.8;
        _mesgView.layer.cornerRadius=5.0;
        _mesgView.layer.masksToBounds=YES;
        [_mesgView addSubview:_lbmesg];
        AppDelegate *deledate=[UIApplication sharedApplication].delegate;
        [deledate.window addSubview:_mesgView];
        _timer=[NSTimer scheduledTimerWithTimeInterval:_disTime target:self selector:@selector(hiddenTostal) userInfo:nil repeats:NO];
        
    }else{
        initCount++;
        
        [_timer invalidate];
        _lbmesg.text=_mesgStr;
        UIFont *font=[UIFont systemFontOfSize:16];
        CGRect rect=[_mesgStr boundingRectWithSize:CGSizeMake(200, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: font} context:nil];
        _mesgView.frame=CGRectMake(0, 0, rect.size.width+20, rect.size.height+20);
        _lbmesg.frame=CGRectMake(0, 0, rect.size.width, rect.size.height);
        _mesgView.center=CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        _lbmesg.center=CGPointMake(_mesgView.bounds.size.width/2, _mesgView.bounds.size.height/2);
        _timer=[NSTimer scheduledTimerWithTimeInterval:_disTime target:self selector:@selector(hiddenTostal) userInfo:nil repeats:NO];
    }
}
- (void)hiddenTostal{
    isShow=NO;

    [_mesgView removeFromSuperview];
}

- (void)showLoadingView:(NSString *)title {
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _hud = [MBProgressHUD showHUDAddedTo:window animated:YES];
    _hud.mode = MBProgressHUDModeCustomView;
    //设置显示的标题
    _hud.labelText = title;
    //设置灰色视图覆盖屏幕
    _hud.dimBackground = YES;
  
}

//隐藏加载视图
- (void)hiddenView {
    
    [_hud hide:YES];
    
}

/*这里是一个好东西*///设置唯一标示加入你要给一个文件命名  你就用这个去命名，如果重复你打我

//这样可以给我的图片一个唯一的key
- (NSString *)getDateTimeString
{
    NSDateFormatter *formatter;
    NSString        *dateString;
    
    formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyyMMddHHmmss"];
    
    dateString = [formatter stringFromDate:[NSDate date]];
    
    return dateString;
}
//这样可以给我的图片一个唯一的key
- (NSString *)randomStringWithLength:(int)len
{
    NSString *letters = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789";
    NSMutableString *randomString = [NSMutableString stringWithCapacity: len];
    
    for (int i=0; i<len; i++) {
        [randomString appendFormat: @"%C", [letters characterAtIndex: arc4random_uniform((int)[letters length])]];
    }
    
    return randomString;
}
/*结束*/
+(Tostal *)sharTostal{
    @synchronized (self){
        if (singleInstance==nil) {
            singleInstance=[[Tostal alloc] init];
        }
    }
    return singleInstance;
}
@end
