//
//  MKOverView.m
//  Taoqicar
//
//  Created by xiaomk on 2019/6/6.
//  Copyright © 2019 taoqicar. All rights reserved.
//

#import "MKOverView.h"

@interface MKOverView(){
    CGPoint _topLeft;
    CGPoint _topRight;
    CGPoint _bottomRight;
    CGPoint _bottomLeft;
}
@property (nonatomic, strong) CAShapeLayer *maskLayer;
@end

@implementation MKOverView

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.tintColor = UIColor.whiteColor;
        self.cornerLength = 25;
    }
    return self;
}

- (void)hide{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.hidden = YES;
    });
}

- (void)setFourPoints:(NSArray *)points{
    if (points && points.count == 4){
        _topLeft = CGPointFromString(points[0]);
        _topRight = CGPointFromString(points[1]);
        _bottomRight = CGPointFromString(points[2]);
        _bottomLeft = CGPointFromString(points[3]);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.hidden){
                self.hidden = NO;
            }
            [self setNeedsDisplay];
        });
    }
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    //是否镂空效果
    UIBezierPath *maskPath = [UIBezierPath bezierPath];
    if (self.hollowOut){
        CGRect biggerRect = self.bounds;
        [maskPath moveToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMaxY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMaxY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMaxX(biggerRect), CGRectGetMinY(biggerRect))];
        [maskPath addLineToPoint:CGPointMake(CGRectGetMinX(biggerRect), CGRectGetMinY(biggerRect))];
        self.maskLayer.fillColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5].CGColor;
        self.maskLayer.fillRule = kCAFillRuleEvenOdd;
    }else{
        self.maskLayer.fillColor = [UIColor colorWithWhite:1 alpha:0.3].CGColor;
    }
    [maskPath moveToPoint:_topLeft];
    [maskPath addLineToPoint:_topRight];
    [maskPath addLineToPoint:_bottomRight];
    [maskPath addLineToPoint:_bottomLeft];
    [maskPath addLineToPoint:_topLeft];
    self.maskLayer.path = maskPath.CGPath;
    
    [self.tintColor set];
    CGContextRef curContext = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(curContext, 2.0f);
    if (self.style == MKOverViewStyle_corner){   // 四角
        int s = self.cornerLength;
        CGPoint tl = CGPointMake(_topLeft.x+1, _topLeft.y+1);
        CGPoint tr = CGPointMake(_topRight.x-1, _topRight.y+1);
        CGPoint br = CGPointMake(_bottomRight.x-1, _bottomRight.y-1);
        CGPoint bl = CGPointMake(_bottomLeft.x+1, _bottomLeft.y-1);
        CGContextMoveToPoint(curContext,    tl.x,   tl.y+s);
        CGContextAddLineToPoint(curContext, tl.x,   tl.y);
        CGContextAddLineToPoint(curContext, tl.x+s, tl.y);
        
        CGContextMoveToPoint(curContext,    tr.x-s, tr.y);
        CGContextAddLineToPoint(curContext, tr.x,   tr.y);
        CGContextAddLineToPoint(curContext, tr.x,   tr.y+s);
        
        CGContextMoveToPoint(curContext,    br.x,   br.y-s);
        CGContextAddLineToPoint(curContext, br.x,   br.y);
        CGContextAddLineToPoint(curContext, br.x-s, br.y);
        
        CGContextMoveToPoint(curContext,    bl.x,   bl.y-s);
        CGContextAddLineToPoint(curContext, bl.x,   bl.y);
        CGContextAddLineToPoint(curContext, bl.x+s, bl.y);
    }else{  //全框
        if (self.style == MKOverViewStyle_dashed){
            CGContextMoveToPoint(curContext, 0, 0);
            CGFloat arr1[] = {5,2}; //虚线 （绘制 5个点 跳过 2个点）
            CGContextSetLineDash(curContext, 0, arr1, 2);
        }
        CGContextMoveToPoint(curContext,    _topLeft.x, _topLeft.y);
        CGContextAddLineToPoint(curContext, _topRight.x, _topRight.y);
        CGContextAddLineToPoint(curContext, _bottomRight.x, _bottomRight.y);
        CGContextAddLineToPoint(curContext, _bottomLeft.x, _bottomLeft.y);
        CGContextAddLineToPoint(curContext, _topLeft.x, _topLeft.y);
    }
    CGContextStrokePath(curContext);
}


#pragma mark - ***** lazy ******
- (CAShapeLayer *)maskLayer{
    if (!_maskLayer) {
        _maskLayer = [CAShapeLayer layer];
        [self.layer addSublayer:_maskLayer];
    }
    return _maskLayer;
}
@end
