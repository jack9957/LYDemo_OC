//
//  UserInfoViewModel.h
//  TestPro
//
//  Created by liyang on 16/9/5.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <Foundation/Foundation.h>
@class UserInfo;

@interface UserInfoViewModel : NSObject

/**
 *  单例的构造方法
 *
 *  @return 单例
 */
+ (instancetype)sharedInstance;

/**
 *  保存用户信息
 *
 *  @param dic 用户信息
 *
 *  @return 结果
 */
- (BOOL)saveUserInfoWithDic:(NSDictionary *)dic;

/**
 *  删除用户信息
 *
 *  @return 删除用户信息
 */
- (BOOL)deleteUserInfo;

/** UserInfo */
@property (nonatomic, strong) UserInfo *userInfo;

/** 存储路径 */
@property (nonatomic, strong) NSString *userPath;

/** 判断用户是否登录,yes 用户登录， no 用户没有登录 */
@property (nonatomic, assign, getter=isUserLog) BOOL userLog;


@end







// 用户类的声明
@interface UserInfo : NSObject <NSCoding>

/** 用户id  */
@property (nonatomic, copy) NSString *u_id;
/** 用户昵称  */
@property (nonatomic, copy) NSString *nickName;
/** 用户手机号  */
@property (nonatomic, copy) NSString *phone;
/** 用户头像缩略图  */
@property (nonatomic, copy) NSString *thumbImgUrl;
/** 用户头像原图  */
@property (nonatomic, copy) NSString *originImgUrl;

/** 用户微信openid  */
@property (nonatomic, copy) NSString *weichatOpenid;

+ (instancetype)userInfoWithDic:(NSDictionary *)dic;

@end







