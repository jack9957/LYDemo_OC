//
//  TestViewController.m
//  UIScrollViewPopGesture
//
//  Created by liyang on 16/10/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "TestViewController.h"
#import "UINavigationController+LYPopGesture.h"
#import "T2ViewController.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupScrollView];
  
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
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

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    T2ViewController *t2 = [[T2ViewController alloc] init];
    
    [self.navigationController pushViewController:t2 animated:YES];
}

@end
