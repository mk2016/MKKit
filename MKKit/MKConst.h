//
//  MKConst.h
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <pthread.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

#ifndef MKKitMacro
#define MKKitMacro

/** LOG */
#ifdef DEBUG
#   define DLog(...) NSLog(@"%s, %d, %@", __func__, __LINE__, [NSString stringWithFormat:__VA_ARGS__]);
#   define ELog(fmt, ...) NSLog((@"[Elog] " fmt), ##__VA_ARGS__);
#   define MK_DEBUG_STATUS YES
#else
#   define DLog(...);
#   define ELog(...);
#   define MK_DEBUG_STATUS NO
#endif

/** Assert */
#define MK_ASSERT_NIL(condition, description, ...)  NSAssert(!(condition), (description), ##__VA_ARGS__);
#define MK_CASSERT_NIL(condition, description, ...) NSCAssert(!(condition), (description), ##__VA_ARGS__);

#define MK_ASSERT_NOT_NIL(condition, description, ...)  NSAssert((condition), (description), ##__VA_ARGS__);
#define MK_CASSERT_NOT_NIL(condition, description, ...) NSCAssert((condition), (description), ##__VA_ARGS__);

#define MK_ASSERT_MAIN_THREAD()     NSAssert([NSThread isMainThread], @"This method must be called on the main thread");
#define MK_CASSERT_MAIN_THREAD()    NSCAssert([NSThread isMainThread], @"This method must be called on the main thread");


#define MK_APPLICATION      [UIApplication sharedApplication]
#define MK_NOTIFICATION     [NSNotificationCenter defaultCenter]
#define MK_USERDEFAULTS     [NSUserDefaults standardUserDefaults]
#define MK_FILEMANAGER      [NSFileManager defaultManager]

/** screen */
#define MK_SCREEN_WIDTH     [UIScreen mainScreen].bounds.size.width
#define MK_SCREEN_HEIGHT    [UIScreen mainScreen].bounds.size.height
#define MK_SCREEN_SIZE      [UIScreen mainScreen].bounds.size
#define MK_SCREEN_BOUNDS    [UIScreen mainScreen].bounds
#define MK_SCREEN_CENTER    CGPointMake(MK_SCREEN_WIDTH/2, MK_SCREEN_HEIGHT/2);

/** device */
#define MK_IS_IPHONE        (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define MK_IS_PAD           (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define MK_IS_IPHONE_X_XS   ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_XSMAX  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(1242, 2688), [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_XR     ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
CGSizeEqualToSize(CGSizeMake(828, 1792), [[UIScreen mainScreen] currentMode].size) : NO)
#define MK_IS_IPHONE_XX     MK_IS_IPHONE_X_XS || MK_IS_IPHONE_XSMAX || MK_IS_IPHONE_XR

#define MK_IS_IPHONE_5      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
                            CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) || \
                            CGSizeEqualToSize(CGSizeMake(1136, 640), [[UIScreen mainScreen] currentMode].size) : NO)

#define MK_IS_IPHONE_6      ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
                            CGSizeEqualToSize(CGSizeMake(750, 1334),  [[UIScreen mainScreen] currentMode].size) || \
                            CGSizeEqualToSize(CGSizeMake(1334, 750),  [[UIScreen mainScreen] currentMode].size) : NO)

#define MK_IS_IPHONE_6Plus  ([UIScreen instancesRespondToSelector:@selector(currentMode)] ?\
                            CGSizeEqualToSize(CGSizeMeke(1242, 2208), [[UIScreen mainScreen] currentMode].size) || \
                            CGSizeEqualToSize(CGSizeMeke(2208, 1242), [[UIScreen mainScreen] currentMode].size) : NO)

#define MK_STATUS_BAR_HEIGHT            (MK_IS_IPHONE_XX ? 44 : 20)
#define MK_NAVGATION_BAR_HEIGHT         44
#define MK_NAVGATION_VIEW_HEIGHT        (MK_IS_IPHONE_XX ? 88 : 64)
#define MK_TOP_DIFF_HEIGHT              (MK_IS_IPHONE_XX ? 24 : 0)
#define MK_TABBAR_HEIGHT                (MK_IS_IPHONE_XX ? 49+34 : 49)

#define MK_SCREEN_SAVE_TOP_HEIGHT       (MK_IS_IPHONE_XX ? 44 : 0)
#define MK_SCREEN_SAVE_BOTTOM_HEIGHT    (MK_IS_IPHONE_XX ? 34 : 0)

#define MK_SCREEN_SAFE_HEIGHT           (MK_SCREEN_HEIGHT - MK_SCREEN_SAVE_TOP_HEIGHT - MK_SCREEN_SAVE_BOTTOM_HEIGHT)
#define MK_SCREEN_MAIN_HEIGHT           (MK_SCREEN_HEIGHT - MK_NAVGATION_VIEW_HEIGHT - MK_SCREEN_SAVE_BOTTOM_HEIGHT)



//#define MK_SCREEN_SAFE_FRAME            CGRectMake(0, MK_SCREEN_IPHONEX_NAVGATION, MK_SCREEN_WIDTH, MK_SCREEN_MAIN_HEIGHT)

#define MK_ONE_PIXEL_HEIGHT             (1.f/[UIScreen mainScreen].scale)

#ifndef MK_iOS_IS_ABOVE
    #define MK_iOS_IS_ABOVE(s) [[[UIDevice currentDevice] systemVersion] floatValue] >= s
#endif

#ifndef MK_IS_SIMULATOR
    #if TARGET_OS_SIMULATOR
        #define MK_IS_SIMULATOR YES
    #else
        #define MK_IS_SIMULATOR NO
    #endif
#endif

/** color */
#define MK_COLOR_RGB(r, g, b)        [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:1]
#define MK_COLOR_RGBA(r, g, b, a)    [UIColor colorWithRed:(r/255.0f) green:(g/255.0f) blue:(b/255.0f) alpha:(a)]
#define MK_COLOR_HEX(rgbValue)       [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
                                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0f \
                                                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0f]
#define MK_COLOR_HEXA(rgbValue, a)   [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0f \
                                                            green:((float)((rgbValue & 0xFF00) >> 8))/255.0f \
                                                            blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]
/** Font */
#define MK_FONT_SYS(a)          [UIFont systemFontOfSize:a]
#define MK_FONT_BOLD(a)         [UIFont boldSystemFontOfSize:a]

#define MK_FONT_PFSC_Regular(a) MK_iOS_IS_ABOVE(9.0) ? [UIFont fontWithName:@"PingFangSC-Regular" size:a]:[UIFont systemFontOfSize:a]
#define MK_FONT_PFSC_Light(a)   MK_iOS_IS_ABOVE(9.0) ? [UIFont fontWithName:@"PingFangSC-Light" size:a]:[UIFont systemFontOfSize:a]
#define MK_FONT_PFSC_Medium(a)  MK_iOS_IS_ABOVE(9.0) ? [UIFont fontWithName:@"PingFangSC-Medium" size:a]:[UIFont boldSystemFontOfSize:a]

/** singleton */
#define MK_INSTANCETYPE + (instancetype)sharedInstance;

#define MK_IMPL_SHAREDINSTANCE(type)\
static type *sharedInstance = nil;\
+ (instancetype)sharedInstance {\
    static dispatch_once_t once;\
    dispatch_once(&once, ^{\
        sharedInstance = [[self alloc] init];\
    });\
    return sharedInstance;\
}\
+ (instancetype)allocWithZone:(struct _NSZone *)zone{\
    static dispatch_once_t once;\
    dispatch_once(&once, ^{\
        sharedInstance = [super allocWithZone:zone];\
    });\
    return sharedInstance;\
}

/** thread */
static inline void mk_dispatch_async_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_async(dispatch_get_main_queue(), block);
    }
}

static inline void mk_dispatch_sync_on_main_queue(void (^block)(void)) {
    if (pthread_main_np()) {
        block();
    } else {
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

/** reference */
#define MK_WEAK_SELF          __weak typeof(self) weakSelf = self;
#define MK_WEAK_IFY(var)      __weak typeof(var) weak_##var = var;
#define MK_STRONG_SELF        __strong typeof(weakSelf) strongSelf = weakSelf;
#define MK_STRONG_IFY(var)    __strong typeof(var) strong_##var = var;

/** block */
#define MK_BLOCK_EXEC(block, ...) if (block) { block(__VA_ARGS__); };

typedef void (^MKBlock)(id result);
typedef void (^MKVoidBlock)(void);
typedef void (^MKBoolBlock)(BOOL bRet);
typedef void (^MKStringBlock)(NSString *text);
typedef void (^MKIntegerBlock)(NSInteger index);
typedef void (^MKFloatBlock)(CGFloat value);
typedef void (^MKArrayBlock)(NSArray *array);


/** adjust table separator ,after ios8 */
#define MK_ADJUST_TABLEVIEW_SEPARATOR \
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{\
    if ([tableView respondsToSelector:@selector(setSeparatorInset:)]) {\
        [tableView setSeparatorInset:UIEdgeInsetsZero];\
    }\
    if ([tableView respondsToSelector:@selector(setLayoutMargins:)]) {\
        [tableView setLayoutMargins:UIEdgeInsetsZero];\
    }\
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {\
        [cell setLayoutMargins:UIEdgeInsetsZero];\
    }\
}

#define  MK_ADJUSTS_SCROLLVIEW_INSETS_TO_NO(scrollView,vc)\
do { \
    _Pragma("clang diagnostic push") \
    _Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
    if ([scrollView respondsToSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:")]) {\
        [scrollView performSelector:NSSelectorFromString(@"setContentInsetAdjustmentBehavior:") withObject:@(2)];\
    } else {\
        vc.automaticallyAdjustsScrollViewInsets = NO;\
    }\
    _Pragma("clang diagnostic pop") \
} while (0)

#endif


#pragma mark - ***** ENUM *****
/** tableView pull refresh type */
typedef enum {
    MKScrollerViewRefreshTypeNone      = 0,            /*!< None */
    MKScrollerViewRefreshTypeHeader    = 1 << 1,       /*!< header */
    MKScrollerViewRefreshTypeFooter    = 1 << 2,       /*!< footer */
    MKScrollerViewRefreshTypeAll       = ~0UL
}MKScrollerViewRefreshType;

typedef NS_ENUM(NSInteger, MKVCState) {
    MKVCStateNoData     =  1,   /*!< 无数据 */
    MKVCStateNoNetwork,         /*!< 无网络 */
    MKVCStateNoNextPage,        /*!< 有数据无下一页 */
    MKVCStateHaveNextPage,      /*!< 有数据有下一页 */
};

/** inline function */
static inline NSUInteger hexStringToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

