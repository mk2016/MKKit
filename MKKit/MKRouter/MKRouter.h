//
//  MKRouter.h
//  MKKit
//
//  Created by xiaomk on 2018/12/24.
//  Copyright © 2018 tqcar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIViewController+MKRouter.h"
#import "MKConst.h"

typedef id (^MKRouterBlock)(id params);

typedef NS_ENUM (NSInteger, MKRouteType) {
    MKRouteType_none            = 0,
    MKRouteType_viewController,
    MKRouteType_block,
    MKRouteType_redirection
};

@interface MKRouter : NSObject
MK_INSTANCETYPE

- (void)map:(NSString *)route toControllerClass:(Class)controllerClass;
- (UIViewController *)matchController:(NSString *)route;

- (void)map:(NSString *)route toBlock:(MKRouterBlock)block;
- (MKRouterBlock)matchBlock:(NSString *)route;

- (void)map:(NSString *)route toRedirection:(NSString *)redirection;
- (id)matchRedirection:(NSString *)route;
- (MKRouteType)redirectionFinallyType:(NSString *)route finallyRoute:(NSString **)finallyRoute;

- (MKRouteType)canRoute:(NSString *)route;

/** 去除 scheme */
+ (NSString *)filterAppUrlScheme:(NSString *)route;
- (NSDictionary *)paramsInRoute:(NSString *)route;
@end

