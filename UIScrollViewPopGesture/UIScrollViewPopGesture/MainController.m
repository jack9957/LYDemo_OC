//
//  MainController.m
//  UIScrollViewPopGesture
//
//  Created by liyang on 16/10/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "MainController.h"
#import "TestViewController.h"
@interface MainController ()

@end

@implementation MainController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self configBtn];
}

- (void)configBtn
{
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"sure" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(selectTaskModel:) forControlEvents:UIControlEventTouchUpInside];
    btn.frame = CGRectMake(140, 130, 180, 30);
    [self.view addSubview:btn];

}

- (void)selectTaskModel:(UIButton *)sender
{
    TestViewController *test = [[TestViewController alloc] init];
    [self.navigationController pushViewController:test animated:YES];
}

@end
