//
//  MKUIUtils.m
//  MKKit
//
//  Created by xmk on 16/9/23.
//  Copyright © 2016年 mk. All rights reserved.
//

#import "MKUIUtils.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"
#import "MKConst.h"

@implementation MKUIUtils

+ (id)getVCFromStoryboard:(NSString *)storyboard identify:(NSString *)identify{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identify];
}

+ (void)showToast:(NSString *)message{
    if ([message isEqual:[NSNull null]] || message == nil || message.length == 0){
        return;
    }
    MK_DISPATCH_MAIN_ASYNC_SAFE(^{
        [[self getCurrentWindow] makeToast:message duration:3.0f position:CSToastPositionCenter style:nil];
    })
}

//set keyWindow's rootViewController by viewController
+ (void)setKeyWindowRootViewController:(UIViewController *)vc{
    if (vc) {
        MK_DISPATCH_MAIN_ASYNC_SAFE(^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            if (keyWindow.rootViewController) {
                [keyWindow.rootViewController.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                keyWindow.rootViewController = nil;
            }
            keyWindow.rootViewController = vc;
            [keyWindow makeKeyAndVisible];
        })
    }
}

#pragma mark - ***** top View ******
+ (UIView *)getTopView{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    NSArray *views = [window subviews];
    if (views && views.count > 0) {
        return views.lastObject;
    }
    return window;
}

#pragma mark - ***** top window *****
+ (UIWindow *)getCurrentWindow{
    return [self getCurrentWindowByLevel:UIWindowLevelNormal];
}

+ (UIWindow *)getCurrentWindowByLevel:(CGFloat)windowLevel{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (topWindow.windowLevel != windowLevel) {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for (UIWindow *window in windows) {
            if (window.windowLevel == windowLevel) {
                topWindow = window;
            }
        }
    }
    return topWindow;
}

#pragma mark - ***** current ViewController ******
+ (UIViewController *)topViewController{
    return [self topViewControllerWith:nil];
}

+ (UIViewController *)topViewControllerByWindowLevel:(CGFloat)level{
    UIWindow *window = [self getCurrentWindowByLevel:level];
    return [self topViewControllerWith:window.rootViewController];
}

+ (UIViewController *)topViewControllerWith:(UIViewController *)base{
    return [self topViewControllerWith:base ignored:nil];
}

+ (UIViewController *)topViewControllerWith:(UIViewController *)base ignored:(NSArray<Class> *)clazzAry{
    if (base == nil) {
        base = [UIApplication sharedApplication].keyWindow.rootViewController;
    }
    if ([base isKindOfClass:[UINavigationController class]]) {
        UIViewController *vc = ((UINavigationController *)base).topViewController;
        return [self topViewControllerWith:vc];
    }
    if ([base isKindOfClass:[UITabBarController class]]) {
        UIViewController *vc = ((UITabBarController *)base).selectedViewController;
        return [self topViewControllerWith:vc];
    }
    if (base.presentedViewController) {
        UIViewController *vc = base.presentedViewController;
        if ([vc isKindOfClass:[UIAlertController class]]
            || [vc isKindOfClass:[UIImagePickerController class]]
            || [vc isKindOfClass:[MFMessageComposeViewController class]]
            ) {
            return base;
        }else if (clazzAry && clazzAry.count){
            for (Class clazz in clazzAry) {
                if ([vc isKindOfClass:clazz]) {
                    return base;
                }
            }
        }
        return [self topViewControllerWith:vc];
    }
    return base;
}


+ (void)callTelephone:(NSString *)phone{
    NSString *str = [NSString stringWithFormat:@"telprompt://%@", phone];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
}

+ (void)exitApplication{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:1.0f animations:^{
        window.alpha = 0;
        window.frame = CGRectMake(0, window.bounds.size.width, 0, 0);
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

+ (void)openAppStroeWithAppId:(NSString *)appId{
    NSString *pkgUrl = [NSString stringWithFormat: @"itms-apps://itunes.apple.com/app/id%@",appId];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:pkgUrl]];
}

+ (void)delayTask:(float)second onTimeEnd:(void(^)(void))block{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

@end
