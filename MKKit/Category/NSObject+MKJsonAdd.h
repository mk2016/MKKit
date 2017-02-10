//
//  NSString+MKJsonAdd.h
//  MKKit
//
//  Created by xmk on 2017/2/10.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (MKJsonAdd)

@end


@interface NSDictionary (MKJsonAdd)
+ (NSDictionary *)mk_dictionaryWithJson:(id)json;
@end
