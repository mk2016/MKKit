//
//  MKRouter.m
//  MKKit
//
//  Created by xiaomk on 2018/12/24.
//  Copyright © 2018 mk. All rights reserved.
//

#import "MKRouter.h"
#import <objc/runtime.h>
#import "NSString+MKAdd.h"

@interface MKRouter()
@property (nonatomic, strong) NSMutableDictionary *routes;
@end

static NSString * kMKRouterKeyVCClass       = @"controllerClass";
static NSString * kMKRouterKeyPath          = @"routePath";
static NSString * kMKRouterKeyRoute         = @"route";
static NSString * kMKRouterKeyOrginRoute    = @"orginRoute";
static NSString * kMKRouterKeyParam         = @"param";

static NSString * kMKRouterKeyRedirection   = @"redirectionRoute";
static NSString * kMKRouterKeyBlock         = @"block";
static NSString * kMKRouterKeyEnd           = @"_";

@implementation MKRouter
MK_IMPL_SHAREDINSTANCE(MKRouter)

#pragma mark - ***** ControllerClass ******
- (void)map:(NSString *)route toControllerClass:(Class)controllerClass{
    if (route && controllerClass){
        NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];
        subRoutes[kMKRouterKeyEnd] = controllerClass;
    }
}

- (UIViewController *)matchController:(NSString *)route{
    return [self matchController:route orginRoute:nil];
}

#pragma mark - ***** block *****
- (void)map:(NSString *)route toBlock:(MKRouterBlock)block{
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];
    subRoutes[kMKRouterKeyEnd] = [block copy];
}

- (MKRouterBlock)matchBlock:(NSString *)route{
    return [self matchBlock:route orginRoute:nil];
}

- (id)callBlock:(NSString *)route{
    NSDictionary *params = [self paramsInRoute:route];
    MKRouterBlock routerBlock = [params[kMKRouterKeyBlock] copy];
    if (routerBlock) {
        return routerBlock([params copy]);
    }
    return nil;
}

#pragma mark - ***** Redirection *****
- (void)map:(NSString *)route toRedirection:(NSString *)redirection{
    NSMutableDictionary *subRoutes = [self subRoutesToRoute:route];
    subRoutes[kMKRouterKeyEnd] = redirection;
}

- (id)matchRedirection:(NSString *)route{
    NSString *finallyRoute = nil;
    MKRouteType type = [self redirectionFinallyType:route finallyRoute:&finallyRoute];
    if (type == MKRouteType_block) {
        return [self matchBlock:finallyRoute orginRoute:route];
    }else if (type == MKRouteType_viewController){
        return [self matchController:finallyRoute orginRoute:route];
    }
    return nil;
}

- (MKRouteType)redirectionFinallyType:(NSString *)route finallyRoute:(NSString **)finallyRoute{
    MKRouteType type = [self canRoute:route];
    if (type == MKRouteType_none || type == MKRouteType_block || type == MKRouteType_viewController) {
        return type;
    }else if (type == MKRouteType_redirection){
        NSString *nextRoute = [self matchNextRouteWith:route];
        *finallyRoute = nextRoute;
        return [self redirectionFinallyType:nextRoute finallyRoute:finallyRoute];
    }
    return MKRouteType_none;
}

#pragma mark - ***** other *****
- (MKRouteType)canRoute:(NSString *)route{
    NSDictionary *params = [self paramsInRoute:route];
    if (params[kMKRouterKeyVCClass]) {
        return MKRouteType_viewController;
    }
    if (params[kMKRouterKeyBlock]) {
        return MKRouteType_block;
    }
    if (params[kMKRouterKeyRedirection]) {
        return MKRouteType_redirection;
    }
    return MKRouteType_none;
}


#pragma mark - ========= private method =========
#pragma mark - ***** register *****
/** user NSDictionary iteration keep router */
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

#pragma mark - ***** match *****
/** view controller */
- (UIViewController *)matchController:(NSString *)route orginRoute:(NSString *)orginRoute{
    NSMutableDictionary *params = [self paramsInRoute:route].mutableCopy;
    if (orginRoute && orginRoute.length > 0){
        [params setValue:orginRoute forKey:kMKRouterKeyOrginRoute];
    }
    Class controllerClass = params[kMKRouterKeyVCClass];
    
    UIViewController *viewController = nil;
    NSArray *pathAry = [params[kMKRouterKeyPath] componentsSeparatedByString:@"/"];
    if (pathAry && pathAry.count >= 3 && [pathAry.firstObject isEqualToString:@"sb"]) {
        viewController = [[UIStoryboard storyboardWithName:pathAry[1] bundle:nil] instantiateViewControllerWithIdentifier:pathAry[2]];
    }else{
        viewController = [[controllerClass alloc] init];
    }
    if ([viewController respondsToSelector:@selector(setMk_routeParams:)]){
        NSString *codeStr = params[kMKRouterKeyParam];
        NSRange range = [codeStr rangeOfString:@"%"];
        if (codeStr && range.location != NSNotFound){
            NSString *json = [codeStr mk_stringByURLDecode];
            
            NSMutableDictionary *tempDic = params.mutableCopy;
            [tempDic setValue:json forKey:kMKRouterKeyParam];
            params = tempDic.mutableCopy;
        }
        [viewController performSelector:@selector(setMk_routeParams:) withObject:params.copy];
    }
    return  viewController;
}

/** block */
- (MKRouterBlock)matchBlock:(NSString *)route orginRoute:(NSString *)orginRoute{
    NSMutableDictionary *params = [self paramsInRoute:route].mutableCopy;
    if (!params){
        return nil;
    }
    if (orginRoute && orginRoute.length > 0) {
        [params setValue:orginRoute forKey:kMKRouterKeyOrginRoute];
    }
    MKRouterBlock routerBlock = [params[kMKRouterKeyBlock] copy];
    MKRouterBlock returnBlock = ^id(NSDictionary *aParams) {
        if (routerBlock) {
            NSMutableDictionary *dic = params.mutableCopy;
            [dic addEntriesFromDictionary:aParams];
            return routerBlock(dic.copy);
        }
        return nil;
    };
    return [returnBlock copy];
    
}

/** redirection */
- (NSString *)matchNextRouteWith:(NSString *)route{
    NSDictionary *params = [self paramsInRoute:route];
    if (!params) {
        return nil;
    }
    NSString *redirectionRoute = params[kMKRouterKeyRedirection];
    if (redirectionRoute) {
        NSMutableString *finallyRoute = [NSMutableString stringWithString:redirectionRoute];
        NSArray *paths = [finallyRoute componentsSeparatedByString:@"/"];
        for (NSString *str in paths) {
            if ([str hasPrefix:@":"]) {
                if ([params valueForKey:[str substringFromIndex:1]]) {
                    NSRange range = [finallyRoute rangeOfString:str];
                    if (range.location != NSNotFound) {
                        [finallyRoute replaceCharactersInRange:range withString:[params valueForKey:[str substringFromIndex:1]]];
                    }
                }
            }
        }
        if (route) {
            NSRange range = [route rangeOfString:@"?"];
            if (range.location != NSNotFound) {
                NSMutableString *orginRoute = [NSMutableString stringWithString:route];
                [orginRoute replaceCharactersInRange:NSMakeRange(0, range.location) withString:finallyRoute];
                return orginRoute;
            }
        }
        return finallyRoute ;
    }
    
    return nil;
}

#pragma mark - ***** return dictionay with route info *****
- (NSDictionary *)paramsInRoute:(NSString *)route{
    if (!route) {
        return nil;
    }
    NSMutableDictionary *params = @{}.mutableCopy;
    params[kMKRouterKeyRoute] = [MKRouter filterAppUrlScheme:route];
    
    NSMutableDictionary *subRoutes = self.routes;
    NSArray *pathComponents = [self pathComponentsFromRoute:params[kMKRouterKeyRoute]];
    params[kMKRouterKeyPath] = [pathComponents componentsJoinedByString:@"/"];
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
    Class class = subRoutes[kMKRouterKeyEnd];
    if (class_isMetaClass(object_getClass(class))) {
        if ([class isSubclassOfClass:[UIViewController class]]) {
            params[kMKRouterKeyVCClass] = subRoutes[kMKRouterKeyEnd];
        } else {
            return nil;
        }
    } else {
        if (subRoutes[kMKRouterKeyEnd]) {
            if ([subRoutes[kMKRouterKeyEnd] isKindOfClass:[NSString class]]) {
                params[kMKRouterKeyRedirection] = subRoutes[kMKRouterKeyEnd];
            }else{
                params[kMKRouterKeyBlock] = [subRoutes[kMKRouterKeyEnd] copy];
            }
        }
    }
    return params.copy;
}

/** return route path array */
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

#pragma mark - ***** filter out the app URL compontents *****
+ (NSString *)filterAppUrlScheme:(NSString *)route{
    for (NSString *appUrlScheme in [self appUrlSchemes]) {
        if ([route hasPrefix:[NSString stringWithFormat:@"%@:", appUrlScheme]]) {
            return [route substringFromIndex:appUrlScheme.length + 2];
        }
    }
    return route;
}

/** app URL schemes */
+ (NSArray *)appUrlSchemes{
    NSMutableArray *appUrlSchemes = [NSMutableArray array];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    for (NSDictionary *dic in infoDictionary[@"CFBundleURLTypes"]) {
        NSString *appUrlScheme = dic[@"CFBundleURLSchemes"][0];
        [appUrlSchemes addObject:appUrlScheme];
    }
    return [appUrlSchemes copy];
}

#pragma mark - ***** lazy *****
- (NSMutableDictionary *)routes{
    if (!_routes) {
        _routes = @{}.mutableCopy;
    }
    return _routes;
}
@end
