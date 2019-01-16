//
//  UIView+MKLogAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import "UIView+MKLogAdd.h"

@implementation MKViewInfo
+ (NSDictionary *)mj_objectClassInArray{
    return @{
             @"childViews" : @"MKViewInfo"
             };
}
@end

@implementation UIView (MKLogAdd)
+ (MKViewInfo *)mk_getSubviewsTreeWith:(UIView *)superview{
    MKViewInfo *info = [[MKViewInfo alloc] init];
    
    NSString *class = NSStringFromClass(superview.class);
    info.viewClass = class;
    info.viewFrame = NSStringFromCGRect(superview.frame);
    info.viewTag = superview.tag;
    
    if (superview.subviews && superview.subviews.count) {
        NSMutableArray *childViews = @[].mutableCopy;
        for (UIView *childView in superview.subviews) {
            MKViewInfo *subViewInfo = [self mk_getSubviewsTreeWith:childView];
            [childViews addObject:subViewInfo];
        }
        info.childViews = childViews.copy;
    }
    return info;
}

- (MKViewInfo *)mk_allSubviewsTree{
    if (self) {
        return [UIView mk_getSubviewsTreeWith:self];
    }
    return nil;
}

- (NSString *)mk_description{
//    return [self mk_allSubviewsTree] mk_json
//    return [[self mk_searchAllSubviews] mk_jsonString];
    return @"";
}

@end
