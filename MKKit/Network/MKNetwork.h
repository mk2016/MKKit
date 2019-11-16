//
//  MKNetwork.h
//  MKKit
//
//  Created by xiaomk on 2018/12/19.
//  Copyright © 2018 tqcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"

@class MKResponseInfo;

typedef NS_ENUM(NSUInteger, MKRequestType) {
    MKRequestType_post = 1,
    MKRequestType_get,
    MKRequestType_put,
    MKRequestType_delete,
    MKRequestType_postImage,
    MKRequestType_postForm,
    MKRequestType_postFileUrl,
    MKRequestType_download,
};

@protocol MKNetworkDelegate <NSObject>
@optional
- (AFHTTPSessionManager * __nullable)makeManagerWithType:(MKRequestType)type;
- (NSDictionary *)getRequestHeader;
@end

typedef void (^MKResponseBlock)(MKResponseInfo *response);
typedef void (^MKProgressBlock)(NSProgress *progress, CGFloat percent);
typedef void (^MKAFMultipartFormDataBlock)(id <AFMultipartFormData> formData);

@interface MKNetwork : NSObject
@property (nonatomic, assign) BOOL analysisDNS;
@property (nonatomic, assign) BOOL checkProxySetting;
@property (nonatomic, assign) BOOL showErrorLog;
@property (nonatomic, weak) id<MKNetworkDelegate>delegate;

+ (instancetype)sharedInstance;

+ (void)sendRequestWith:(NSString *)urlString
                   type:(MKRequestType)requestType
                  param:(NSDictionary *)param
                   file:(id)file
               fileName:(NSString *)fileName
  constructingBodyBlock:(MKAFMultipartFormDataBlock)bodyBlock
               progress:(MKProgressBlock)progressBlock
             completion:(MKResponseBlock)responseBlock;

+ (NSString *)appendQueryToUrl:(NSString *)url byParam:(NSDictionary *)dic;

+ (NSDictionary *)getRequestHeader;
@end


@interface MKResponseInfo : NSObject
@property (nonatomic, assign) NSInteger statusCode;
@property (nonatomic, strong) id originData;
@property (nonatomic, strong) id content;
@property (nonatomic, strong) NSError *error;
@property (nonatomic, copy) NSDictionary *headerFields;
@end

