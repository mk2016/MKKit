//
//  UIView+MKFrameAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/16.
//  Copyright © 2019 mk. All rights reserved.
//

#import "UIView+MKFrameAdd.h"

@implementation UIView (MKFrameAdd)

- (CGPoint)origin{
    return self.frame.origin;
}

- (void)setOrigin:(CGPoint)origin{
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size{
    return self.frame.size;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (CGFloat)x{
    return self.frame.origin.x;
}

- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (void)setY:(CGFloat)y;{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (void)setCenterX:(CGFloat)centerX{
    CGPoint center = self.center;
    center.x = centerX;
    self.center = center;
}

- (CGFloat)centerY{
    return self.center.y;
}

- (void)setCenterY:(CGFloat)centerY{
    CGPoint center = self.center;
    center.y = centerY;
    self.center = center;
}

- (CGFloat)top{
    return self.y;
}

- (void)setTop:(CGFloat)top{
    self.y = top;
}

- (CGFloat)left{
    return self.x;
}

- (void)setLeft:(CGFloat)left{
    self.x = left;
}

- (CGFloat)bottom{
    return self.y + self.height;
}

- (void)setBottom:(CGFloat)bottom{
    CGRect frame = self.frame;
    frame.origin.y = bottom-frame.size.height;
    self.frame = frame;
}

- (CGFloat)right{
    return self.x + self.width;
}

- (void)setRight:(CGFloat)right{
    CGRect frame = self.frame;
    frame.origin.y = right - frame.size.width;
    self.frame = frame;
}

- (CGPoint)topLeft{
    return CGPointMake(self.x, self.y);
}

- (void)setTopLeft:(CGPoint)topLeft{
    CGRect frame = self.frame;
    frame.origin = topLeft;
    self.frame = frame;
}

- (CGPoint)topRight{
    return CGPointMake(self.x+self.width, self.y);
}

- (void)setTopRight:(CGPoint)topRight{
    CGRect frame = self.frame;
    frame.origin.x = topRight.x - frame.size.width;
    frame.origin.y = topRight.y;
    self.frame = frame;
}

- (CGPoint)bottomRight{
    return CGPointMake(self.x+self.width, self.y+self.height);
}

- (void)setBottomRight:(CGPoint)bottomRight{
    CGRect frame = self.frame;
    frame.origin.x = bottomRight.x - frame.size.width;
    frame.origin.y = bottomRight.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)bottomLeft{
    return CGPointMake(self.x, self.y+self.height);
}

- (void)setBottomLeft:(CGPoint)bottomLeft{
    CGRect frame = self.frame;
    frame.origin.x = bottomLeft.x;
    frame.origin.y = bottomLeft.y - frame.size.height;
    self.frame = frame;
}
@end
