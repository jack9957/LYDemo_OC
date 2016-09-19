//
//  LYNetworking.h
//  project2016
//
//  Created by liyang on 16/6/14.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import <UIKit/UIKit.h>

/** 网络请求类 **/

NS_ASSUME_NONNULL_BEGIN

/** 成功的回调 */
typedef void (^ LYResponseSuccess)(id responseObject);

/** 失败的回调 */
typedef void (^ LYResponseFail)(NSError *error);

/**
 *  下载(上传)进度
 *
 *  @param completeCount 已经完成的大小
 *  @param totalCount    文件总大小
 */
typedef void (^ _Nullable Progress)(int64_t completeCount, int64_t totalCount);
/** 下载进度条 */
typedef Progress LYDownloadProgress;
/** 上传进度条 */
typedef Progress LYUploadProgress;

/** 返回类型，默认JSON */
typedef NS_ENUM(NSUInteger, LYResponseType) {
    kLYResponseTypeJSON = 1,
    kLYResponseTypeXML = 2,
    kLYResponseTypeData = 3
};

/** 网络状态 */
typedef NS_ENUM(NSUInteger, LYNetworkStatus) {
    kLYNetworkStatusUnknow = 0, // 未知的网络状态
    kLYNetworkStatusReachable = 1, // 无网络
    kLYNetworkStatusReachableViaWWAN = 2, // 蜂窝数据网
    kLYNetworkStatusReachableViaWiFi = 3 // WiFi网络
};

/** 请求方式 */
typedef NS_ENUM(NSUInteger, LYHttpMethod) {
    GET = 0,
    POST = 1
};


@interface LYNetworking : NSObject

/**
 *  检查网络状态
 *
 *  @param callBack 返回此刻的网络状态
 */
+ (void)checkNetworkCallBack:(void(^)(LYNetworkStatus status))callBack;

/**
 *  域名
 *
 *  @return 域名
 */
+ (NSString *)baseUrl;

/**
 *  更新域名
 *
 *  @param baseUrl 最新域名
 */
+ (void)updateBaseUrl:(NSString *)baseUrl;

/**
 *  设置返回值类型
 *
 *  @param responseType 请求返回值类型
 */
+ (void)configResponse:(LYResponseType)responseType;

/**
 *  get请求
 *
 *  @param urlString 请求的路径，如path/getArticleList
 *  @param param     请求的参数，如@{@"key":@"value"}
 *  @param success   请求得到的结果
 *  @param failure   请求失败
 */
+ (void)getWithUrl:(NSString *)urlString
            params:(NSDictionary *)param
          progress:(Progress)progress
           success:(LYResponseSuccess)success
           failure:(LYResponseFail)failure;

/**
 *  post请求
 *
 *  @param urlString 请求路径 如path/getArticleList
 *  @param param     请求参数 如@{@"key":@"value"}
 *  @param success   成功
 *  @param progress  进度
 *  @param failure   失败
 */
+ (void)postWithUrl:(NSString *)urlString
            params:(NSDictionary *)param
          progress:(Progress)progress
           success:(LYResponseSuccess)success
           failure:(LYResponseFail)failure;

/**
 *  下载
 *
 *  @param URLString       下载链接
 *  @param progress        下载进度
 *  @param filePath        下载路径
 *  @param downLoadSuccess 下载成功
 *  @param failure         下载失败
 */
+ (void)downLoadWithURL:(NSString *)URLString progress:(LYDownloadProgress)progress filePath:(NSString *)filePath downLoadSuccess:(LYResponseSuccess)downLoadSuccess failure:(LYResponseFail)failure;

/**
 *  图片上传(单张图片)
 *
 *  @param URLString  上传接口
 *  @param parameters 上传参数
 *  @param img        上传图片
 *  @param imageName  自定义的图片名称（全部用字母写，不能出现汉字）
 *  @param fileName   由后台指定的图片名称
 *  @param progress   上传进度
 *  @param success    成功的回调方法
 *  @param failure    失败的回调方法
 */
+ (void)UpLoadWithPOST:(NSString *)URLString parameters:(NSDictionary *)parameters image:(UIImage *)img imageName:(NSString *)imageName fileName:(NSString *)fileName progress:(LYUploadProgress)progress success:(LYResponseSuccess)success failure:(LYResponseFail)failure;

/**
 *  上传文件
 *
 *  @param url           上传接口
 *  @param uploadingFile 上传文件的url路径
 *  @param progress      上传进度
 *  @param success       成功
 *  @param fail          失败
 */
+ (void)uploadFileWithUrl:(NSString *)url
            uploadingFile:(NSString *)uploadingFile
                 progress:(LYUploadProgress)progress
                  success:(LYResponseSuccess)success
                     fail:(LYResponseFail)fail;
@end

NS_ASSUME_NONNULL_END