//
//  CALayer+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2020/8/24.
//  Copyright © 2020 mk. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

NS_ASSUME_NONNULL_BEGIN

@interface CALayer (MKAdd)
- (void)mk_setShadowWithColor:(UIColor *)color offset:(CGSize)offset opacity:(CGFloat)opacity radius:(CGFloat)radius;
- (void)mk_setCornerWithRect:(CGRect)rect corners:(UIRectCorner)corners radii:(CGSize)radii;
- (void)mk_oscillatoryAnimation;
@end

NS_ASSUME_NONNULL_END
