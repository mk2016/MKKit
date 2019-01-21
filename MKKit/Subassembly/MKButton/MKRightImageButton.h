//
//  MKRightImageButton.h
//  MKKit
//
//  Created by xiaomk on 15/9/15.
//  Copyright (c) 2015年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MKRightImageButton : UIButton
@property (nonatomic, assign) CGFloat space;
@property (nonatomic, assign, getter=isResetButtonSize) BOOL resetButtonSize;
@end
