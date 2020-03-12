//
//  UIView+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 16/5/19.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

typedef enum {
    MKBorderDirectionTypeNone       = 0,
    MKBorderDirectionTypeTop        = 1 << 1,   //top
    MKBorderDirectionTypeLeft       = 1 << 2,   //left
    MKBorderDirectionTypeBottom     = 1 << 3,   //bottom
    MKBorderDirectionTypeRight      = 1 << 4,   //right
    MKBorderDirectionTypeAll        = ~0UL
}MKBorderDirectionType;

@interface UIView (MKAdd)

#pragma mark - ***** rounded corner ******
- (void)mk_setCorner;
- (void)mk_setCornerValue:(CGFloat)value;
- (void)mk_setToCircle;
- (void)mk_setCornerWith:(UIRectCorner)corners radii:(CGSize)size;

#pragma mark - ***** shadow ******
- (void)mk_addShadowWithColor:(UIColor *)color;
- (void)mk_addShadowWithColor:(UIColor *)color offset:(CGSize)offset;
- (void)mk_addShadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;
- (void)mk_addShadowWithCorner:(CGFloat)cornerRadius color:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;

#pragma mark - ***** Border ******
- (void)mk_setBorderColor:(UIColor *)color;
- (void)mk_setBorderWidth:(CGFloat)width andColor:(UIColor *)color;
- (void)mk_addBorderOnDirection:(MKBorderDirectionType)direction;
- (void)mk_addBorderOnDirection:(MKBorderDirectionType)direction
                    borderWidth:(CGFloat)width
                    borderColor:(UIColor *)color
                   isConstraint:(BOOL)constraint;
- (CALayer *)mk_addLayerWithFrame:(CGRect)frame color:(UIColor *)color;

#pragma mark - ***** remove ******
- (void)mk_removeAllSubviews;

#pragma mark - ***** screenshot ******
- (UIImage *)mk_screenshot;

#pragma mark - ***** view on window ******
- (void)mk_showOnWindow;
- (void)mk_removeFromWindow;

- (void)mk_showOnWindowWithAnimations:(void (^)(void))animations
                           completion:(void (^ __nullable)(BOOL finished))completion;

- (void)mk_removeFromWindowWithAnimations:(void (^)(void))animations
                               completion:(void (^ __nullable)(BOOL finished))completion;
@end
