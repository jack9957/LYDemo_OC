//
//  LYImagePickController.h
//  LYImagePicker
//
//  Created by liyang on 16/10/12.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 获取用户图片和视频的工具类 */
#import "LYImageManager.h"
@class LYImagePickController,LYToolView;

@protocol LYImagePickControllerDelegate <NSObject>

@optional
- (void)kLYImagePickController:(LYImagePickController *)pickController selectItems:(NSArray<LYAssetModel *> *)items;

@end

@interface LYImagePickController : UINavigationController

/** 最小选择个数(默认是1) */
@property (nonatomic, assign) NSInteger minSelectNo;

/** 最大选择个数(默认是9) */
@property (nonatomic, assign) NSInteger maxSelectNo;

/** 代理 */
@property (nonatomic, assign) id<LYImagePickControllerDelegate>pickDelegate;

/** LYToolView,下面的view */
@property (nonatomic, strong) LYToolView *toolView;

/** 初始化方法 */
- (instancetype)initWithMediaType:(LY_AssetType)type delegate:(id<LYImagePickControllerDelegate>)delegate;

@end


@interface LYToolView : UIView

/** 完成按钮btn */
@property (nonatomic, strong) UIButton *toolBtn;

/** 选择个数的label */
@property (nonatomic, strong) UILabel *noLabel;

/** 选择个数的背景图片 */
@property (nonatomic, strong) UIImageView *labelBJView;

/** 预览按钮 */
@property (nonatomic, strong) UIButton *preBtn;

@end
