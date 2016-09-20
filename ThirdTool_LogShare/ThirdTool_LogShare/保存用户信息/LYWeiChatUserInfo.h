//
//  LYWeiChatUserInfo.h
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/20.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LYWeiChatUserInfo : NSObject

/** 普通用户的标识，对当前开发者帐号唯一  */
@property (nonatomic, copy) NSString *openid;

/** 用户昵称  */
@property (nonatomic, copy) NSString *nickname;

/** sex:1为男性，2为女性  */
@property (nonatomic, copy) NSNumber *sex;

/** 普通用户个人资料填写的省份  */
@property (nonatomic, copy) NSString *province;

/** 普通用户个人资料填写的城市  */
@property (nonatomic, copy) NSString *city;

/** 国家  */
@property (nonatomic, copy) NSString *country;

/** 语音  */
@property (nonatomic, copy) NSString *language;

/** 用户头像，最后一个数值代表正方形头像大小（有0、46、64、96、132数值可选，0代表640*640正方形头像），用户没有头像时该项为空  */
@property (nonatomic, copy) NSString *headimgurl;

/** 用户特权信息，json数组 */
@property (nonatomic, strong) NSArray *privilege;

/** 用户统一标识。针对一个微信开放平台帐号下的应用，同一用户的unionid是唯一的  */
@property (nonatomic, copy) NSString *unionid;

+ (instancetype)weichatUserInfoWithDic:(NSDictionary *)dic;

@end
