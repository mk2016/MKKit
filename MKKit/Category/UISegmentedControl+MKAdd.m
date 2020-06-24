//
//  UISegmentedControl+MKAdd.m
//  Fanmugua
//
//  Created by xiaomk on 2020/6/24.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "UISegmentedControl+MKAdd.h"
#import "UIImage+MKAdd.h"

@implementation UISegmentedControl (MKAdd)

- (void)mk_setiOS13Style{
    [self mk_setiOS13StyleWithFont:[UIFont systemFontOfSize:12]];
}

- (void)mk_setiOS13StyleWithFont:(UIFont *)font{
    if (@available(iOS 13.0, *)){
        UIImage *tintColorImage = [UIImage mk_imageWithColor:self.tintColor];
        
        [self setBackgroundImage:[UIImage mk_imageWithColor:self.backgroundColor ? self.backgroundColor : [UIColor clearColor]]
                        forState:UIControlStateNormal
                      barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:[UIImage mk_imageWithColor:[self.tintColor colorWithAlphaComponent:0.2]]
                        forState:UIControlStateHighlighted
                      barMetrics:UIBarMetricsDefault];
        [self setBackgroundImage:tintColorImage
                        forState:UIControlStateSelected
                      barMetrics:UIBarMetricsDefault];

        [self setDividerImage:[UIImage mk_imageWithColor:[self.tintColor colorWithAlphaComponent:0.3]]
          forLeftSegmentState:UIControlStateNormal
            rightSegmentState:UIControlStateNormal
                   barMetrics:UIBarMetricsDefault];

        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:self.tintColor,NSFontAttributeName:font}
                            forState:UIControlStateNormal];
        [self setTitleTextAttributes:@{NSForegroundColorAttributeName:self.backgroundColor}
                            forState:UIControlStateSelected];
        self.layer.borderWidth = 1;
        self.layer.borderColor = self.tintColor.CGColor;
    }
}
@end
