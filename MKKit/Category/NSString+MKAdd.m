//
//  NSString+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSString+MKAdd.h"
#import "NSDictionary+MKAdd.h"

@implementation NSString (MKAdd)

/** get string content size */
- (CGSize)mk_contentSizeWithFont:(UIFont *)font width:(CGFloat)width{
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin
                                  attributes:@{NSFontAttributeName : font}
                                     context:nil].size;
    return size;
}

- (CGSize)mk_contentSizeWithFont:(UIFont *)font width:(CGFloat)width lineSpacing:(CGFloat)lineSpacing{
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = lineSpacing;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    NSDictionary *attributes = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paragraphStyle};
    CGSize size = [self boundingRectWithSize:CGSizeMake(width, MAXFLOAT)
                                     options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingTruncatesLastVisibleLine
                                  attributes:attributes
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

#pragma mark - ***** chinese string ******
/** is chinese word */
- (BOOL)mk_isChinese:(unichar)word{
    if( word >= 0x4e00 && word <= 0x9fff){
        return YES;
    }
    return NO;
}

/** check the string is include chinese word */
- (BOOL)mk_isIncludeChinese{
    for(int i = 0; i < [self length]; i++){
        unichar a = [self characterAtIndex:i];
        if ([self mk_isChinese:a]) {
            return YES;
        }
    }
    return NO;
}

/** Check the string is all in Chinese */
- (BOOL)mk_isChineseString{
    for (int i = 0; i < [self length]; i++) {
        unichar a = [self characterAtIndex:i];
        if (![self mk_isChinese:a]) {
            return NO;
        }
    }
    return YES;
}

/** validate email format */
- (BOOL)mk_validateEmail{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/** validate id card format */
- (BOOL)mk_validateIdentityCard{
    if (!self || self.length <= 0) {
        return NO;
    }
    //    NSString *regex = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSString *regex = @"(\\d{15}$)|(\\d{17}([0-9]|[xX])$)";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    return [identityCardPredicate evaluateWithObject:self];
}

#pragma mark - ***** chinese to pinyin ******
/** get pinyin from chinese first word */
- (NSString *)mk_chineseNameFirstLetter{
    NSString *str = [self mk_chineseNameToPinyin];
    if (str && str.length > 0) {
        str = [str substringToIndex:1];
    }
    return str;
}

/** chinese name -> pinyin */
- (NSString *)mk_chineseNameToPinyin{
    return [self mk_hanziToPinyinIsChineseName:YES];
}

/** chinese -> pinyin */
- (NSString *)mk_hanziToPinyinIsChineseName:(BOOL)isName{
    if (self.length == 0) {
        return self;
    }
    NSMutableString *ms = [[NSMutableString alloc] initWithString:self];
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformMandarinLatin, NO);     //转拼音
    CFStringTransform((__bridge CFMutableStringRef)ms, 0, kCFStringTransformStripDiacritics, NO);   //去声调
    if (isName) {   //如果是名字，处理姓氏多音字
        if ([[(NSString *)self substringToIndex:1] compare:@"长"] == NSOrderedSame) {
            [ms replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chang"];
        }
        if ([[(NSString *)self substringToIndex:1] compare:@"沈"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 4)withString:@"shen"];
        }
        if ([[(NSString *)self substringToIndex:1] compare:@"厦"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 3)withString:@"xia"];
        }
        if ([[(NSString *)self substringToIndex:1] compare:@"地"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 2)withString:@"di"];
        }
        if ([[(NSString *)self substringToIndex:1] compare:@"重"] == NSOrderedSame){
            [ms replaceCharactersInRange:NSMakeRange(0, 5) withString:@"chong"];
        }
    }
    return ms;
}

- (NSDictionary * __nullable)mk_dictionaryWithUrlQuery{
    NSURL *url = [NSURL URLWithString:self];
    if (url) {
        NSDictionary *dic = [NSDictionary mk_dictionaryWithUrlQuery:url.query];
        return dic;
    }
    return nil;
}
@end
