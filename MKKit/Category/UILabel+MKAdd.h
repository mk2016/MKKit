//
//  UILabel+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2016/5/19.
//  Copyright © 2016 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface UILabel(MKAdd)

- (CGSize)mk_contentSizeWithWidth:(CGFloat)width;

/**
 *  改变行间距
 */
- (void)mk_setLineSpace:(float)space;

/**
 *  改变字间距
 */
- (void)mk_setWordSpace:(float)space;

/**
 *  改变行间距和字间距
 */
- (void)mk_setLineSpace:(float)lineSpace wordSpace:(float)wordSpace;
@end
