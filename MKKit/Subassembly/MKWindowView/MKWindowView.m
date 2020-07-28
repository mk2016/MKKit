//
//  MKWindowView.m
//  MKKit
//
//  Created by xiaomk on 2016/11/4.
//  Copyright © 2016 mk. All rights reserved.
//

#import "MKWindowView.h"
#import "UIView+MKAdd.h"

@implementation MKWindowView

+ (id)viewWithNibBlock:(MKBlock)block{
    MKWindowView *view = [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class) owner:nil options:nil].firstObject;
    view.frame = MK_SCREEN_BOUNDS;
    view.block = block;
    view.backgroundColor = MK_COLOR_RGBA(0, 0, 0, 0.3);
    [view setupUI];
    return view;
}

- (instancetype)initWithBlock:(MKBlock)block{
    if (self = [super initWithFrame:MK_SCREEN_BOUNDS]) {
        self.block = block;
        self.backgroundColor = MK_COLOR_RGBA(0, 0, 0, 0.3);
        [self setupUI];
    }
    return self;
}

- (void)setupUI{
    UIButton *btnBg = [UIButton buttonWithType:UIButtonTypeCustom];
    btnBg.frame = self.bounds;
    [btnBg addTarget:self action:@selector(hide) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btnBg];
    [self sendSubviewToBack:btnBg];
}

- (void)show{
    [self mk_showOnWindow];
}

- (void)hide{
    [self mk_removeFromWindow];
}

@end
