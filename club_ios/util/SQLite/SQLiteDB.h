//
//  SQLiteDB.h
//  Ceshi
//
//  Created by chen on 16/1/13.
//  Copyright © 2016年 jeck. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserModel.h"
#import <RongIMKit/RongIMKit.h>

//创建数据表有两种方式：方式一：代码创建；方式二：在程序第一次进入的时候将手动创建的数据文件拷贝到沙盒中

@interface SQLiteDB : NSObject

/**
 *  单例方法
 *
 *  @return 单例对象
 */
+ (instancetype)shareSQLiteDB;

/**
 *  插入数据
 *
 *  @param key        字段
 *  @param jsonString 数据
 *
 *  @return 是否成功
 */
- (BOOL)addDataWithKey:(NSString *)key json:(NSString *)jsonString;

/**
 *  更新数据
 *
 *  @param key        字段
 *  @param jsonString 数据
 *
 *  @return 是否成功
 */
- (BOOL)updateDataWithKey:(NSString *)key json:(NSString *)jsonString;

/**
 *  删除数据
 *
 *  @param key 字段
 *
 *  @return 是否成功
 */
- (BOOL)deleteDataWithKey:(NSString *)key;

/**
 *  查询数据
 *
 *  @param key 字段
 *
 *  @return 查询的数据列表
 */
- (NSArray *)queryDataWithKey:(NSString *)key;


/**
 *  创建表格
 *
 *  @param tableFormat 表的格式: @"user(name text,age int,num text)"
 *
 *  @return 是否创建成功
 */

- (BOOL)creatTableWithTableFormat:(NSString *)tableFormat;
/**
 *  删除表格
 *
 *  @param name 表名
 *
 *  @return 是否删除成功
 */
- (BOOL)deleteTableWithName:(NSString *)name;
//字典转json
- (NSString *)jsonStringFromDictionary:(NSDictionary *)dic;
//json转字典
- (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString;
//DML
//添加用户
+ (void)addUser:(RCUserInfo* )userInfo;
//异步查询
+ (void)finderUser:(void(^)(NSArray *))completionBlock;
@end
