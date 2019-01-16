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
@end
