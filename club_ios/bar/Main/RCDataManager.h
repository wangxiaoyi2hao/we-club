//
//  RCDataManager.h
//  Weclub
//
//  Created by chen on 15/12/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <RongIMKit/RongIMKit.h>

@interface RCDataManager : NSObject<RCIMUserInfoDataSource,RCIMGroupInfoDataSource,RCIMReceiveMessageDelegate>
@property(nonatomic,assign)BOOL success;
@property(nonatomic,strong)NSMutableArray *unFriendInfoArray;
//单人
//@property (nonatomic,retain)RCUserInfo*strangeruserinfo;

+(RCDataManager *) shareManager;

-(void)getUserInfoWithUserId:(NSString *)userId completion:(void (^)(RCUserInfo *))completion;
/**
 
 从服务器同步好友列表
 
 */

-(BOOL)hasTheFriendWithUserId:(NSString *)userId;
//登录融云
-(void)loginRongCloud;
//同步好友列表的方法，用此方法可以刷新到最新的好友列表，比如有新朋友了，那么就要同步一下
-(void) syncFriendList:(void (^)(NSMutableArray * friends,BOOL isSuccess))completion;
//刷新角标
-(void)refreshBadgeValue;

-(NSString *)currentNameWithUserId:(NSString *)userId;

-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId;
//监听网络状态变化
-(void)onRCIMConnectionStatusChanged:(RCConnectionStatus)status;
@end
