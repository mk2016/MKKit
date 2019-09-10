//
//  AVCaptureDevice+MKAdd.h
//  STIMProject
//
//  Created by xiaomk on 2019/7/12.
//  Copyright © 2019 mk. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface AVCaptureDevice (MKAdd)
/**
 * set torch
 */
- (void)mk_setTorch:(BOOL)torch;
 
/**
 * focus at point
 */
+ (void)mk_focusAtPoint:(CGPoint)point;


@end

NS_ASSUME_NONNULL_END
