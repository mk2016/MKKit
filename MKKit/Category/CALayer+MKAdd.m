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


#pragma mark - ***** animation ******
- (void)mk_oscillatoryAnimation{
//    NSNumber *animationScale1 = type == TZOscillatoryAnimationToBigger ? @(1.15) : @(0.5);
//    NSNumber *animationScale2 = type == TZOscillatoryAnimationToBigger ? @(0.92) : @(1.15);
    NSNumber *animationScale1 = @(1.15);
    NSNumber *animationScale2 = @(0.92);
    [UIView animateWithDuration:0.15 delay:0
                        options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                     animations:^{
        [self setValue:animationScale1 forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.15 delay:0
                            options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut animations:^{
            [self setValue:animationScale2 forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 delay:0
                                options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveEaseInOut
                             animations:^{
                [self setValue:@(1.0) forKeyPath:@"transform.scale"];
            } completion:nil];
        }];
    }];
}

+ (CAGradientLayer *)mk_layerGradientWithStartColor:(UIColor *)startColor endColor:(UIColor *)endColor{
    CAGradientLayer *gl = [CAGradientLayer layer];
    gl.startPoint = CGPointMake(0, 0);
    gl.endPoint = CGPointMake(1, 1);
    gl.colors = @[(__bridge id)startColor.CGColor, (__bridge id)endColor.CGColor];
    gl.locations = @[@(0.0),@(1)];
    return gl;
}
@end
