//
//  MKRightImageButton.m
//  MKKit
//
//  Created by xiaomk on 15/9/15.
//  Copyright (c) 2015年 mk. All rights reserved.
//

#import "MKRightImageButton.h"

@implementation MKRightImageButton

- (id)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (void)layoutSubviews{
    
    [super layoutSubviews];
    
    // title size
    CGSize maxSize = CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX);
    NSMutableDictionary *attrDic = [NSMutableDictionary dictionary];
    attrDic[NSFontAttributeName] = self.titleLabel.font;
    CGRect titleRect = [self.currentTitle boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:attrDic context:nil];
    
    // image size
    CGFloat imageW = self.imageView.frame.size.width;
    CGFloat imageH = self.imageView.frame.size.height;
    
    // title size
    CGFloat titleW = titleRect.size.width;
    CGFloat titleH = titleRect.size.height;
    
    // button size
    CGFloat btnH = self.frame.size.height;
    CGFloat btnW = self.frame.size.width;
    
    if (self.resetButtonSize) { // reset button size
        CGRect frame = self.frame;
        btnH = titleH > imageH ? titleH : imageH;
        btnW = titleW + imageW + self.space;
        self.frame = frame;
    }
    
    // title position
    CGFloat titleX = (btnW - titleW - imageW - self.space) * 0.5;
    CGFloat titleY = (btnH - titleH) * 0.5;
    
    // title position
    CGFloat imageX = titleX + titleW + self.space;
    CGFloat imageY = (btnH - imageH) * 0.5;
    
    // set title & image frame
    self.titleLabel.frame = CGRectMake(titleX, titleY, titleW, titleH);
    self.imageView.frame = CGRectMake(imageX, imageY, imageW, imageH);
    
}

- (void)setSpace:(CGFloat)space{
    _space = space;
    [self setNeedsLayout];
}


@end
