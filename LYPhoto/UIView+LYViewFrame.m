//
//  UIView+LYViewFrame.m
//  LYLotteryTicket
//
//  Created by liyang on 16/4/25.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "UIView+LYViewFrame.h"
#import <objc/runtime.h>

@implementation UIView (LYViewFrame)
- (CGFloat)ly_x
{
    return self.frame.origin.x;
}
- (void)setLy_x:(CGFloat)ly_x
{
    CGRect rect = self.frame;
    rect.origin.x = ly_x;
    self.frame = rect;
}

- (CGFloat)ly_y
{
    return self.frame.origin.y;
}
- (void)setLy_y:(CGFloat)ly_y
{
    CGRect rect = self.frame;
    rect.origin.y = ly_y;
    self.frame = rect;
}

- (CGFloat)ly_width
{
    return self.frame.size.width;
}
- (void)setLy_width:(CGFloat)ly_width
{
    CGRect rect = self.frame;
    rect.size.width = ly_width;
    self.frame = rect;
}

- (CGFloat)ly_height
{
    return self.frame.size.height;
}
- (void)setLy_height:(CGFloat)ly_height
{
    CGRect rect = self.frame;
    rect.size.height = ly_height;
    self.frame = rect;
}

- (CGFloat)ly_centerX
{
    return self.center.x;
}
- (void)setLy_centerX:(CGFloat)ly_centerX
{
    CGPoint center = self.center;
    center.x = ly_centerX;
    self.center = center;
}

- (CGFloat)ly_centerY
{
    return self.center.y;
}
- (void)setLy_centerY:(CGFloat)ly_centerY
{
    CGPoint center = self.center;
    center.y = ly_centerY;
    self.center = center;
}

- (CGFloat)ly_frameMaxX
{
    return CGRectGetMaxX(self.frame);
}
- (void)setLy_frameMaxX:(CGFloat)ly_frameMaxX
{
    self.frame = CGRectMake(ly_frameMaxX - self.frame.size.width, self.frame.origin.y, self.frame.size.width, self.frame.size.height);
}

- (CGFloat)ly_frameMaxY
{
    return CGRectGetMaxY(self.frame);
}
- (void)setLy_frameMaxY:(CGFloat)ly_frameMaxY
{
    self.frame = CGRectMake(self.frame.origin.x, ly_frameMaxY - self.frame.size.height, self.frame.size.width, self.frame.size.height);
}


#pragma mark - 给view添加手势
- (UITapGestureRecognizer *)lyAddTapActionWithTarget:(id)target selector:(SEL)selector
{
    if (target && [target respondsToSelector:selector]) {
        self.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:target action:selector];
        [self addGestureRecognizer:tap];
        return tap;
    }
    return nil;
}
/** 获取view的控制器 */
- (UIViewController *)lyViewController {
    UIView *superView = self.superview;
    
    while (superView)
    {
        UIResponder *nextResponder = [superView nextResponder];
        if ([nextResponder isKindOfClass:[UIViewController class]]) {
            return (UIViewController *)nextResponder;
        }
        superView = superView.superview;
    }
    
    return nil;
}

/**
 *  给当前view设置圆角，边框，边框颜色
 *
 *  @param radius view的圆角
 *  @param width  边框宽度
 *  @param color  边框颜色（如果有边框）
 */
- (void)lySetMaskWithCornerRadius:(CGFloat)radius borderWidth:(CGFloat)width borderColor:(UIColor *)color
{
    CGPathRef maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:UIRectCornerAllCorners cornerRadii:CGSizeMake(radius, radius)].CGPath;
    CGPoint position = CGPointMake(self.bounds.size.width/2, self.bounds.size.height/2);
    
    if (radius > 0) {
        CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
        
        maskLayer.bounds = self.bounds;
        maskLayer.position = position;
        maskLayer.path = maskPath;
        maskLayer.fillColor = [UIColor blackColor].CGColor;
        
        [self.layer setMask:maskLayer];
    }
    
    
    if (width > 0 && color) {
        
        CAShapeLayer *borderLayer = self.borderLayer ? self.borderLayer : [CAShapeLayer layer];
        
        borderLayer.bounds = self.bounds;
        borderLayer.position = position;
        borderLayer.path = maskPath;
        borderLayer.lineWidth = width * 2.0f;
        borderLayer.strokeColor = color.CGColor;
        borderLayer.fillColor = [UIColor clearColor].CGColor;
        
        if (!self.borderLayer) {
            [self.layer addSublayer:borderLayer];
        }
        self.borderLayer = borderLayer;
    }
}

- (void) setBorderLayer:(CAShapeLayer *)borderLayer {
    objc_setAssociatedObject(self, @selector(setBorderLayer:), borderLayer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}
- (CAShapeLayer *)borderLayer {
    return objc_getAssociatedObject(self, @selector(setBorderLayer:));
}



/**
 *  给当前的view设置渐变色
 *
 *  @param theColor            要渐变的颜色
 *  @param transparentToOpaque 一般给YES
 */
- (void)addLinearGradientToSelfWithColor:(UIColor *)theColor transparentToOpaque:(BOOL)transparentToOpaque
{
    CAGradientLayer *gradient = [CAGradientLayer layer];
    
    // the gradient layer must be positioned at the origin of the view
    CGRect gradientFrame = self.frame;
    
    gradientFrame.origin.x = 0;
    gradientFrame.origin.y = 0;
    gradient.frame = gradientFrame;
    
    // build the colors array for the gradient
    NSArray *colors = [NSArray arrayWithObjects:
                       (id)[theColor CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.9f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.6f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.4f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.3f] CGColor],
                       (id)[[theColor colorWithAlphaComponent:0.1f] CGColor],
                       (id)[[UIColor clearColor] CGColor],
                       nil];
    
    // reverse the color array if needed
    if (transparentToOpaque) {
        colors = [[colors reverseObjectEnumerator] allObjects];
    }
    
    // apply the colors and the gradient to the view
    gradient.colors = colors;
    
    [self.layer insertSublayer:gradient atIndex:0];
}
@end
