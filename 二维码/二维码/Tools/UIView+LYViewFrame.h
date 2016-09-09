//
//  UIView+LYViewFrame.h
//  LYLotteryTicket
//
//  Created by liyang on 16/4/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

// 分类里面不能生成成员属性,分类只能作用于本类，对于子类无效果
// 会自动生成get，set方法和成员属性
// @property如果在分类里面只会生成get,set方法的声明，并不会生成成员属性。

@interface UIView (LYViewFrame)

@property (nonatomic, assign) CGFloat ly_x;
@property (nonatomic, assign) CGFloat ly_y;
@property (nonatomic, assign) CGFloat ly_width;
@property (nonatomic, assign) CGFloat ly_height;

@property (nonatomic, assign) CGFloat ly_centerX;
@property (nonatomic, assign) CGFloat ly_centerY;

@property (nonatomic, assign) CGFloat ly_frameMaxX;
@property (nonatomic, assign) CGFloat ly_frameMaxY;


#pragma mark - 给view添加手势
/** 给view添加手势,并且监听事件 */
- (UITapGestureRecognizer *)addTapActionWithTarget:(id)target selector:(SEL)selector;

/** 获取view的控制器 */
- (UIViewController *)lyViewController;

/**
 *  给当前view设置圆角，边框，边框颜色
 *
 *  @param radius view的圆角
 *  @param width  边框宽度
 *  @param color  边框颜色（如果有边框）
 */
- (void)lySetMaskWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color;


/**
 *  给当前的view设置渐变色
 *
 *  @param theColor            要渐变的颜色
 *  @param transparentToOpaque 一般给YES
 */
- (void)addLinearGradientToSelfWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque;

@end
