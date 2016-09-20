//
//  LYWeiChatUserInfo.m
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/20.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYWeiChatUserInfo.h"

@implementation LYWeiChatUserInfo

+ (instancetype)weichatUserInfoWithDic:(NSDictionary *)dic
{
    LYWeiChatUserInfo *weichat = [[LYWeiChatUserInfo alloc] init];
    [weichat setValuesForKeysWithDictionary:dic];
    return weichat;
}

- (NSString *)description
{
    return [self dictionaryWithValuesForKeys:@[@"openid",@"nickname",@"sex",@"headimgurl",@"province",@"city",@"country"]].description;
}

- (void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    
}

@end
