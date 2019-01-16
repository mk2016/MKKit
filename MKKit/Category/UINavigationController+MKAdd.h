//
//  UINavigationController+MKAdd.h
//  MKToolsKit
//
//  Created by xiaomk on 16/9/21.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MKAdd)

/** pop to an appointed viewController */
- (BOOL)mk_popToViewControllerWithName:(NSString *)vcName animated:(BOOL)animated;

/** 设置底部黑线 隐藏 */
- (void)mk_setBottomLineHidden:(BOOL)hidden;

/** global hidden navigationBar bottom line */
+ (void)mk_hiddenBottomLine;

@end
