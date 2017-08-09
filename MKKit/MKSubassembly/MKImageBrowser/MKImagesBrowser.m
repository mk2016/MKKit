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
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) NSInteger imageCount;             /*!< 图片总数 */
@property (nonatomic, strong) NSMutableArray<MKPictureView *> *picturesArray;    /*!< picture imageView array */
@property (nonatomic, strong) NSMutableArray<MKPictureView *> *tempPicArray;
/** pageControlDot */
@property (nonatomic, strong) UIControl *pageControl;
@property (nonatomic, assign) CGSize pageControlDotSize;

@end

@implementation MKImagesBrowser

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self initData];
    }
    return self;
}

- (void)initData{
    _pageControlAlignment = MKIBPageControlAlignmentCenter;
    _pageControlDotSize = CGSizeMake(10, 10);
    _hidePageControlWhenSinglePage = YES;
    _currentIndex = 0;
    _imageCount = 0;
}



- (void)show{
    self.backgroundColor = self.bgColor;
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
    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:sourceImageWithIndex:)]) {
        targetImage = [self.dataSource imagesBrowser:self sourceImageWithIndex:self.currentIndex];
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
    UIImageView *curImageView = nil;
    for (MKPictureView *view in self.picturesArray) {
        if (view.tag == self.currentIndex) {
            curImageView = view.imageView;
        }
    }
//    [self.picturesArray objectAtIndex:self.currentIndex].imageView;

    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:viewWithIndex:)]) {
        imageView = [self.dataSource imagesBrowser:self viewWithIndex:self.currentIndex];
    }
    if ([self.dataSource respondsToSelector:@selector(imagesBrowser:sourceImageWithIndex:)]) {
        targetImage = [self.dataSource imagesBrowser:self sourceImageWithIndex:self.currentIndex];
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
    for (NSInteger i = self.currentIndex-1; i <= self.currentIndex+1; i++) {
        if (i < 0 || i >= self.imageCount) {
            MKPictureView *view = [[MKPictureView alloc] init];
            view.delegate = self;
            [self.tempPicArray addObject:view];
            [self.scrollView addSubview:view];
            continue;
        }
        MKPictureView *pictureView = [[MKPictureView alloc] init];
        pictureView.tag = i;
        pictureView.pictureViewDelegate = self;
        pictureView.frame = CGRectMake((self.bounds.size.width+MKIBImageViewMargin)*i, 0, self.bounds.size.width, self.bounds.size.height);
        [self.scrollView addSubview:pictureView];
        if ([self.dataSource respondsToSelector:@selector(imagesBrowser:sourceImageWithIndex:)]) {
            UIImage *sourceImage = [self.dataSource imagesBrowser:self sourceImageWithIndex:i];
            if (!sourceImage) {
                sourceImage = self.placeholderImage;
            }
            NSString *imgUrl = nil;
            if ([self.dataSource respondsToSelector:@selector(imagesBrowser:HDImageUrlWithIndex:)]) {
                imgUrl = [self.dataSource imagesBrowser:self HDImageUrlWithIndex:i];
            }
            [pictureView setShowHDImageWithUrl:imgUrl placeholderImage:sourceImage];
        }
        [self.picturesArray addObject:pictureView];
    }
}

- (void)updatePageView{
  
    NSMutableArray *tagAry = @[].mutableCopy;
    for (MKPictureView *view in self.picturesArray) {
        if (view.tag < self.currentIndex-1 || view.tag > self.currentIndex+1) {
            [self.tempPicArray addObject:view];
        }else{
            [tagAry addObject:@(view.tag)];
        }
    }
    if (self.tempPicArray.count == 0) {
        return;
    }
    [self.picturesArray removeObjectsInArray:self.tempPicArray];
    for (NSInteger i = self.currentIndex-1; i <= self.currentIndex+1; i++) {
        if (i < 0 || i >= self.imageCount) {
            continue;
        }
        BOOL have = NO;
        for (NSNumber *tagNum in tagAry) {
            if (tagNum.integerValue == i) {
                have = YES;
                break;
            }
        }
        if (!have && self.tempPicArray.count > 0) {
            MKPictureView *view = self.tempPicArray.firstObject;
            view.tag = i;
            view.frame = CGRectMake((self.bounds.size.width+MKIBImageViewMargin)*i, 0, self.bounds.size.width, self.bounds.size.height);
            if ([self.dataSource respondsToSelector:@selector(imagesBrowser:sourceImageWithIndex:)]) {
                UIImage *sourceImage = [self.dataSource imagesBrowser:self sourceImageWithIndex:i];
                if (!sourceImage) {
                    sourceImage = self.placeholderImage;
                }
                NSString *imgUrl = nil;
                if ([self.dataSource respondsToSelector:@selector(imagesBrowser:HDImageUrlWithIndex:)]) {
                    imgUrl = [self.dataSource imagesBrowser:self HDImageUrlWithIndex:i];
                }
                [view setShowHDImageWithUrl:imgUrl placeholderImage:sourceImage];
            }
            [self.tempPicArray removeObject:view];
            [self.picturesArray addObject:view];
        }
    }
}

- (void)setupPageControl{
    if (_pageControl) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    }
    if ((self.imageCount <= 1 && self.hidePageControlWhenSinglePage) || self.pageControlAlignment == MKIBPageControlAlignmentNone) {
        return;
    }
    UIPageControl *pageControl = (UIPageControl *)self.pageControl;
    pageControl.numberOfPages = self.imageCount;
    pageControl.currentPage = self.currentIndex;
    
    CGSize size = CGSizeMake(self.imageCount * (self.pageControlDotSize.width + 14), self.pageControlDotSize.height);
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
    if (self.imageCount == 1 && self.hidePageControlWhenSinglePage && self.pageControl) {
        self.pageControl.hidden = YES;
        return;
    }
    NSInteger currentIndex = ((UIPageControl *)self.pageControl).currentPage;
    if (currentIndex != self.currentIndex) {
        ((UIPageControl *)self.pageControl).currentPage = self.currentIndex;
    }
    
}

#pragma mark - ***** UIScrollView delegate*****
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    CGFloat offsetX = scrollView.contentOffset.x;
    double page = offsetX/scrollView.bounds.size.width;
    NSUInteger pageInt = (int)(page+0.5f);
    if (pageInt == self.currentIndex) {
        return;
    }
    if (pageInt < self.imageCount) {
        self.currentIndex = pageInt;
    }else{
        self.currentIndex = self.imageCount-1;
    }
    [self updatePageControlIndex];
    [self updatePageView];
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

- (UIControl *)pageControl{
    if (!_pageControl) {
        UIPageControl *pageControl = [[UIPageControl alloc] init];
        if (self.pageDotColor) {
            pageControl.pageIndicatorTintColor = self.pageDotColor;
        }
        if (self.pageDotCurrentColor) {
            pageControl.currentPageIndicatorTintColor = self.pageDotCurrentColor;
        }
        if (self.pageDotImage ) {
            [pageControl setValue:self.pageDotImage forKey:@"_pageImage"];
            _pageControlDotSize = self.pageDotImage.size;
        }
        if (self.pageDotCurrentImage) {
            [pageControl setValue:self.pageDotCurrentImage forKey:@"_currentPageImage"];
        }
        
        pageControl.userInteractionEnabled = NO;
        [self addSubview:pageControl];
        _pageControl = pageControl;
    }
    return _pageControl;
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

- (NSMutableArray *)tempPicArray{
    if (!_tempPicArray) {
        _tempPicArray = @[].mutableCopy;
    }
    return _tempPicArray;
}

- (UIImage *)placeholderImage{
    if (!_placeholderImage) {
        _placeholderImage = [UIImage mk_imageWithColor:[UIColor grayColor]];
    }
    return _placeholderImage;
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
