//
//  UITabBar+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 16/6/24.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar(MKAdd)

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
