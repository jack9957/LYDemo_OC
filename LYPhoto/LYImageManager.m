//
//  LYImageManager.m
//  LYImagePicker
//
//  Created by liyang on 16/10/10.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYImageManager.h"

#define kLYScreenWidth [UIScreen mainScreen].bounds.size.width
#define kLYScreenScale 2.0

@implementation LYImageManager

+ (instancetype)sharedImageManager
{
    static LYImageManager *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (sharedInstance == nil) {
            sharedInstance = [[self alloc] init];
        }
    });
    return sharedInstance;
}

// 初始化
- (PHCachingImageManager *)manager
{
    if (!_manager) {
        _manager = [[PHCachingImageManager alloc] init];
    }
    return _manager;
}

// 判断是否得到了用户授权，如果没有授权返回NO，不能访问用户数据
- (BOOL)authorizationStatusAuthorized
{
    return [PHPhotoLibrary authorizationStatus] == PHAuthorizationStatusAuthorized;
}

#pragma mark 获取图片和视频资料的模型
- (void)getAllMediaType:(LY_AssetType)type completion:(void (^)(NSArray<LYAssetModel *> *))completion
{
    // 创建筛选条件
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    if (type == LY_ImageType) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }else if (type == LY_VideoType){
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    }
    
    // 按照时间排序，YES，最新的下面；NO，最新的上面
    option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"modificationDate" ascending:YES]];
    
    PHFetchResult<PHAsset *> *result = [PHAsset fetchAssetsWithOptions:option];
    
    NSMutableArray<LYAssetModel *> *tempArray = [NSMutableArray array];
    
    for (PHAsset *asset in result) {
        [tempArray addObject:[LYAssetModel modelWithAsset:asset]];
    }
    
    if (completion&&tempArray.count) {
        completion(tempArray);
    }
}

#pragma mark 获取相册
- (void)getAllAlbumsType:(LY_AssetType)type completion:(void (^)(NSArray<LYAlbumModel *> *))completion
{
    // 创建筛选条件
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    
    if (type == LY_ImageType) {
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeImage];
    }else if (type == LY_VideoType){
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %ld", PHAssetMediaTypeVideo];
    }
    
    // 获取PHAssetCollection类型（获取全部系统相册）
    PHFetchResult<PHAssetCollection *> *smartAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    // 获取PHAssetCollection类型(获取全部用户相册)
    PHFetchResult<PHCollection *> *topLecelUserCollections = [PHAssetCollection fetchTopLevelUserCollectionsWithOptions:nil];
    
    // 存用户相册数据的数组
    NSMutableArray<LYAlbumModel *> *tempAblum1 = [NSMutableArray array];
    
    // 先找系统相册
    for (PHAssetCollection *assetCollection in smartAlbum) {
        // 找出该资源集合中的media数据
        PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
        // 只找有元素的集合，并且转换成我们自定义的数据模型
        if (fetchResult.count > 0) {
            // 向数组中添加元素
            [tempAblum1 addObject:[LYAlbumModel modelWithResult:fetchResult name:assetCollection.localizedTitle]];
        }
    }
    
    for (PHAssetCollection *assetCollection in topLecelUserCollections) {
        // 找出该资源集合中的media数据
        PHFetchResult<PHAsset *> *fetchResult = [PHAsset fetchAssetsInAssetCollection:assetCollection options:option];
        if (fetchResult.count > 0) {
            // 添加元素
            [tempAblum1 addObject:[LYAlbumModel modelWithResult:fetchResult name:assetCollection.localizedTitle]];
        }
    }
    if (tempAblum1.count&&completion) {
        completion(tempAblum1);
    }
}

#pragma mark 根据一个PHAsset获取其中的图片
- (void)getPhotoWithAsset:(PHAsset *)asset photoWidth:(CGFloat)photoWidth completion:(void (^)(UIImage *, NSDictionary *, BOOL))completion
{
    CGSize imageSize;
    PHAsset *phAsset = (PHAsset *)asset;
    CGFloat aspectRatio = phAsset.pixelWidth / (CGFloat)phAsset.pixelHeight;
    CGFloat pixelWidth = photoWidth * kLYScreenScale;
    CGFloat pixelHeight = pixelWidth / aspectRatio;
    imageSize = CGSizeMake(pixelWidth, pixelHeight);
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        // 如果是本地图
        if (downloadFinined && result) {
            // 判断下图片朝向
            result = [self fixOrientation:result];
            if (completion) {
                // 返回结果
                completion(result,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
            }
        }
        // 如果需要从iCloud下载图片
        if ([info objectForKey:PHImageResultIsInCloudKey] && !result) {
            PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
            option.networkAccessAllowed = YES;
            option.resizeMode = PHImageRequestOptionsResizeModeFast;
            [[PHImageManager defaultManager] requestImageDataForAsset:asset options:option resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
                UIImage *resultImage = [UIImage imageWithData:imageData scale:0.1];
                resultImage = [self scaleImage:resultImage toSize:imageSize];
                if (resultImage) {
                    resultImage = [self fixOrientation:resultImage];
                    if (completion) completion(resultImage,info,[[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                }
            }];
        }
    }];
}

// 缩放图片到目标尺寸
- (UIImage *)scaleImage:(UIImage *)image toSize:(CGSize)size
{
    if (image.size.width > size.width) {
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return newImage;
    } else {
        return image;
    }
}

// 修复图片的朝向
- (UIImage *)fixOrientation:(UIImage *)aImage
{
    
    if (aImage.imageOrientation == UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                             CGImageGetBitsPerComponent(aImage.CGImage), 0,
                                             CGImageGetColorSpace(aImage.CGImage),
                                             CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark 根据AlbumModel获取一张图片
- (void)getImageWithAlbumModel:(LYAlbumModel *)albumModel completion:(void (^)(UIImage *photo))completion
{
    PHAsset *asset = [albumModel.result firstObject];
    [self getPhotoWithAsset:asset photoWidth:80 completion:^(UIImage *photo, NSDictionary *info, BOOL isDegraded) {
        if (photo&&completion) {
            completion(photo);
        }
    }];
    
}

#pragma mark 根据AlbumModel获取一组图片
- (void)getAllMediaByAlbumModel:(LYAlbumModel *)albumModel completion:(void (^)(NSArray<LYAssetModel *> *medias))completion
{
    PHFetchResult *result = albumModel.result;
    
    NSMutableArray<LYAssetModel *> *tempArray = [NSMutableArray array];
    
    for (PHAsset *asset in result) {
        [tempArray addObject:[LYAssetModel modelWithAsset:asset]];
    }
    if (completion&&tempArray.count) {
        completion(tempArray);
    }
}

#pragma mark - 获取原图
- (void)getOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *photo,NSDictionary *info))completion
{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc]init];
    option.networkAccessAllowed = YES;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFit options:option resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        BOOL downloadFinined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (downloadFinined && result) {
            result = [self fixOrientation:result];
            if (completion){
                completion(result,info);
            }
        }
    }];
}
@end

#pragma mark - 相册的模型
@implementation LYAlbumModel

+ (instancetype)modelWithResult:(PHFetchResult *)result name:(NSString *)name
{
    LYAlbumModel *model = [[LYAlbumModel alloc] init];
    model.result = result;
    model.name = name;
    model.count = result.count;
    return model;
}

- (NSString *)description
{
    return [self dictionaryWithValuesForKeys:@[@"name",@"count"]].description;
}

@end

#pragma mark - 相片的模型
@implementation LYAssetModel

+ (instancetype)modelWithAsset:(PHAsset *)asset
{
    LYAssetModel *model = [[LYAssetModel alloc] init];
    model.asset = asset;
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        NSString *timeLength = [NSString stringWithFormat:@"%0.0f",asset.duration];
        model.video_time = [model getNewTimeFromDurationSecond:[timeLength integerValue]];
        model.type = LY_VideoType;
    }else if (asset.mediaType == PHAssetMediaTypeImage){
        model.image_creatTime = [model getImageCreatTimeBy:asset.creationDate];
        model.type = LY_ImageType;
    }
    
    return model;
}

+ (instancetype)modelWithImage:(UIImage *)image
{
    LYAssetModel *model = [[LYAssetModel alloc] init];
    model.thumbImage = image;
    return model;
}

// 获取视频的时长
- (NSString *)getNewTimeFromDurationSecond:(NSInteger)duration
{
    NSString *newTime;
    if(duration < 60) {
        newTime = [NSString stringWithFormat:@"00:%zd",duration];
    }else{
        NSInteger min = duration / 60; // 分
        NSInteger sec = duration - (min * 60); // 秒
        if (sec < 10) {
            newTime = [NSString stringWithFormat:@"%zd:0%zd",min,sec];
        } else {
            newTime = [NSString stringWithFormat:@"%zd:%zd",min,sec];
        }
    }
    return newTime;
}

// 获取照片的创建时间
- (NSString *)getImageCreatTimeBy:(NSDate *)date
{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    return [formatter stringFromDate:date];
}

@end


@implementation UIImage (MyBundle)

+ (UIImage *)imageNamedFromMyBundle:(NSString *)name {
    UIImage *image = [UIImage imageNamed:[@"LYPhotoResource.bundle" stringByAppendingPathComponent:name]];
    if (image) {
        return image;
    } else {
        image = [UIImage imageNamed:[@"Frameworks/LYPhoto.framework/LYPhotoResource.bundle" stringByAppendingPathComponent:name]];
        if (!image) {
            image = [UIImage imageNamed:name];
        }
        return image;
    }
}

@end
