//
//  LYPhotoBrowseController.h
//  LYImagePicker
//
//  Created by liyang on 16/10/14.
//  Copyright © 2016年 liyang. All rights reserved.
//  图片浏览器

#import <UIKit/UIKit.h>
#import "LYImageManager.h"
#import "SVProgressHUD.h"

@interface LYPhotoBrowseController : UIViewController

/** 从哪个位置开始 */
@property (nonatomic, assign) NSInteger index;

/** 全部Model的数组 */
@property (nonatomic, strong) NSMutableArray<LYAssetModel *> *items;

/** 选择的asset数组 */
@property (nonatomic, strong) NSMutableArray<LYAssetModel *> *selectItems;

/** block传值(当控制器被push出来的时候，用到这个block)  */
@property (nonatomic, copy) void(^BrowseBlock)(NSMutableArray<LYAssetModel *> *selectItems);

@end


@interface LYPhotoBrowseCell : UICollectionViewCell

/** 模型 */
@property (nonatomic, strong) LYAssetModel *assetModel;

/** 单击的传值  */
@property (nonatomic, copy) void (^photoBrowseBlock)(void);

@end
