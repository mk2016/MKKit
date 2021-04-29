//
//  UIViewController+MKAdd.h
//  MKKit
//
//  Created by MK on 2021/4/30.
//  Copyright © 2021 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIViewController (MKAdd)
+ (id)mk_createWithStoryboard:(NSString *)storyboard identify:(NSString *)identify;
@end

NS_ASSUME_NONNULL_END
