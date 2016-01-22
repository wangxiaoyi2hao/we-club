//
//  UserInfo.h
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfo : NSObject
@property(nonatomic,copy)NSString*phoneNum;
@property(nonatomic,copy)NSString*user_id;
@property(nonatomic,copy)NSString*user_name;
@property(nonatomic,copy)NSString*user_pwd;
@property(nonatomic,assign)double user_balance;
@property(nonatomic,copy)NSString*user_head;
@property(nonatomic,copy)NSString*user_key;
@property(nonatomic,assign)int user_sex;
@property(nonatomic,copy)NSString*sessionkey;
@property(nonatomic,copy)NSString*qiNiuTOken;
@property(nonatomic,copy)NSString*rongYunTOken;
@property(nonatomic,assign)float longitude;//经度
@property(nonatomic,assign)float latitude;//纬度
@property(nonatomic,assign)int successArrive;
@property(nonatomic,copy)NSString*vClubId;
@property(nonatomic,assign)int loginType;
@property(nonatomic,copy)NSString*otherId;



@end
