//
//  Foundation+MKLog.h
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "Foundation+MKLog.h"
#include <UIKit/UIKit.h>

@interface MKViewInfo : NSObject
@property (nonatomic, strong) NSMutableArray *childViews;
@property (nonatomic, copy) NSString *viewClass;
@property (nonatomic, copy) NSString *viewFrame;
@property (nonatomic, assign) NSInteger viewTag;
@end

@interface UIView(MKLog)
+ (MKViewInfo *)searchAllSubviews:(UIView *)superview;
- (NSString *)mk_description;
@end


