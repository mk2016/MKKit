//
//  UIColor+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2020/8/23.
//  Copyright © 2020 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (MKAdd)
+ (UIColor *)mk_randomColor;

+ (UIColor *)mk_colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b;
+ (UIColor *)mk_colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)a;

+ (UIColor *)mk_colorWithHEX:(NSUInteger)hex;
+ (UIColor *)mk_colorWithHEX:(NSUInteger)hex alpha:(CGFloat)a;
@end

NS_ASSUME_NONNULL_END
