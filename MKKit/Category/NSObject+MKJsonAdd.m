//
//  NSString+MKJsonAdd.m
//  MKKit
//
//  Created by xmk on 2017/2/10.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "NSObject+MKJsonAdd.h"
#import "MKKitConst.h"

@implementation NSString (MKJsonAdd)


@end


@implementation NSDictionary (MKJsonAdd)
+ (NSDictionary *)mk_dictionaryWithJson:(id)json{
    if (!json || json == (id)kCFNull) return nil;
    
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSString class]]) {
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([jsonData isKindOfClass:[NSData class]]){
        jsonData = json;
    }
    
    NSDictionary *dic = nil;
    if (jsonData) {
        NSError *error;
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];
        if (error) {
            ELog(@"json 解析失败:%@", error);
            dic = nil;
        }
    }
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        return dic;
    }
    return nil;
}
@end
