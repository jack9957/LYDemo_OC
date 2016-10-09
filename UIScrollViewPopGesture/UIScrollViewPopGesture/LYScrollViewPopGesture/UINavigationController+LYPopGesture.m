//
//  UINavigationController+LYPopGesture.m
//  UIScrollViewPopGesture
//
//  Created by liyang on 16/10/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "UINavigationController+LYPopGesture.h"
#import <objc/runtime.h>

@interface UINavigationController (LYPopGesturePrivate)

@property (nonatomic, weak, readonly) id ly_popDelegate;
@property (nonatomic, weak, readonly) id ly_naviDelegate;

@end

@implementation UINavigationController (LYPopGesture)

+ (void)load
{
    Method originalMethod = class_getInstanceMethod(self, @selector(viewWillAppear:));
    Method swizzledMethod = class_getInstanceMethod(self, @selector(ly_viewWillAppear:));
    method_exchangeImplementations(originalMethod, swizzledMethod);
}

- (void)ly_viewWillAppear:(BOOL)animated
{
    [self ly_viewWillAppear:animated];
    
     // 只是为了触发tz_PopDelegate的get方法，获取到原始的interactivePopGestureRecognizer的delegate
    [self.ly_popDelegate class];
    [self.ly_naviDelegate class];
    self.delegate = self;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.delegate = self.ly_naviDelegate;
    });
}

- (id)ly_popDelegate
{
    id ly_popDelegate = objc_getAssociatedObject(self, _cmd);
    if (!ly_popDelegate) {
        ly_popDelegate = self.interactivePopGestureRecognizer.delegate;
        objc_setAssociatedObject(self, _cmd, ly_popDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ly_popDelegate;
}

- (id)ly_naviDelegate
{
    id ly_naviDelegate = objc_getAssociatedObject(self, _cmd);
    if (!ly_naviDelegate) {
        ly_naviDelegate = self.delegate;
        objc_setAssociatedObject(self, _cmd, ly_naviDelegate, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return ly_naviDelegate;
}

- (UIPanGestureRecognizer *)ly_popGestureRecognizer
{
    UIPanGestureRecognizer *pan = objc_getAssociatedObject(self, _cmd);
    if (!pan) {
        // 侧滑返回手势，手势触发的时候，让target执行action
        id target = self.ly_popDelegate;
        SEL action = NSSelectorFromString(@"handleNavigationTransition:");
        pan = [[UIPanGestureRecognizer alloc] initWithTarget:target action:action];
        pan.maximumNumberOfTouches = 1;
        pan.delegate = self;
        self.interactivePopGestureRecognizer.enabled = NO;
        objc_setAssociatedObject(self, _cmd, pan, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return pan;
}

#pragma mark - UIGestureReconginzerDelegate
- (BOOL)gestureRecognizerShouldBegin:(UIPanGestureRecognizer *)gestureRecognizer
{
    if ([[self valueForKey:@"_isTransitioning"] boolValue]) {
        return NO;
    }
    if (self.childViewControllers.count <= 1) {
        return NO;
    }
    
    // 侧滑手势触发位置
    CGPoint location = [gestureRecognizer locationInView:self.view];
    CGPoint offSet = [gestureRecognizer translationInView:gestureRecognizer.view]; // offSet.x 为正，是往右滑动；为负，是往左滑动
    
    BOOL ret = (offSet.x > 0 && location.x <= 40);
    
    return ret;
}

/// 只有当系统侧滑手势失败了，才去触发ScrollView的滑动
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldBeRequiredToFailByGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    return YES;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    // 让系统的侧滑返回生效
    self.interactivePopGestureRecognizer.enabled = YES;
    if (viewController == self.viewControllers[0]) {
        self.interactivePopGestureRecognizer.delegate = self.ly_popDelegate;
    }else{
        self.interactivePopGestureRecognizer.delegate = nil;
    }
}

@end


@implementation UIViewController (LYPopGesture)

- (void)ly_addPopGestureToView:(UIView *)view
{
    if (!self.navigationController) {
        // 控制器转场的时候，self.navigationController可能是nil,用GCD和递归来处理这种情况
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.05*NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self ly_addPopGestureToView:view];
        });
    }else{
        UIPanGestureRecognizer *pan = self.navigationController.ly_popGestureRecognizer;
        [view addGestureRecognizer:pan];
    }
}

@end
