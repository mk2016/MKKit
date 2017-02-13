//
//  UINavigationController+MKAdd.h
//  MKKit
//
//  Created by xmk on 2017/2/10.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (MKAdd)

/** pop 到制定界面 */
- (BOOL)popToViewControllerWitnName:(NSString *)vcName animated:(BOOL)animated;

/** 设置底部黑线 隐藏 */
- (void)setBottomLineHidden:(BOOL)hidden;

/** 自定义底部 线条 */
- (void)setCustomNavigationBarBottomLineWithImageName:(NSString *)imageName hidden:(BOOL)hidden;

/** 设置不透明的颜色背景图 */
- (void)setBackgroundOpacityColor:(UIColor *)color;

@end
