//
//  UIButton+MKHitRect.h
//  MKKit
//
//  Created by xiaomk on 2018/5/28.
//  Copyright © 2018年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (MKHitRect)

/**
 * custom respond extent : UIEdgeInsetsMake(-3, -4, -5, -6).
 * negative is enlarge
 * example： botton.mk_hitEdgeInsets = UIEdgeInsetsMake(-3, -4, -5, -6);
 */
@property(nonatomic, assign) UIEdgeInsets mk_hitEdgeInsets;

@end
