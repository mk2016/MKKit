//
//  MKNavigationController.h
//  MKKit
//
//  Created by xiaomk on 2016/9/29.
//  Copyright © 2016 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKNavigationController : UINavigationController<UIGestureRecognizerDelegate,UINavigationControllerDelegate>
@property (nonatomic, assign) NSInteger tabbarIndex;
- (void)setCustomNavigationBarLineHidden:(BOOL)hidden;

@end
