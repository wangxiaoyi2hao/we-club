// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: app.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class Request14001_Params;
@class RequestCommon;
@class Response14001_Data;
@class ResponseCommon;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - AppRoot

@interface AppRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - Request14001

typedef GPB_ENUM(Request14001_FieldNumber) {
  Request14001_FieldNumber_Common = 1,
  Request14001_FieldNumber_Params = 2,
};

//检查版本更新
//url： /appAction/checkUpdate
@interface Request14001 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request14001_Params *params;

@end

#pragma mark - Request14001_Params

@interface Request14001_Params : GPBMessage

@end

#pragma mark - Response14001

typedef GPB_ENUM(Response14001_FieldNumber) {
  Response14001_FieldNumber_Common = 1,
  Response14001_FieldNumber_Data_p = 2,
};

@interface Response14001 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response14001_Data *data_p;

@end

#pragma mark - Response14001_Data

typedef GPB_ENUM(Response14001_Data_FieldNumber) {
  Response14001_Data_FieldNumber_UpdateState = 1,
  Response14001_Data_FieldNumber_LastedVersion = 2,
  Response14001_Data_FieldNumber_DownloadURL = 3,
};

@interface Response14001_Data : GPBMessage

//返回的数据
@property(nonatomic, readwrite) int32_t updateState;

//最新版本号     当有更新时才会传入该数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *lastedVersion;

//下载新版本url   当有更新时才会传入该数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *downloadURL;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
