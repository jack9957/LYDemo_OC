//
//  TestViewController.m
//  UIScrollViewPopGesture
//
//  Created by liyang on 16/10/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "TestViewController.h"
#import "UINavigationController+LYPopGesture.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupScrollView];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(back:)];
}

- (void)back:(UIBarButtonItem *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)setupScrollView
{
    UIScrollView *scrollView = [[UIScrollView alloc] init];
    scrollView.frame = CGRectMake(0, 100, self.view.frame.size.width, 300);
    scrollView.backgroundColor = [UIColor orangeColor];
    scrollView.pagingEnabled = YES;
    scrollView.contentSize = CGSizeMake(self.view.frame.size.width*3, 0);
    [self.view addSubview:scrollView];
    
    [self ly_addPopGestureToView:scrollView];
    
}

@end
