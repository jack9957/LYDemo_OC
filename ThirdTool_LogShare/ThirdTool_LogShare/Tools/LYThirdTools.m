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

/** 检查有木有安装过：微信，微博，qq */
- (BOOL)installThirdApp:(LYThirdLog)thirdApp
{
    NSString *tempStr;
    if (thirdApp == WeiChatLog) {
        tempStr = @"weixin://";
    }else if (thirdApp == SinaLog){
        tempStr = @"sinaweibo://";
    }else if (thirdApp == QQLog){
        tempStr = @"mqq://";
    }
    return [[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:tempStr]];
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


#pragma mark - 微信登录、分享、支付的回调方法

/*! @brief 发送一个sendReq后，收到微信的回应
 *
 * 收到一个来自微信的处理结果。调用一次sendReq后会收到onResp。
 * 可能收到的处理结果有SendMessageToWXResp、SendAuthResp等。
 * @param resp具体的回应内容，是自动释放的
 */
- (void)onResp:(BaseResp *)resp
{
    if (resp.errCode == 0) {
        // 0代表操作成功
        if ([resp isKindOfClass:[SendMessageToWXResp class]]) {
            // 微信分享
            if ([self.delegate respondsToSelector:@selector(thirdTool:weichatResult:)]) {
                [self.delegate thirdTool:self weichatResult:@{@"msg":@"分享成功"}];
            }
        }else if ([resp isKindOfClass:[SendAuthResp class]]){
            // 微信登录
            SendAuthResp *authResp = (SendAuthResp *)resp;
            if (authResp.code) {
                // 说明成功,通过下面的路径去拿access_token（调用凭证）和openid（用户唯一标识）
                [LYNetworking updateBaseUrl:@"https://api.weixin.qq.com"];
                NSDictionary *dic = @{
                                      @"appid":weichatAppID,
                                      @"secret":weichatAppSecret,
                                      @"code":authResp.code,
                                      @"grant_type":@"authorization_code"
                                      };
                [LYNetworking postWithUrl:@"sns/oauth2/access_token" params:dic progress:nil success:^(id  _Nonnull responseObject) {
                    // 成功拿到access_token和openid,用这两个去请求用户信息
                    if ([responseObject isKindOfClass:[NSDictionary class]]) {
                        [self getWeiChatUserInfoWithDic:responseObject];
                    }else{
                        NSLog(@"失败:%@", responseObject);
                    }
                } failure:^(NSError * _Nonnull error) {
                    //
                    NSLog(@"获取用户的access_token失败：原因是:%@", error);
                }];
            }
        }else if ([resp isKindOfClass:[PayResp class]]){
            // 微信支付
            PayResp *payResp = (PayResp *)resp;
            if ([self.delegate respondsToSelector:@selector(thirdTool:weichatResult:)]) {
                [self.delegate thirdTool:self weichatResult:@{@"msg":@"支付成功",@"result":payResp.returnKey}];
            }
        }
        
    }else if (resp.errCode == -2){
        // -2是用户取消操作
        if ([self.delegate respondsToSelector:@selector(thirdTool:weichatResult:)]) {
            [self.delegate thirdTool:self weichatResult:@{@"msg":@"用户取消操作"}];
        }
        return;
    }else{
        // 其他的错误码全是失败
        if ([self.delegate respondsToSelector:@selector(thirdTool:weichatResult:)]) {
            [self.delegate thirdTool:self weichatResult:@{@"msg":@"操作失败"}];
        }
        return;
    }
}

/** 请求微信用户信息资料 */
- (void)getWeiChatUserInfoWithDic:(NSDictionary *)responseObject
{
    [LYNetworking updateBaseUrl:@"https://api.weixin.qq.com"];
    NSDictionary *dic = @{
                          @"access_token":responseObject[@"access_token"],
                          @"openid":responseObject[@"openid"]
                          };
    [LYNetworking getWithUrl:@"sns/userinfo" params:dic progress:nil success:^(id  _Nonnull responseObject) {
        //
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            if ([self.delegate respondsToSelector:@selector(thirdTool:weichatResult:)]) {
                [self.delegate thirdTool:self weichatResult:@{@"msg":@"操作成功",@"result":responseObject}];
            }
        }else{
            NSLog(@"获取用户信息失败,返回格式不是json,而是:%@", responseObject);
        }
    } failure:^(NSError * _Nonnull error) {
        //
        NSLog(@"获取用户信息失败: %@",error);
    }];
}

#pragma mark - 支付
- (void)thirdPayWith:(NSDictionary *)dict platForm:(LYThirdPayPlatForm)platForm
{
    if (platForm == WeiChatPay) {
        // 微信支付
        PayReq* req             = [[PayReq alloc] init];
        req.partnerId           = [dict objectForKey:@"partnerid"];
        req.prepayId            = [dict objectForKey:@"prepayid"];
        req.nonceStr            = [dict objectForKey:@"noncestr"];
        req.timeStamp           = [[dict objectForKey:@"timestamp"] intValue];
        req.package             = [dict objectForKey:@"package"];
        req.sign                = [dict objectForKey:@"sign"];
        req.nonceStr = [dict objectForKey:@"noncestr"];
        [WXApi sendReq:req];
    }
}

@end






#pragma mark - 分享的数据模型
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
