//
//  ViewController.m
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

/** 自己写一个qq，新浪，微信的登录分享 **/

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
}

#pragma mark - 登录
- (IBAction)qq:(id)sender
{
    NSLog(@"%@",qqAppID);
}
- (IBAction)weichat:(id)sender
{
    // 在进行微信OAuth2.0授权登录接入之前，在微信开放平台注册开发者帐号，并拥有一个已审核通过的移动应用，并获得相应的AppID和AppSecret，申请微信登录且通过审核后，可开始接入流程。
    
    
    
}
- (IBAction)sina:(id)sender
{
    
}

#pragma mark - 分享
- (IBAction)sinaShare:(id)sender {
}
- (IBAction)qqShare:(id)sender {
}
- (IBAction)weiChatShare:(id)sender {
}


@end
