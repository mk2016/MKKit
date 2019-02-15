//
//  UIViewController+MKRouter.m
//  MKKit
//
//  Created by xiaomk on 2018/12/24.
//  Copyright © 2018 tqcar. All rights reserved.
//

#import "UIViewController+MKRouter.h"
#import <objc/runtime.h>

@implementation UIViewController(MKRouter)

static char kAssociatedParamsObjectKey;
static char kAssociatedBlockKey;
static char kAssociatedTransitionMode;

- (void)setMk_routeParams:(NSDictionary *)paramsDictionary{
    objc_setAssociatedObject(self, &kAssociatedParamsObjectKey, paramsDictionary, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)mk_routeParams{
    return objc_getAssociatedObject(self, &kAssociatedParamsObjectKey);
}

- (void)setMk_routeBlock:(MKRouteBlock)mk_routeBlock{
    objc_setAssociatedObject(self, &kAssociatedBlockKey, mk_routeBlock, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MKRouteBlock)mk_routeBlock{
    return objc_getAssociatedObject(self, &kAssociatedBlockKey);
}

- (void)setMk_transitionMode:(MKVCTransitionMode)mk_transitionMode{
    objc_setAssociatedObject(self, &kAssociatedTransitionMode, @(mk_transitionMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MKVCTransitionMode)mk_transitionMode{
    return [objc_getAssociatedObject(self, &kAssociatedTransitionMode) unsignedIntegerValue];
}
@end


@implementation NSString (MKRouterAdd)

- (void)setMk_transitionMode:(MKVCTransitionMode)mk_transitionMode{
    objc_setAssociatedObject(self, &kAssociatedTransitionMode, @(mk_transitionMode), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (MKVCTransitionMode)mk_transitionMode{
    return [objc_getAssociatedObject(self, &kAssociatedTransitionMode) unsignedIntegerValue];
}
@end
