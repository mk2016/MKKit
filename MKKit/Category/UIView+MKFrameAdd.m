//
//  UIView+MKFrameAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/16.
//  Copyright © 2019 mk. All rights reserved.
//

#import "UIView+MKFrameAdd.h"

@implementation UIView (MKFrameAdd)
- (CGFloat)x{
    return self.frame.origin.x;
}

- (CGFloat)y{
    return self.frame.origin.y;
}

- (CGFloat)width{
    return self.frame.size.width;
}

- (CGFloat)height{
    return self.frame.size.height;
}

- (CGSize)size{
    return self.frame.size;
}

- (CGPoint)origin{
    return self.frame.origin;
}

- (CGFloat)centerX{
    return self.center.x;
}

- (CGFloat)centerY{
    return self.center.y;
}


- (void)setX:(CGFloat)x{
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (void)setY:(CGFloat)y;{
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (void)setWidth:(CGFloat)width{
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (void)setHeight:(CGFloat)height{
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (void)setSize:(CGSize)size{
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}

- (void)setCenterX:(CGFloat)x{
    CGPoint center = self.center;
    center.x = x;
    self.center = center;
}

- (void)setCenterY:(CGFloat)y{
    CGPoint center = self.center;
    center.y = y;
    self.center = center;
}

- (CGFloat)top{
    return self.y;
}

- (CGFloat)left{
    return self.x;
}

- (CGFloat)bottom{
    return self.y + self.height;
}

- (CGFloat)right{
    return self.x + self.width;
}

- (CGPoint)topLeft{
    return CGPointMake(self.x, self.y);
}

- (CGPoint)topRight{
    return CGPointMake(self.x+self.width, self.y);
}

- (CGPoint)bottomRight{
    return CGPointMake(self.x+self.width, self.y+self.height);
}

- (CGPoint)bottomLeft{
    return CGPointMake(self.x, self.y+self.height);
}
@end
