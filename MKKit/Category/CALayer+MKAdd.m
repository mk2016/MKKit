//
//  CALayer+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2020/8/24.
//  Copyright © 2020 mk. All rights reserved.
//

#import "CALayer+MKAdd.h"

@implementation CALayer (MKAdd)

- (void)mk_setShadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius{
    self.shadowColor = color.CGColor;
    self.shadowOffset = offset;
    self.shadowOpacity = opacity;
    self.shadowRadius = radius;
    self.masksToBounds = NO;
}

- (void)mk_setCornerWithRect:(CGRect)rect corners:(UIRectCorner)corners radii:(CGSize)radii{
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:rect byRoundingCorners:corners cornerRadii:radii];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = rect;
    maskLayer.path = maskPath.CGPath;
    self.mask = maskLayer;
}
@end
