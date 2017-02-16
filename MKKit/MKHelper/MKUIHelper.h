//
//  MKUIHelper.h
//  MKKit
//
//  Created by xmk on 2017/2/15.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKUIHelper : NSObject

+ (id)getVCFromStoryboard:(NSString *)storyboard identify:(NSString *)identify;

#pragma mark - ***** top View adn window ******
+ (UIView *)getTopView;
+ (UIWindow *)getTopFullWindow;
+ (UIWindow *)getWindow:(UIWindowLevel)windowLevel fullScreen:(BOOL)fullScreen;

#pragma mark - ***** current ViewController ******
+ (UIViewController *)getCurrentVC;
+ (UIViewController *)getCurrentVCIncludePresentedVC:(BOOL)isIncludePVC;
+ (UIViewController *)getCurrentVCWithWindowLevel:(UIWindowLevel)windowLevel includePresentedVC:(BOOL)isIncludePVC;
+ (UIViewController *)getPresentedVC;

@end
