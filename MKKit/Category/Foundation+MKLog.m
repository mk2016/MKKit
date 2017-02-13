//
//  Foundation+MKLog.m
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "Foundation+MKLog.h"
#import "NSObject+MKJsonAdd.h"

@implementation MKViewInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"childViews" : @"MKViewInfo"
             };
}
@end

@implementation UIView (MKLog)
+ (MKViewInfo *)searchAllSubviews:(UIView *)superview{
    MKViewInfo *info = [[MKViewInfo alloc] init];
    
    NSString *class = NSStringFromClass(superview.class);
    info.viewClass = class;
    info.viewFrame = NSStringFromCGRect(superview.frame);
    info.viewTag = superview.tag;
    
    if (superview.subviews && superview.subviews.count) {
        info.childViews = @[].mutableCopy;
        for (UIView *childView in superview.subviews) {
            MKViewInfo *subViewInfo = [self searchAllSubviews:childView];
            [info.childViews addObject:subViewInfo];
        }
    }
    return info;
}

- (NSString *)mk_description{
    return [[UIView searchAllSubviews:self] mk_jsonString];
}

@end



