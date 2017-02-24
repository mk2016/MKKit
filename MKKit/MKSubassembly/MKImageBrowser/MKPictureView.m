//
//  MKPictureView.m
//  MKKitExample
//
//  Created by xmk on 2017/2/20.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "MKPictureView.h"
#import "MKKitConst.h"

#import "SDImageCache.h"
#import "UIImageView+WebCache.h"

@interface MKPictureView ()<UIScrollViewDelegate>
@property (nonatomic, assign) CGFloat progress;
@end

@implementation MKPictureView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

/** 初始化设置 */
- (void)initData{
    self.showsVerticalScrollIndicator = NO;
    self.showsHorizontalScrollIndicator = NO;
    self.delegate = self;
    self.backgroundColor = [UIColor clearColor];
    self.imageView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.imageView];
    
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapEvent:)];
    UITapGestureRecognizer *doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(doubleTapEvent:)];
    doubleTap.numberOfTapsRequired = 2;
    [singleTap requireGestureRecognizerToFail:doubleTap];
    [self addGestureRecognizer:singleTap];
    [self addGestureRecognizer:doubleTap];
    
    UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressEvent:)];
    [self addGestureRecognizer:longPress];
}

/** 设置图片 */
- (void)setShowHDImageWithUrl:(NSString *)url placeholderImage:(UIImage *)placeholderImage{
    if (!url) {
        [self setShowImage:placeholderImage];
        return;
    }
    
    UIImage *urlImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:[NSURL URLWithString:url].absoluteString];
    if (urlImage) {
        [self setShowImage:urlImage];
        return;
    }
    self.progress = 0.01f;
    MKWEAKSELF
    [self.imageView setShowActivityIndicatorView:YES];
    [self setShowImage:placeholderImage];
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:url]
                      placeholderImage:placeholderImage options:SDWebImageRetryFailed |
                                                                SDWebImageLowPriority |
                                                                SDWebImageHandleCookies
                              progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                  weakSelf.progress = (CGFloat)receivedSize / expectedSize ;
                                  ELog(@"progress : %f", weakSelf.progress);
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        if (error) {
            DLog(@"加载图片失败 image url : %@",imageURL);
        }else{
            weakSelf.imageView.image = image;
            [weakSelf.imageView setNeedsDisplay];
            [UIView animateWithDuration:0.3 animations:^{
                [weakSelf setMaxAndMinZoomScales];
            }];
        }
    }];
}

- (void)setShowImage:(UIImage *)image{
    if (image) {
        self.imageView.image = image;
        [self setMaxAndMinZoomScales];
        [self setNeedsLayout];
    }
}

- (void)resetImageZoomScale{
    self.maximumZoomScale = 1.0;
    self.minimumZoomScale = 1.0;
}

/** 设置最大最小比例 */
- (void)setMaxAndMinZoomScales{
    UIImage *image = self.imageView.image;
    if (image == nil || image.size.height == 0) {
        return;
    }
    
    CGFloat maxScale = 2.0f;
    CGFloat screenWHRatio = MKSCREEN_WIDTH/MKSCREEN_HEIGHT;
    CGFloat imageWHRatio = image.size.width / image.size.height;
    CGRect frame = CGRectMake(0, 0, MKSCREEN_WIDTH, MKSCREEN_HEIGHT);
    if (imageWHRatio >= screenWHRatio) {
        frame.size.height = MKSCREEN_WIDTH/imageWHRatio;
        frame.origin.y = (MKSCREEN_HEIGHT - frame.size.height)/2.0f;
        maxScale = MAX(MKSCREEN_HEIGHT/frame.size.height, 2.0f);
    }else{
        frame.size.width = MKSCREEN_HEIGHT*imageWHRatio;
        frame.origin.x = (MKSCREEN_WIDTH - frame.size.width)/2.0f;
        maxScale = MAX(MKSCREEN_WIDTH/frame.size.width, 2.0f);
    }
    self.imageView.frame = frame;
    self.scrollEnabled = NO;
    
    self.maximumZoomScale = maxScale;
    self.minimumZoomScale = 1.0f;
    self.zoomScale = 1.0f;
    self.contentSize = CGSizeMake(frame.size.width, MAX(frame.size.height, MKSCREEN_HEIGHT));
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGRect frameCenter = self.imageView.frame;
    
    if (frameCenter.size.width < MKSCREEN_WIDTH) {
        frameCenter.origin.x = floor((MKSCREEN_WIDTH - frameCenter.size.width)/2.0f);
    }else{
        frameCenter.origin.x = 0;
    }
    if (frameCenter.size.height < MKSCREEN_HEIGHT) {
        frameCenter.origin.y = floor((MKSCREEN_HEIGHT - frameCenter.size.height)/2.0f);
    }else{
        frameCenter.origin.y = 0;
    }
    
    if (!CGRectEqualToRect(self.imageView.frame, frameCenter)) {
        self.imageView.frame = frameCenter;
    }
}

#pragma mark - ***** 手势 *****
- (void)longPressEvent:(UILongPressGestureRecognizer *)longPress{
    if (self.pictureViewDelegate && [self.pictureViewDelegate respondsToSelector:@selector(pictureView:longPressGesture:)]) {
        [self.pictureViewDelegate pictureView:self longPressGesture:longPress];
    }
}

- (void)singleTapEvent:(UITapGestureRecognizer *)singleTap{
    ELog(@"singleTap");
    if (self.pictureViewDelegate && [self.pictureViewDelegate respondsToSelector:@selector(pictureView:singleTapGesture:)]) {
        [self.pictureViewDelegate pictureView:self singleTapGesture:singleTap];
    }
}

- (void)doubleTapEvent:(UITapGestureRecognizer *)doubleTap{
    ELog(@"doubleTap");
    self.userInteractionEnabled = NO;
    [self handleDoubleTap:[doubleTap locationInView:doubleTap.view]];
}

- (void)handleDoubleTap:(CGPoint)point{
    self.userInteractionEnabled = NO;
    CGRect zoomRect = [self zoomRectForScale:[self willBecomeZoomScale] withCenter:point];
    [self zoomToRect:zoomRect animated:YES];
}

/** 将要缩放的比例 */
- (CGFloat)willBecomeZoomScale{
    if (self.zoomScale > self.minimumZoomScale) {
        return self.minimumZoomScale;
    }else{
        return self.maximumZoomScale;
    }
}

- (CGRect)zoomRectForScale:(CGFloat)scale withCenter:(CGPoint)center{
    CGFloat width = MKSCREEN_WIDTH / scale;
    CGFloat height = MKSCREEN_HEIGHT / scale;
    CGFloat x = center.x - width * 0.5;
    CGFloat y = center.y - height * 0.5;
    return CGRectMake(x, y, width, height);
}

#pragma mark - ***** UIScrollView delegate *****
- (void)scrollViewDidZoom:(UIScrollView *)scrollView{
    [self setNeedsLayout];
    [self layoutIfNeeded];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    return self.imageView;
}

- (void)scrollViewWillBeginZooming:(UIScrollView *)scrollView withView:(UIView *)view{
    self.scrollEnabled = YES;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale{
    self.userInteractionEnabled = YES;
}

#pragma mark - ***** lazy *****
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc] init];
    }
    return _imageView;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
