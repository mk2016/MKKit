//
//  UILabel+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2016/5/19.
//  Copyright © 2016 mk. All rights reserved.
//

#import "UILabel+MKAdd.h"

@implementation UILabel(MKAdd)

- (CGSize)mk_contentSizeWithWidth:(CGFloat)width{
    CGSize size = [self.text boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin
//                                                    | NSStringDrawingTruncatesLastVisibleLine
//                                                    | NSStringDrawingUsesFontLeading
                                          attributes:@{NSFontAttributeName: self.font}
                                             context:nil].size;
    
    return size;
}
@end
