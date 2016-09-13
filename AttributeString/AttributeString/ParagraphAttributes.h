//
//  ParagraphAttributes.h
//  AttributeString
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

/* 配置段落信息 */

@interface ParagraphAttributes : NSObject

@property (nonatomic, strong) UIColor  *textColor;
@property (nonatomic, strong) UIFont   *textFont;
@property (nonatomic, assign) CGFloat   kern;                // 字间距

@property (nonatomic, strong) NSNumber *lineSpacing;         // 段落样式 - 行间距
@property (nonatomic, strong) NSNumber *paragraphSpacing;    // 段落样式 - 段间距
@property (nonatomic, strong) NSNumber *firstLineHeadIndent; // 段落样式 - 段首文字缩进

- (NSDictionary *)createAttributes;

@end
