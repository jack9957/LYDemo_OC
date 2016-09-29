//
//  LYConst.h
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/14.
//  Copyright © 2016年 liyang. All rights reserved.
//

/** 这里存放各个平常申请到的账号信息 */

// 应用本身的Scheme
UIKIT_EXTERN NSString * const appScheme;

// 这个是申请的新浪OA授权
UIKIT_EXTERN NSString * const sinaAppID;
UIKIT_EXTERN NSString * const sinaAppSecret;
// 这个在高级信息中，注意保持一致
UIKIT_EXTERN NSString * const sinaRedirectURI;

// 这个是申请的QQOA授权
UIKIT_EXTERN NSString * const qqAppID;
UIKIT_EXTERN NSString * const qqAppKey;

// 这个是申请的微信OA授权
UIKIT_EXTERN NSString * const weichatAppID;
UIKIT_EXTERN NSString * const weichatAppSecret;

// 这个是支付宝的相关信息
UIKIT_EXTERN NSString * const aliAppId; // 应用ID
UIKIT_EXTERN NSString * const aliPrivateKey; // 应用私钥，pkcs8格式
UIKIT_EXTERN NSString * const aliNotify_url; // 支付宝服务器主动通知商户服务器里指定的页面http/https路径。建议商户使用https;这里要和填写应用时候填写的信息一致
