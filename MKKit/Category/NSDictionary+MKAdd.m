//
//  NSDictionary+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/2/11.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSDictionary+MKAdd.h"

@implementation NSDictionary (MKAdd)
- (BOOL)mk_containsObjectForKey:(NSString *)key{
    if (!key) return NO;
    return self[key] != nil;
}

+ (NSDictionary *)mk_dictionaryWithUrlQuery:(NSString *)query{
    NSMutableDictionary *dic = @{}.mutableCopy;
    if (query){
        NSArray *paramAry = [query componentsSeparatedByString:@"&"];
        if (paramAry.count > 0) {
            for (NSString *param in paramAry) {
                NSArray *ary = [param componentsSeparatedByString:@"="];
                if (ary.count == 2) {
                    [dic setValue:ary[1] forKey:ary[0]];
                }
            }
        }
    }
    return dic.copy;
}
@end
