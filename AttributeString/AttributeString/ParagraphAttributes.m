//
//  ParagraphAttributes.m
//  AttributeString
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ParagraphAttributes.h"

@implementation ParagraphAttributes

/**
 *  因为段落样式常用的只有这一类，所以只需要一个便利构造器。
 *
 */
- (NSDictionary *)createAttributes
{
    // 初始化字典
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    //========================设置属性的通过三元运算符同时赋予默认属性值========================
    // 设置颜色
    [dic setValue:(self.textColor == nil ? [UIColor blackColor] : self.textColor)
           forKey:NSForegroundColorAttributeName];
    
    // 设置字体
    [dic setValue:(self.textFont == nil ? [UIFont systemFontOfSize:18.f] : self.textFont)
           forKey:NSFontAttributeName];
    
    // 段落样式
    NSMutableParagraphStyle *style = [NSMutableParagraphStyle new];
    {
        style.lineSpacing         = (self.lineSpacing         == nil ? 5.f : self.lineSpacing.floatValue);
        style.paragraphSpacing    = (self.paragraphSpacing    == nil ? 5.f : self.paragraphSpacing.floatValue);
        style.firstLineHeadIndent = (self.firstLineHeadIndent == nil ? 18 * 2 : self.firstLineHeadIndent.floatValue);
    }
    
    [dic setValue:style
           forKey:NSParagraphStyleAttributeName];
    
    // 字间距
    [dic setValue:(self.kern <= 0 ? @(0) : @(self.kern))
           forKey:NSKernAttributeName];
    
    return dic;
}

@end
