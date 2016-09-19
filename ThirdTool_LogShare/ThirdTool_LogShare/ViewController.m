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
    [[LYThirdTools sharedInstance] thirdToolsLog:WeiChatLog];
}
- (IBAction)sina:(id)sender
{
    
}

#pragma mark - 分享
- (IBAction)sinaShare:(id)sender
{
}
- (IBAction)qqShare:(id)sender
{
    
}
- (IBAction)weiChatShare:(id)sender
{
    LYToolModel *model = [LYToolModel toolModel];
    [[LYThirdTools sharedInstance] thirdToolsShareModel:model toplatForm:WeiChatSession];
//    [[LYThirdTools sharedInstance] thirdToolsShareModel:model toplatForm:WeiChatTimeline];
}


@end
