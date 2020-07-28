//
//  UINavigationController+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2016/9/21.
//  Copyright © 2016 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MKAdd)

- (BOOL)mk_canPopToViewContrller:(NSString *)vcName;

/** pop to an appointed viewController */
- (BOOL)mk_popToViewControllerWithName:(NSString *)vcName animated:(BOOL)animated;

/** hidden navigationBar bottom line */
- (void)mk_setBottomLineHidden:(BOOL)hidden;

/** global hidden navigationBar bottom line */
+ (void)mk_hiddenBottomLine;

/** set bottom shadow */
- (void)mk_setBottomShadowHidden:(BOOL)hidden;

- (void)mk_setBarColor:(UIColor *)color;
@end
