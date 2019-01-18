//
//  UITabBar+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 16/6/24.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "UITabBar+MKAdd.h"

#define MKUITabBarTagBase 1102

@implementation UITabBar(MKAdd)

#pragma mark - ***** system badge ******
- (void)mk_setBadgeWithValue:(NSString *)value onIndex:(int)index{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (index < self.items.count) {
            UITabBarItem *item = [self.items objectAtIndex:index];
            item.badgeValue = value;
        }
    });
}

#pragma mark - ***** custom badge ******
/** set badge to show or hidden on item index  */
- (void)mk_setSmallBadgeShow:(BOOL)show onIndex:(int)index{
    if (show) {
        [self mk_showSmallBadgeOnIndex:index];
    }else{
        [self mk_hideSmallBadgeOnIndex:index];
    }
}

/** show small badge */
- (void)mk_showSmallBadgeOnIndex:(int)index{
    UIView *badgeView = [self viewWithTag:MKUITabBarTagBase + index];

    if (!badgeView) {
        badgeView = [[UIView alloc] init];
        badgeView.tag = MKUITabBarTagBase + index;
        badgeView.layer.cornerRadius = 5;//圆形
        badgeView.backgroundColor = [UIColor redColor];//颜色：红色
        CGRect tabFrame = self.frame;
        
        float percentX = (index + 0.55) / self.items.count;
        CGFloat x = ceilf(percentX * tabFrame.size.width);
        CGFloat y = ceilf(0.1 * tabFrame.size.height);
        badgeView.frame = CGRectMake(x, y, 10, 10);//圆形大小为10
        [self addSubview:badgeView];
    }
    badgeView.hidden = NO;
}


/** hidden badge by index */
- (void)mk_hideSmallBadgeOnIndex:(int)index{
    UIView *badgeView = [self viewWithTag:MKUITabBarTagBase+index];
    if (badgeView) {
        badgeView.hidden = YES;
    }
}

/** hidden all small badge */
- (void)mk_clearAllSmallBadge{
    for (int i = 0; i < self.items.count; i++) {
        [self mk_hideSmallBadgeOnIndex:i];
    }
}



@end
