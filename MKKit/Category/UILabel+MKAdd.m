//
//  UILabel+MKAdd.m
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "UILabel+MKAdd.h"

@implementation UILabel (MKAdd)

- (CGSize)mk_contentSizeWithWidth:(CGFloat)width{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                          options:NSStringDrawingUsesLineFragmentOrigin
                                       attributes:@{NSFontAttributeName: self.font}
                                          context:nil].size;
    
    return size;
}

@end
