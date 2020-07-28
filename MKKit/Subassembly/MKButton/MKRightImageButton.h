//
//  MKRightImageButton.h
//  MKKit
//
//  Created by xiaomk on 2015/9/15.
//  Copyright © 2015 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKRightImageButton : UIButton
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign, getter=isResetButtonSize) BOOL resetButtonSize;
@end
