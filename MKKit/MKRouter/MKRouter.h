//
//  MKRouter.h
//  MKKit
//
//  Created by xmk on 2017/2/14.
//  Copyright © 2017年 mk. All rights reserved.
//
//  Inspired by [HHRouter](https://github.com/lightory/HHRouter.git)
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


typedef NS_ENUM (NSInteger, MKRouteType) {
    MKRouteTypeNone = 0,
    MKRouteTypeViewController,
    MKRouteTypeBlock,
    MKRouteTypeAction,
};

typedef id (^MKRouteBlock)(id params);

@interface MKRouter : NSObject

+ (instancetype)sharedInstance;

/** register route */
- (void)map:(NSString *)route toControllerClass:(Class)controllerClass;
- (void)map:(NSString *)route toBlock:(MKRouteBlock)block;

/** match route */
- (UIViewController *)matchController:(NSString *)route;
- (MKRouteBlock)matchBlock:(NSString *)route;

/** execute block route */
- (id)callBlock:(NSString *)route;

- (MKRouteType)canRoute:(NSString *)route;

/** route filter scheme */
+ (NSString *)filterAppUrlScheme:(NSString *)route;
@end


#pragma mark - ***** UIViewController Category *****
@interface UIViewController (MKRouter)
@property (nonatomic, strong) NSDictionary *params;
@end
