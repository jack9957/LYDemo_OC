//
//  ViewController.m
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

/** 自己写一个qq，新浪，微信的登录分享 **/

#import "ViewController.h"
#import "LYThirdTools.h"

@interface ViewController ()<LYThirdToolsDelegate>

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [LYThirdTools sharedInstance].delegate = self;
}

#pragma mark - 登录
- (IBAction)qq:(id)sender
{
   [[LYThirdTools sharedInstance] thirdToolsLog:QQLog];
}

- (IBAction)weichat:(id)sender
{
    [[LYThirdTools sharedInstance] thirdToolsLog:WeiChatLog];
}
- (IBAction)sina:(id)sender
{
    [[LYThirdTools sharedInstance] thirdToolsLog:SinaLog];
}

#pragma mark - 分享
- (IBAction)sinaShare:(id)sender
{
    [[LYThirdTools sharedInstance] thirdToolsShareModel:[LYToolModel toolModel] toplatForm:Sina];
}
- (IBAction)qqShare:(id)sender
{
    LYToolModel *model = [LYToolModel toolModel];
    [[LYThirdTools sharedInstance] thirdToolsShareModel:model toplatForm:QQ];
}

- (IBAction)weiChatShare:(id)sender
{
    LYToolModel *model = [LYToolModel toolModel];
    [[LYThirdTools sharedInstance] thirdToolsShareModel:model toplatForm:WeiChatSession];
//    [[LYThirdTools sharedInstance] thirdToolsShareModel:model toplatForm:WeiChatTimeline];
}

#pragma mark - 微信支付
- (IBAction)weiChatPay:(id)sender
{
    // com.yesing.advertsplayer
    // com.liyang.ThirdTool-LogShare
    // 1、从服务器拿到统一订单号，一般返回的数据是json，如果不是，自己处理下
    NSDictionary *dic = @{
                          @"orderids":@"123456789",
                          @"order_price":@"1",
                          @"product_name":@"xiaoming"
                          };
    [LYNetworking updateBaseUrl:@"http://120.24.1.189"];
    [LYNetworking getWithUrl:@"app.php/Wx/index" params:dic progress:nil success:^(id  _Nonnull responseObject) {
        if ([responseObject isKindOfClass:[NSDictionary class]]) {
            // 2、吊起支付
            [[LYThirdTools sharedInstance] thirdPayWith:responseObject platForm:WeiChatPay];
        }
    } failure:^(NSError * _Nonnull error) {
        //
        NSLog(@"%@", error);
    }];
}

#pragma mark - 三方工具的代理方法
- (void)thirdTool:(LYThirdTools *)tool weichatResult:(NSDictionary *)result
{
    // 
    NSLog(@"微信回调的结果是: %@", result);
}


@end
