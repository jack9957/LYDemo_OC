//
//  LYThirdTools.h
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/19.
//  Copyright © 2016年 liyang. All rights reserved.
//

// 这是管理微信、微博、QQ的类，包括初始化，结果回调等

#import <Foundation/Foundation.h>
#import "WXApi.h"  // sdkversion=1.7.3
#import "WeiboSDK.h"  // sdkversion=2.5
#import "TencentOpenAPI/TencentOAuth.h" // sdkversion=3.1.0 登录
#import "TencentOpenAPI/QQApiInterface.h" // QQ分享
#import "TencentOpenAPI/TencentApiInterface.h"

@class LYThirdTools,LYToolModel;

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
 登录

 - WeiChatLog: 微信登录
 - SinaLog:    微博登录
 - QQLog:      QQ登录
 */
typedef NS_ENUM(NSUInteger, LYThirdLog) {
    WeiChatLog,
    SinaLog,
    QQLog
};

/**
 三方支付

 - LYAliPay:     支付宝支付
 - LYWeiChatPay: 微信支付
 */
typedef NS_ENUM(NSUInteger, LYThirdPayPlatForm) {
    AliPay,
    WeiChatPay
};


@protocol LYThirdToolsDelegate <NSObject>

@optional

/**
 微信成功结果回调方法

 @param tool   三方工具类
 @param result 微信的回调结果
 */
- (void)thirdTool:(LYThirdTools *)tool weichatResult:(NSDictionary *)result;

/**
 新浪分享、登录成功的回调方法

 @param tool   类
 @param result 结果
 */
- (void)thirdTool:(LYThirdTools *)tool sinaResult:(NSDictionary *)result;

/**
 qq分享、登录成功的回调方法

 @param tool   类本身
 @param result 结果
 */
- (void)thirdTool:(LYThirdTools *)tool qqResult:(NSDictionary *)result;
@end


@interface LYThirdTools : NSObject<WXApiDelegate,WeiboSDKDelegate,TencentSessionDelegate,QQApiInterfaceDelegate>

/** LYThirdToolsDelegate */
@property (nonatomic, assign) id<LYThirdToolsDelegate>delegate;

/** 单例方法 */
+ (instancetype)sharedInstance;

/** 向各个三方机构注册 */
- (void)setupThirdTools;

/** 检查有木有安装过：微信，微博，qq */
- (BOOL)installThirdApp:(LYThirdLog)thirdApp;

/** 分享的方法 */
- (void)thirdToolsShareModel:(LYToolModel *)model toplatForm:(LYSharePlatForm)platForm;

/** 登录的方法 */
- (void)thirdToolsLog:(LYThirdLog)thirdLog;

/** 支付的方法 */
- (void)thirdPayWith:(NSDictionary *)payDic platForm:(LYThirdPayPlatForm)platForm;

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






