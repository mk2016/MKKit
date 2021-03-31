//
//  UITabBar+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2016/6/24.
//  Copyright © 2016 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar(MKAdd)

#pragma mark - ***** shadow line ******
- (void)mk_setShadowWithOffset:(CGSize)offset radius:(CGFloat)radius color:(UIColor *)color opacity:(CGFloat)opacity;
- (void)mk_setTitleNormalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor;

#pragma mark - ***** system badge ******
- (void)mk_setBadgeWithValue:(NSString *)value onIndex:(int)index;

#pragma mark - ***** custom badge ******
/** set badge to show or hidden on item index  */
- (void)mk_setSmallBadgeShow:(BOOL)show onIndex:(int)index;

/** show small badge */
- (void)mk_showSmallBadgeOnIndex:(int)index;

/** hide small badge */
- (void)mk_hideSmallBadgeOnIndex:(int)index;

/** remove all small badge */
- (void)mk_clearAllSmallBadge;

@end

@interface UITabBarItem(MKAdd)
- (void)mk_setTitle:(NSString *)title normalImage:(NSString *)normalImage selectedImage:(NSString *)selectedImage;
@end
