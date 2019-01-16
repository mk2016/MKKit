//
//  UIView+MKLogAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKViewInfo : NSObject
@property (nonatomic, copy) NSArray *childViews;
@property (nonatomic, copy) NSString *viewClass;
@property (nonatomic, copy) NSString *viewFrame;
@property (nonatomic, assign) NSInteger viewTag;
@end

@interface UIView (MKLogAdd)
- (MKViewInfo *)mk_allSubviewsTree;
- (NSString *)mk_description;
@end
