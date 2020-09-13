//
//  UIBarButtonItem+MKAdd.m
//  Fanmugua
//
//  Created by xiaomk on 2020/9/13.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "UIBarButtonItem+MKAdd.h"

@implementation UIBarButtonItem (MKAdd)

+ (UIBarButtonItem *)mk_itemWithTitle:(NSString *)title font:(UIFont *)font color:(UIColor *)color target:(id)target action:(SEL)action{
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithTitle:title style:UIBarButtonItemStylePlain target:target action:action];
    item.tintColor = color;
    [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName,nil]
                        forState:UIControlStateNormal];
    return item;
}

+ (UIBarButtonItem *)mk_itemWithImageNamed:(NSString *)imgName target:(id)target action:(SEL)action{
    UIImage *img = [[UIImage imageNamed:imgName] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithImage:img
                                                             style:UIBarButtonItemStylePlain
                                                            target:target
                                                            action:action];
    return item;
}
@end
