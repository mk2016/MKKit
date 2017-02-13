//
//  UIImage+MKAdd.m
//  MKKit
//
//  Created by xmk on 2017/2/10.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "UIImage+MKAdd.h"

@implementation UIImage (MKAdd)

/** 以color生成Image */
+ (UIImage *)mk_imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    // 开启位图上下文
    UIGraphicsBeginImageContext(rect.size);
    // 获取位图上下文
    CGContextRef context = UIGraphicsGetCurrentContext();
    // 使用color演示填充上下文
    CGContextSetFillColorWithColor(context, [color CGColor]);
    // 渲染上下文
    CGContextFillRect(context, rect);
    // 从上下文中获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 结束上下文
    UIGraphicsEndImageContext();
    return image;
}

@end
