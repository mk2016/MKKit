//
//  MKUtils.h
//  MKKit
//
//  Created by xmk on 16/9/23.
//  Copyright © 2016年 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

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
+ (UIViewController *)topViewControllerWith:(UIViewController *)base;
+ (UIViewController *)topViewControllerWith:(UIViewController *)base ignored:(NSArray<Class> *)clazzAry;

+ (void)callTelephone:(NSString *)phone;
/** exit app */
+ (void)exitApplication;

+ (void)openAppStroeWithAppId:(NSString *)appId;

+ (void)delayTask:(float)second onTimeEnd:(void(^)(void))block;
@end
