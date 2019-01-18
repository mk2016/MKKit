//
//  UIImageView+MKTapAdd.m
//  MKKit
//
//  Created by xmk on 2017/5/24.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "UIImageView+MKTapAdd.h"
#import <objc/runtime.h>

@implementation UIImageView (MKTapAdd)

- (BOOL)mk_tapPreview{
    NSNumber *tapPreview = objc_getAssociatedObject(self, @selector(mk_tapPreview));
    return [tapPreview boolValue];
}

- (void)setMk_tapPreview:(BOOL)mk_tapPreview{
    objc_setAssociatedObject(self, @selector(mk_tapPreview), @(mk_tapPreview), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self setUserInteractionEnabled:mk_tapPreview];
    if (mk_tapPreview) {
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(mk_tapGesture:)];
        [self addGestureRecognizer:gesture];
    }
}

- (void)mk_tapGesture:(UITapGestureRecognizer *)sender{
    if (self) {
        [self mk_previewImageView];
    }
}

static CGRect s_oldframe;
- (void)mk_previewImageView{
    //image
    UIImage *image = self.image;
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    s_oldframe = [self convertRect:self.bounds toView:window];
    
    backgroundView.backgroundColor = [UIColor blackColor];
    backgroundView.alpha = 0;
    
    UIImageView *imageV =[[UIImageView alloc] initWithFrame:s_oldframe];
    imageV.image = image;
    imageV.tag = 1102;
    [backgroundView addSubview:imageV];
    [window addSubview:backgroundView];
    
    //add hidden Gesture
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mk_hideImage:)];
    [backgroundView addGestureRecognizer:tap];
    
    CGFloat imageHeight = image.size.height / image.size.width * [UIScreen mainScreen].bounds.size.width;
    [UIView animateWithDuration:0.3 animations:^{
        imageV.frame = CGRectMake(0,
                                  ([UIScreen mainScreen].bounds.size.height - imageHeight)/2,
                                  [UIScreen mainScreen].bounds.size.width,
                                  imageHeight
                                  );
        backgroundView.alpha = 1;
    } completion:nil];
}

- (void)mk_hideImage:(UITapGestureRecognizer *)tap{
    UIView *backgroundView = tap.view;
    UIImageView *imageView = (UIImageView *)[tap.view viewWithTag:1102];
    [UIView animateWithDuration:0.3 animations:^{
        imageView.frame = s_oldframe;
        backgroundView.alpha = 0;
    } completion:^(BOOL finished) {
        [backgroundView removeFromSuperview];
    }];
}

@end
