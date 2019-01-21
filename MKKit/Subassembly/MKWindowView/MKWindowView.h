//
//  MKWindowView.h
//  Taoqicar
//
//  Created by xmk on 2016/11/4.
//  Copyright © 2016年 taoqicar. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKConst.h"

@interface MKWindowView : UIView

@property (nonatomic, copy) MKBlock block;
+ (id)viewWithNibBlock:(MKBlock)block;
- (instancetype)initWithBlock:(MKBlock)block;

- (void)setupUI;
- (void)show;
- (void)hide;

@end
