//
//  LYImageManager.h
//  LYImagePicker
//
//  Created by liyang on 16/10/10.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>

#define kLYScreenWidth [UIScreen mainScreen].bounds.size.width
#define kLYScreenHeight [UIScreen mainScreen].bounds.size.height
#define kLYRGBAColor(r, g, b, a) [UIColor colorWithRed:(r)/255.0 green:(r)/255.0 blue:(r)/255.0 alpha:a] // rgba三色

@class LYAlbumModel,LYAssetModel;

typedef NS_ENUM(NSUInteger, LY_AssetType) {
    LY_ImageType,
    LY_VideoType,
    LY_AllMediaType,
};

@interface LYImageManager : NSObject

+ (instancetype)sharedImageManager;

/** 通过这个类来获取图片或者视频 */
@property (nonatomic, strong) PHCachingImageManager *manager;

// 判断是否得到授权，返回YES证明得到了授权
- (BOOL)authorizationStatusAuthorized;

/**
 获取所有的视频、图片数据

 @param type       类型
 @param completion 结果
 */
- (void)getAllMediaType:(LY_AssetType)type completion:(void (^)(NSArray<LYAssetModel *> *medias))completion;

/**
 获取用户相册

 @param type       选择相册中元素的类型
 @param completion 回调结果
 */
- (void)getAllAlbumsType:(LY_AssetType)type completion:(void (^)(NSArray<LYAlbumModel *> *albums))completion;

/**
 获取普通的图片

 @param asset      PHAsset
 @param photoWidth 宽度
 @param completion 结果
 */
- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *photo, NSDictionary *info, BOOL isDegraded))completion;


/**
 根据一个LYAlbumModel获取一张图片

 @param albumModel 模型数据
 @param completion 结果
 */
- (void)getImageWithAlbumModel:(LYAlbumModel *)albumModel completion:(void (^)(UIImage *photo))completion;

/**
 通过一个album获取所有其中包含的图片数组
 
 @param albumModel 模型
 @param completion 结果数组
 */
- (void)getAllMediaByAlbumModel:(LYAlbumModel *)albumModel completion:(void (^)(NSArray<LYAssetModel *> *medias))completion;

/**
 获取原图

 @param asset      PHAsset
 @param completion 结果
 */
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion;

@end


#pragma mark - 相册的模型
@interface LYAlbumModel : NSObject

/** 相册名字 */
@property (nonatomic, copy) NSString *name;

/** 相册中元素个数 */
@property (nonatomic, assign) NSInteger count;

/** 相册中元素的集合 PHFetchResult<PHAsset> */
@property (nonatomic, strong) PHFetchResult *result;

@property (nonatomic, strong) NSArray *models;
@property (nonatomic, strong) NSArray *selectedModels;
@property (nonatomic, assign) NSUInteger selectedCount;

+ (instancetype)modelWithResult:(PHFetchResult *)result name:(NSString *)name;

@end

#pragma mark - 相片和视频的模型
@interface LYAssetModel : NSObject

/** 数据模型 */
@property (nonatomic, strong) PHAsset *asset;

/** 数据类型 */
@property (nonatomic, assign) LY_AssetType type;

/** 如果是视频的话，视频的实际长度  */
@property (nonatomic, copy) NSString *video_time;

/** 如果是图片的话，图片创建时间  */
@property (nonatomic, copy) NSString *image_creatTime;

/** 是否是选中状态 */
@property (nonatomic, assign) BOOL selectedAsset;

/** 原图 */
@property (nonatomic, strong) UIImage *originImg;

/** 普通图 */
@property (nonatomic, strong) UIImage *thumbImage;

+ (instancetype)modelWithAsset:(PHAsset *)asset;

+ (instancetype)modelWithImage:(UIImage *)image;

@end


#pragma mark - 图片加载
@interface UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name;

@end
