//
//  RCDataManager.m
//  Weclub
//
//  Created by chen on 15/12/30.
//  Copyright © 2015年 BIT. All rights reserved.
//

#import "RCDataManager.h"
#import "UserInfo.h"
#import "AppDelegate.h"
#import "ChatViewController.h"
#import "BarTabBarController.h"
#import "SQLiteDB.h"

extern UserInfo *LoginUserInfo;
extern NSMutableArray *friendsAndRoucludUserInfoArray;
extern NSMutableArray *rouclubGroupInfoArray;
@implementation RCDataManager{
    
    NSMutableArray *dataSoure;
    ASIFormDataRequest*_reuqestGroup;
    
}
-(instancetype)init{
    
    if (self = [super init]) {
        dataSoure = [[NSMutableArray alloc]init];
    }
    
    return self;
    
}
+(RCDataManager *)shareManager{
    
    static RCDataManager* manager = nil;
    
    static dispatch_once_t predicate;
    
    dispatch_once(&predicate, ^{
        
        manager = [[[self class] alloc] init];
    });
    
    return manager;
    
}
//登录融云
-(void)loginRongCloud{
    NSLog(@"%@",LoginUserInfo.rongYunTOken);
    // 快速集成第二步，连接融云服务器
    [[RCIM sharedRCIM] connectWithToken:LoginUserInfo.rongYunTOken success:^(NSString *userId) {
//        //同步好友列表
//        [self syncFriendList:^(NSMutableArray *friends,BOOL isSuccess) {
//            
//            NSLog(@"%@",friends);
//            
//            if (isSuccess) {
//                
//                NSLog(@" success发送通知");
//                
//                //[[NSNotificationCenter defaultCenter]postNotificationName:@"alreadyLogin" object:nil];
//                //发送自定义通知（不是融云的），处理一些逻辑，比如什么各单位注意，我已登录，我已登录。
//            }            
//        }];
//        //初始化个人信息(暂时)
//        [RCIM sharedRCIM].currentUserInfo = [[RCUserInfo alloc] initWithUserId:LoginUserInfo.user_id name:LoginUserInfo.user_name portrait:LoginUserInfo.user_head];
        // Connect 成功,会返回用户的userId
        NSLog(@"链接融云成功");
        /*
         默认NO，如果YES，发送消息会包含自己用户信息。
         */
        [RCIM sharedRCIM].enableMessageAttachUserInfo = YES;
        RCUserInfo *user = [[RCUserInfo alloc]init];
        user.userId = LoginUserInfo.user_id;
        user.name = LoginUserInfo.user_name;
        user.portraitUri = LoginUserInfo.user_head;
        [RCIMClient sharedRCIMClient].currentUserInfo = user;

        //异步查询数据库(需添加群组信息进数据库)
        [SQLiteDB finderUser:^(NSArray *result) {
            NSLog(@"%ld",friendsAndRoucludUserInfoArray.count);
            //把数据库中消息加入融云本地列表
            [friendsAndRoucludUserInfoArray addObjectsFromArray:(NSArray *)result];
            NSLog(@"result：%@",result);
             NSLog(@"%ld",result.count);
            NSLog(@"%ld",friendsAndRoucludUserInfoArray.count);
            
            for (int i =0; i<result.count; i++) {
                RCUserInfo *usereee = result[i];
                NSLog(@"%@",usereee.portraitUri);
                
            }
        }];
        
        
    }
                                  error:^(RCConnectErrorCode status) {
                                      
                                      
                                  }
                         tokenIncorrect:^() {
                             self.success =NO;
                             NSLog(@"token失效");
                             
                             
                         }];    
}

-(void)requestGroupMessage:(NSString*)talekTeamId{
    Request11018*request=[[Request11018 alloc]init];
    NSString*strUrl=[NSString stringWithFormat:@"%@clubAction/getTalkTeamUsers",REQUESTURL];
    NSURL *url = [NSURL URLWithString:strUrl];
    _reuqestGroup = [ASIFormDataRequest requestWithURL:url];
    request.common.platform=2;//已经传好
    request.common.version=@"1.0.0";//版本号
    request.common.timestamp=[[NSDate date]timeIntervalSince1970];//当前时间戳//_passwordText
    request.common.cmdid=10002;
    request.params.talkTeamId=talekTeamId;
    NSLog(@"%@",LoginUserInfo.user_pwd);
    NSData*data= [request data];
    [_reuqestGroup setPostBody:(NSMutableData*)data];
    [_reuqestGroup setDelegate:self];
    //请求延迟时间
    _reuqestGroup.timeOutSeconds=0;
    [ASIHTTPRequest setDefaultCache:[ASIDownloadCache sharedCache]];
    _reuqestGroup.cachePolicy=ASIFallbackToCacheIfLoadFailsCachePolicy;
    //设置缓存的保存方式，ASICachePermanentlyCacheStoragePolicy为永久保存
    _reuqestGroup.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;
    _reuqestGroup.secondsToCache=3600;
    [_reuqestGroup startAsynchronous];
}
- (void)requestFinished:(ASIHTTPRequest *)request{
    if ([request isEqual:_reuqestGroup]) {
        Response11018*reponse11018 = [Response11018 parseFromData:request.responseData error:nil];
        if (reponse11018.common.code!=0) {
           
        }else{
            NSLog(@"%@",reponse11018.data_p.chatUsersArray);
        }
    }
}
-(void)syncFriendList:(void (^)(NSMutableArray* friends,BOOL isSuccess))completion
{ //这里是用户的身份，可能其他开发者不需要这个逻辑，不需要的话，就直接调用好友列表的接口，拿到好友列表的数组，做成RCUserInfo，然后add进去数组。就这简单！ UsersType type = [MSUtil checkUserType];
    //网络请求下来的数据做成RCUserInfo,然后add进去数组
    for (int i=0;i<friendsAndRoucludUserInfoArray.count;i++) {
        UserAvatarAndName*userAvatat = friendsAndRoucludUserInfoArray[i];
        NSLog(@"======%@",userAvatat.userid);
        NSLog(@"======%@",userAvatat.username);
        NSLog(@"======%@",userAvatat.avatar);
        RCUserInfo *aUser = [[RCUserInfo alloc] initWithUserId:userAvatat.userid name:userAvatat.username portrait:userAvatat.avatar];
        [dataSoure addObject:aUser];
    }
    friendsAndRoucludUserInfoArray = dataSoure;
            
    completion(friendsAndRoucludUserInfoArray,YES);
    if (friendsAndRoucludUserInfoArray.count) {
        NSLog(@"从服务器同步好友列表成功FFF");
        if ([RCIMClient sharedRCIMClient].currentUserInfo.userId) {
            
        }else{
                        
            [self loginRongCloud];
        }
                    
    }
            
}

///**
// * 本地用户信息改变，调用此方法更新kit层用户缓存信息
// * @param userInfo 要更新的用户实体
// * @param userId  要更新的用户Id
// */
//- (void)refreshUserInfoCache:(RCUserInfo *)userInfo
//                  withUserId:(NSString *)userId{
//    
//}
#pragma mark- 融云个人信息提供
// 获取用户信息的方法。
-(void)getUserInfoWithUserId:(NSString *)userId completion:(void(^)(RCUserInfo* userInfo))completion
{
    if (userId == nil || [userId length] == 0 )
    {
        completion(nil);
        return ;
    }
    
    if ([userId isEqualToString:[RCIM sharedRCIM].currentUserInfo.userId]) {
        //显示自己的信息
        RCUserInfo *aUser = [[RCUserInfo alloc] initWithUserId:LoginUserInfo.user_id name:LoginUserInfo.user_name portrait:LoginUserInfo.user_head];
        completion(aUser);
        
    }else{
        //显示好友的信息
        for (NSInteger i =0; i<friendsAndRoucludUserInfoArray.count; i++) {
            //循环全局的好友数组，拿到userId相同的，比如，userId＝ 12的是老王，那么循环，找到数组中userId＝12的，那么肯定就是老王啦。那么肯定就配置好老王的信息了，和老王聊天的时候，融云内部封装的方法就可以拿到老王的信息，这样老王的头像和名字就可以出来了
            
            RCUserInfo *aUser = friendsAndRoucludUserInfoArray[i];
            
            if ([userId isEqualToString:aUser.userId]) {
                completion(aUser);
            }
        }
    }
    
}
/*!
 获取群组信息
 
 @param groupId                     群组ID
 @param completion                  获取群组信息完成之后需要执行的Block
 @param groupInfo(in completion)    该群组ID对应的群组信息
 
 @discussion SDK通过此方法获取用户信息并显示，请在completion的block中返回该用户ID对应的用户信息。
 在您设置了用户信息提供者之后，SDK在需要显示用户信息的时候，会调用此方法，向您请求用户信息用于显示。
 */
//每次需要显示群组信息时会调用
#pragma mark- 融云群组信息提供
- (void)getGroupInfoWithGroupId:(NSString *)groupId
                     completion:(void (^)(RCGroup *groupInfo))completion{
    
    if (groupId == nil || [groupId length] == 0 ){
        completion(nil);
        return ;
    }else{
        
        
    }
    //显示好友的信息
    for (NSInteger i =0; i<rouclubGroupInfoArray.count; i++) {
        //逻辑同好友信息的显示
        RCGroup *groupInfo = rouclubGroupInfoArray[i];
        
        if ([groupId isEqualToString:groupInfo.groupId]) {
            completion(groupInfo);
        }
    }
//    RCGroup *groupInfo = [[RCGroup alloc] initWithGroupId:groupId groupName:@"啥名字好呢?" portraitUri:@"http://v1.qzone.cc/avatar/201408/20/17/23/53f468ff9c337550.jpg!200x200.jpg"];
//
//    
//    //    _groupUserInfo=[[RCGroup alloc]init];
//    //    _groupUserInfo.groupId=groupId;
//    //    NSLog(@"%@",groupId);
//        completion(groupInfo);
}

// @param message 收到的消息实体。
// @param nLeft 剩余消息数。
// 这里是融云的监听消息事件，这个代理会在每次接收到消息的时候走，所以我们可以在这个方法中处理逻辑了，我处理的逻辑有勿扰时段和头像的及时更新等等
- (void)onRCIMReceiveMessage:(RCMessage *)message left:(int)left{
    //获取好友信息
    NSString *extraString = nil;
    if ([message.content isKindOfClass:[RCTextMessage class]]) {
        
        RCTextMessage *textMessage = (RCTextMessage*)message.content;
        NSLog(@"=====+++++%@",[textMessage valueForKey:@"extra"]);
        extraString =[textMessage valueForKey:@"extra"];
        
        
    }else if ([message.content isKindOfClass:[RCVoiceMessage class]]) {
        
        RCVoiceMessage *voiceMessage = (RCVoiceMessage*)message.content;
        NSLog(@"=====+++++%@",[voiceMessage valueForKey:@"extra"]);
        extraString =[voiceMessage valueForKey:@"extra"];
        
        
    }else if ([message.content isKindOfClass:[RCImageMessage class]]) {
        
        RCImageMessage *imageMessage = (RCImageMessage*)message.content;
        NSLog(@"=====+++++%@",[imageMessage valueForKey:@"extra"]);
        extraString =[imageMessage valueForKey:@"extra"];
        
    }
    
    if (extraString) {
        NSData *jsonData = [extraString dataUsingEncoding:NSUTF8StringEncoding]; NSError *err;
        if (jsonData) {
            //拿到字符串，转换称Data，然后转成我们经常用的字典。
            NSDictionary *userInfoDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&err];
            NSLog(@"FFFFF%@",userInfoDic);
            if (userInfoDic) {
                //用RCDataManager的API直接拿到发送者老王的userInfo，然后下面就是比较头像的url是否一样了。
                //发送者的信息对象(任意发消息过来的人)
                RCUserInfo *theLastedInfo = [[RCUserInfo alloc] initWithUserId:userInfoDic[@"sendUsersId"] name:userInfoDic[@"sendUsersName"] portrait:userInfoDic[@"sendUsersPhoto"]];
                //获取好友对象(从好友列表中取出)
                RCUserInfo *senderInfo = [[RCDataManager shareManager] currentUserInfoWithUserId:userInfoDic[@"sendUsersId"]];
                NSLog(@"%@",userInfoDic[@"sendUsersPhoto"]);
                    NSLog(@"%@",senderInfo.portraitUri);
                if (senderInfo.userId == nil) {
                    //这里把对方信息存入沙盒里的数据库中
                    [SQLiteDB addUser:theLastedInfo];
                }
//                //异步查询数据库
//                [SQLiteDB finderUser:^(NSArray *result) {
//                    for (int i= 0; i<result.count; i++) {
//                        
//                        RCUserInfo *userInfo = result[i];
//                        //当数据库中没有这个id的时候
//                        if (![theLastedInfo.userId isEqualToString:userInfo.userId]) {
//                            //这里把对方信息存入沙盒里的数据库中
//                            [SQLiteDB addUser:theLastedInfo];
//                        }else{
//                            //当数据库中有这个id时,并且本地用户信息改变(名字或者头像不同时)
//                            if ((![userInfoDic[@"sendUsersPhoto"] isEqualToString:userInfo.portraitUri]) || (![userInfoDic[@"sendUsersName"] isEqualToString:userInfo.name])) {
//                                //修改数据库中数据
//                                NSLog(@"此处应该修改数据库中数据");
//                                
//                                
//                            }
//                            
//                            
//                            
//                        }
//                    }
//                    NSLog(@"%ld",friendsAndRoucludUserInfoArray.count);
//                    [friendsAndRoucludUserInfoArray addObjectsFromArray:result];
//                    NSLog(@"result：%@",result);
//                    NSLog(@"%ld",friendsAndRoucludUserInfoArray.count);
//                }];

                //本地用户信息改变(名字或者头像不同时)
                if ((![userInfoDic[@"sendUsersPhoto"] isEqualToString:senderInfo.portraitUri]) || (![userInfoDic[@"sendUsersName"] isEqualToString:senderInfo.name])) {
                    NSDictionary *dic =@{
                                         @"user_id":userInfoDic[@"sendUsersId"],
                                         @"user_name":userInfoDic[@"sendUsersName"],
                                         @"user_icon":userInfoDic[@"sendUsersPhoto"]
                                         };
                    //更新非好友,存到沙盒
                    [[SQLiteDB shareSQLiteDB] updateDataWithKey:@"dic" json:[[SQLiteDB shareSQLiteDB] jsonStringFromDictionary:dic]];
                    NSLog(@"%@",userInfoDic[@"sendUsersId"]);
                    NSLog(@"%@",userInfoDic[@"sendUsersName"]);
                    NSLog(@"%@",userInfoDic[@"sendUsersPhoto"]);
                    /**
                     * 本地用户信息改变，调用此方法更新kit层用户缓存信息
                     * @param userInfo 要更新的用户实体
                     * @param userId  要更新的用户Id
                     */
                    NSLog(@"%@",theLastedInfo.portraitUri);
                    
                    [[RCIM sharedRCIM] refreshUserInfoCache:theLastedInfo withUserId:userInfoDic[@"sendUsersId"]];
                    //刷新聊天列表
                    [[ChatViewController shareChat].conversationMessageCollectionView reloadData];
                }else{
//                //这里更新好友的最新列表
//                [[RCDataManager shareManager] syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
//                if (isSuccess) {
                    //这里更新融云缓存，不更新缓存是不行的，我已经实验过了
//                    NSLog(@"%@",userInfoDic[@"sendUsersId"]);
//                    NSLog(@"%@",userInfoDic[@"sendUsersName"]);
//                    NSLog(@"%@",userInfoDic[@"sendUsersPhoto"]);
//                    [[RCIM sharedRCIM] refreshUserInfoCache:theLastedInfo withUserId:userInfoDic[@"sendUsersId"]];
                    
//                }else{
//                    [[RCDataManager shareManager] syncFriendList:^(NSMutableArray *friends, BOOL isSuccess) {
//                        
//                    }];
//                }
//            }];
        }
    }
    }
    }
    //设置消息提醒
    NSUserDefaults *userDefaultes = [NSUserDefaults standardUserDefaults];
    NSInteger number3 = [userDefaultes integerForKey:@"_number3"];
    if (number3 ==1) {
        // 震动 首先要引入头文件
        LxxPlaySound *playSound =[[LxxPlaySound alloc]initForPlayingVibrate];
        [playSound play];
        
    }
    //    NSInteger number2 = [userDefaultes integerForKey:@"_number2"];
    //    if (number2 ==1) {
    //        //自定义声音
    //        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSoundEffectWith:@"tap.aif"];
    //        [sound play];
    ////        LxxPlaySound *sound = [[LxxPlaySound alloc]initForPlayingSystemSoundEffectWith:@"1007" ofType:@"aiff"];
    ////        [sound play];
    //    
    //    }
}
//刷新角标
-(void)refreshBadgeValue{
    dispatch_async(dispatch_get_main_queue(), ^{
        
//        int notReadMessage = [[UserInfoModel currentUserinfo].notReadMessage intValue];
        int notReadMessage = [[RCIMClient sharedRCIMClient] getTotalUnreadCount];
        
        
        
        NSInteger unreadMsgCount = (NSInteger)[[RCIMClient sharedRCIMClient] getUnreadCount:@[@(ConversationType_PRIVATE)]];
        
        
        if (unreadMsgCount == 0) {
            
            [BarTabBarController shareBarTabBarController].numberLabel.text = nil;
            
            if (notReadMessage > 0) {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = notReadMessage;
                
            }else{
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = 0;
                
            }
        }else{
            
            [BarTabBarController shareBarTabBarController].numberLabel.text = [NSString stringWithFormat:@"%li",(long)unreadMsgCount];
            
            if (notReadMessage > 0) {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount + notReadMessage;
                
            }
            
            else {
                
                [UIApplication sharedApplication].applicationIconBadgeNumber = unreadMsgCount;
                
            } 
        }
        
    });
}
//获取当前用户名
-(NSString *)currentNameWithUserId:(NSString *)userId{
    
    for (NSInteger i = 0; i<friendsAndRoucludUserInfoArray.count; i++) {
        
        RCUserInfo *aUser = friendsAndRoucludUserInfoArray[i];
        
        if ([userId isEqualToString:aUser.userId]) {
            
            NSLog(@"current ＝ %@",aUser.name);
            
            return aUser.name;
            
        }
        
    }
    
    return nil;
}
//获取一个userId对应的好友对象，这个对象我们叫做RCUserInfo，这个是融云的类，我们看看源代码的.h里面怎么写
-(RCUserInfo *)currentUserInfoWithUserId:(NSString *)userId{
    
    for (NSInteger i = 0; i<friendsAndRoucludUserInfoArray.count; i++) {
        
        RCUserInfo *aUser = friendsAndRoucludUserInfoArray[i];
        
        if ([userId isEqualToString:aUser.userId]) {
            
            NSLog(@"current ＝ %@",aUser.name);
            
            return aUser;
            
        }
    }
    return nil;
}


@end
