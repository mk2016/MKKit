//
//  MKPictureView.h
//  MKKitExample
//
//  Created by xmk on 2017/2/20.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MKPictureView;
@protocol MKPictureViewDelegate <NSObject>

- (void)pictureView:(MKPictureView *)view singleTapGesture:(UITapGestureRecognizer *)singleTap;
- (void)pictureView:(MKPictureView *)view longPressGesture:(UILongPressGestureRecognizer *)longPress;
- (void)pictureView:(MKPictureView *)view imageLoadProgress:(CGFloat)progress;

@end

@interface MKPictureView : UIScrollView
@property (nonatomic, weak) id<MKPictureViewDelegate> pictureViewDelegate;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setShowHDImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage;
@end
