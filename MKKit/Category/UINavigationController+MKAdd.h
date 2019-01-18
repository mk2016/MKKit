//
//  UINavigationController+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 16/9/21.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MKAdd)

/** pop to an appointed viewController */
- (BOOL)mk_popToViewControllerWithName:(NSString *)vcName animated:(BOOL)animated;

/** hidden navigationBar bottom line */
- (void)mk_setBottomLineHidden:(BOOL)hidden;

/** global hidden navigationBar bottom line */
+ (void)mk_hiddenBottomLine;

@end
