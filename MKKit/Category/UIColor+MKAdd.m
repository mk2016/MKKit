//
//  UIColor+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2020/8/23.
//  Copyright © 2020 mk. All rights reserved.
//

#import "UIColor+MKAdd.h"

@implementation UIColor (MKAdd)

+ (UIColor *)mk_randomColor{
    NSInteger r = arc4random() % 255;
    NSInteger g = arc4random() % 255;
    NSInteger b = arc4random() % 255;
    UIColor *color = [UIColor colorWithRed:r /255.0f green:g/255.0f blue:b/255.0f alpha:1.0f];
    return color;
}

+ (UIColor *)mk_colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b{
    return [self mk_colorWithR:r G:g B:b alpha:1];
}

+ (UIColor *)mk_colorWithR:(CGFloat)r G:(CGFloat)g B:(CGFloat)b alpha:(CGFloat)a{
    return [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:a];
}

+ (UIColor *)mk_colorWithHEX:(NSUInteger)hex{
    return [self mk_colorWithHEX:hex alpha:1.f];
}

+ (UIColor *)mk_colorWithHEX:(NSUInteger)hex alpha:(CGFloat)a{
    UIColor *color = [UIColor colorWithRed:((float)((hex & 0xFF0000) >> 16))/255.0f
                                     green:((float)((hex & 0xFF00) >> 8))/255.0f
                                      blue:((float)(hex & 0xFF))/255.0
                                     alpha:a];
    return color;
}
@end
