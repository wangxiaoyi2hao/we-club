// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: clubuser.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class BriefUser;
@class DetailUser;
@class Request10001_Params;
@class Request10002_Params;
@class Request10003_Params;
@class Request10004_Params;
@class Request10005_Params;
@class Request10006_Params;
@class Request10007_Params;
@class Request10008_Params;
@class Request10009_Params;
@class Request10010_Params;
@class Request10011_Params;
@class Request10012_Params;
@class Request10013_Params;
@class Request10014_Params;
@class Request10015_Params;
@class Request10016_Params;
@class Request10017_Params;
@class Request10018_Params;
@class Request10019_Params;
@class Request10020_Params;
@class Request10021_Params;
@class RequestCommon;
@class Response10001_Data;
@class Response10002_Data;
@class Response10003_Data;
@class Response10004_Data;
@class Response10005_Data;
@class Response10006_Data;
@class Response10007_Data;
@class Response10008_Data;
@class Response10009_Data;
@class Response10010_Data;
@class Response10011_Data;
@class Response10012_Data;
@class Response10013_Data;
@class Response10014_Data;
@class Response10015_Data;
@class Response10016_Data;
@class Response10017_Data;
@class Response10018_Data;
@class Response10019_Data;
@class Response10020_Data;
@class Response10021_Data;
@class ResponseCommon;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ClubuserRoot

@interface ClubuserRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - User

typedef GPB_ENUM(User_FieldNumber) {
  User_FieldNumber_Userid = 1,
  User_FieldNumber_Username = 2,
  User_FieldNumber_Phone = 3,
};

@interface User : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userid;

@property(nonatomic, readwrite, copy, null_resettable) NSString *username;

@property(nonatomic, readwrite, copy, null_resettable) NSString *phone;

@end

#pragma mark - Request10001

typedef GPB_ENUM(Request10001_FieldNumber) {
  Request10001_FieldNumber_Common = 1,
  Request10001_FieldNumber_Params = 2,
};

//用户注册 10001
//url: /userAction/register
@interface Request10001 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10001_Params *params;

@end

#pragma mark - Request10001_Params

typedef GPB_ENUM(Request10001_Params_FieldNumber) {
  Request10001_Params_FieldNumber_PhoneNumber = 1,
  Request10001_Params_FieldNumber_UserName = 2,
  Request10001_Params_FieldNumber_Md5Psw = 3,
  Request10001_Params_FieldNumber_Sex = 4,
  Request10001_Params_FieldNumber_Birthday = 5,
  Request10001_Params_FieldNumber_DiviceNumber = 6,
  Request10001_Params_FieldNumber_Hometown = 7,
};

@interface Request10001_Params : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *phoneNumber;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *md5Psw;

//1 男性   2 女性   切记！！！
@property(nonatomic, readwrite) int32_t sex;

//格式： 1982-10-21
@property(nonatomic, readwrite, copy, null_resettable) NSString *birthday;

//设备唯一标示
@property(nonatomic, readwrite, copy, null_resettable) NSString *diviceNumber;

//家乡
@property(nonatomic, readwrite, copy, null_resettable) NSString *hometown;

@end

#pragma mark - Response10001

typedef GPB_ENUM(Response10001_FieldNumber) {
  Response10001_FieldNumber_Common = 1,
  Response10001_FieldNumber_Data_p = 2,
};

@interface Response10001 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10001_Data *data_p;

@end

#pragma mark - Response10001_Data

typedef GPB_ENUM(Response10001_Data_FieldNumber) {
  Response10001_Data_FieldNumber_UserId = 1,
  Response10001_Data_FieldNumber_UserName = 2,
  Response10001_Data_FieldNumber_Md5Psw = 3,
};

@interface Response10001_Data : GPBMessage

//返回的数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *userId;

@property(nonatomic, readwrite, copy, null_resettable) NSString *userName;

@property(nonatomic, readwrite, copy, null_resettable) NSString *md5Psw;

@end

#pragma mark - Request10002

typedef GPB_ENUM(Request10002_FieldNumber) {
  Request10002_FieldNumber_Common = 1,
  Request10002_FieldNumber_Params = 2,
};

//用户登录 10002
//url: /userAction/login
@interface Request10002 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10002_Params *params;

@end

#pragma mark - Request10002_Params

typedef GPB_ENUM(Request10002_Params_FieldNumber) {
  Request10002_Params_FieldNumber_Account = 1,
  Request10002_Params_FieldNumber_Md5Psw = 2,
};

@interface Request10002_Params : GPBMessage

//手机号
@property(nonatomic, readwrite, copy, null_resettable) NSString *account;

//经过md5加密的密码
@property(nonatomic, readwrite, copy, null_resettable) NSString *md5Psw;

@end

#pragma mark - Response10002

typedef GPB_ENUM(Response10002_FieldNumber) {
  Response10002_FieldNumber_Common = 1,
  Response10002_FieldNumber_Data_p = 2,
};

@interface Response10002 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10002_Data *data_p;

@end

#pragma mark - Response10002_Data

typedef GPB_ENUM(Response10002_Data_FieldNumber) {
  Response10002_Data_FieldNumber_Userid = 1,
  Response10002_Data_FieldNumber_Key = 2,
  Response10002_Data_FieldNumber_Sex = 3,
  Response10002_Data_FieldNumber_Name = 4,
  Response10002_Data_FieldNumber_Sessionkey = 5,
  Response10002_Data_FieldNumber_QiniuToken = 6,
  Response10002_Data_FieldNumber_RongyunToken = 7,
  Response10002_Data_FieldNumber_UpdateState = 8,
  Response10002_Data_FieldNumber_LastedVersion = 9,
  Response10002_Data_FieldNumber_DownloadURL = 10,
};

@interface Response10002_Data : GPBMessage

@property(nonatomic, readwrite, copy, null_resettable) NSString *userid;

//用户私钥，每次请求时放到common里
@property(nonatomic, readwrite, copy, null_resettable) NSString *key;

@property(nonatomic, readwrite) int32_t sex;

@property(nonatomic, readwrite, copy, null_resettable) NSString *name;

//sessionKey，以后加入h5会用到
@property(nonatomic, readwrite, copy, null_resettable) NSString *sessionkey;

//七牛平台上传文件（图片）使用的token
@property(nonatomic, readwrite, copy, null_resettable) NSString *qiniuToken;

//用户使用融云聊天的token 如果没有，则使用上一次保存的token
@property(nonatomic, readwrite, copy, null_resettable) NSString *rongyunToken;

// 1:没有更新    2：用户可选更新   3：强制用户更新
@property(nonatomic, readwrite) int32_t updateState;

//最新版本号     当有更新时才会传入该数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *lastedVersion;

//下载新版本url   当有更新时才会传入该数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *downloadURL;

@end

#pragma mark - Request10003

typedef GPB_ENUM(Request10003_FieldNumber) {
  Request10003_FieldNumber_Common = 1,
  Request10003_FieldNumber_Params = 2,
};

//获取用户简要信息 “我” 10003
//url: /userAction/getUserBrief
@interface Request10003 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10003_Params *params;

@end

#pragma mark - Request10003_Params

@interface Request10003_Params : GPBMessage

@end

#pragma mark - Response10003

typedef GPB_ENUM(Response10003_FieldNumber) {
  Response10003_FieldNumber_Common = 1,
  Response10003_FieldNumber_Data_p = 2,
};

@interface Response10003 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10003_Data *data_p;

@end

#pragma mark - Response10003_Data

typedef GPB_ENUM(Response10003_Data_FieldNumber) {
  Response10003_Data_FieldNumber_Avatar = 1,
  Response10003_Data_FieldNumber_Username = 2,
  Response10003_Data_FieldNumber_ClubNumber = 3,
};

@interface Response10003_Data : GPBMessage

//返回的数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *avatar;

@property(nonatomic, readwrite, copy, null_resettable) NSString *username;

//用户账号 即vclub号
@property(nonatomic, readwrite) int64_t clubNumber;

@end

#pragma mark - Request10004

typedef GPB_ENUM(Request10004_FieldNumber) {
  Request10004_FieldNumber_Common = 1,
  Request10004_FieldNumber_Params = 2,
};

//获取我 发起的邀约  10004
//url: /userAction/getMyCreateInvite
@interface Request10004 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10004_Params *params;

@end

#pragma mark - Request10004_Params

@interface Request10004_Params : GPBMessage

@end

#pragma mark - Response10004

typedef GPB_ENUM(Response10004_FieldNumber) {
  Response10004_FieldNumber_Common = 1,
  Response10004_FieldNumber_Data_p = 2,
};

@interface Response10004 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10004_Data *data_p;

@end

#pragma mark - Response10004_Data

typedef GPB_ENUM(Response10004_Data_FieldNumber) {
  Response10004_Data_FieldNumber_InviteArray = 1,
};

@interface Response10004_Data : GPBMessage

//返回的数据
// |inviteArray| contains |ClubInvite|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *inviteArray;
@property(nonatomic, readonly) NSUInteger inviteArray_Count;

@end

#pragma mark - Request10005

typedef GPB_ENUM(Request10005_FieldNumber) {
  Request10005_FieldNumber_Common = 1,
  Request10005_FieldNumber_Params = 2,
};

//获取我 参与的邀约  10005
//url: /userAction/getMyJoinInvite
@interface Request10005 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10005_Params *params;

@end

#pragma mark - Request10005_Params

@interface Request10005_Params : GPBMessage

@end

#pragma mark - Response10005

typedef GPB_ENUM(Response10005_FieldNumber) {
  Response10005_FieldNumber_Common = 1,
  Response10005_FieldNumber_Data_p = 2,
};

@interface Response10005 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10005_Data *data_p;

@end

#pragma mark - Response10005_Data

typedef GPB_ENUM(Response10005_Data_FieldNumber) {
  Response10005_Data_FieldNumber_InviteArray = 1,
};

@interface Response10005_Data : GPBMessage

//返回的数据
// |inviteArray| contains |ClubInvite|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *inviteArray;
@property(nonatomic, readonly) NSUInteger inviteArray_Count;

@end

#pragma mark - Request10006

typedef GPB_ENUM(Request10006_FieldNumber) {
  Request10006_FieldNumber_Common = 1,
  Request10006_FieldNumber_Params = 2,
};

//获取我的好友列表   10006
//url: /userAction/getMyFriends
@interface Request10006 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10006_Params *params;

@end

#pragma mark - Request10006_Params

@interface Request10006_Params : GPBMessage

@end

#pragma mark - Response10006

typedef GPB_ENUM(Response10006_FieldNumber) {
  Response10006_FieldNumber_Common = 1,
  Response10006_FieldNumber_Data_p = 2,
};

@interface Response10006 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10006_Data *data_p;

@end

#pragma mark - Response10006_Data

typedef GPB_ENUM(Response10006_Data_FieldNumber) {
  Response10006_Data_FieldNumber_UserAvatarAndNameArray = 1,
};

@interface Response10006_Data : GPBMessage

//返回的数据
// |userAvatarAndNameArray| contains |UserAvatarAndName|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *userAvatarAndNameArray;
@property(nonatomic, readonly) NSUInteger userAvatarAndNameArray_Count;

@end

#pragma mark - Request10007

typedef GPB_ENUM(Request10007_FieldNumber) {
  Request10007_FieldNumber_Common = 1,
  Request10007_FieldNumber_Params = 2,
};

//根据clubnumber搜索用户   10007
//url: /userAction/searchUser
@interface Request10007 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10007_Params *params;

@end

#pragma mark - Request10007_Params

typedef GPB_ENUM(Request10007_Params_FieldNumber) {
  Request10007_Params_FieldNumber_ClubNumber = 1,
};

@interface Request10007_Params : GPBMessage

//根据clubNumber搜索好友
@property(nonatomic, readwrite) int64_t clubNumber;

@end

#pragma mark - Response10007

typedef GPB_ENUM(Response10007_FieldNumber) {
  Response10007_FieldNumber_Common = 1,
  Response10007_FieldNumber_Data_p = 2,
};

@interface Response10007 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10007_Data *data_p;

@end

#pragma mark - Response10007_Data

typedef GPB_ENUM(Response10007_Data_FieldNumber) {
  Response10007_Data_FieldNumber_BriefUser = 1,
};

@interface Response10007_Data : GPBMessage

@property(nonatomic, readwrite) BOOL hasBriefUser;
@property(nonatomic, readwrite, strong, null_resettable) BriefUser *briefUser;

@end

#pragma mark - Request10008

typedef GPB_ENUM(Request10008_FieldNumber) {
  Request10008_FieldNumber_Common = 1,
  Request10008_FieldNumber_Params = 2,
};

//获取我的粉丝 10008
//url: /userAction/getMyFollower
@interface Request10008 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10008_Params *params;

@end

#pragma mark - Request10008_Params

@interface Request10008_Params : GPBMessage

@end

#pragma mark - Response10008

typedef GPB_ENUM(Response10008_FieldNumber) {
  Response10008_FieldNumber_Common = 1,
  Response10008_FieldNumber_Data_p = 2,
};

@interface Response10008 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10008_Data *data_p;

@end

#pragma mark - Response10008_Data

typedef GPB_ENUM(Response10008_Data_FieldNumber) {
  Response10008_Data_FieldNumber_BriefUsersArray = 1,
};

@interface Response10008_Data : GPBMessage

// |briefUsersArray| contains |BriefUser|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *briefUsersArray;
@property(nonatomic, readonly) NSUInteger briefUsersArray_Count;

@end

#pragma mark - Request10009

typedef GPB_ENUM(Request10009_FieldNumber) {
  Request10009_FieldNumber_Common = 1,
  Request10009_FieldNumber_Params = 2,
};

//获取我关注的酒吧 10009
//url: /userAction/getMyFollowClub
@interface Request10009 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10009_Params *params;

@end

#pragma mark - Request10009_Params

@interface Request10009_Params : GPBMessage

@end

#pragma mark - Response10009

typedef GPB_ENUM(Response10009_FieldNumber) {
  Response10009_FieldNumber_Common = 1,
  Response10009_FieldNumber_Data_p = 2,
};

@interface Response10009 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10009_Data *data_p;

@end

#pragma mark - Response10009_Data

typedef GPB_ENUM(Response10009_Data_FieldNumber) {
  Response10009_Data_FieldNumber_BriefClubsArray = 1,
};

@interface Response10009_Data : GPBMessage

// |briefClubsArray| contains |BriefClub|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *briefClubsArray;
@property(nonatomic, readonly) NSUInteger briefClubsArray_Count;

@end

#pragma mark - Request10010

typedef GPB_ENUM(Request10010_FieldNumber) {
  Request10010_FieldNumber_Common = 1,
  Request10010_FieldNumber_Params = 2,
};

//获取我关注的人 10010
//url: /userAction/getMyFollowUser
@interface Request10010 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10010_Params *params;

@end

#pragma mark - Request10010_Params

@interface Request10010_Params : GPBMessage

@end

#pragma mark - Response10010

typedef GPB_ENUM(Response10010_FieldNumber) {
  Response10010_FieldNumber_Common = 1,
  Response10010_FieldNumber_Data_p = 2,
};

@interface Response10010 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10010_Data *data_p;

@end

#pragma mark - Response10010_Data

typedef GPB_ENUM(Response10010_Data_FieldNumber) {
  Response10010_Data_FieldNumber_BriefUsersArray = 1,
};

@interface Response10010_Data : GPBMessage

// |briefUsersArray| contains |BriefUser|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *briefUsersArray;
@property(nonatomic, readonly) NSUInteger briefUsersArray_Count;

@end

#pragma mark - Request10011

typedef GPB_ENUM(Request10011_FieldNumber) {
  Request10011_FieldNumber_Common = 1,
  Request10011_FieldNumber_Params = 2,
};

//退出登录 10011
//url: /userAction/logout
@interface Request10011 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10011_Params *params;

@end

#pragma mark - Request10011_Params

typedef GPB_ENUM(Request10011_Params_FieldNumber) {
  Request10011_Params_FieldNumber_Md5Psw = 1,
};

@interface Request10011_Params : GPBMessage

//密码经过md5加密
@property(nonatomic, readwrite, copy, null_resettable) NSString *md5Psw;

@end

#pragma mark - Response10011

typedef GPB_ENUM(Response10011_FieldNumber) {
  Response10011_FieldNumber_Common = 1,
  Response10011_FieldNumber_Data_p = 2,
};

@interface Response10011 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10011_Data *data_p;

@end

#pragma mark - Response10011_Data

@interface Response10011_Data : GPBMessage

@end

#pragma mark - Request10012

typedef GPB_ENUM(Request10012_FieldNumber) {
  Request10012_FieldNumber_Common = 1,
  Request10012_FieldNumber_Params = 2,
};

//修改密码 10012
//url: /userAction/modifyPassword
@interface Request10012 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10012_Params *params;

@end

#pragma mark - Request10012_Params

typedef GPB_ENUM(Request10012_Params_FieldNumber) {
  Request10012_Params_FieldNumber_OdlMd5Psw = 1,
  Request10012_Params_FieldNumber_NewMd5Psw = 2,
};

@interface Request10012_Params : GPBMessage

//旧密码经过md5加密
@property(nonatomic, readwrite, copy, null_resettable) NSString *odlMd5Psw;

//新密码  md5加密
@property(nonatomic, readwrite, copy, null_resettable) NSString *newMd5Psw NS_RETURNS_NOT_RETAINED;

@end

#pragma mark - Response10012

typedef GPB_ENUM(Response10012_FieldNumber) {
  Response10012_FieldNumber_Common = 1,
  Response10012_FieldNumber_Data_p = 2,
};

@interface Response10012 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10012_Data *data_p;

@end

#pragma mark - Response10012_Data

@interface Response10012_Data : GPBMessage

@end

#pragma mark - Request10013

typedef GPB_ENUM(Request10013_FieldNumber) {
  Request10013_FieldNumber_Common = 1,
  Request10013_FieldNumber_Params = 2,
};

//重置密码 10013
//url: /userAction/resetPassword
@interface Request10013 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10013_Params *params;

@end

#pragma mark - Request10013_Params

typedef GPB_ENUM(Request10013_Params_FieldNumber) {
  Request10013_Params_FieldNumber_NewMd5Psw = 1,
  Request10013_Params_FieldNumber_PhoneNumber = 2,
};

@interface Request10013_Params : GPBMessage

//新密码  md5加密
@property(nonatomic, readwrite, copy, null_resettable) NSString *newMd5Psw NS_RETURNS_NOT_RETAINED;

//原账户的手机号码
@property(nonatomic, readwrite, copy, null_resettable) NSString *phoneNumber;

@end

#pragma mark - Response10013

typedef GPB_ENUM(Response10013_FieldNumber) {
  Response10013_FieldNumber_Common = 1,
  Response10013_FieldNumber_Data_p = 2,
};

@interface Response10013 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10013_Data *data_p;

@end

#pragma mark - Response10013_Data

@interface Response10013_Data : GPBMessage

@end

#pragma mark - Request10014

typedef GPB_ENUM(Request10014_FieldNumber) {
  Request10014_FieldNumber_Common = 1,
  Request10014_FieldNumber_Params = 2,
};

//获取用户详情 10014
//url: /userAction/getUserDetail
@interface Request10014 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10014_Params *params;

@end

#pragma mark - Request10014_Params

typedef GPB_ENUM(Request10014_Params_FieldNumber) {
  Request10014_Params_FieldNumber_Userid = 1,
};

@interface Request10014_Params : GPBMessage

//查看的用户的id，如果是看自己的，就写自己的id，如果是别人的，就写别人的id
@property(nonatomic, readwrite, copy, null_resettable) NSString *userid;

@end

#pragma mark - Response10014

typedef GPB_ENUM(Response10014_FieldNumber) {
  Response10014_FieldNumber_Common = 1,
  Response10014_FieldNumber_Data_p = 2,
};

@interface Response10014 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10014_Data *data_p;

@end

#pragma mark - Response10014_Data

typedef GPB_ENUM(Response10014_Data_FieldNumber) {
  Response10014_Data_FieldNumber_DetailUser = 1,
};

@interface Response10014_Data : GPBMessage

//用户详情
@property(nonatomic, readwrite) BOOL hasDetailUser;
@property(nonatomic, readwrite, strong, null_resettable) DetailUser *detailUser;

@end

#pragma mark - Request10015

typedef GPB_ENUM(Request10015_FieldNumber) {
  Request10015_FieldNumber_Common = 1,
  Request10015_FieldNumber_Params = 2,
};

//提交意见反馈 10015
//url: /userAction/sendSuggestion
@interface Request10015 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10015_Params *params;

@end

#pragma mark - Request10015_Params

typedef GPB_ENUM(Request10015_Params_FieldNumber) {
  Request10015_Params_FieldNumber_Content = 1,
  Request10015_Params_FieldNumber_PicKeyArray = 2,
};

@interface Request10015_Params : GPBMessage

//意见内容
@property(nonatomic, readwrite, copy, null_resettable) NSString *content;

//意见反馈上传的图片在七牛上的key
// |picKeyArray| contains |NSString|
@property(nonatomic, readwrite, strong, null_resettable) NSMutableArray *picKeyArray;
@property(nonatomic, readonly) NSUInteger picKeyArray_Count;

@end

#pragma mark - Response10015

typedef GPB_ENUM(Response10015_FieldNumber) {
  Response10015_FieldNumber_Common = 1,
  Response10015_FieldNumber_Data_p = 2,
};

@interface Response10015 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10015_Data *data_p;

@end

#pragma mark - Response10015_Data

@interface Response10015_Data : GPBMessage

@end

#pragma mark - Request10016

typedef GPB_ENUM(Request10016_FieldNumber) {
  Request10016_FieldNumber_Common = 1,
  Request10016_FieldNumber_Params = 2,
};

//更改用户资料(包括添加图片，更改图片顺序，更改背景等操作)  10016
//修改了哪些字段，只给哪些字段赋值就行
//url: /userAction/updateUserDetail
@interface Request10016 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10016_Params *params;

@end

#pragma mark - Request10016_Params

typedef GPB_ENUM(Request10016_Params_FieldNumber) {
  Request10016_Params_FieldNumber_DetailUser = 1,
};

@interface Request10016_Params : GPBMessage

//该类中所有字段都是可选字段，也就是说：用户修改了那些字段，就只给那些字段赋值就行
@property(nonatomic, readwrite) BOOL hasDetailUser;
@property(nonatomic, readwrite, strong, null_resettable) DetailUser *detailUser;

@end

#pragma mark - Response10016

typedef GPB_ENUM(Response10016_FieldNumber) {
  Response10016_FieldNumber_Common = 1,
  Response10016_FieldNumber_Data_p = 2,
};

@interface Response10016 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10016_Data *data_p;

@end

#pragma mark - Response10016_Data

@interface Response10016_Data : GPBMessage

@end

#pragma mark - Request10017

typedef GPB_ENUM(Request10017_FieldNumber) {
  Request10017_FieldNumber_Common = 1,
  Request10017_FieldNumber_Params = 2,
};

//验证用户名   注册部分
//url: /userAction/verifyUsername
@interface Request10017 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10017_Params *params;

@end

#pragma mark - Request10017_Params

typedef GPB_ENUM(Request10017_Params_FieldNumber) {
  Request10017_Params_FieldNumber_Username = 1,
};

@interface Request10017_Params : GPBMessage

//用户输入验证的用户名
@property(nonatomic, readwrite, copy, null_resettable) NSString *username;

@end

#pragma mark - Response10017

typedef GPB_ENUM(Response10017_FieldNumber) {
  Response10017_FieldNumber_Common = 1,
  Response10017_FieldNumber_Data_p = 2,
};

@interface Response10017 : GPBMessage

//code = 0(success)
@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10017_Data *data_p;

@end

#pragma mark - Response10017_Data

@interface Response10017_Data : GPBMessage

@end

#pragma mark - Request10018

typedef GPB_ENUM(Request10018_FieldNumber) {
  Request10018_FieldNumber_Common = 1,
  Request10018_FieldNumber_Params = 2,
};

//验证手机号   注册部分
//url: /userAction/verifyPhoneNumber
@interface Request10018 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10018_Params *params;

@end

#pragma mark - Request10018_Params

typedef GPB_ENUM(Request10018_Params_FieldNumber) {
  Request10018_Params_FieldNumber_PhoneNumber = 1,
};

@interface Request10018_Params : GPBMessage

//用户输入验证的手机号
@property(nonatomic, readwrite, copy, null_resettable) NSString *phoneNumber;

@end

#pragma mark - Response10018

typedef GPB_ENUM(Response10018_FieldNumber) {
  Response10018_FieldNumber_Common = 1,
  Response10018_FieldNumber_Data_p = 2,
};

@interface Response10018 : GPBMessage

//code = 0(success)
@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10018_Data *data_p;

@end

#pragma mark - Response10018_Data

@interface Response10018_Data : GPBMessage

@end

#pragma mark - Request10019

typedef GPB_ENUM(Request10019_FieldNumber) {
  Request10019_FieldNumber_Common = 1,
  Request10019_FieldNumber_Params = 2,
};

//申请加为好友 10019
//url: /userAction/applyFriend
@interface Request10019 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10019_Params *params;

@end

#pragma mark - Request10019_Params

typedef GPB_ENUM(Request10019_Params_FieldNumber) {
  Request10019_Params_FieldNumber_FriendId = 1,
};

@interface Request10019_Params : GPBMessage

//要加为好友的用户的id
@property(nonatomic, readwrite, copy, null_resettable) NSString *friendId;

@end

#pragma mark - Response10019

typedef GPB_ENUM(Response10019_FieldNumber) {
  Response10019_FieldNumber_Common = 1,
  Response10019_FieldNumber_Data_p = 2,
};

@interface Response10019 : GPBMessage

//code = 0(success)
@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10019_Data *data_p;

@end

#pragma mark - Response10019_Data

@interface Response10019_Data : GPBMessage

@end

#pragma mark - Request10020

typedef GPB_ENUM(Request10020_FieldNumber) {
  Request10020_FieldNumber_Common = 1,
  Request10020_FieldNumber_Params = 2,
};

//同意加为好友 10020
//url: /userAction/agreeFriend
@interface Request10020 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10020_Params *params;

@end

#pragma mark - Request10020_Params

typedef GPB_ENUM(Request10020_Params_FieldNumber) {
  Request10020_Params_FieldNumber_FriendId = 1,
};

@interface Request10020_Params : GPBMessage

//同意的用户的id
@property(nonatomic, readwrite, copy, null_resettable) NSString *friendId;

@end

#pragma mark - Response10020

typedef GPB_ENUM(Response10020_FieldNumber) {
  Response10020_FieldNumber_Common = 1,
  Response10020_FieldNumber_Data_p = 2,
};

@interface Response10020 : GPBMessage

//code = 0(success)
@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10020_Data *data_p;

@end

#pragma mark - Response10020_Data

@interface Response10020_Data : GPBMessage

@end

#pragma mark - Request10021

typedef GPB_ENUM(Request10021_FieldNumber) {
  Request10021_FieldNumber_Common = 1,
  Request10021_FieldNumber_Params = 2,
};

//获取用户账户金额   10021
//url: /userAction/getMoney
@interface Request10021 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request10021_Params *params;

@end

#pragma mark - Request10021_Params

@interface Request10021_Params : GPBMessage

@end

#pragma mark - Response10021

typedef GPB_ENUM(Response10021_FieldNumber) {
  Response10021_FieldNumber_Common = 1,
  Response10021_FieldNumber_Data_p = 2,
};

@interface Response10021 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response10021_Data *data_p;

@end

#pragma mark - Response10021_Data

typedef GPB_ENUM(Response10021_Data_FieldNumber) {
  Response10021_Data_FieldNumber_Money = 1,
};

@interface Response10021_Data : GPBMessage

//用户的金额数
@property(nonatomic, readwrite) int32_t money;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
