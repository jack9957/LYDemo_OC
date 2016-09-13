//
//  ConfigAttributedString.m
//  AttributeString
//
//  Created by liyang on 16/9/13.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "ConfigAttributedString.h"

@interface ConfigAttributedString ()

@property (nonatomic, strong) NSString *attribute;
@property (nonatomic, strong) id        value;
@property (nonatomic, assign) NSRange   range;

@end


@implementation ConfigAttributedString

/**
 *  本类Config中全都是类工厂方法
 *
 *  每一种类工厂方法创建特定的属性配置，类工厂方法使用场景：同一类的比较多，但是有限，不会拓展很多的时候，可以用类工厂方法罗列
 */
+ (instancetype)attribute:(NSString *)attribute value:(id)value range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    
    config.attribute = attribute;
    config.value     = value;
    config.range     = range;
    
    return config;
}

+ (instancetype)font:(UIFont *)font range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSFontAttributeName;
    config.value     = font;
    config.range     = range;
    
    return config;
}

+ (instancetype)foregroundColor:(UIColor *)color range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSForegroundColorAttributeName;
    config.value     = color;
    config.range     = range;
    
    return config;
}

+ (instancetype)backgroundColor:(UIColor *)color range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSBackgroundColorAttributeName;
    config.value     = color;
    config.range     = range;
    
    return config;
}

+ (instancetype)strikethroughStyle:(NSInteger)number range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSStrikethroughStyleAttributeName;
    config.value     = [NSNumber numberWithInteger:number];
    config.range     = range;
    
    return config;
}

+ (instancetype)paragraphStyle:(NSMutableParagraphStyle *)style range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSParagraphStyleAttributeName;
    config.value     = style;
    config.range     = range;
    
    return config;
}

+ (instancetype)kern:(float)number range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSKernAttributeName;
    config.value     = [NSNumber numberWithFloat:number];
    config.range     = range;
    
    return config;
}

+ (instancetype)underlineStyle:(NSInteger)number range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSUnderlineStyleAttributeName;
    config.value     = [NSNumber numberWithInteger:number];
    config.range     = range;
    
    return config;
}

+ (instancetype)strokeColor:(UIColor *)color range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSStrokeColorAttributeName;
    config.value     = color;
    config.range     = range;
    
    return config;
}

+ (instancetype)strokeWidth:(float)number range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSStrokeWidthAttributeName;
    config.value     = [NSNumber numberWithFloat:number];
    config.range     = range;
    
    return config;
}

+ (instancetype)shadow:(NSShadow *)shadow range:(NSRange)range
{
    ConfigAttributedString *config = [self new];
    config.attribute = NSShadowAttributeName;
    config.value     = shadow;
    config.range     = range;
    
    return config;
}

@end
