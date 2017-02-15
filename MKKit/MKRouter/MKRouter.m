//
//  MKRouter.m
//  MKKit
//
//  Created by xmk on 2017/2/14.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "MKRouter.h"
#import "MKKitConst.h"
#import "MKAppInfoHelper.h"

@interface MKRouter()
@property (nonatomic, strong) NSMutableDictionary *routes;
@end

static NSString * kMKRouterControllerClassKey   = @"controller_class";
static NSString * kMKRouterEndKey               = @"_";
static NSString * kMKRouterBlockKey             = @"block";

@implementation MKRouter

MKImpl_sharedInstance(MKRouter)

#pragma mark - ***** public method *****
/** regiser route */
- (void)map:(NSString *)route toControllerClass:(Class)controllerClass{
    MKAssertNotNil(route && controllerClass, @"route and controllerClass unable by nil");
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];
    subRoutes[kMKRouterEndKey] = controllerClass;
}

- (void)map:(NSString *)route toBlock:(MKRouteBlock)block{
    MKAssertNotNil(route && block, @"route and controllerClass unable by nil");
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];
    subRoutes[kMKRouterEndKey] = [block copy];
}

/** match route */
- (UIViewController *)matchController:(NSString *)route{
    MKAssertNotNil(route, @"route unable by nil");
    NSDictionary *params = [self paramsInRoute:route];
    if (!params || !params[kMKRouterControllerClassKey]) {
        return nil;
    }
    
    Class controllerClass = params[kMKRouterControllerClassKey];
    UIViewController *viewController = [[controllerClass alloc] init];
    if ([viewController respondsToSelector:@selector(setParams:)]) {
        NSString *param = params[@"param"];
        if (param && param.length) {
            NSString *decodeParam = [param mk_stringByURLDecode];
            [params setValue:decodeParam forKey:@"param"];
        }
        [viewController performSelector:@selector(setParams:) withObject:[params copy]];
    }
    return viewController;
}

- (MKRouteBlock)matchBlock:(NSString *)route{
    MKAssertNotNil(route, @"route unable by nil");
    NSDictionary *params = [self paramsInRoute:route];
    if (!params || !params[kMKRouterBlockKey]){
        return nil;
    }
    
    MKRouteBlock routerBlock = [params[kMKRouterBlockKey] copy];
    MKRouteBlock returnBlock = ^id(NSDictionary *aParams) {
        if (routerBlock) {
            NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:params];
            [dic addEntriesFromDictionary:aParams];
            return routerBlock([NSDictionary dictionaryWithDictionary:dic].copy);
        }else{
            return nil;
        }
    };
    return [returnBlock copy];
}


/** execute block route */
- (id)callBlock:(NSString *)route{
    MKAssertNotNil(route, @"route unable by nil");
    NSDictionary *params = [self paramsInRoute:route];
    if (!params){
        return nil;
    }
    if (params[kMKRouterBlockKey]) {
        MKRouteBlock routerBlock = [params[kMKRouterBlockKey] copy];
        return routerBlock([params copy]);
    }
    return nil;
}

- (MKRouteType)canRoute:(NSString *)route{
    MKAssertNotNil(route, @"route unable by nil");
    NSDictionary *params = [self paramsInRoute:route];
    if (params[kMKRouterControllerClassKey]) {
        return MKRouteTypeViewController;
    }
    if (params[kMKRouterBlockKey]) {
        return MKRouteTypeBlock;
    }
    return MKRouteTypeNone;
}

#pragma mark - ***** private method *****
/** 以 NSDictionary 层级 保持 route 以 "_" 结束 */
- (NSMutableDictionary *)subRoutesToRoute:(NSString *)route{
    NSArray *pathComponents = [self pathComponentsFromRoute:route];
    NSInteger index = 0;
    NSMutableDictionary *subRoutes = self.routes;
    
    while (index < pathComponents.count) {
        NSString *pathComponent = pathComponents[index];
        if (![subRoutes objectForKey:pathComponent]) {
            subRoutes[pathComponent] = @{}.mutableCopy;
        }
        subRoutes = subRoutes[pathComponent];
        index++;
    }
    return subRoutes;
}

/** 以/分割 返回路径数组 */
- (NSArray *)pathComponentsFromRoute:(NSString *)route{
    NSMutableArray *pathComponents = [NSMutableArray array];
    NSURL *url = [NSURL URLWithString:[route stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    for (NSString *pathComponent in url.path.pathComponents) {
        if ([pathComponent isEqualToString:@"/"]) continue;
        if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
        [pathComponents addObject:[pathComponent stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    return [pathComponents copy];
}

/** 提取 route 中的 params */
- (NSDictionary *)paramsInRoute:(NSString *)route{
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    params[@"route"] = [MKRouter filterAppUrlScheme:route];
    
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromRoute:params[@"route"]];
    for (NSString *pathComponent in pathComponents) {
        BOOL found = NO;
        NSArray *subRoutesKeys = subRoutes.allKeys;
        for (NSString *key in subRoutesKeys) {
            if ([subRoutesKeys containsObject:pathComponent]) {
                found = YES;
                subRoutes = subRoutes[pathComponent];
                break;
            }else if ([key hasPrefix:@":"]){
                found = YES;
                subRoutes = subRoutes[key];
                params[[key substringFromIndex:1]] = pathComponent;
                break;
            }
        }
        if (!found) {
            return nil;
        }
    }
    // Extract Params From Query.
    NSRange firstRange = [route rangeOfString:@"?"];
    if (firstRange.location != NSNotFound && route.length > firstRange.location + firstRange.length) {
        NSString *paramsString = [route substringFromIndex:firstRange.location + firstRange.length];
        NSArray *paramStringArr = [paramsString componentsSeparatedByString:@"&"];
        for (NSString *paramString in paramStringArr) {
            NSArray *paramArr = [paramString componentsSeparatedByString:@"="];
            if (paramArr.count == 2) {
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [[paramArr objectAtIndex:1] mk_stringByURLDecode];
                params[key] = value;
            }else if (paramArr.count > 2){
                NSString *key = [paramArr objectAtIndex:0];
                NSString *value = [paramArr objectAtIndex:1];
                for (NSInteger i = 2; i < paramArr.count; i++) {
                    value = [value stringByAppendingString:[NSString stringWithFormat:@"=%@",[paramArr objectAtIndex:i]]];
                }
                params[key] = [value mk_stringByURLDecode];
            }
        }
    }
    
    Class class = subRoutes[kMKRouterEndKey];
    if (class_isMetaClass(object_getClass(class))) {
        if ([class isSubclassOfClass:[UIViewController class]]) {
            params[kMKRouterControllerClassKey] = subRoutes[kMKRouterEndKey];
        } else {
            return nil;
        }
    } else {
        if (subRoutes[kMKRouterEndKey]) {
            params[kMKRouterBlockKey] = [subRoutes[kMKRouterEndKey] copy];
        }
    }
    return [NSDictionary dictionaryWithDictionary:params];
}

/** route filter scheme */
+ (NSString *)filterAppUrlScheme:(NSString *)route{
    for (NSString *appUrlScheme in [MKAppInfoHelper appUrlSchemes]) {
        if ([route hasPrefix:[NSString stringWithFormat:@"%@:", appUrlScheme]]) {
            return [route substringFromIndex:appUrlScheme.length + 2];
        }
    }
    return route;
}


#pragma mark - ***** lazy *****
- (NSMutableDictionary *)routes{
    if (!_routes) {
        _routes = @{}.mutableCopy;
    }
    return _routes;
}

@end


#pragma mark - UIViewController Category
@implementation UIViewController (MKRouter)

static char kAssociatedParamsObjectKey;

- (void)setParams:(NSDictionary *)paramsDictionary{
    objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, paramsDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)params{
    return objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}
@end
