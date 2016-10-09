//
//  LYNavigationController.m
//  UIScrollViewPopGesture
//
//  Created by liyang on 16/10/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYNavigationController.h"

@interface LYNavigationController ()

@end

@implementation LYNavigationController

+ (void)initialize
{
    UINavigationBar *bar = [UINavigationBar appearanceWhenContainedIn:self, nil];
    
    // 导航栏的背景颜色
    [bar setBarTintColor:[UIColor colorWithRed:0.200 green:0.710 blue:0.659 alpha:1.000]];
    
    // 标题颜色大小
    NSMutableDictionary *titleAttr = [NSMutableDictionary dictionary];
    titleAttr[NSForegroundColorAttributeName] = [UIColor whiteColor];
    titleAttr[NSFontAttributeName] = [UIFont boldSystemFontOfSize:20];
    [bar setTitleTextAttributes:titleAttr];
    
    // NavBar64                     不透明
    // navigationbarBackgroundWhite 透明
    [bar setBackgroundImage:[UIImage imageNamed:@"navigationbarBackgroundWhite"] forBarMetrics:UIBarMetricsDefault];
    [bar setShadowImage:[[UIImage alloc] init]];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.childViewControllers.count > 0) {
        viewController.navigationItem.leftBarButtonItem = ({
            UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"navigationButtonReturn"] style:UIBarButtonItemStylePlain target:self action:@selector(navback:)];
            item;
        });
    }
    [super pushViewController:viewController animated:animated];
}
- (void)navback:(UIBarButtonItem *)sender
{
    [self popViewControllerAnimated:YES];
}


@end
