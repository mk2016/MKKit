//
//  MKNetwork.m
//  MKKit
//
//  Created by xiaomk on 2018/12/19.
//  Copyright © 2018 mk. All rights reserved.
//

#import "MKNetwork.h"
#import "MKConst.h"
#import "MKCategoryHeads.h"
#import "MKAlertView.h"
#import "MKFileUtils.h"
#import "MKDeviceUtils.h"

@implementation MKNetwork

static MKNetwork *sharedInstance = nil;
+ (instancetype)sharedInstance{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

static dispatch_queue_t s_queueNetwork = NULL;

+ (void)sendRequestWith:(NSString *)urlString
                   type:(MKRequestType)requestType
                  param:(NSDictionary *)param
                   file:(id)file fileName:(NSString *)fileName
  constructingBodyBlock:(MKAFMultipartFormDataBlock __nullable)bodyBlock
               progress:(MKProgressBlock)progressBlock
             completion:(MKResponseBlock)responseBlock{
    
    if ([MKNetwork sharedInstance].checkProxySetting) {
        if ([MKNetwork checkProxySetting]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [MKAlertView alertWithTitle:@"提示" message:@"请先关闭代理，保证网络安全" cancelTitle:@"确定" confirmTitle:nil onViewController:nil block:nil];
            });
            MK_BLOCK_EXEC(responseBlock, nil);
            return;
        }
    }
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    });
    NSString *urlStr = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (!param) {
        param = @{}.copy;
    }
    if (!s_queueNetwork) {
        s_queueNetwork = dispatch_queue_create("com.mkkit.network", NULL); // 创建
    }
    MK_WEAK_SELF
    dispatch_async(s_queueNetwork, ^{
        @autoreleasepool {
            switch (requestType) {
                case MKRequestType_get:
                    [weakSelf af_getRequestWihtUrlString:urlStr param:param completion:responseBlock];
                    break;
                case MKRequestType_post:
                    [weakSelf af_postRequestWithUrlString:urlStr param:param completion:responseBlock];
                    break;
                case MKRequestType_put:
                    [weakSelf af_putRequestWithUrlString:urlStr param:param completion:responseBlock];
                    break;
                case MKRequestType_delete:
                    [weakSelf af_deleteRequestWithUrlString:urlStr param:param completion:responseBlock];
                    break;
                case MKRequestType_postImage:
                    if (file && [file isKindOfClass:[UIImage class]]) {
                        [weakSelf af_upLoadImageWithUrl:urlStr param:param image:file imageName:fileName constructingBodyBlock:bodyBlock progress:progressBlock completion:responseBlock];
                    }else{
                        ELog(@"MKNetwork error : source is not image");
                        MK_BLOCK_EXEC(responseBlock, nil);
                    }
                    break;
                case MKRequestType_postForm:
                    [self af_postFormWithUrlString:urlStr param:param formName:fileName completion:responseBlock];
                    break;
                case MKRequestType_download:
                    [self af_downloadWithUrlString:urlStr progress:progressBlock completion:responseBlock];
                    break;
                case MKRequestType_postFileUrl:
                    break;
                default:
                    break;
            }
        }
    });
}

#pragma mark - ***** 请求结果处理 ******
/** response success */
+ (void)responseSuccessWithUrl:(NSString *)urlString param:(NSDictionary *)param method:(NSString *)method httpResponse:(NSURLResponse *)httpResponse responseObject:(id)responseObject block:(MKResponseBlock)block{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    ELog(@"request URL %@ : %@", method, urlString);
    ELog(@"request param : %@", [param mk_jsonString]);
    
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)httpResponse;
    NSInteger statusCode = [resp statusCode];
    ELog(@"response statusCode : %@",@(statusCode));
    
    if ([responseObject isKindOfClass:[NSData class]]) {
        responseObject = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
    }
    
    id content = nil;
    if ([responseObject isKindOfClass:[NSDictionary class]] || [responseObject isKindOfClass:[NSArray class]]) {
        content = responseObject;
    }else{
        content = [NSDictionary mk_dictionaryWithJson:responseObject];
    }
    
    ELog(@"response success json: %@", [content mk_jsonString]);
    
    MKResponseInfo *resInfo = [[MKResponseInfo alloc] init];
    resInfo.statusCode = statusCode;
    resInfo.originData = responseObject;
    resInfo.content = content;
    resInfo.headerFields = resp.allHeaderFields.copy;
    MK_BLOCK_EXEC(block, resInfo);
}

/** response error */
+ (void)responseFailureWithUrl:(NSString *)urlString param:(NSDictionary *)param method:(NSString *)method httpResponse:(NSURLResponse *)httpResponse error:(NSError *)error block:(MKResponseBlock)block{
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    ELog(@"request URL %@ : %@", method, urlString);
    ELog(@"request param : %@", [param mk_jsonString]);
    [self printError:error];
    
    NSHTTPURLResponse *resp = (NSHTTPURLResponse *)httpResponse;
    //    ELog(@"response header : %@", resp.allHeaderFields);
    NSInteger statusCode = [resp statusCode];
    ELog(@"response statusCode:%@ || errorCode:%@",@(statusCode), @(error.code));
    
    MKResponseInfo *resInfo = [[MKResponseInfo alloc] init];
    resInfo.statusCode = statusCode;
    resInfo.error = error;
    resInfo.headerFields = resp.allHeaderFields.copy;
    MK_BLOCK_EXEC(block, resInfo);
}

+ (void)printError:(NSError *)error{
    ELog(@"===============================================");
    ELog(@"error localizedDescription:%@", error.localizedDescription);
    NSData *data = error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] ;
    if (data) {
        ELog(@"errorStr :%@", [[ NSString alloc ] initWithData:data encoding:NSUTF8StringEncoding]);
    }
    if ([MKNetwork sharedInstance].showErrorLog) {
        ELog(@"error userInfo:  %@", error.userInfo);
    }
    ELog(@"end=============================================");
}





#pragma mark - ***** AFNetworging ******
/** GET */
+ (void)af_getRequestWihtUrlString:(NSString *)urlStr param:(NSDictionary *)param completion:(MKResponseBlock)responseBlock{
    MK_WEAK_SELF
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_get];
    [manager GET:urlStr parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf responseSuccessWithUrl:urlStr
                                   param:param
                                  method:@"GET"
                            httpResponse:task.response
                          responseObject:responseObject
                                   block:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf responseFailureWithUrl:urlStr
                                   param:param
                                  method:@"GET"
                            httpResponse:task.response
                                   error:error
                                   block:responseBlock];
    }];
}

/** POST */
+ (void)af_postRequestWithUrlString:(NSString *)urlStr param:(NSDictionary *)param completion:(MKResponseBlock)responseBlock{
    MK_WEAK_SELF
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_post];
    [manager POST:urlStr parameters:param headers:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf responseSuccessWithUrl:urlStr
                                   param:param
                                  method:@"POST"
                            httpResponse:task.response
                          responseObject:responseObject
                                   block:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf responseFailureWithUrl:urlStr
                                   param:param
                                  method:@"POST"
                            httpResponse:task.response
                                   error:error
                                   block:responseBlock];
    }];
}
//POST FORM
+ (void)af_postFormWithUrlString:(NSString *)urlStr param:(NSDictionary *)param formName:(NSString *)formName completion:(MKResponseBlock)responseBlock{
    MK_WEAK_SELF
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_postForm];
    [manager POST:urlStr parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFormData:[[param mk_jsonString] dataUsingEncoding:NSUTF8StringEncoding] name:formName];
    } progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf responseSuccessWithUrl:urlStr
                                   param:param
                                  method:@"POST_FORM"
                            httpResponse:task.response
                          responseObject:responseObject
                                   block:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf responseFailureWithUrl:urlStr
                                   param:param
                                  method:@"POST_FORM"
                            httpResponse:task.response
                                   error:error
                                   block:responseBlock];
    }];
}

/** PUT */
+ (void)af_putRequestWithUrlString:(NSString *)urlStr param:(NSDictionary *)param completion:(MKResponseBlock)responseBlock{
    MK_WEAK_SELF
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_put];
    [manager PUT:urlStr parameters:param headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf responseSuccessWithUrl:urlStr
                                   param:param
                                  method:@"PUT"
                            httpResponse:task.response
                          responseObject:responseObject
                                   block:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf responseFailureWithUrl:urlStr
                                   param:param
                                  method:@"PUT"
                            httpResponse:task.response
                                   error:error
                                   block:responseBlock];
    }];
}

/** DELETE */
+ (void)af_deleteRequestWithUrlString:(NSString *)urlStr param:(NSDictionary *)param completion:(MKResponseBlock)responseBlock{
    MK_WEAK_SELF
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_delete];
    [manager DELETE:urlStr parameters:param headers:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf responseSuccessWithUrl:urlStr
                                   param:param
                                  method:@"DELETE"
                            httpResponse:task.response
                          responseObject:responseObject
                                   block:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf responseFailureWithUrl:urlStr
                                   param:param
                                  method:@"DELETE"
                            httpResponse:task.response
                                   error:error
                                   block:responseBlock];
    }];
}

/** upload image*/
+ (void)af_upLoadImageWithUrl:(NSString *)urlStr param:(NSDictionary *)param image:(UIImage *)image imageName:(NSString *)imageName
        constructingBodyBlock:(MKAFMultipartFormDataBlock)bodyBlock
                     progress:(MKProgressBlock)progressBlock
                   completion:(MKResponseBlock)responseBlock{
    MK_WEAK_SELF
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_postImage];;
    [manager POST:urlStr parameters:param headers:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        if (bodyBlock) {
            MK_BLOCK_EXEC(bodyBlock,formData);
        }else{
            NSData *data = [image mk_compressLessThan1M];
            ELog(@"image Leng : %lu", (unsigned long)data.length);
            NSString *fileName = [NSString stringWithFormat:@"%@.jpg",@([NSDate mk_currentTimestamp])];
            [formData appendPartWithFileData:data name:imageName fileName:fileName mimeType:@"image/jpeg"];
        }
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        CGFloat proportion = 1.0 * uploadProgress.completedUnitCount / uploadProgress.totalUnitCount;
        ELog(@"======= upload proportion : %f" ,proportion);
        MK_BLOCK_EXEC(progressBlock, uploadProgress, proportion);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [weakSelf responseSuccessWithUrl:urlStr
                                   param:param
                                  method:@"UPLOAD_IMAGE"
                            httpResponse:task.response
                          responseObject:responseObject
                                   block:responseBlock];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [weakSelf responseFailureWithUrl:urlStr
                                   param:param
                                  method:@"UPLOAD_IMAGE"
                            httpResponse:task.response
                                   error:error
                                   block:responseBlock];
    }];
}


/** download */
+ (void)af_downloadWithUrlString:(NSString *)urlStr progress:(MKProgressBlock)progressBlock completion:(MKResponseBlock)responseBlock{
    
    AFHTTPSessionManager *manager = [self createManagerWith:MKRequestType_download];;
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]];
    //    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    //    AFURLSessionManager *manager = [[AFURLSessionManager alloc] initWithSessionConfiguration:configuration];
    
    //download task
    MK_WEAK_SELF
    NSURLSessionDownloadTask *task = [manager downloadTaskWithRequest:request progress:^(NSProgress * _Nonnull downloadProgress) {
        CGFloat proportion = 1.0 * downloadProgress.completedUnitCount / downloadProgress.totalUnitCount;
        ELog(@"======= download proportion : %f" ,proportion);
        MK_BLOCK_EXEC(progressBlock, downloadProgress, proportion);
    } destination:^NSURL * _Nonnull(NSURL * _Nonnull targetPath, NSURLResponse * _Nonnull response) {
        //设置下载路径，通过沙盒获取缓存地址，最后返回NSURL对象
        NSString *path = [[MKFileUtils cachePath] stringByAppendingPathComponent:response.suggestedFilename];
        ELog(@"======= download path : %@" ,path);
        return [NSURL fileURLWithPath:path];
    } completionHandler:^(NSURLResponse * _Nonnull response, NSURL * _Nullable filePath, NSError * _Nullable error) {
        ELog(@"======= download over =======");
        if (error == nil) {
            NSDictionary *dic = @{@"filePath" : filePath.absoluteString};
            [weakSelf responseSuccessWithUrl:urlStr
                                       param:nil
                                      method:@"DOWNLOAD"
                                httpResponse:response
                              responseObject:dic
                                       block:responseBlock];
        }else{
            [weakSelf responseFailureWithUrl:urlStr
                                       param:nil
                                      method:@"DOWNLOAD"
                                httpResponse:response
                                       error:error
                                       block:responseBlock];
        }
    }];
    [task resume];
}


static AFHTTPSessionManager *_afHttpSectionManager = nil;
/** create manager */
+ (AFHTTPSessionManager *)createManagerWith:(MKRequestType)type{
    if ([MKNetwork sharedInstance].delegate &&
        [[MKNetwork sharedInstance].delegate respondsToSelector:@selector(makeManagerWithType:)]){
        return [[MKNetwork sharedInstance].delegate makeManagerWithType:type];
    }

    if (!_afHttpSectionManager) {
        _afHttpSectionManager = [AFHTTPSessionManager manager];
        
        _afHttpSectionManager.requestSerializer = [AFJSONRequestSerializer serializer];
//      _afHttpSectionManager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _afHttpSectionManager.requestSerializer.timeoutInterval = 30.f;
        
        _afHttpSectionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//      _afHttpSectionManager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _afHttpSectionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/html",@"text/plain", nil];
        ((AFJSONResponseSerializer *)_afHttpSectionManager.responseSerializer).removesKeysWithNullValues = YES;
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        securityPolicy.validatesDomainName = NO;
        _afHttpSectionManager.securityPolicy = securityPolicy;   
    }
    NSDictionary *dic = [self getRequestHeader];
    if ([MKNetwork sharedInstance].delegate && [[MKNetwork sharedInstance].delegate respondsToSelector:@selector(getRequestHeader)]) {
        dic = [[MKNetwork sharedInstance].delegate getRequestHeader];
    }
    
    for (NSString *key in dic.keyEnumerator) {
        [_afHttpSectionManager.requestSerializer setValue:dic[key] forHTTPHeaderField:key];
    }
    return _afHttpSectionManager;
}

/** 获取 request head 设置 */
+ (nonnull NSDictionary *)getRequestHeader{
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:@"application/json;charset=UTF-8"            forKey:@"Content-Type"];
    [dic setObject:[MKDeviceUtils appBundleShortVersion]        forKey:@"app_v"];       //客户端版本号
    [dic setObject:[MKDeviceUtils appBundleVersion]             forKey:@"app_b_v"];     //客户端内部版本号 int
    [dic setObject:@"iOS"                                       forKey:@"os"];          //系统
    [dic setObject:[MKDeviceUtils systemVersionString]          forKey:@"os_v"];        //系统版本
    [dic setObject:[MKDeviceUtils deviceType]                   forKey:@"os_name"];     //设备名称
    [dic setObject:@([NSDate mk_currentTimestamp]).stringValue  forKey:@"timestamp"];   //时间戳
    return [dic mutableCopy];
}

+ (BOOL)checkProxySetting{
    CFDictionaryRef dicRef = CFNetworkCopySystemProxySettings();
    CFArrayRef arrarRef = CFNetworkCopyProxiesForURL((__bridge CFURLRef _Nonnull)[NSURL URLWithString:@"https://www.baidu.com"],
                                                     dicRef);
    NSArray *proxies = (__bridge NSArray *)arrarRef;
    BOOL ret = NO;
    if (proxies.count > 0) {
        NSDictionary *settings = proxies[0];
        ELog(@"%@",[settings objectForKey:(NSString *)kCFProxyHostNameKey]);
        ELog(@"%@",[settings objectForKey:(NSString *)kCFProxyPortNumberKey]);
        ELog(@"%@",[settings objectForKey:(NSString *)kCFProxyTypeKey]);
        if ([[settings objectForKey:(NSString *)kCFProxyTypeKey] isEqualToString:@"kCFProxyTypeNone"]){
            ELog(@"no proxy");
            ret = NO;
        }else{
            ELog(@"had proxy");
            ret = YES;
        }
    }
    CFRelease(dicRef);
    CFRelease(arrarRef);
    return ret;
}


#pragma mark - ***** tools method ******
+ (NSString *)appendQueryToUrl:(NSString *)url byParam:(NSDictionary *)dic{
    NSMutableArray *queryAry = @[].mutableCopy;
    for (NSString *key in dic) {
        id value = dic[key];
        if (value == nil || [value isEqual:[NSNull null]]) {
            continue;
        }
        NSString *query = [NSString stringWithFormat:@"%@=%@",key, value];
        [queryAry addObject:query];
    }
    if (queryAry.count > 0) {
        NSString *queryStr = [queryAry componentsJoinedByString:@"&"];
        url = [self appendQueryToUrl:url byQuery:queryStr];
    }
    return url;
}

+ (NSString *)appendQueryToUrl:(NSString *)url byQuery:(NSString *)query{
    url = [self filtrateUrl:url];
    NSString *urlQuery = [self getQueryWithUrl:url];
    if (urlQuery && urlQuery.length > 0) {
        url = [url stringByAppendingString:@"&"];
    }else{
        url = [url stringByAppendingString:@"?"];
    }
    url = [url stringByAppendingString:query];
    return url;
}

//filtrate URL tail invalid string
+ (NSString *)filtrateUrl:(NSString *)url{
    if (url && url.length > 1) {
        NSString *lastStr = [url substringFromIndex:url.length-1];
        if ([lastStr isEqualToString:@"?"] || [lastStr isEqualToString:@"&"] ) {
            url = [url substringToIndex:(url.length-1)];
            return [self filtrateUrl:url];
        }
    }
    return url;
}

//get URL query
+ (NSString *)getQueryWithUrl:(NSString *)url{
    NSString *urlQuery = [NSURL URLWithString:url].query;
    if (urlQuery == nil) {
        NSRange range = [url rangeOfString:@"?" options:NSLiteralSearch];
        if (range.location != NSNotFound) {
            urlQuery = [url substringFromIndex:range.location+range.length];
        }
    }
    return urlQuery;
}
@end


@implementation MKResponseInfo
@end
