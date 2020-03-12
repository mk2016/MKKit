//
//  UIView+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "UIView+MKAdd.h"

@implementation UIView (MKAdd)

#pragma mark - ***** rounded corner ******
- (void)mk_setCorner{
    [self mk_setCornerValue:4.f];
}

- (void)mk_setCornerValue:(CGFloat)value{
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = value;
}

- (void)mk_setToCircle{
    [self mk_setCornerValue:CGRectGetWidth(self.frame)/2];
}

- (void)mk_setCornerWith:(UIRectCorner)corners radii:(CGSize)size{
    [self layoutIfNeeded];
    UIBezierPath *maskPath = [UIBezierPath bezierPathWithRoundedRect:self.bounds byRoundingCorners:corners cornerRadii:size];
    CAShapeLayer *maskLayer = [[CAShapeLayer alloc] init];
    maskLayer.frame = self.bounds;
    maskLayer.path = maskPath.CGPath;
    self.layer.mask = maskLayer;
//    self.layer.cornerRadius = size.width;
//    self.layer.masksToBounds = YES;
//    self.layer.shouldRasterize = YES;
//    self.layer.rasterizationScale = [UIScreen mainScreen].scale;
}

#pragma mark - ***** shadow ******
- (void)mk_addShadowWithColor:(UIColor *)color{
    [self mk_addShadowWithColor:color offset:CGSizeMake(0, 0)];
}

- (void)mk_addShadowWithColor:(UIColor *)color offset:(CGSize)offset{
    [self mk_addShadowWithColor:color offset:offset opacity:0.5 radius:2.f];
}

- (void)mk_addShadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius{
    self.layer.masksToBounds = NO;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}

- (void)mk_addShadowWithCorner:(CGFloat)cornerRadius color:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius{
    self.layer.masksToBounds = NO;
    self.layer.cornerRadius = cornerRadius;
    self.layer.shadowColor = color.CGColor;
    self.layer.shadowOffset = offset;
    self.layer.shadowOpacity = opacity;
    self.layer.shadowRadius = radius;
}
    
    

#pragma mark - ***** Border ******
- (void)mk_setBorderColor:(UIColor *)color{
    [self mk_setBorderWidth:0.7 andColor:color];
}

- (void)mk_setBorderWidth:(CGFloat)width andColor:(UIColor *)color{
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}

- (void)mk_addBorderOnDirection:(MKBorderDirectionType)direction{
    [self mk_addBorderOnDirection:direction
                      borderWidth:0.7
                      borderColor:[UIColor colorWithRed:(200/255.0f) green:(200/255.0f) blue:(200/255.0f) alpha:1]
                     isConstraint:YES];
}

- (void)mk_addBorderOnDirection:(MKBorderDirectionType)direction borderWidth:(CGFloat)width borderColor:(UIColor *)color isConstraint:(BOOL)constraint{
    if (direction & MKBorderDirectionTypeTop) {
        [self mk_addLayerWithFrame:CGRectMake(0, 0, self.frame.size.width, width) color:color];
    }
    if (direction & MKBorderDirectionTypeLeft){
        [self mk_addLayerWithFrame:CGRectMake(0, 0, width, self.frame.size.height) color:color];
    }
    if (direction & MKBorderDirectionTypeBottom){
        [self mk_addLayerWithFrame:CGRectMake(0, self.frame.size.height-width, self.frame.size.width, width) color:color];
    }
    if (direction & MKBorderDirectionTypeRight){
        [self mk_addLayerWithFrame:CGRectMake(self.frame.size.width-width, 0, width, self.frame.size.height) color:color];
    }
    if (constraint) {
        [self layoutIfNeeded];
    }
}

- (CALayer *)mk_addLayerWithFrame:(CGRect)frame color:(UIColor *)color{
    CALayer *layer = [CALayer layer];
    layer.frame = frame;
    layer.backgroundColor = color.CGColor;
    [self.layer addSublayer:layer];
    return layer;
}

#pragma mark - ***** remove ******
- (void)mk_removeAllSubviews{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
}

#pragma mark - ***** screenshot ******
- (UIImage *)mk_screenshot{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [UIScreen mainScreen].scale);
    
    if ([self respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        NSInvocation *invoc = [NSInvocation invocationWithMethodSignature:
                               [self methodSignatureForSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]];
        [invoc setTarget:self];
        [invoc setSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)];
        CGRect arg2 = self.bounds;
        BOOL arg3 = YES;
        [invoc setArgument:&arg2 atIndex:2];
        [invoc setArgument:&arg3 atIndex:3];
        [invoc invoke];
    } else {
        [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - ***** view on window ******
- (void)mk_showOnWindow{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    self.alpha = 0;
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 1;
    }];
}

- (void)mk_removeFromWindow{
    [UIView animateWithDuration:0.3 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)mk_showOnWindowWithAnimations:(void (^)(void))animations
                           completion:(void (^ __nullable)(BOOL finished))completion{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    [UIView animateWithDuration:0.3 animations:animations completion:completion];
}

- (void)mk_removeFromWindowWithAnimations:(void (^)(void))animations
                               completion:(void (^ __nullable)(BOOL finished))completion{
    [UIView animateWithDuration:0.3 animations:animations completion:^(BOOL finished) {
        if (completion) {
            completion(finished);
        }
        [self removeFromSuperview];
    }];
}
@end
