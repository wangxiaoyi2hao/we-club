//
//  SQLiteDB.m
//  Ceshi
//
//  Created by chen on 16/1/13.
//  Copyright © 2016年 jeck. All rights reserved.
//

#import "SQLiteDB.h"
#import "EGODatabase.h"
#import "sqlite3.h"

#define PATH [NSHomeDirectory() stringByAppendingPathComponent:@"Documents/DB_RongCloud.sqlite"]
static SQLiteDB *instance = nil;
@interface SQLiteDB ()
{
    sqlite3 *_sqlite;
}
@end

@implementation SQLiteDB

- (void)dealloc {
    sqlite3_close(_sqlite);
}
#pragma mark - 单例方法
+ (instancetype)shareSQLiteDB {
    return [[self alloc] init];
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [super allocWithZone:zone];
        [instance openSqlite];
    });
    return instance;
}
#pragma mark - 打开数据库
- (void)openSqlite
{
    _sqlite = nil;
    
    int result = sqlite3_open([PATH UTF8String], &_sqlite);
    
    if (result == SQLITE_OK) {
        NSLog(@"打开数据库成功了");
    } else {
        NSLog(@"打开数据库失败了");
        return;
    }
    
    NSString *sqlStr = @"create table if not exists userInfo(dataName text,jsonString text)";
    char *error = nil;
    result = sqlite3_exec(_sqlite, [sqlStr UTF8String], NULL, NULL, &error);
    
    if (result != SQLITE_OK) {
        NSLog(@"创建userInfo表格失败了");
        sqlite3_close(_sqlite);
        return;
    }
    NSLog(@"创建userInfo表格成功了");
}
#pragma mark - 更新数据
- (BOOL)updateDataWithKey:(NSString *)key json:(NSString *)jsonString
{
    if ([self queryDataWithKey:key].count == 0) {
        return [self addDataWithKey:key json:jsonString];
    }
    
    sqlite3_stmt *sqlit_stmt = nil;
    NSString *sqlStr = @"update userInfo set jsonString=? where dataName=?";
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &sqlit_stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"更新数据失败");
        sqlite3_close(_sqlite);
        return NO;
    }
    
    sqlite3_bind_text(sqlit_stmt, 1, [key UTF8String], -1, nil);
    sqlite3_bind_text(sqlit_stmt, 2, [jsonString UTF8String], -1, nil);
    result = sqlite3_step(sqlit_stmt);
    if (result != SQLITE_DONE) {
        NSLog(@"更新数据失败");
        sqlite3_finalize(sqlit_stmt);
        return NO;
    }
    NSLog(@"更新数据成功");
    sqlite3_finalize(sqlit_stmt);
    return YES;
}
#pragma mark - 添加数据
- (BOOL)addDataWithKey:(NSString *)key json:(NSString *)jsonString
{
    sqlite3_stmt *sqlit_stmt = nil;
    
    NSString *sqlStr = @"insert into userInfo(dataName,jsonString) values(?,?)";
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &sqlit_stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"添加数据失败");
        sqlite3_close(_sqlite);
        return NO;
    }
    
    sqlite3_bind_text(sqlit_stmt, 1, [key UTF8String], -1, nil);
    sqlite3_bind_text(sqlit_stmt, 2, [jsonString UTF8String], -1, nil);
    result = sqlite3_step(sqlit_stmt);
    if (result != SQLITE_DONE) {
        NSLog(@"添加数据失败");
        sqlite3_finalize(sqlit_stmt);
        return NO;
    }
    NSLog(@"添加数据成功");
    sqlite3_finalize(sqlit_stmt);
    return YES;
}

#pragma mark - 删除数据
- (BOOL)deleteDataWithKey:(NSString *)key
{
    sqlite3_stmt *sqlit_stmt = nil;
    
    NSString *sqlStr = @"delete from userInfo where dataName=?";
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &sqlit_stmt, nil);
    if (result != SQLITE_OK) {
        NSLog(@"删除数据失败");
        return NO;
    }
    sqlite3_bind_text(sqlit_stmt, 1, [key UTF8String], -1, nil);
    result = sqlite3_step(sqlit_stmt);
    if (result != SQLITE_DONE) {
        NSLog(@"删除数据失败");
        return NO;
    }
    NSLog(@"删除数据成功");
    return YES;
}

#pragma mark - 查询数据
- (NSArray *)queryDataWithKey:(NSString *)key
{
    NSMutableArray *mArray = [NSMutableArray arrayWithCapacity:5];
    sqlite3_stmt *sqlite_stmt = nil;
    NSString *sqlStr = @"SELECT * FROM userInfo WHERE dataName=?";
    int result = sqlite3_prepare_v2(_sqlite, [sqlStr UTF8String], -1, &sqlite_stmt, nil);
    if (result != SQLITE_OK) {
        return mArray;
    }
    sqlite3_bind_text(sqlite_stmt, 1, [key UTF8String], -1, nil);
    result = sqlite3_step(sqlite_stmt);
    
    while (result == SQLITE_ROW) {
        const unsigned char *string = sqlite3_column_text(sqlite_stmt, 1);
        NSString *jsonString = [[NSString alloc] initWithCString:string encoding:NSUTF8StringEncoding];
        //        NSLog(@"%@",jsonString);
        if (jsonString != nil) {
            [mArray addObject:jsonString];
        }
        result = sqlite3_step(sqlite_stmt);
    }
    sqlite3_finalize(sqlite_stmt);
    return mArray;
}

#pragma mark - 创建表格
- (BOOL)creatTableWithTableFormat:(NSString *)tableFormat
{
    NSString *sqlStr = [NSString stringWithFormat:@"create table if not exists %@",tableFormat];
    char *error = nil;
    int result = sqlite3_exec(_sqlite, [sqlStr UTF8String], NULL, NULL, &error);
    
    if (result != SQLITE_OK) {
        NSLog(@"创建表格失败");
        sqlite3_close(_sqlite);
        return NO;
    }
    NSLog(@"创建表格成功");
    return YES;
}
#pragma mark - 删除表格
- (BOOL)deleteTableWithName:(NSString *)name
{
    NSString *sqlStr = [NSString stringWithFormat:@"drop table %@",name];
    char *error = nil;
    int result = sqlite3_exec(_sqlite, [sqlStr UTF8String], NULL, NULL, &error);
    
    if (result != SQLITE_OK) {
        NSLog(@"删除表格失败");
        sqlite3_close(_sqlite);
        return NO;
    }
    NSLog(@"删除表格成功");
    return YES;
}
//DML
//添加用户
+ (void)addUser:(RCUserInfo* )userInfo{
    
    //创建dataBase对象
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:PATH];
    
    //打开数据库
    [dataBase open];
    
    //构造SQL语句
    NSString *sql = @"INSERT INTO userInfo(user_id,user_name,user_icon) VALUES (?,?,?)";
    
    //执行
    NSArray *data = @[userInfo.userId,userInfo.name,userInfo.portraitUri];
    [dataBase executeQuery:sql parameters:data];
    
    //关闭
    [dataBase close];
    
}
//异步查询
+ (void)finderUser:(void(^)(NSArray *))completionBlock {
    
    //创建dataBase
    EGODatabase *dataBase = [[EGODatabase alloc] initWithPath:PATH];
    
    //构造SQL语句
    NSString *sql = @"SELECT * FROM userInfo";
    
    //同步查询
    //    [dataBase executeQuery:<#(NSString *)#> parameters:<#(NSArray *)#>]
    
    //异步查询
    EGODatabaseRequest *request = [dataBase requestWithQuery:sql];
    [request setCompletion:^(EGODatabaseRequest *request, EGODatabaseResult *result, NSError *error) {
        
        NSMutableArray *array = [[NSMutableArray alloc] init];
        
        for (int i=0; i<result.count; i++) {
            
            RCUserInfo*userInfo = [[RCUserInfo alloc] init];
            
            EGODatabaseRow *row = result.rows[i];
            
            userInfo.userId = [row stringForColumn:@"user_id"];
            [row stringForColumnAtIndex:1];
            userInfo.name = [row stringForColumnAtIndex:1];
            userInfo.portraitUri = [row stringForColumnAtIndex:2];
            [array addObject:userInfo];
        }
        
        //回调block
        completionBlock(array);
        
        //关闭数据库
        [dataBase close];
        
    }];
    
    //将operstion放到队列中
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    
    [queue addOperation:request];
    
    //关闭数据库
    //    [dataBase close];
    
}

//字典转json
- (NSString *)jsonStringFromDictionary:(NSDictionary *)dic
{
    NSError *parseError = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    NSString *jsonString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    return jsonString;
}
//json转字典
- (NSDictionary *)dictionaryFromJsonString:(NSString *)jsonString
{
    if (jsonString == nil) {
        return nil;
    }
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error = nil;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
    if (error) {
        NSLog(@"json解析失败:%@",error);
        return nil;
    }
    return dic;
}



@end
