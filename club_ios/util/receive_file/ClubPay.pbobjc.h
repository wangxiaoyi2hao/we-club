// Generated by the protocol buffer compiler.  DO NOT EDIT!
// source: clubPay.proto

#import "GPBProtocolBuffers.h"

#if GOOGLE_PROTOBUF_OBJC_GEN_VERSION != 30000
#error This file was generated by a different version of protoc-gen-objc which is incompatible with your Protocol Buffer sources.
#endif

// @@protoc_insertion_point(imports)

CF_EXTERN_C_BEGIN

@class Request13001_Params;
@class Request13002_Params;
@class RequestCommon;
@class Response13001_Data;
@class Response13002_Data;
@class ResponseCommon;

NS_ASSUME_NONNULL_BEGIN

#pragma mark - ClubPayRoot

@interface ClubPayRoot : GPBRootObject

// The base class provides:
//   + (GPBExtensionRegistry *)extensionRegistry;
// which is an GPBExtensionRegistry that includes all the extensions defined by
// this file and all files that it depends on.

@end

#pragma mark - Request13001

typedef GPB_ENUM(Request13001_FieldNumber) {
  Request13001_FieldNumber_Common = 1,
  Request13001_FieldNumber_Params = 2,
};

//调用生成订单 接口
//url: /payAction/unifiedorder
@interface Request13001 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request13001_Params *params;

@end

#pragma mark - Request13001_Params

typedef GPB_ENUM(Request13001_Params_FieldNumber) {
  Request13001_Params_FieldNumber_TotalFee = 1,
};

@interface Request13001_Params : GPBMessage

//总金额
@property(nonatomic, readwrite) int32_t totalFee;

@end

#pragma mark - Response13001

typedef GPB_ENUM(Response13001_FieldNumber) {
  Response13001_FieldNumber_Common = 1,
  Response13001_FieldNumber_Data_p = 2,
};

@interface Response13001 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response13001_Data *data_p;

@end

#pragma mark - Response13001_Data

typedef GPB_ENUM(Response13001_Data_FieldNumber) {
  Response13001_Data_FieldNumber_PrepayId = 1,
  Response13001_Data_FieldNumber_OrderId = 2,
};

@interface Response13001_Data : GPBMessage

//返回的数据
@property(nonatomic, readwrite, copy, null_resettable) NSString *prepayId;

//app内该订单的id
@property(nonatomic, readwrite, copy, null_resettable) NSString *orderId;

@end

#pragma mark - Request13002

typedef GPB_ENUM(Request13002_FieldNumber) {
  Request13002_FieldNumber_Common = 1,
  Request13002_FieldNumber_Params = 2,
};

//不管支付结果如何 都会调用一次该接口
//url: /payAction/verifyPayState
@interface Request13002 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) RequestCommon *common;

@property(nonatomic, readwrite) BOOL hasParams;
@property(nonatomic, readwrite, strong, null_resettable) Request13002_Params *params;

@end

#pragma mark - Request13002_Params

typedef GPB_ENUM(Request13002_Params_FieldNumber) {
  Request13002_Params_FieldNumber_PrepayId = 1,
  Request13002_Params_FieldNumber_OrderId = 2,
  Request13002_Params_FieldNumber_Success = 3,
};

@interface Request13002_Params : GPBMessage

//微信的预付订单的id
@property(nonatomic, readwrite, copy, null_resettable) NSString *prepayId;

//app内该订单的id
@property(nonatomic, readwrite, copy, null_resettable) NSString *orderId;

//1:表示支付成功   2：表示支付失败
@property(nonatomic, readwrite) int32_t success;

@end

#pragma mark - Response13002

typedef GPB_ENUM(Response13002_FieldNumber) {
  Response13002_FieldNumber_Common = 1,
  Response13002_FieldNumber_Data_p = 2,
};

@interface Response13002 : GPBMessage

@property(nonatomic, readwrite) BOOL hasCommon;
@property(nonatomic, readwrite, strong, null_resettable) ResponseCommon *common;

@property(nonatomic, readwrite) BOOL hasData_p;
@property(nonatomic, readwrite, strong, null_resettable) Response13002_Data *data_p;

@end

#pragma mark - Response13002_Data

typedef GPB_ENUM(Response13002_Data_FieldNumber) {
  Response13002_Data_FieldNumber_Success = 1,
};

@interface Response13002_Data : GPBMessage

//返回的数据
@property(nonatomic, readwrite) int32_t success;

@end

NS_ASSUME_NONNULL_END

CF_EXTERN_C_END

// @@protoc_insertion_point(global_scope)
