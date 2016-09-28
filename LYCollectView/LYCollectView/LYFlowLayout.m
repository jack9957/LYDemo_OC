//
//  LYFlowLayout.m
//  LYCollectView
//
//  Created by liyang on 16/9/27.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYFlowLayout.h"

/**
 自定义布局，只需要了解5个方法
 */
@implementation LYFlowLayout

// 从写父类方法，扩展一些功能

// 研究方法，可以研究2点：1、什么时候用 2、做什么用

- (void)prepareLayout
{
    [super prepareLayout];
    // 第一次collectView布局的时候就调用和刷新的时候调用；可以计算cell布局
    // 不刷新的话，一般只会调用一次
}

- (CGSize)collectionViewContentSize
{
    // 计算collectView的滚蛋范围
    return [super collectionViewContentSize];
}


/**
 UICollectionViewLayoutAttributes: 确定cell的尺寸

 @param rect cell尺寸

 @return 为每一个cell设置尺寸
 */
- (NSArray<UICollectionViewLayoutAttributes *> *)layoutAttributesForElementsInRect:(CGRect)rect
{
    // 越靠近collectView的中心点，cell的size越大
    
    // 1、获取当前cell的布局
    NSArray *attrs = [super layoutAttributesForElementsInRect:rect];
    
    for (UICollectionViewLayoutAttributes *att in attrs) {
        // 2、计算中心点距离 fabs是取绝对值 (括号中的是:计算cell距离collectView中心点的距离,最大是collectView宽的一半；最小是0)
        CGFloat delta = fabs((att.center.x - self.collectionView.contentOffset.x) - self.collectionView.bounds.size.width/2);
        
        // 3、计算比例（取值范围是0.75-1）(这个地方可能有点绕，需要多思考)
        CGFloat scale = 1 - delta / (self.collectionView.bounds.size.width/2) * 0.25;
        
        att.transform = CGAffineTransformMakeScale(scale, scale);
    }
    
    return attrs;
}


/**
 在滚动的时候是否刷新布局

 @param newBounds 刷新布局

 @return 返回结果
 */
- (BOOL)shouldInvalidateLayoutForBoundsChange:(CGRect)newBounds
{
    return YES;
}


/**
 确定最终的偏移量，当用户松开屏幕的时候就调用

 @param proposedContentOffset 手机偏移量
 @param velocity              定位

 @return 偏移量
 */
- (CGPoint)targetContentOffsetForProposedContentOffset:(CGPoint)proposedContentOffset withScrollingVelocity:(CGPoint)velocity
{
    // 最终的偏移量
    CGPoint point = [super targetContentOffsetForProposedContentOffset:proposedContentOffset withScrollingVelocity:velocity];
    
    // 1、获取最终显示的区域
    CGRect targetRect = CGRectMake(point.x, 0, self.collectionView.bounds.size.width, MAXFLOAT);
    
    // 2、获取最终显示的cell
    NSArray *attrs = [super layoutAttributesForElementsInRect:targetRect];
    
    CGFloat minDelta = MAXFLOAT;
    
    for (UICollectionViewLayoutAttributes *att in attrs) {
        // 获取距离中心点的距离
        CGFloat delta = (att.center.x - point.x) - self.collectionView.bounds.size.width * 0.5;
        if (fabs(delta) < fabs(minDelta)) {
            minDelta = delta;
        }
    }
    
    point.x += minDelta;
    
    // 判断一下最终偏移量，解决问题
    if (point.x < 0) {
        point.x = 0;
    }
    
    return point;
}
@end
