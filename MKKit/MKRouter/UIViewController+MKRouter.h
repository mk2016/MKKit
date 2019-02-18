//
//  UIViewController+MKRouter.h
//  MKKit
//
//  Created by xiaomk on 2018/12/24.
//  Copyright © 2018 tqcar. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^MKRouteBlock)(id params);

typedef enum : NSUInteger {
    MKVCTransitionMode_push     = 0,
    MKVCTransitionMode_present  = 1,
} MKVCTransitionMode;

@interface UIViewController(MKRouter)
@property (nonatomic, copy) MKRouteBlock mk_routeBlock;
@property (nonatomic, copy) NSDictionary *mk_routeParams;
@property (nonatomic, assign) MKVCTransitionMode mk_transitionMode;
@end

@interface NSString (MKRouterAdd)
@property (nonatomic, assign) MKVCTransitionMode mk_transitionMode;
@end

