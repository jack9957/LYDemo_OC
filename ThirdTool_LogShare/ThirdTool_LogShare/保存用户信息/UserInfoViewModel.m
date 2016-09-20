//
//  UserInfoViewModel.m
//  TestPro
//
//  Created by liyang on 16/9/5.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "UserInfoViewModel.h"

@implementation UserInfoViewModel

/**
 *  单例的构造方法
 *
 *  @return 单例
 */
+ (instancetype)sharedInstance
{
    static UserInfoViewModel *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

/**
 *  保存用户信息
 *
 *  @param dic 用户信息
 *
 *  @return 结果
 */
- (BOOL)saveUserInfoWithDic:(NSDictionary *)dic
{
    UserInfo *user = [[UserInfo alloc] init];
    [user setValuesForKeysWithDictionary:dic];
    return [NSKeyedArchiver archiveRootObject:user toFile:[UserInfoViewModel sharedInstance].userPath];
}

/**
 *  删除用户信息
 *
 *  @return 删除用户信息
 */
- (BOOL)deleteUserInfo
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:self.userPath]) {
        return [fileManager removeItemAtPath:self.userPath error:nil];
    }
    NSLog(@"不存在该文件");
    return NO;
}

/**
 *  用户信息
 *
 *  @return 返回用户信息
 */
- (UserInfo *)userInfo
{
    return [NSKeyedUnarchiver unarchiveObjectWithFile:self.userPath];
}

/**
 *  存储用户信息的路径
 *
 *  @return 路径
 */
- (NSString *)userPath
{
    return [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject] stringByAppendingPathComponent:@"useInfo.plist"];
}

/**
 *  判断用户是否登录过
 *
 *  @return 结果
 */
- (BOOL)isUserLog
{
    return self.userInfo == nil ? NO : YES;
}


@end




// 用户类的实现
@implementation UserInfo

+ (instancetype)userInfoWithDic:(NSDictionary *)dic
{
    UserInfo *userInfo = [[UserInfo alloc] init];
    [userInfo setValuesForKeysWithDictionary:dic];
    return userInfo;
}

/**
 *  解档
 *
 *  @param coder 解档
 *
 *  @return 解档
 */
- (instancetype)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    if (self) {
        self.u_id = [coder decodeObjectForKey:@"u_id"];
        self.nickName = [coder decodeObjectForKey:@"nickName"];
        self.phone = [coder decodeObjectForKey:@"phone"];
        self.thumbImgUrl = [coder decodeObjectForKey:@"thumbImgUrl"];
        self.originImgUrl = [coder decodeObjectForKey:@"originImgUrl"];
        self.weichatOpenid = [coder decodeObjectForKey:@"weichatOpenid"];
    }
    return self;
}

/**
 *  归档
 *
 *  @param aCoder 归档
 */
- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.u_id forKey:@"u_id"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.phone forKey:@"phone"];
    [aCoder encodeObject:self.thumbImgUrl forKey:@"thumbImgUrl"];
    [aCoder encodeObject:self.originImgUrl forKey:@"originImgUrl"];
    [aCoder encodeObject:self.weichatOpenid forKey:@"weichatOpenid"];
}


- (NSString *)description
{
    return [self dictionaryWithValuesForKeys:@[@"u_id", @"nickName", @"phone", @"thumbImgUrl", @"originImgUrl",@"weichatOpenid"]].description;
}

@end




