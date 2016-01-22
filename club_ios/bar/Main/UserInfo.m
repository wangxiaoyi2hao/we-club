//
//  UserInfo.m
//  bar
//
//  Created by lsp's mac pro on 15/11/7.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "UserInfo.h"
UserInfo*LoginUserInfo;
@implementation UserInfo
- (void)encodeWithCoder:(NSCoder *)aCoder{
    [aCoder encodeObject:_user_id forKey:@"user_id"];
    [aCoder encodeObject:_user_name forKey:@"user_name"];
    [aCoder encodeObject:_user_pwd forKey:@"user_pwd"];
    [aCoder encodeObject:_user_head forKey:@"user_head"];
    [aCoder encodeObject:_qiNiuTOken forKey:@"qiNiuTOken"];
    [aCoder encodeObject:_rongYunTOken forKey:@"rongYunTOken"];
    [aCoder encodeInt32:_user_sex forKey:@"user_sex"];
    [aCoder encodeObject:_user_key forKey:@"user_key"];
    [aCoder encodeFloat:_longitude forKey:@"longitude"];
    [aCoder encodeFloat:_latitude forKey:@"latitude"];
    [aCoder encodeObject:_phoneNum forKey:@"phoneNum"];
     [aCoder encodeInt32:_loginType forKey:@"loginType"];
    [aCoder encodeObject:_vClubId forKey:@"vClubId"];
    [aCoder encodeObject:_otherId forKey:@"otherId"];
   
  
    

}
- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self=[super init]) {
        _otherId=[aDecoder decodeObjectForKey:@"otherId"];
        _user_id=[aDecoder decodeObjectForKey:@"user_id"];
        _user_name=[aDecoder decodeObjectForKey:@"user_name"];
        _user_pwd=[aDecoder decodeObjectForKey:@"user_pwd"];
        _user_head=[aDecoder decodeObjectForKey:@"user_head"];
        _qiNiuTOken=[aDecoder decodeObjectForKey:@"qiNiuTOken"];
        _rongYunTOken=[aDecoder decodeObjectForKey:@"rongYunTOken"];
        _user_sex=[aDecoder decodeInt32ForKey:@"user_sex"];
        _user_key=[aDecoder decodeObjectForKey:@"user_key"];
        _longitude=[aDecoder decodeFloatForKey:@"longitude"];
        _latitude=[aDecoder decodeFloatForKey:@"latitude"];
        _phoneNum=[aDecoder decodeObjectForKey:@"phoneNum"];
        _loginType=[aDecoder decodeInt32ForKey:@"loginType"];
//        [aCoder encodeObject:_vClubId forKey:@"vClubId"];
        _vClubId=[aDecoder decodeObjectForKey:@"vClubId"];

    }
    return self;
}
@end
