//
//  LYThirdTools.m
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/19.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYThirdTools.h"

// 获取微信用户access_token时候使用的授权域
static NSString *kAuthScope = @"snsapi_message,snsapi_userinfo,snsapi_friend,snsapi_contact";
// 微信用户access_token时候设置微信回调标识
static NSString *kAuthState = @"liyang_custom";

@implementation LYThirdTools

+ (instancetype)sharedInstance
{
    static LYThirdTools *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

/**
 初始化，注册
 */
- (void)setupThirdTools
{
    [WXApi registerApp:weichatAppID withDescription:@"微信初始化"];
}

/**
 分享

 @param model    分享的模型数据
 @param platForm 分享到哪个平台
 */
- (void)thirdToolsShareModel:(LYToolModel *)model toplatForm:(LYSharePlatForm)platForm
{
    if (platForm == WeiChatSession || platForm == WeiChatTimeline) {
        // 分享到微信的
        WXMediaMessage *mediaMessage = [WXMediaMessage message];
        mediaMessage.title = model.shareTitle;
        mediaMessage.description = model.shareSubTitle;
        [mediaMessage setThumbImage:model.shareImg];
        WXWebpageObject *webObj = [WXWebpageObject object];
        webObj.webpageUrl = model.shareUrl;
        mediaMessage.mediaObject = webObj;
        
        // 发送
        SendMessageToWXReq *toReq = [[SendMessageToWXReq alloc] init];
        toReq.bText = NO;
        toReq.message = mediaMessage;
        toReq.scene = platForm;
        [WXApi sendReq:toReq];
    }
}


/** 登录的方法 */
- (void)thirdToolsLog:(LYThirdLog)thirdLog
{
    if (thirdLog == WeiChatLog) {
        // 微信登录
        // 1、获取用户的access_token（接口调用凭证）
        // 1-1、定义消息结构体
        SendAuthReq *authReq = [[SendAuthReq alloc] init];
        authReq.scope = kAuthScope;
        authReq.state = kAuthState;
        // 1-2、向微信发送消息
        [WXApi sendReq:authReq];
    }
}


#pragma mark - 微信登录分享的回调方法
/*! @brief 收到一个来自微信的请求，第三方应用程序处理完后调用sendResp向微信发送结果
 *
 * 收到一个来自微信的请求，异步处理完成后必须调用sendResp发送处理结果给微信。
 * 可能收到的请求有GetMessageFromWXReq、ShowMessageFromWXReq等。
 * @param req 具体请求内容，是自动释放的
 */
- (void)onReq:(BaseReq *)req
{
    NSLog(@"=====%@", [req class]);
}
/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp
{
    NSLog(@"-----%@", [resp class]);
    if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
        // 分享
        SendMessageToWXResp *respMessage = (SendMessageToWXResp *)resp;
        NSLog(@"%@\n%@", respMessage.lang, respMessage.country);
        if (respMessage.errStr == nil) {
            NSLog(@"分享成功");
        }
    }else if ([resp isKindOfClass:[SendAuthResp class]]){
        // 登录
        SendAuthResp *authResp = (SendAuthResp *)resp;
        if (authResp.code) {
            // 说明成功,通过下面的路径去拿access_token
            [LYNetworking updateBaseUrl:@"https://api.weixin.qq.com"];
            NSDictionary *dic = @{
                                  @"appid":weichatAppID,
                                  @"secret":weichatAppSecret,
                                  @"code":authResp.code,
                                  @"grant_type":@"authorization_code"
                                  };
            [LYNetworking postWithUrl:@"sns/oauth2/access_token" params:dic progress:nil success:^(id  _Nonnull responseObject) {
                //
                NSLog(@"%@", responseObject);
            } failure:^(NSError * _Nonnull error) {
                //
                NSLog(@"获取用户的access_token失败：原因是:%@", error);
            }];
        }else{
            NSLog(@"调用失败");
        }
    }
    
    
}

@end







@implementation LYToolModel

+ (instancetype)toolModel
{
    LYToolModel *model = [[LYToolModel alloc] init];
    model.shareTitle = @"1级标题";
    model.shareSubTitle = @"2级标题";
    model.shareImg = [UIImage imageNamed:@"iphone"];
    model.shareUrl = @"http://www.baidu.com";
    return model;
}

@end
