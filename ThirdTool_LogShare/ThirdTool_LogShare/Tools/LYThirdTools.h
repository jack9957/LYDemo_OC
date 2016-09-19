//
//  LYThirdTools.h
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/19.
//  Copyright © 2016年 liyang. All rights reserved.
//

// 这是管理微信、微博、QQ的类，包括初始化，结果回调等

#import <Foundation/Foundation.h>
#import "WXApi.h"
@class LYToolModel;

/**
 分享

 - WeiChat: 分享到微信聊天界面
 - WeiChatTimeline: 分享到微信朋友圈
 - Sina:    分享到微博
 - QQ:      分享到QQ
 */
typedef NS_ENUM(NSUInteger, LYSharePlatForm) {
    WeiChatSession = 0,
    WeiChatTimeline,
    Sina,
    QQ
};

/**
 第三方登录

 - WeiChatLog: 微信登录
 - SinaLog:    微博登录
 - QQLog:      QQ登录
 */
typedef NS_ENUM(NSUInteger, LYThirdLog) {
    WeiChatLog,
    SinaLog,
    QQLog
};

@interface LYThirdTools : NSObject<WXApiDelegate>

/** 单例方法 */
+ (instancetype)sharedInstance;

/** 向各个三方机构注册 */
- (void)setupThirdTools;

/** 分享的方法 */
- (void)thirdToolsShareModel:(LYToolModel *)model toplatForm:(LYSharePlatForm)platForm;

/** 登录的方法 */
- (void)thirdToolsLog:(LYThirdLog)thirdLog;

@end




/**
 这是分享的模型类
 */
@interface LYToolModel : NSObject

/** 分享的一级文字  */
@property (nonatomic, copy) NSString *shareTitle;
/** 分享的二级文字  */
@property (nonatomic, copy) NSString *shareSubTitle;
/** 分享的图片  */
@property (nonatomic, strong) UIImage *shareImg;
/** 点击分享内容，跳转的连接Url  */
@property (nonatomic, copy) NSString *shareUrl;

+ (instancetype)toolModel;

@end






