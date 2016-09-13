//
//  ViewController.m
//  AttributeString
//
//  Created by liyang on 16/9/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ViewController.h"

#import "BookTextView.h"
#import "ParagraphAttributes.h"
#import "ConfigAttributedString.h"

#define  Width                             [UIScreen mainScreen].bounds.size.width
#define  Height                            [UIScreen mainScreen].bounds.size.height

#define  READ_WORD_COLOR   [UIColor colorWithRed:0.600 green:0.490 blue:0.376 alpha:1]
#define  QingKeBengYue     @"FZQKBYSJW--GB1-0"

@interface ViewController ()<UITextViewDelegate>
/** BooKView
 */
@property (nonatomic, strong) BookTextView *bookView;
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
    [self textView3];
    
}

/**
 *  富文本学习 途径-3
 */
- (void)textView3
{
    // 读取文本
    NSString *text = [NSString stringWithContentsOfFile:[[NSBundle mainBundle] URLForResource:@"lorem" withExtension:@"txt"].path encoding:NSUTF8StringEncoding error:nil];
    
    // 初始化BookView
    self.bookView                     = [[BookTextView alloc] initWithFrame:CGRectMake(10, 60, Width - 20, Height - 70)];
    self.bookView.textString          = text;
    
    // 设置段落
    self.bookView.paragraphAttributes = ({
        
        ParagraphAttributes *config = [ParagraphAttributes new];
        
        config.textColor                   = READ_WORD_COLOR;
        config.textFont                    = [UIFont fontWithName:QingKeBengYue size:16.f];
        config.lineSpacing                 = @(10.f);
        config.paragraphSpacing            = @(40.f);
        config.firstLineHeadIndent         = @(0.f);
        
        [config createAttributes];
    });
    
    // 设置富文本
    self.bookView.attributes = @[[ConfigAttributedString foregroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.75f] range:NSMakeRange(0, 9)], [ConfigAttributedString font:[UIFont systemFontOfSize:22.0f] range:NSMakeRange(0, 9)]];
    
    // 加载其他view
    UIView *exclusionView = [[UIView alloc] initWithFrame:CGRectMake(150.f, 195, 320, 150)];
    self.bookView.exclusionViews = @[exclusionView];
    UIImageView *imageView       = [[UIImageView alloc] initWithFrame:exclusionView.bounds];
    imageView.image              = [UIImage imageNamed:@"demo"];
    [exclusionView addSubview:imageView];
    
    // 构建view
    [self.bookView buildWidgetView];
    [self.view addSubview:self.bookView];
    
    
    // 延时0.01s执行
    [self performSelector:@selector(event)
               withObject:nil
               afterDelay:3.01];
}

- (void)event
{
    [self.bookView moveToTextPercent:0.20];
}

/**
 *  富文本学习 途径-2
 */
- (void)textView
{
//  实现的过程如下:
//  storage --> layoutManager --> textContainer --> textView

    //  NSTextStorage: 装载字符串NSString文本对象

    //  NSLayoutManager: 布局

    //  addAttribute : 添加富文本的属性

    //  NSTextContainer : 内容的容器
    
    NSTextStorage *storage = [[NSTextStorage alloc] initWithString:@"海上升明月，天涯共此时;明月几时有,把酒问青天;明月松间照，清泉石上流;海上升明月，天涯共此时;明月几时有,把酒问青天;明月松间照，清泉石上流;海上升明月，天涯共此时;明月几时有,把酒问青天;明月松间照，清泉石上流;海上升明月，天涯共此时;明月几时有,把酒问青天;明月松间照，清泉石上流"];
    
    //设置段落样式
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 1.0f; // 行间距
    paraStyle.lineHeightMultiple = 2.0f; // 可变行高
    paraStyle.minimumLineHeight = 10.0f; // 最小行高
    paraStyle.maximumLineHeight = 20.0f; // 最大行高
    paraStyle.paragraphSpacing = 10.f; // 段落间距
    paraStyle.alignment = NSTextAlignmentLeft; // 对齐方式
    paraStyle.firstLineHeadIndent = 10.0f; // 段落首字符定格对齐
    
    [storage addAttribute:NSParagraphStyleAttributeName value:paraStyle range:NSMakeRange(0, storage.string.length)];
    
    // 高亮容器里面的某些内容
    [storage addAttribute:NSForegroundColorAttributeName
                    value:[UIColor redColor]
                    range:NSMakeRange(0, 5)];
    [storage addAttribute:NSForegroundColorAttributeName
                    value:[UIColor greenColor]
                    range:NSMakeRange(6, 5)];
    
    // 给内容容器添加布局（可以添加多个）
    NSLayoutManager *layoutManager = [[NSLayoutManager alloc] init];
    [storage addLayoutManager:layoutManager];
    
    // 带有内容和布局的容器
    NSTextContainer *textContainer = [[NSTextContainer alloc] init];
    [layoutManager addTextContainer:textContainer];
    
    // 设置textContainer要排斥的路径(图文混排)
    UIImage *img = [UIImage imageNamed:@"head"];
    CGRect areaRect = CGRectMake(5, 5, 80, 80);
    UIBezierPath *ovalPath = [UIBezierPath bezierPathWithRect:areaRect];
    textContainer.exclusionPaths = @[ovalPath];
    
    // 显示文字
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(50, 150, self.view.frame.size.width-100, 500) textContainer:textContainer];
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.layer.borderWidth = 1;
    [self.view addSubview:textView];
    
    UIImageView *show = [[UIImageView alloc] initWithFrame:areaRect];
    show.image = img;
    show.contentMode = UIViewContentModeScaleAspectFill;
    [textView addSubview:show];
}


/**
 *  富文本 途径-1
 */
- (void)attributedString
{
    // 1、学习练习使用富文本之NSAttributedString
    NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:@"学习练习使用富文本"];
    
    // 2、设置各种属性
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor redColor] range:NSMakeRange(0, 4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:30] range:NSMakeRange(0, 4)];
    
    [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(4, string.length-4)];
    [string addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:10] range:NSMakeRange(4, string.length-4)];
    
//    self.testLabel.attributedText = string;
}

@end
