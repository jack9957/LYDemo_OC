//
//  BookTextView.m
//  AttributeString
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "BookTextView.h"
#import "ParagraphAttributes.h"
#import "ConfigAttributedString.h"

#define  READ_WORD_COLOR   [UIColor colorWithRed:0.600 green:0.490 blue:0.376 alpha:1]
#define  QingKeBengYue     @"FZQKBYSJW--GB1-0"

typedef enum : NSUInteger {
    EBOOK_NONE,              // 什么也不做
    EBOOK_CALCULATE_HEIGHT,  // 计算文本高度
} EBookTextViewStatus;


@interface BookTextView ()<UITextViewDelegate>
{
    EBookTextViewStatus _bookStatus;
    
    CGFloat             _tmpOffsetY;
    CGFloat             _tmpPercent;
}
@property (nonatomic, strong)   UITextView     *textView;
@property (nonatomic, assign)   CGFloat         textHeight;
@property (nonatomic, assign)   CGFloat         currentPercent;

@end


@implementation BookTextView

- (void)buildWidgetView
{
    // 获取长宽
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    
    // 创建文本容器并设置段落样式
    NSTextStorage *storage = [[NSTextStorage alloc] initWithString:self.textString attributes:self.paragraphAttributes];
    
    // 设置富文本
    for (int count = 0; count < _attributes.count; count++) {
        ConfigAttributedString *config = _attributes[count];
        [storage addAttribute:config.attribute
                        value:config.value
                        range:config.range];
    }
    
    // 管理器
    NSLayoutManager *layoutManager = [NSLayoutManager new];
    [storage addLayoutManager:layoutManager];
    
    // 显示的容器
    NSTextContainer *textContainer = [NSTextContainer new];
    CGSize size = CGSizeMake(width, MAXFLOAT);
    textContainer.size = size;
    [layoutManager addTextContainer:textContainer];
    
    // 给TextView添加带有内容和布局的容器
    self.textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, width, height) textContainer:textContainer];
    self.textView.scrollEnabled                    = YES;
    self.textView.editable                         = NO;
    self.textView.selectable                       = NO;
    self.textView.layer.masksToBounds              = YES;
    self.textView.showsVerticalScrollIndicator     = NO;
    self.textView.delegate                         = self;
    
    // 如果有额外的view（一般是配图）
    if (self.exclusionViews) {
        // 存放贝塞尔曲线的，哪些部分不用绘制
        NSMutableArray *pathArray = [NSMutableArray arrayWithCapacity:_exclusionViews.count];
        
        // 在textView上添加其他的view，并且保存贝塞尔曲线
        for (int count = 0; count < _exclusionViews.count; count++) {
            // 添加view
            UIView *tempView = _exclusionViews[count];
            [_textView addSubview:tempView];
            
            // 添加path
            [pathArray addObject:[UIBezierPath bezierPathWithRect:tempView.frame]];
        }
        
        textContainer.exclusionPaths = pathArray;
    }
    
    // 添加要显示的view
    [self addSubview:self.textView];
    
    
    // 存储文本高度
    [self storeBookHeight];
}

// 计算文本的高度
- (void)storeBookHeight
{
    // 先偏移到文本末尾位置
    _bookStatus = EBOOK_CALCULATE_HEIGHT;
    [UIView setAnimationsEnabled:NO];
    // 快速偏移到文本末尾，拿到文本的高度
    [self.textView scrollRangeToVisible:NSMakeRange([self.textView.text length], 0)];
    [UIView setAnimationsEnabled:YES];
    _bookStatus = EBOOK_NONE;
    
    // 再偏移到文本开头位置
    [UIView setAnimationsEnabled:NO];
    [self.textView scrollRangeToVisible:NSMakeRange(0, 0)];
    [UIView setAnimationsEnabled:YES];
}
#pragma mark - textView的代理方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    // Y轴偏移量
    _tmpOffsetY = scrollView.contentOffset.y;
    if (_bookStatus == EBOOK_NONE) {
        
        _tmpPercent = _tmpOffsetY / _textHeight;
        if (_tmpPercent >= 0 && _tmpPercent <= 1) {
            _currentPercent = _tmpPercent;
        } else if (_tmpPercent < 0) {
            _currentPercent = 0.f;
        } else {
            _currentPercent = 1.f;
        }
    } else if (_bookStatus == EBOOK_CALCULATE_HEIGHT) {
        self.textHeight = scrollView.contentOffset.y;
    }
}

#pragma mark - 移动到指定位置
- (void)moveToTextPosition:(CGFloat)position
{
    [self.textView setContentOffset:CGPointMake(0, position) animated:NO];
}

#pragma mark - 移动到百分比
- (void)moveToTextPercent:(CGFloat)percent
{
    // 计算出百分比
    CGFloat position = 0.f;
    if (percent >= 0 && percent <= 1) {
        position = percent * _textHeight;
    } else if (percent < 0) {
        position = 0.f;
    } else {
        position = _textHeight;
    }
    
    // 移动到指定的位置
    [self.textView setContentOffset:CGPointMake(0, position) animated:NO];
}
@end
