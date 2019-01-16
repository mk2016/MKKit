//
//  NSString+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (MKAdd)
/** get string content size */
- (CGSize)mk_contentSizeWithFont:(UIFont *)font width:(CGFloat)width;

#pragma mark - ***** URL Encode Decode *****
/** string URLEncode */
- (NSString *)mk_stringByURLEncode;

/** string URLDecode */
- (NSString *)mk_stringByURLDecode;

#pragma mark - ***** chinese string ******
/** is chinese word */
- (BOOL)mk_isChinese:(unichar)word;

/** check the string is include chinese word */
- (BOOL)mk_isIncludeChinese;

/** Check the string is all in Chinese */
- (BOOL)mk_isChineseString;

/** validate email format */
- (BOOL)mk_validateEmail;

/** validate id card format */
- (BOOL)mk_validateIdentityCard;

#pragma mark - ***** chinese to pinyin ******
/** get pinyin from chinese first word */
- (NSString *)mk_chineseNameFirstLetter;

/** chinese name -> pinyin */
- (NSString *)mk_chineseNameToPinyin;

/** chinese -> pinyin */
- (NSString *)mk_hanziToPinyinIsChineseName:(BOOL)isName;
@end
