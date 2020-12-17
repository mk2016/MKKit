//
//  MKUtils.m
//  MKKit
//
//  Created by xiaomk on 2016/9/23.
//  Copyright © 2016 mk. All rights reserved.
//

#import "MKUtils.h"
#import <MessageUI/MessageUI.h>
#import "UIView+Toast.h"
#import "MKConst.h"
#import <AudioToolbox/AudioToolbox.h>

@implementation MKUtils

+ (void)toastManagerInit{
    [CSToastManager setTapToDismissEnabled:NO];
    [CSToastManager setQueueEnabled:NO];
}

+ (id)getVCFromStoryboard:(NSString *)storyboard identify:(NSString *)identify{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identify];
}

+ (void)showToast:(NSString *)message{
    [self showToast:message duration:2.0];
}

+ (void)showToast:(NSString *)message duration:(CGFloat)duration{
    if ([message isEqual:[NSNull null]] || message == nil || message.length == 0){
        return;
    }
    dispatch_async(dispatch_get_main_queue(), ^{
        [[self getCurrentWindow] makeToast:message duration:duration position:CSToastPositionCenter style:nil];
    });
}


//set keyWindow's rootViewController by viewController
+ (void)setKeyWindowRootViewController:(UIViewController *)vc{
    if (vc) {
        dispatch_async(dispatch_get_main_queue(), ^{
            UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
            if (keyWindow.rootViewController) {
                [keyWindow.rootViewController.view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
                keyWindow.rootViewController = nil;
            }
            keyWindow.rootViewController = vc;
            [keyWindow makeKeyAndVisible];
        });
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

+ (UIViewController *)topViewControllerWith:(UIViewController * _Nullable)base{
    return [self topViewControllerWith:base ignored:nil];
}

+ (UIViewController *)topViewControllerWith:(UIViewController * _Nullable)base ignored:(NSArray<Class> * _Nullable)clazzAry{
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
    [self openOuterUrl:str];
}

+ (void)openOuterUrl:(NSString *)urlStr{
    [self openOuterUrl:urlStr completionHandler:nil];
}

+ (void)openOuterUrl:(NSString *)urlStr completionHandler:(void (^ __nullable)(BOOL success))completion{
    if(@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr] options:@{} completionHandler:^(BOOL success) {
            MK_BLOCK_EXEC(completion,success);
        }];
    }else{
        BOOL open = [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
        MK_BLOCK_EXEC(completion,open);
    }
}

+ (void)exitApplication{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [UIView animateWithDuration:0.3f animations:^{
        CGAffineTransform curent =  window.transform;
        CGAffineTransform scale = CGAffineTransformScale(curent, 0.01,0.01);
        [window setTransform:scale];
    } completion:^(BOOL finished) {
        exit(0);
    }];
}

+ (void)openAppStoreWithAppId:(NSString *)appId{
    NSString *pkgUrl = [NSString stringWithFormat: @"https://apps.apple.com/cn/app/id%@",appId];
    [self openOuterUrl:pkgUrl];
}

+ (void)delayTask:(float)second onTimeEnd:(void(^)(void))block{
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(second * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), block);
}

/** v1<v2 return -1   v1=v2 return 0  v1>v2 return 1 */
+ (MKComparisonResult)compareVersionWith:(NSString *)v1 and:(NSString *)v2{
    if ([v1 isEqualToString:v2]) {
        return MKComparisonResultEqual;
    }
    NSArray *v1Ary = [v1 componentsSeparatedByString:@"."];
    NSArray *v2Ary = [v2 componentsSeparatedByString:@"."];
    NSInteger minLength = MIN(v1Ary.count, v2Ary.count);
    for (int i = 0 ; i < minLength; i++) {
        NSString *v1Num = v1Ary[i];
        NSString *v2Num = v2Ary[i];
        if (v1Num.integerValue > v2Num.integerValue ) {
            return MKComparisonResultMore;
        }else if (v1Num.integerValue < v2Num.integerValue){
            return MKComparisonResultLess;
        }
    }
    
    return MKComparisonResultEqual;
}

+ (void)playShortVoiceWithUrl:(NSURL *)fileUrl{
    SystemSoundID soundID;
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)(fileUrl), &soundID);
    AudioServicesAddSystemSoundCompletion(soundID,NULL,NULL,MKSoundCompleteCallBack,NULL);
    AudioServicesPlaySystemSound(soundID);
    AudioServicesPlaySystemSound(kSystemSoundID_Vibrate);
}

void MKSoundCompleteCallBack(SystemSoundID soundID, void *clientData){
    ELog(@"播放完成");
}

+ (void)setPasteboard:(NSString *)str{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = str;
}
@end

