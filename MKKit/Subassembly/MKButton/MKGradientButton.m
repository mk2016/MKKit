//
//  MKGradientButton.m
//  Huaya
//
//  Created by MK on 2021/7/22.
//  Copyright © 2021 taolang. All rights reserved.
//

#import "MKGradientButton.h"
#import "UIImage+MKAdd.h"

@interface MKGradientButton ()
@property (nonatomic, strong) CAGradientLayer *colorLayer;
@property (nonatomic, strong) UIImage *colorImage;
@end

@implementation MKGradientButton

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
//        [self setNeedsLayout];
//        [self layoutIfNeeded];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {

    }
    return self;
}

- (void)setStartColors:(NSArray <UIColor *> *)colors{
    NSMutableArray *cgColors = @[].mutableCopy;
    for (UIColor *c in colors) {
        [cgColors addObject:(id)c.CGColor];
    }
    self.colorLayer = [CAGradientLayer layer];
    self.colorLayer.startPoint = CGPointMake(0, 0);
    self.colorLayer.endPoint = CGPointMake(1, 1);
    self.colorLayer.colors = cgColors;
    self.colorLayer.locations = @[@(0.0),@(1)];
    [self.layer addSublayer:self.colorLayer];
    self.colorLayer.zPosition = -1;
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (void)setBackgroundImageWithColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state{
    UIImage *img = [UIImage mk_gradientWithColors:colors size:self.frame.size];
    [self setBackgroundImage:img forState:state];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    self.colorLayer.frame = self.bounds;
}


@end
