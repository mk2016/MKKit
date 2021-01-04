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

/**
 *  改变行间距
 */
- (void)mk_setLineSpace:(float)space{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:space];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

/**
 *  改变字间距
 */
- (void)mk_setWordSpace:(float)space{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(space)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

/**
 *  改变行间距和字间距
 */
- (void)mk_setLineSpace:(float)lineSpace wordSpace:(float)wordSpace{
    NSString *labelText = self.text;
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:labelText attributes:@{NSKernAttributeName:@(wordSpace)}];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpace];
    [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [labelText length])];
    self.attributedText = attributedString;
    [self sizeToFit];
}

@end
