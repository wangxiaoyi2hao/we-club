//
//  CommonDefine.h
//  bar
//
//  Created by chen on 15/11/6.
//  Copyright © 2015年 BIT. All rights reserved.
//

#ifndef CommonDefine_h
#define CommonDefine_h
//加载时候的个数
#define LOAD_NUM 20
#define CODENUM 901
//宏定义屏幕的宽高
#define KScreenWidth    [UIScreen mainScreen].bounds.size.width
#define KScreenHeight   [UIScreen mainScreen].bounds.size.height
//宏定义背景颜色
#define BackgroundColor  [UIColor colorWithRed:220.0/255 green:220.0/255 blue:220.0/255 alpha:1]
//宏定义通知名称
#define AnyInformation     @"anyInformationChangeValue"
#define InviteChangeValue  @"InviteChangeValue"
//借口前缀
#define REQUESTURL  @"http://101.200.84.75:8080/VClubWeb/"
//http://101.200.84.75:8080/线上的
//http://10.0.1.4:8080/线下的
//七牛的借口
//地图框架的导入
#import <MAMapKit/MAMapKit.h>
#import <AMapSearchKit/AMapSearchKit.h>
#import <QiniuSDK.h>
//ASI的框架导入
#import "ASIFormDataRequest.h"
#import "ASIDownloadCache.h"
//提示框的单例按钮显示
#import "Tostal.h"
#import "MyFile.h"
#import "UIImageView+WebCache.h"
#import "MBProgressHUD.h"
//要导入的属性
#import "UserInfo.h"
//七牛图片上传单例
#import "QiNiuObjc.h"
//自定义相册
#import "ZYQAssetPickerController.h"
//下拉刷新和上啦加载
#import "MJRefresh.h"
#import "HelperUtil.h"
//声音提醒
#import "LxxPlaySound.h"
//这里是一个好看的提示框的问题
#endif /* CommonDefine_h */

