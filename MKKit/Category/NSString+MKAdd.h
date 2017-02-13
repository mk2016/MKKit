//
//  NSString+MKAdd.h
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MKAdd)



/** 获取字符串的size */
- (CGSize)mk_contentSizeWithFont:(UIFont *)font width:(CGFloat)width;

#pragma mark - ***** URL Encode Decode *****
/** 对字符串进行URLEncode */
- (NSString *)mk_stringByURLEncode;

/** 对字符串进行URLDecode */
- (NSString *)mk_stringByURLDecode;

#pragma mark - ***** String format verify *****
/** 是否包含汉字 */
- (BOOL)isIncludeChinese;
/** 是否全部为汉字 */
- (BOOL)isChineseString;
/** 单个字是否为汉字 */
- (BOOL)isChinese:(unichar)word;
/** 邮箱格式检查 */
- (BOOL)isValidEmail;
/** 简单的身份证格式检查 */
- (BOOL)isValidIdentityCard;

@end
