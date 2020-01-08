//
//  UIView+MKFrameAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/16.
//  Copyright © 2019 mk. All rights reserved.
//

#import "UIView+MKFrameAdd.h"

@implementation UIView (MKFrameAdd)

- (CGPoint)mk_origin{
    return self.frame.origin;
}

- (void)setMk_origin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)mk_size{
    return self.frame.size;
}

- (void)setMk_size:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)mk_x{
    return self.frame.origin.x;
}

- (void)setMk_x:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)mk_y{
    return self.frame.origin.y;
}

- (void)setMk_y:(CGFloat)y;{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)mk_width{
    return self.frame.size.width;
}

- (void)setMk_width:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)mk_height{
    return self.frame.size.height;
}

- (void)setMk_height:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)mk_centerX{
    return self.center.x;
}

- (void)setMk_centerX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)mk_centerY{
    return self.center.y;
}

- (void)setMk_centerY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)mk_top{
    return self.mk_y;
}

- (void)setMk_top:(CGFloat)top{
    self.mk_y = top;
}

- (CGFloat)mk_left{
    return self.mk_x;
}

- (void)setMk_left:(CGFloat)left{
    self.mk_x = left;
}

- (CGFloat)mk_bottom{
    return self.mk_y + self.mk_height;
}

- (void)setMk_bottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom-frame.size.height;
    self.frame = frame;
}

- (CGFloat)mk_right{
    return self.mk_x + self.mk_width;
}

- (void)setMk_right:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.y = right - frame.size.width;
    self.frame = frame;
}

- (CGPoint)mk_topLeft{
    return CGPointMake(self.mk_x, self.mk_y);
}

- (void)setMk_topLeft:(CGPoint)topLeft{
    CGRect frame = self.frame;
    frame.origin = topLeft;
    self.frame = frame;
}

- (CGPoint)mk_topRight{
    return CGPointMake(self.mk_x+self.mk_width, self.mk_y);
}

- (void)setMk_topRight:(CGPoint)topRight{
    CGRect frame = self.frame;
    frame.origin.x = topRight.x - frame.size.width;
    frame.origin.y = topRight.y;
    self.frame = frame;
}

- (CGPoint)mk_bottomRight{
    return CGPointMake(self.mk_x+self.mk_width, self.mk_y+self.mk_height);
}

- (void)setMk_bottomRight:(CGPoint)bottomRight{
    CGRect frame = self.frame;
    frame.origin.x = bottomRight.x - frame.size.width;
    frame.origin.y = bottomRight.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)mk_bottomLeft{
    return CGPointMake(self.mk_x, self.mk_y+self.mk_height);
}

- (void)setMk_bottomLeft:(CGPoint)bottomLeft{
    CGRect frame = self.frame;
    frame.origin.x = bottomLeft.x;
    frame.origin.y = bottomLeft.y - frame.size.height;
    self.frame = frame;
}
@end
