//
//  AppDelegate.m
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "AppDelegate.h"
#import "LYThirdTools.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    [[LYThirdTools sharedInstance] setupThirdTools];
    
    return YES;
}

- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    if ([url.host isEqualToString:@"response_from_qq"] || [url.host isEqualToString:@"qzapp"] ) {
        // 从qq分享 跳回来的
        [TencentOAuth HandleOpenURL:url];
//        [QQApiInterface handleOpenURL:url delegate:[LYThirdTools sharedInstance]];
        
    }else if([url.host isEqualToString:@"oauth"] || [url.host isEqualToString:@"platformId=wechat"] || [url.host isEqualToString:@"pay"]){
        // 从 微信登录 || 微信分享 || 微信支付 跳回来的
        [WXApi handleOpenURL:url delegate:[LYThirdTools sharedInstance]];
    }else if ([url.host isEqualToString:@"safepay"]){
        // 这是从支付宝跳回来的
        
    }else if ([url.host isEqualToString:@"response"]){
        // 这是从新浪微博跳回来的(新浪微博就这一个host)
        [WeiboSDK handleOpenURL:url delegate:[LYThirdTools sharedInstance]];
    }
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
