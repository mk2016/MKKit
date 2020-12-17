//
//  UIBarButtonItem+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2020/9/13.
//  Copyright © 2020 taolang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIBarButtonItem (MKAdd)
+ (UIBarButtonItem *)mk_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)mk_itemWithImageNamed:(NSString *)imgName target:(id)target action:(SEL)action;
@end

NS_ASSUME_NONNULL_END
