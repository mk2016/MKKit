//
//  MKRouterHelper.h
//  MKKit
//
//  Created by xmk on 2017/2/15.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKRouter.h"
#import "MKKitConst.h"

@interface MKRouterHelper : NSObject

@property (nonatomic, copy) MKBlock registerRoutesBlock;
@property (nonatomic, copy) NSString *externalRoute;

+ (instancetype)sharedInstance;

/** 初始注册 路由 ，设置 允许 外部打开的 route*/
- (void)initRouterWithAllowExternalRouteArray:(NSArray *)array registerBlock:(void (^)(void))registerBlock;

/** ViewController route */
- (UIViewController *)matchVCWithRoute:(NSString *)route;
- (UIViewController *)matchVCWithRoute:(NSString *)route param:(id)param;

/** block route */
- (MKRouteBlock)matchBlockWithRoute:(NSString *)route;
- (MKRouteBlock)matchBlockWithRoute:(NSString *)route param:(id)param;

- (id)callBlockWithRoute:(NSString *)route;
- (id)callBlockWithRoute:(NSString *)route param:(id)param;

/** can route */
- (MKRouteType)canRoute:(NSString *)route;

#pragma mark - ***** action route *****
- (void)actionWithRoute:(NSString *)route onVC:(UIViewController *)currentVC block:(MKBlock)block;
- (void)actionWithRoute:(NSString *)route param:(id)param onVC:(UIViewController *)currentVC block:(MKBlock)block;
/** 执行 外部 route */
- (void)actionExternalRoute:(NSString *)route;

/** get base route */
- (NSString *)baseRoute:(NSString *)route;
@end
