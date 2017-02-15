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

#pragma mark - ***** top View ******
+ (UIView *)getTopView;

#pragma mark - ***** current ViewController ******
+ (UIViewController *)getCurrentViewController;
+ (UIViewController *)getCurrentViewControllerIncludePresentedVC:(BOOL)isIncludePVC;
+ (UIViewController *)getCurrentViewControllerWithWindowLevel:(CGFloat)windowLevel includePresentedVC:(BOOL)isIncludePVC;
+ (UIViewController *)getPresentedViewController;

@end
