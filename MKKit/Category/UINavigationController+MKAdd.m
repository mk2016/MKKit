//
//  UINavigationController+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 16/9/21.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "UINavigationController+MKAdd.h"
#import "UIImage+MKAdd.h"

@implementation UINavigationController (MKAdd)

/** pop to an appointed viewController */
- (BOOL)mk_popToViewControllerWithName:(NSString *)vcName animated:(BOOL)animated{
    Class class = NSClassFromString(vcName);
    if (class) {
        for (UIViewController *vc in self.viewControllers) {
            if ([vc isKindOfClass:class]) {
                [self popToViewController:vc animated:animated];
                return YES;
            }
        }
    }
    if (self.viewControllers.count > 0) {
        [self popViewControllerAnimated:YES];
    }
    return NO;
}

/** set navigationBar bottom line hidden */
- (void)mk_setBottomLineHidden:(BOOL)hidden{
    if ([self.navigationBar respondsToSelector:@selector(setBackgroundImage:forBarMetrics:)]) {
        NSArray *array = self.navigationBar.subviews;
        for (id obj in array) {
            if ([obj isKindOfClass:[UIView class]]) {
                UIView *viewBar = (UIView *)obj;
                NSArray *subViews = viewBar.subviews;
                for (id view in subViews) {
                    if ([view isKindOfClass:[UIImageView class]]) {
                        UIImageView *viewLine = (UIImageView*)view;
                        if (viewLine.bounds.size.height <= 1.0) {
                            viewLine.hidden = hidden;
                        }
                    }
                }
            }
        }
    }
}
/** global hidden navigationBar bottom line */
+ (void)mk_hiddenBottomLine{
    if ([UINavigationBar instancesRespondToSelector:@selector(setShadowImage:)]){
        [[UINavigationBar appearance] setShadowImage:[UIImage mk_imageWithColor:[UIColor clearColor]]];
    }
}
@end
