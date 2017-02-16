//
//  MKUIHelper.m
//  MKKit
//
//  Created by xmk on 2017/2/15.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "MKUIHelper.h"
#import <MessageUI/MessageUI.h>
#import "MKKitConst.h"

@implementation MKUIHelper

+ (id)getVCFromStoryboard:(NSString *)storyboard identify:(NSString *)identify{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identify];
}

#pragma mark - ***** top View adn window ******
+ (UIView *)topView{
    return [[[self getWindow:UIWindowLevelNormal fullScreen:YES] subviews] lastObject];
}

/** 根据 windowLevel 获取 window */
+ (UIWindow *)topFullWindow{
    return [self getCurrentVC].view.window;
}

+ (UIWindow *)getWindow:(NSInteger)windowLevel fullScreen:(BOOL)fullScreen{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    if (!topWindow || topWindow.windowLevel != windowLevel) {
        NSEnumerator *windows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in windows) {
            if ([window isKindOfClass:NSClassFromString(@"UITextEffectsWindow")]) {
                continue;
            }
            if (window.windowLevel == windowLevel){
                if (!fullScreen || (window.bounds.size.width == MKSCREEN_WIDTH && window.bounds.size.height == MKSCREEN_HEIGHT)) {
                    topWindow = window;
                }
            }
        }
    }
    return topWindow;
}

#pragma mark - ***** current ViewController ******
/** default include presentedViewController */
+ (UIViewController *)getCurrentVC{
    return [self getCurrentVCWithWindowLevel:UIWindowLevelNormal includePresentedVC:YES];
}

+ (UIViewController *)getCurrentVCIncludePresentedVC:(BOOL)isIncludePVC{
    return [self getCurrentVCWithWindowLevel:UIWindowLevelNormal includePresentedVC:isIncludePVC];
}

+ (UIViewController *)getCurrentVCWithWindowLevel:(CGFloat)windowLevel includePresentedVC:(BOOL)isIncludePVC{
    UIViewController *result = nil;
    
    if (isIncludePVC) {
        result = [self getPresentedVC];
        if (result) {
            return result;
        }
    }
    
    UIWindow *topWindow = [self getWindow:windowLevel fullScreen:YES];
    
    UIView *rootView;
    NSArray *subViews = [topWindow subviews];
    if (subViews.count) {
        rootView = [subViews objectAtIndex:0];
    }else{
        rootView = topWindow;
    }
    
    id nextResponder = [rootView nextResponder];

    if ([nextResponder isKindOfClass:[UIViewController class]]) {
        result = nextResponder;
    }else if ([topWindow respondsToSelector:@selector(rootViewController)]){
        if ([topWindow rootViewController]) {
            result = [topWindow rootViewController];
        }
    }else{
        NSAssert(NO, @"MKToolsKit: Could not find a root view controller.");
    }
    if ([result isKindOfClass:[UINavigationController class]]) {
        UINavigationController *nav = (UINavigationController *)result;
        result = nav.topViewController;
    }
    return result;
}

+ (UIViewController *)getPresentedVC{
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow];
    UIViewController *appRootVC = topWindow.rootViewController;
    UIViewController *topVC = nil;
    if (appRootVC.presentedViewController) {
        if (![appRootVC.presentedViewController isKindOfClass:[UIAlertController class]] &&
            ![appRootVC.presentedViewController isKindOfClass:[UIImagePickerController class]] &&
            ![appRootVC.presentedViewController isKindOfClass:[MFMessageComposeViewController class]]){
            topVC = appRootVC.presentedViewController;
            
            if (topVC && [topVC isKindOfClass:[UINavigationController class]]) {
                UINavigationController *nav = (UINavigationController *)topVC;
                if (nav.topViewController) {
                    topVC = nav.topViewController;
                }
            }
        }
    }
    return topVC;
}



@end
