//
//  LYShowPhotosController.h
//  LYImagePicker
//
//  Created by liyang on 16/10/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 获取数据的类 */
#import "LYImageManager.h"

@interface LYShowPhotosController : UIViewController

/** 数组 */
@property (nonatomic, strong) LYAlbumModel *albumModel;

@end

#pragma mark - 展示图片的cell
@interface LYAssetCell : UICollectionViewCell

/** LYAssetModel */
@property (nonatomic, strong) LYAssetModel *assetModel;

/** 选择图片的状态 */
@property (weak, nonatomic) UIImageView *selectStateImg;

/** block  */
@property (nonatomic, copy) void (^assetCellBlock)(BOOL select);

@end

