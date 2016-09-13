//
//  ViewController.m
//  AttributeString
//
//  Created by liyang on 16/9/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *testLabel;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}


 /**
 iOS 6之前：CoreText,纯C语言,极其蛋疼
 iOS 6开始：NSAttributedString,简单易用
 iOS 7开始：TextKit,功能强大,简单易用
 */




- (IBAction)btn1Action:(id)sender
{
    // 1、学习练习使用富文本之NSAttributedString
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"学习练习使用富文本"];
    
    // 2、设置各种属性
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 4)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(4, string.length-4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4, string.length-4)];
    
    self.testLabel.attributedText = string;
}

@end
