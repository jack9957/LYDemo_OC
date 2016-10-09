//
//  UINavigationController+LYPopGesture.h
//  UIScrollViewPopGesture
//
//  Created by liyang on 16/10/9.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (LYPopGesture)<UIGestureRecognizerDelegate,UINavigationControllerDelegate>

/** 自定义手势 */
@property (nonatomic, strong, readonly) UIPanGestureRecognizer *ly_popGestureRecognizer;

@end


@interface UIViewController (LYPopGesture)

/** 写个Vc的分类，提供一个方法给view添加手势 */
- (void)ly_addPopGestureToView:(UIView *)view;

@end
