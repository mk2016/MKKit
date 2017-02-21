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
- (UIImage *)imagesBrowser:(MKImagesBrowser *)browser placeholderImageWithIndex:(NSInteger)index;

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

@property (nonatomic, assign) MKIBPageControlAlignment pageControlAlignment;
@property (nonatomic, assign ) NSUInteger currentIndex;                 /*!< current image index */

- (void)show;
@end
