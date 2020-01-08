//
//  UIView+MKFrameAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/16.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (MKFrameAdd)

@property (nonatomic) CGPoint mk_origin;
@property (nonatomic) CGSize  mk_size;

@property (nonatomic) CGFloat mk_x;
@property (nonatomic) CGFloat mk_y;
@property (nonatomic) CGFloat mk_width;
@property (nonatomic) CGFloat mk_height;

@property (nonatomic) CGFloat mk_centerX;
@property (nonatomic) CGFloat mk_centerY;

@property (nonatomic) CGFloat mk_top;
@property (nonatomic) CGFloat mk_left;
@property (nonatomic) CGFloat mk_bottom;
@property (nonatomic) CGFloat mk_right;

@property (nonatomic) CGPoint mk_topLeft;
@property (nonatomic) CGPoint mk_topRight;
@property (nonatomic) CGPoint mk_bottomLeft;
@property (nonatomic) CGPoint mk_bottomRight;
@end
