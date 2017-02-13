//
//  NSString+MKAdd.m
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "NSString+MKAdd.h"

@implementation NSString (MKAdd)


/** 获取字符串的size */
- (CGSize)mk_contentSizeWithFont:(UIFont *)font width:(CGFloat)width{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName: font}
                                     context:nil].size;
    return size;
}


/** 对字符串进行URLEncode */
- (NSString *)mk_stringByURLEncode{
    NSString *encodedString = (NSString *)
    CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                              (CFStringRef)self,
                                                              NULL,
                                                              (CFStringRef)@"!$&'()*+,-./:;=?@_~%#[]",
                                                              kCFStringEncodingUTF8));
    return encodedString;
}

/** 对字符串进行URLDecode */
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

#pragma mark - ***** String format verify *****
/** 是否包含汉字 */
- (BOOL)isIncludeChinese{
    for(int i = 0; i < [self length]; i++){
        unichar a = [self characterAtIndex:i];
        if ([self isChinese:a]) {
            return YES;
        }
    }
    return NO;
}
/** 是否全部为汉字 */
- (BOOL)isChineseString{
    for (int i = 0; i < [self length]; i++) {
        unichar a = [self characterAtIndex:i];
        if (![self isChinese:a]) {
            return NO;
        }
    }
    return YES;
}
/** 单个字是否为汉字 */
- (BOOL)isChinese:(unichar)word{
    if( word >= 0x4e00 && word <= 0x9fff){
        return YES;
    }
    return NO;
}
/** 邮箱格式检查 */
- (BOOL)isValidEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}
/** 简单的身份证格式检查 */
- (BOOL)isValidIdentityCard{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex = @"(\\d{15}$)|(\\d{17}([0-9]|[xX])$)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:self];
}

@end
