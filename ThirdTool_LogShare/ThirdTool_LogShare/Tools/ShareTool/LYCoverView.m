//
//  LYCoverView.m
//  ThirdTool_LogShare
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYCoverView.h"

#define kScreenBounds [UIScreen mainScreen].bounds
#define LYKeyWindow [UIApplication sharedApplication].keyWindow

@implementation LYCoverView

+ (void)show
{
    // 创建蒙版对象
    LYCoverView *cover = [[LYCoverView alloc] initWithFrame:kScreenBounds];
    
    cover.backgroundColor = [UIColor blackColor];
    
    cover.alpha = 0.6;
    
    // 把蒙版对象添加到主窗口
    [LYKeyWindow addSubview:cover];
}


+ (void)hide
{
    for (UIView *childView in LYKeyWindow.subviews) {
        if ([childView isKindOfClass:self]) {
            [childView removeFromSuperview];
        }
    }
}

@end
