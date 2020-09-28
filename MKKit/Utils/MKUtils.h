//
//  MKUtils.h
//  MKKit
//
//  Created by xiaomk on 2016/9/23.
//  Copyright © 2016 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MKConst.h"

NS_ASSUME_NONNULL_BEGIN

@interface MKUtils : NSObject

+ (void)toastManagerInit;

+ (id)getVCFromStoryboard:(NSString *)storyboard identify:(NSString *)identify;

+ (void)showToast:(NSString *)message;

+ (void)setKeyWindowRootViewController:(UIViewController *)vc;

#pragma mark - ***** top View ******
+ (UIView *)getTopView;

#pragma mark - ***** top window *****
+ (UIWindow *)getCurrentWindow;
+ (UIWindow *)getCurrentWindowByLevel:(CGFloat)windowLevel;

#pragma mark - ***** current ViewController ******
+ (UIViewController *)topViewController;
+ (UIViewController *)topViewControllerByWindowLevel:(CGFloat)level;
+ (UIViewController *)topViewControllerWith:(UIViewController * _Nullable)base;
+ (UIViewController *)topViewControllerWith:(UIViewController * _Nullable)base ignored:(NSArray<Class> * _Nullable)clazzAry;

+ (void)callTelephone:(NSString *)phone;
+ (void)openOuterUrl:(NSString *)urlStr;
+ (void)openOuterUrl:(NSString *)urlStr completionHandler:(void (^ __nullable)(BOOL success))completion;

/** exit app */
+ (void)exitApplication;

+ (void)openAppStoreWithAppId:(NSString *)appId;

+ (void)delayTask:(float)second onTimeEnd:(void(^)(void))block;

/** 版本比对  -1:v1<v2, 0:v1=v2, 1:v1>v2  */
+ (MKComparisonResult)compareVersionWith:(NSString *)v1 and:(NSString *)v2;

+ (void)playShortVoiceWithUrl:(NSURL *)fileUrl;

+ (void)setPasteboard:(NSString *)str;
@end

NS_ASSUME_NONNULL_END
