//
//  MKNetwork.h
//  TQSAASPro
//
//  Created by xiaomk on 2018/12/19.
//  Copyright © 2018 tqcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class MKResponseInfo;

typedef NS_ENUM(NSInteger, MKRequestType) {
    MKRequestType_post = 1,
    MKRequestType_get,
    MKRequestType_put,
    MKRequestType_delete,
    MKRequestType_postImage,
    MKRequestType_postFileUrl,
    MKRequestType_download,
};

typedef void (^MKResponseBlock)(MKResponseInfo *response);
typedef void (^MKProgressBlock)(NSProgress *progress, CGFloat percent);

@interface MKNetwork : NSObject
@property (nonatomic, assign) BOOL analysisDNS;
@property (nonatomic, assign) BOOL checkProxySetting;

+ (instancetype)sharedInstance;

+ (void)sendRequestWith:(NSString *)urlString
                   type:(MKRequestType)requestType
                  param:(NSDictionary *)param
                   file:(id)file
             completion:(MKResponseBlock)responseBlock;

+ (void)sendRequestWith:(NSString *)urlString
                   type:(MKRequestType)requestType
                  param:(NSDictionary *)param
                   file:(id)file
               progress:(MKProgressBlock)progressBlock
             completion:(MKResponseBlock)responseBlock;

@end


@interface MKResponseInfo : NSObject
@property (nonatomic, assign) NSInteger httpCode;
@property (nonatomic, strong) id originData;
@property (nonatomic, copy) NSDictionary *content;
@property (nonatomic, strong) NSError *error;
@end

