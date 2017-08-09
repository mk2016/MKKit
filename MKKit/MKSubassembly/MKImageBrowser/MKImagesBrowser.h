//
//  MKImagesBrowser.h
//  MKKitExample
//
//  Created by xmk on 2017/2/20.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, MKIBPageControlAlignment) {
    MKIBPageControlAlignmentCenter = 1,
    MKIBPageControlAlignmentLeft,
    MKIBPageControlAlignmentRight,
    MKIBPageControlAlignmentNone,
};

@class MKImagesBrowser;
@protocol MKImagesBrowserDataSource <NSObject>
/** 
 * 获取默认的图片
 */
- (UIImage *)imagesBrowser:(MKImagesBrowser *)browser sourceImageWithIndex:(NSInteger)index;

/**
 * 获取界面上显示的imageView，用于获取frame 做 开始结束的 放大缩小动画
 */
- (UIImageView *)imagesBrowser:(MKImagesBrowser *)browser viewWithIndex:(NSInteger)index;

/** 
 * 获取 image 的数量
 */
- (NSInteger)numberOfImagesInBrowser:(MKImagesBrowser *)browser;
@optional
/** 获取 高清网络图片 */
- (NSString *)imagesBrowser:(MKImagesBrowser *)browser HDImageUrlWithIndex:(NSInteger)index;

@end

@protocol MKImagesBrowserDelegate <NSObject>
@optional
/** 长按事件回调 和  longPressblock 效果一样，正常使用其中一个就好了 */
- (void)imagesBrowser:(MKImagesBrowser *)browser longPressImageWithIndex:(NSUInteger)index;
@end

/** 长按事件回调 和 imagesBrowser:longPressImageWithIndex 效果一样， 正常使用其中一个就好了 */
typedef void (^MKImagesBrowserLongPressBlock)(MKImagesBrowser *broeser, NSUInteger index);

@interface MKImagesBrowser : UIView
@property (nonatomic, weak) id<MKImagesBrowserDataSource> dataSource;
@property (nonatomic, weak) id<MKImagesBrowserDelegate> delegate;
@property (nonatomic, copy) MKImagesBrowserLongPressBlock longPressblock;   /*!< 长按事件回调 */

@property (nonatomic, strong) UIColor *bgColor;                             /*!< 背景颜色 */
@property (nonatomic, assign ) NSInteger currentIndex;                     /*!< current image index */
@property (nonatomic, strong) UIImage *placeholderImage;                    /*!< 占位图 */
/** pageControl set */
@property (nonatomic, assign) MKIBPageControlAlignment pageControlAlignment;/*!< 控制 pageControl 位置 */
@property (nonatomic, assign) BOOL hidePageControlWhenSinglePage;           /*!< 单图是否隐藏 pageControl. default:YES */
@property (nonatomic, strong) UIColor *pageDotColor;                        /*!< pageControl normal dot color */
@property (nonatomic, strong) UIColor *pageDotCurrentColor;                 /*!< pageControl current page dot color */
@property (nonatomic, strong) UIImage *pageDotImage;
@property (nonatomic, strong) UIImage *pageDotCurrentImage;

- (void)show;
@end
