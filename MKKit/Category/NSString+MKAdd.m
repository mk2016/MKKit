//
//  NSString+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSString+MKAdd.h"

@implementation NSString (MKAdd)

/** get string content size */
- (CGSize)mk_contentSizeWithFont:(UIFont *)font width:(CGFloat)width{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil].size;
    return size;
}

#pragma mark - ***** URL Encode Decode *****

/** string URLEncode */
- (NSString *)mk_stringByURLEncode{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}


/** string URLDecode */
- (NSString *)mk_stringByURLDecode{
    if ([self respondsToSelector:@selector(stringByRemovingPercentEncoding)]) {
        return [self stringByRemovingPercentEncoding];
    } else {
        NSString *decoded = (__bridge_transfer NSString *)
        CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                (__bridge CFStringRef)self,
                                                                CFSTR(""),
                                                                CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
        return decoded;
    }
}
@end
