//
//  AFHTTPSessionManager+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/2/1.
//  Copyright © 2019 mk. All rights reserved.
//

#import "AFHTTPSessionManager+MKAdd.h"
#import <objc/runtime.h>
#import "MKNetwork.h"
#import "NSMutableURLRequest+MKAdd.h"
#import "MKConst.h"


@implementation AFHTTPSessionManager (MKAdd)

+ (void)load{
    [super load];
    SEL originalSel = @selector(dataTaskWithHTTPMethod:URLString:parameters:uploadProgress:downloadProgress:success:failure:);
    SEL newSel = @selector(mk_dataTaskWithHTTPMethod:URLString:parameters:uploadProgress:downloadProgress:success:failure:);
    
    Method originalMethod = class_getInstanceMethod(self, originalSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    if (originalMethod && newMethod){
        class_addMethod(self,
                        originalSel,
                        class_getMethodImplementation(self, originalSel),
                        method_getTypeEncoding(originalMethod));
        class_addMethod(self,
                        newSel,
                        class_getMethodImplementation(self, newSel),
                        method_getTypeEncoding(newMethod));
        
        method_exchangeImplementations(class_getInstanceMethod(self, originalSel),
                                       class_getInstanceMethod(self, newSel));
        ELog(@"AFHTTPSessionManager replace method success");

    }
}

- (NSURLSessionDataTask *)mk_dataTaskWithHTTPMethod:(NSString *)method
                                          URLString:(NSString *)URLString
                                         parameters:(id)parameters
                                     uploadProgress:(nullable void (^)(NSProgress *uploadProgress)) uploadProgress
                                   downloadProgress:(nullable void (^)(NSProgress *downloadProgress)) downloadProgress
                                            success:(void (^)(NSURLSessionDataTask *, id))success
                                            failure:(void (^)(NSURLSessionDataTask *, NSError *))failure
{
    NSError *serializationError = nil;
    NSMutableURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:URLString relativeToURL:self.baseURL] absoluteString] parameters:parameters error:&serializationError];
    if ([MKNetwork sharedInstance].analysisDNS) {
        [request mk_switchToIp];
    }
    if (serializationError) {
        if (failure) {
            dispatch_async(self.completionQueue ?: dispatch_get_main_queue(), ^{
                failure(nil, serializationError);
            });
        }
        
        return nil;
    }
    
    __block NSURLSessionDataTask *dataTask = nil;
    dataTask = [self dataTaskWithRequest:request
                          uploadProgress:uploadProgress
                        downloadProgress:downloadProgress
                       completionHandler:^(NSURLResponse * __unused response, id responseObject, NSError *error) {
                           if (error) {
                               if (failure) {
                                   failure(dataTask, error);
                               }
                           } else {
                               if (success) {
                                   success(dataTask, responseObject);
                               }
                           }
                       }];
    
    return dataTask;
}


@end
