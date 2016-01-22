//
//  DBSearch.m
//  Weclub
//
//  Created by lsp's mac pro on 16/1/21.
//  Copyright © 2016年 BIT. All rights reserved.
//

#import "DBSearch.h"
static DBSearch *singleInstance;
@implementation DBSearch
+(DBSearch *)sharedInfo{
    @synchronized(self){
        if (singleInstance==nil) {
            singleInstance=[[self alloc] init];
        }
    }
    return singleInstance;
}
-(BOOL)InsertSearchHistory:(NSString *)searchStr{
    if (![self openDB]) {
        return NO;
    }
    NSString *delectStr=[NSString stringWithFormat:@"DELETE  FROM tb_history WHERE history_value='%@'",searchStr];
    char *error;
    int delectSuccess=sqlite3_exec(_datebase, [delectStr UTF8String], nil, nil, &error);
    if (delectSuccess!=SQLITE_OK) {
        NSLog(@"删除搜索历史失败");
        sqlite3_close(_datebase);
        return NO;
    }
    NSString *sqlStr=[NSString stringWithFormat:@"INSERT INTO tb_history(history_value)  VALUES('%@')",searchStr];
    int success=sqlite3_exec(_datebase, [sqlStr UTF8String], nil, nil, &error);
    if (success!=SQLITE_OK) {
        NSLog(@"添加搜索历史失败");
        sqlite3_close(_datebase);
        return NO;
    }
    sqlite3_close(_datebase);
    NSLog(@"添加搜索历史成功");
    return YES;
    
}
-(BOOL)deleteSearchHistory{
    if (![self openDB]) {
        return NO;
    }
    NSString *delectStr=[NSString stringWithFormat:@"DELETE  FROM tb_history"];
    char *error;
    int delectSuccess=sqlite3_exec(_datebase, [delectStr UTF8String], nil, nil, &error);
    if (delectSuccess!=SQLITE_OK) {
        NSLog(@"删除搜索历史失败");
        sqlite3_close(_datebase);
        return NO;
    }
    sqlite3_close(_datebase);
    NSLog(@"删除搜索历史成功");
    return YES;
    
}

-(NSMutableArray *)AllSearchHistory{
    NSMutableArray *mutArray=[NSMutableArray array];
    if (![self openDB]) {
        return nil;
    }
    sqlite3_stmt *statement;
    NSString *sqlStr=[NSString stringWithFormat:@"SELECT *FROM tb_history ORDER BY history_id DESC"];
    
    int sqlResult=sqlite3_prepare_v2(_datebase, [sqlStr UTF8String], -1, &statement, nil);
    if (sqlResult!=SQLITE_OK) {
        NSLog(@"查询语句编译失败");
        return nil;
    }
    while(sqlite3_step(statement)==SQLITE_ROW) {
        NSString *searchStr=[NSString string];
        char *searchName=(char *)sqlite3_column_text(statement, 1);
        if (searchName) {
            searchStr=[NSString stringWithUTF8String:searchName];
        }
        [mutArray addObject:searchStr];
    }
    sqlite3_close(_datebase);
    return mutArray;
}
-(BOOL)openDB{
    NSString *pathStr=[MyFile fileByDocumentPath:@"/DB_RongCloud.sqlite"];
    int openNum=sqlite3_open([pathStr UTF8String], &_datebase);
    if (openNum==SQLITE_OK) {
        NSLog(@"打开数据库成功");
        return YES;
    }else{
        NSLog(@"打开数据库失败");
        return NO;
    }
}
@end
