//
//  MKImagesBrowser.m
//  MKKitExample
//
//  Created by xmk on 2017/2/20.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "MKImagesBrowser.h"
#import "MKPictureView.h"
#import "MKKitConst.h"

#define MKIBImageViewMargin 10
#define MKIBImageViewAnimationDuration 0.3f

@interface MKImagesBrowser()<UIScrollViewDelegate, MKPictureViewDelegate>

@property (nonatomic, strong) UIWindow *bgWindow;
@property (nonatomic, strong) UIColor *bgColor;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign ) NSInteger imageCount;    /*!< 图片总数 */
@property (nonatomic, strong) NSMutableArray *picturesArray;
/** pageControlDot */
@property (nonatomic, strong) UIControl *pageControl;
@property (nonatomic, assign) CGSize pageControlDotSize;
@property (nonatomic, assign) BOOL hideForSinglePage;
@property (nonatomic, strong) UIColor *pageDotColor;
@property (nonatomic, strong) UIColor *pageDotSelectedColor;
@property (nonatomic, strong) UIImage *pageDotImage;
@property (nonatomic, strong) UIImage *pageDotSelectedImage;
@end

@implementation MKImagesBrowser

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)initData{
    self.backgroundColor = self.bgColor;
    _pageControlAlignment = MKIBPageControlAlignmentCenter;
    _pageControlDotSize = CGSizeMake(10, 10);
    _hideForSinglePage = YES;
    _currentIndex = 0;
    _imageCount = 0;
}



- (void)show{
    [self.bgWindow addSubview:self];
    self.frame = self.bgWindow.bounds;
    self.alpha = 0.0f;
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationFade];
    [self reloadData];
    [self startImageAnimation];
}

- (void)startImageAnimation{
    UIImageView *fromImageView = nil;
    UIImage *targetImage = nil;
    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:viewWithIndex:)]) {
        fromImageView = [self.dataSource imagesBrowser:self viewWithIndex:self.currentIndex];
    }
    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:placeholderImageWithIndex:)]) {
        targetImage = [self.dataSource imagesBrowser:self placeholderImageWithIndex:self.currentIndex];
    }

    if (fromImageView && targetImage) {
        self.scrollView.hidden = YES;
        self.alpha = 1.0;

        CGRect oldframe = [fromImageView.superview convertRect:fromImageView.frame toView:self];
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.image = targetImage;
        tempImageView.contentMode = fromImageView.contentMode;
        tempImageView.frame = oldframe;
        [self addSubview:tempImageView];

        CGRect overframe = [self getTargetFrameWithImage:targetImage];
        [UIView animateWithDuration:MKIBImageViewAnimationDuration animations:^{
            tempImageView.frame = overframe;
        } completion:^(BOOL finished) {
            [tempImageView removeFromSuperview];
            self.scrollView.hidden = NO;
        }];
    }else{
        [UIView animateWithDuration:MKIBImageViewAnimationDuration animations:^{
            self.alpha = 1.0f;
        }];
        return;
    }
}

- (void)endImageAnimation{
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationFade];
    UIImageView *imageView = nil;
    UIImage *targetImage = nil;
    UIImageView *curImageView = [self.picturesArray objectAtIndex:self.currentIndex];

    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:viewWithIndex:)]) {
        imageView = [self.dataSource imagesBrowser:self viewWithIndex:self.currentIndex];
    }
    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:placeholderImageWithIndex:)]) {
        targetImage = [self.dataSource imagesBrowser:self placeholderImageWithIndex:self.currentIndex];
    }
    
    if (imageView && targetImage && curImageView) {
        self.scrollView.hidden = YES;
        
        CGRect oldframe = [curImageView.superview convertRect:curImageView.frame toView:self];
        
        UIImageView *tempImageView = [[UIImageView alloc] init];
        tempImageView.contentMode = imageView.contentMode;
        tempImageView.clipsToBounds = YES;
        tempImageView.image = targetImage;
        tempImageView.frame = oldframe;
        [self addSubview:tempImageView];
        
        CGRect overFrame = [imageView convertRect:imageView.bounds toView:self];
        
        [UIView animateWithDuration:MKIBImageViewAnimationDuration animations:^{
            tempImageView.frame = overFrame;
            self.backgroundColor = [UIColor clearColor];
        } completion:^(BOOL finished) {
            [tempImageView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }else{
        [self dismiss];
    }
}

- (void)dismiss{
    [UIView animateWithDuration:MKIBImageViewAnimationDuration animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)reloadData{
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];

    if (self.dataSource && [self.dataSource respondsToSelector:@selector(numberOfImagesInBrowser:)]) {
        self.imageCount = [self.dataSource numberOfImagesInBrowser:self];
    }
    if (self.imageCount <= 0) {
        return;
    }
    if (self.currentIndex >= self.imageCount) {
        self.currentIndex = self.imageCount - 1;
    }
    
    
    [self setupPageControl];
    self.scrollView.contentSize = CGSizeMake((self.bounds.size.width+MKIBImageViewMargin)*self.imageCount, self.bounds.size.height);
    self.scrollView.contentOffset = CGPointMake(self.currentIndex*(self.scrollView.bounds.size.width), 0);
    
    [self.picturesArray removeAllObjects];
    for (NSInteger i = 0; i < self.imageCount; i++) {
        MKPictureView *pictureView = [[MKPictureView alloc] init];
        pictureView.pictureViewDelegate = self;
        pictureView.frame = CGRectMake((self.bounds.size.width+MKIBImageViewMargin)*i, 0, self.bounds.size.width, self.bounds.size.height);
        [self.scrollView addSubview:pictureView];
        if ([self.dataSource respondsToSelector:@selector(imagesBrowser:placeholderImageWithIndex:)]) {
            UIImage *placeholdImage = [self.dataSource imagesBrowser:self placeholderImageWithIndex:i];
            [pictureView setShowImage:placeholdImage];
        }
        [self.picturesArray addObject:pictureView.imageView];
    }
}

- (void)setupPageControl{
    if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    if ((self.imageCount <= 1 && self.hideForSinglePage) || self.pageControlAlignment == MKIBPageControlAlignmentNone) {
        return;
    }
    
    UIPageControl *pageControl = [[UIPageControl alloc] init];
    pageControl.numberOfPages = self.imageCount;
    pageControl.pageIndicatorTintColor = self.pageDotColor;
    pageControl.currentPageIndicatorTintColor = self.pageDotSelectedColor;
    pageControl.userInteractionEnabled = NO;
    pageControl.currentPage = self.currentIndex;
    [self addSubview:pageControl];
    self.pageControl = pageControl;
    
    
    CGSize size = CGSizeMake(self.imageCount * self.pageControlDotSize.width * 1.2, self.pageControlDotSize.height);
    if (self.pageControlAlignment == MKIBPageControlAlignmentCenter){
        self.pageControl.frame = CGRectMake((MKSCREEN_WIDTH-size.width)/2, MKSCREEN_HEIGHT-30, size.width, size.height);
    }else if (self.pageControlAlignment == MKIBPageControlAlignmentLeft){
        self.pageControl.frame = CGRectMake(30, MKSCREEN_HEIGHT-30, size.width, size.height);
    }else if (self.pageControlAlignment == MKIBPageControlAlignmentRight){
        self.pageControl.frame = CGRectMake(MKSCREEN_WIDTH-size.width-30, MKSCREEN_HEIGHT-30, size.width, size.height);
    }
}

/** 更新 pageControl */
- (void)updatePageControlIndex{
    if (self.imageCount == 1 && self.hideForSinglePage && self.pageControl) {
        self.pageControl.hidden = YES;
        return;
    }
    ((UIPageControl *)self.pageControl).currentPage = self.currentIndex;
}

#pragma mark - ***** UIScrollView delegate*****
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    double page = offsetX/scrollView.bounds.size.width;
    NSUInteger pageInt = (int)(page+0.5f);
    if (pageInt < self.imageCount) {
        self.currentIndex = pageInt;
    }else{
        self.currentIndex = self.imageCount-1;
    }
    [self updatePageControlIndex];
}

#pragma mark - ***** MKPictureView delegate *****
- (void)pictureView:(MKPictureView *)view singleTapGesture:(UITapGestureRecognizer *)singleTap{
    [self endImageAnimation];
}

- (void)pictureView:(MKPictureView *)view longPressGesture:(UILongPressGestureRecognizer *)longPress{
    if (longPress.state == UIGestureRecognizerStateBegan) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagesBrowser:longPressImageWithIndex:)]) {
            [self.delegate imagesBrowser:self longPressImageWithIndex:self.currentIndex];
        }
        MKBlockExec(self.longPressblock, self, self.currentIndex);
    }
}

- (void)pictureView:(MKPictureView *)view imageLoadProgress:(CGFloat)progress{
    
}

#pragma mark - ***** tools *****
- (CGRect)getTargetFrameWithImage:(UIImage *)image{
    CGFloat screenWHRatio = MKSCREEN_WIDTH/MKSCREEN_HEIGHT;
    CGFloat imageWHRatio = image.size.width / image.size.height;
    CGRect overframe = CGRectMake(0, 0, MKSCREEN_WIDTH, MKSCREEN_HEIGHT);
    if (imageWHRatio >= screenWHRatio) {
        overframe.size.height = MKSCREEN_WIDTH/imageWHRatio;
        overframe.origin.y = (MKSCREEN_HEIGHT - overframe.size.height)/2.0f;
    }else{
        overframe.size.width = MKSCREEN_HEIGHT*imageWHRatio;
        overframe.origin.x = (MKSCREEN_WIDTH - overframe.size.width)/2.0f;
    }
    return overframe;
}

#pragma mark - ***** lazy *****
- (UIWindow *)bgWindow{
    if (!_bgWindow) {
        _bgWindow = [MKUIHelper getTopFullWindow];
        _bgWindow.hidden = NO;
    }
    return _bgWindow;
}

- (UIScrollView *)scrollView{
    if (!_scrollView) {
        CGRect rect = self.bounds;
        rect.size.width += MKIBImageViewMargin;
        _scrollView = [[UIScrollView alloc] initWithFrame:rect];
        _scrollView.delegate = self;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.pagingEnabled = YES;
        _scrollView.backgroundColor = [UIColor clearColor];
        [self addSubview:_scrollView];
        [self sendSubviewToBack:_scrollView];
    }
    return _scrollView;
}

- (UIColor *)bgColor{
    if (!_bgColor) {
        _bgColor = [UIColor blackColor];
    }
    return _bgColor;
}

- (NSMutableArray *)picturesArray{
    if (!_picturesArray) {
        _picturesArray = @[].mutableCopy;
    }
    return _picturesArray;
}

- (void)dealloc{
    DLog(@"dealloc");
    if (_picturesArray && _picturesArray.count) {
        [_picturesArray removeAllObjects];
        _picturesArray = nil;
    }
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
