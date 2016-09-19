//
//  LYNetworking.m
//  project2016
//
//  Created by liyang on 16/6/14.
//  Copyright © 2016年 liyang. All rights reserved.
//

#import "LYNetworking.h"

#import "AFNetworking.h"

@implementation LYNetworking

/** 域名 */
static NSString *ly_NetworkBaseUrl = @"http://120.24.1.189";
/** 接受的返回值类型 */
static LYResponseType ly_responseType = kLYResponseTypeJSON;
/** 网络状态 */
static LYNetworkStatus ly_networkStatus = kLYNetworkStatusUnknow;
/** 等待相应时间 */
static NSTimeInterval ly_timeout = 60.0f;


#pragma mark - 检查此刻的网络状态
/**
 *  检查网络状态
 *
 *  @param callBack 返回此刻的网络状态
 */
+ (void)checkNetworkCallBack:(void(^)(LYNetworkStatus status))callBack
{
    // 创建网络监测者
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        // 监测到不同网络的情况
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
            {
                ly_networkStatus = kLYNetworkStatusUnknow;
                callBack(kLYNetworkStatusUnknow);
            }
                break;
                
            case AFNetworkReachabilityStatusNotReachable:
            {
                ly_networkStatus = kLYNetworkStatusReachable;
                callBack(kLYNetworkStatusReachable);
            }
                break;
                
            case AFNetworkReachabilityStatusReachableViaWWAN:
            {
                ly_networkStatus = kLYNetworkStatusReachableViaWWAN;
                callBack(kLYNetworkStatusReachableViaWWAN);
            }
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
            {
                ly_networkStatus = kLYNetworkStatusReachableViaWiFi;
                callBack(kLYNetworkStatusReachableViaWiFi);
            }
                break;
                
            default:
                break;
        }
    }] ;
    // 开始监听网络状况
    [manager startMonitoring];
}

#pragma mark - 设置域名
/**
 *  域名
 *
 *  @return 域名
 */
+ (NSString *)baseUrl
{
    return ly_NetworkBaseUrl;
}

/**
 *  更新域名
 *
 *  @param baseUrl 最新域名
 */
+ (void)updateBaseUrl:(NSString *)baseUrl
{
    ly_NetworkBaseUrl = baseUrl;
}

#pragma mark - 配置返回值类型
/**
 *  设置返回值类型
 *
 *  @param responseType 请求返回值类型
 */
+ (void)configResponse:(LYResponseType)responseType
{
    ly_responseType = responseType;
}

#pragma mark - get 请求
/**
 *  get请求
 *
 *  @param urlString 请求的路径，如 path/getArticleList
 *  @param param     请求的参数，如@{@"key":@"value"}
 *  @param success   请求得到的结果
 *  @param failure   请求失败
 */
+ (void)getWithUrl:(NSString *)urlString
            params:(NSDictionary *)param
          progress:(Progress)progress
           success:(LYResponseSuccess)success
           failure:(LYResponseFail)failure;
{
    [self requestWithUrl:[self ly_URLEncode:urlString] refreshCache:NO httpMedth:GET params:param success:success progress:progress fail:failure];
}

#pragma mark - post 请求
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
            failure:(LYResponseFail)failure
{
    [self requestWithUrl:[self ly_URLEncode:urlString] refreshCache:NO httpMedth:POST params:param success:success progress:progress fail:failure];
}

#pragma mark - 下载
/**
 *  下载
 *
 *  @param URLString       下载链接
 *  @param progress        下载进度
 *  @param filePath        下载路径
 *  @param downLoadSuccess 下载成功
 *  @param failure         下载失败
 */
+ (void)downLoadWithURL:(NSString *)URLString progress:(LYDownloadProgress)progress filePath:(NSString *)filePath downLoadSuccess:(LYResponseSuccess)downLoadSuccess failure:(LYResponseFail)failure
{
    AFHTTPSessionManager *manager = [self manager];
    
    //  开启状态栏动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self ly_URLEncode:URLString]]];
    
    // 下载任务
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        if (progress) {
            progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
        }
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        return [NSURL URLWithString:filePath];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        if (!error) {
            downLoadSuccess(response);
        }else{
            failure(error);
        }
        //  开启状态栏动画
        [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    
    // 开始启动任务
    [task resume];
}

#pragma mark - 上传图片
/**
 *  封装POST图片上传(单张图片)
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
+ (void)UpLoadWithPOST:(NSString *)URLString parameters:(NSDictionary *)parameters image:(UIImage *)img imageName:(NSString *)imageName fileName:(NSString *)fileName progress:(LYUploadProgress)progress success:(LYResponseSuccess)success failure:(LYResponseFail)failure
{
    AFHTTPSessionManager *manager = [self manager];
    
    //  开启状态栏动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLSessionDataTask *uploadTask = [manager POST:URLString parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        NSData *imgData = UIImageJPEGRepresentation(img, 1.0);
        // 第一个name是后台给图片在服务器上起的字段名，第二个fileName是我们自己起的名字
        NSString *imageFileName = fileName;
        if (fileName == nil || ![fileName isKindOfClass:[NSString class]] || fileName.length == 0) {
            NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
            formatter.dateFormat = @"yyyyMMddHHmmss";
            NSString *str = [formatter stringFromDate:[NSDate date]];
            imageFileName = [NSString stringWithFormat:@"%@.jpg", str];
        }
        
        [formData appendPartWithFileData:imgData name:imageName fileName:imageFileName mimeType:@"image/jpeg"];
        
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.totalUnitCount, uploadProgress.totalUnitCount);
        }
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        if (success) {
            success(responseObject);
        }
      [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        if (failure) {
            failure(error);
        }
         [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    }];
    [uploadTask resume];
}

#pragma mark - 上传文件
+ (void)uploadFileWithUrl:(NSString *)url
            uploadingFile:(NSString *)uploadingFile
                 progress:(LYUploadProgress)progress
                  success:(LYResponseSuccess)success
                     fail:(LYResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    
    //  开启状态栏动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[self ly_URLEncode:url]]];
    
    [manager uploadTaskWithRequest:request fromFile:[NSURL URLWithString:uploadingFile] progress:^(NSProgress * _Nonnull uploadProgress) {
        if (progress) {
            progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
        }
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
        if (!error) {
            if (fail) {
                fail(error);
            }
        }else{
            if (success) {
                success(responseObject);
            }
        }
    }];
}

#pragma mark - 私有方法
+ (AFHTTPSessionManager *)manager
{
    AFHTTPSessionManager *manager = nil;
    
    if ([self baseUrl] != nil) {
        manager = [[AFHTTPSessionManager alloc] initWithBaseURL:[NSURL URLWithString:[self baseUrl]]];
    }else{
        manager = [AFHTTPSessionManager manager];
    }
    
    switch (ly_responseType) {
        case kLYResponseTypeJSON: {
            manager.responseSerializer = [AFJSONResponseSerializer serializer];
            break;
        }
        case kLYResponseTypeXML: {
            manager.responseSerializer = [AFXMLParserResponseSerializer serializer];
            break;
        }
        case kLYResponseTypeData: {
            manager.responseSerializer = [AFHTTPResponseSerializer serializer];
            break;
        }
        default: {
            break;
        }
    }
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*"]];
    
    manager.requestSerializer.timeoutInterval = ly_timeout;
    
    // 设置允许同时最大并发数量，过大容易出问题
    manager.operationQueue.maxConcurrentOperationCount = 3;
    
    return manager;
}
+ (void)requestWithUrl:(NSString *)url
          refreshCache:(BOOL)refreshCache
             httpMedth:(LYHttpMethod)httpMethod
                params:(NSDictionary *)params
               success:(LYResponseSuccess)success
              progress:(LYDownloadProgress)progress
                  fail:(LYResponseFail)fail
{
    AFHTTPSessionManager *manager = [self manager];
    
    //  开启状态栏动画
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
    
    if (httpMethod == GET) {
        [manager GET:url parameters:params progress:^(NSProgress * _Nonnull downloadProgress) {
            // 下载进度
            if (progress) {
                progress(downloadProgress.completedUnitCount, downloadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            success(responseObject);
            // 状态栏动画消失
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            fail(error);
            // 状态栏动画消失
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }else if (httpMethod == POST){
        [manager POST:url parameters:params progress:^(NSProgress * _Nonnull uploadProgress) {
            if (progress) {
                progress(uploadProgress.completedUnitCount, uploadProgress.totalUnitCount);
            }
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            // 成功
            success(responseObject);
            // 状态栏动画消失
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            //失败
            fail(error);
            // 状态栏动画消失
            [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
        }];
    }
}

+ (NSString *)ly_URLEncode:(NSString *)urlString
{
    NSString *newUrl = [NSString stringWithFormat:@"%@/%@", ly_NetworkBaseUrl, urlString];
    return [newUrl stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
}

@end
