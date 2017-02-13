//
//  UIImage+MKAdd.h
//  MKKit
//
//  Created by xmk on 2017/2/10.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MKAdd)

/** 以color生成Image */
+ (UIImage *)mk_imageWithColor:(UIColor *)color;

/** 生成二维码 */
+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr imageWidth:(CGFloat)imageWidth;

/** dataURL 转 图片 */
+ (UIImage *)mk_imageWithDataURL:(NSString *)imageSrc;

@end
