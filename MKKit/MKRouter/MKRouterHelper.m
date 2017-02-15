//
//  MKRouterHelper.m
//  MKKit
//
//  Created by xmk on 2017/2/15.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "MKRouterHelper.h"
#import "MKUIHelper.h"

@interface MKRouterHelper()

@property (nonatomic, strong) NSMutableArray *externalRouterArray;
@property (nonatomic, strong) Class baseClass;
@end

@implementation MKRouterHelper

static const NSString * kMKRouteCustomBlockKey = @"customBlock";

MKImpl_sharedInstance(MKRouterHelper);

/** init method */
- (void)initRouterWithAllowExternalRouteArray:(NSArray *)array registerBlock:(void (^)(void))registerBlock{
    if (array) {
        [self.externalRouterArray addObjectsFromArray:array];
    }
    MKBlockExec(registerBlock);
}

/** route append param */
- (NSString *)route:(NSString *)route appendParam:(id)param{
    if (route && param) {
        NSString *encodeStr = [[param mj_JSONString] mk_stringByURLEncode];
        if (encodeStr) {
            NSString *paramStr = [NSString stringWithFormat:@"?param=%@",encodeStr];
            route = [route stringByAppendingString:paramStr];
        }
    }
    return route;
}

#pragma mark - ***** viewcontroller route *****
- (UIViewController *)matchVCWithRoute:(NSString *)route{
    UIViewController *vc = [[MKRouter sharedInstance] matchController:route];
    if ([vc isKindOfClass:self.baseClass]) {
        return vc;
    }
    return nil;
}

- (UIViewController *)matchVCWithRoute:(NSString *)route param:(id)param{
    NSString *routeFull = [self route:route appendParam:param];
    if (routeFull) {
        return [self matchVCWithRoute:routeFull];
    }
    return nil;
}

#pragma mark - ***** block route *****
- (MKRouteBlock)matchBlockWithRoute:(NSString *)route{
    return [[MKRouter sharedInstance] matchBlock:route];
}

- (MKRouteBlock)matchBlockWithRoute:(NSString *)route param:(id)param{
    NSString *routeFull = [self route:route appendParam:param];
    if (routeFull) {
        return [self matchBlockWithRoute:routeFull];
    }
    return nil;
}

#pragma mark - ***** call block *****
- (id)callBlockWithRoute:(NSString *)route{
    return [[MKRouter sharedInstance] callBlock:route];
}

- (id)callBlockWithRoute:(NSString *)route param:(id)param{
    NSString *routeFull = [self route:route appendParam:param];
    if (routeFull) {
        return [self matchBlockWithRoute:routeFull];
    }
    return nil;
}

#pragma mark - ***** can router *****
- (MKRouteType)canRoute:(NSString *)route{
    return [[MKRouter sharedInstance] canRoute:route];
}

#pragma mark - ***** action route *****
- (void)actionWithRoute:(NSString *)route onVC:(UIViewController *)currentVC block:(MKBlock)block{
    MKRouteType type = [self canRoute:route];
    if (type == MKRouteTypeNone || !route || route.length == 0) {
        return;
    }
    if (type == MKRouteTypeViewController) {
        UIViewController *vc = [self matchVCWithRoute:route];
//        TQBaseViewController *vc = [self matchVCWithRoute:route];
//        vc.block = block;
//        NSString *sRoute = [self baseRoute:route];
//        if ([sRoute isEqualToString:kRoute_itemDetail]) {
//            ((CommonWebView_VC *)vc).urlStr = [TQWebUrlManager sharedInstance].url_carItemDetail;
//        }
        [currentVC.navigationController pushViewController:vc animated:YES];
    }else if (type == MKRouteTypeBlock){
        MKRouteBlock routerBlock = [self matchBlockWithRoute:route];
        if (block) {
            NSDictionary *dic = @{kMKRouteCustomBlockKey: [block copy]};
            MKBlockExec(routerBlock, dic);
        }else{
            MKBlockExec(routerBlock, nil);
        }
    }
}

- (void)actionWithRoute:(NSString *)route param:(id)param onVC:(UIViewController *)currentVC block:(MKBlock)block{
    if (param && route) {
        route = [self route:route appendParam:param];
    }
    [self actionWithRoute:route onVC:currentVC block:block];
}

/** 执行 外部 route */
- (void)actionExternalRoute:(NSString *)route{
    if (route == nil) {
        route = self.externalRoute;
    }
    if (route) {
        if ([self canRouteWithExternal:route]) {
            
        }
    }
}

- (BOOL)canRouteWithExternal:(NSString *)route{
    route = [self baseRoute:route];
    for (NSString *r in self.externalRouterArray) {
        if ([r isEqualToString:route]) {
            return YES;
        }
    }
    return NO;
}


/** get base route */
- (NSString *)baseRoute:(NSString *)route{
    route = [MKRouter filterAppUrlScheme:route];
    NSArray *strArr = [route componentsSeparatedByString:@"?"];
    if (strArr && strArr.count > 0) {
        route = strArr.firstObject;
    }
    return route;
}


#pragma mark - ***** lazy *****
- (NSMutableArray *)externalRouterArray{
    if (!_externalRouterArray) {
        _externalRouterArray = @[].mutableCopy;
    }
    return _externalRouterArray;
}

- (Class)baseClass{
    if (!_baseClass) {
        _baseClass = [UIViewController class];
    }
    return _baseClass;
}
@end
