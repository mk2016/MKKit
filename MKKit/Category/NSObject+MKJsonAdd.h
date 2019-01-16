//
//  NSObject+MKJsonAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MKJsonAdd)
/** model -> jsonString */
- (NSString *)mk_jsonString;
- (NSString *)mk_jsonStringByPrettyPrint:(BOOL)pretty;

/** model -> jsonData */
- (NSData *)mk_jsonData;
- (NSData *)mk_jsonDataByPrettyPrint:(BOOL)pretty;
@end

@interface NSDictionary (MKJsonAdd)
/** id -> dictionary */
+ (NSDictionary *)mk_dictionaryWithJson:(id)json;

@end
