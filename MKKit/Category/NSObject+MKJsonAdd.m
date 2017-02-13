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


@implementation NSObject(MKJsonAdd)

/** model -> jsonString */
- (NSString *)mk_jsonString{
    return [self mk_jsonStringWithPrettyPrint:YES];
}

- (NSString *)mk_jsonStringWithPrettyPrint:(BOOL)pretty{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }else if ([self isKindOfClass:[NSData class]]){
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    return [[NSString alloc] initWithData:pretty ? [self mk_jsonData] : [self mk_jsonDataWithPrettyPrint:NO] encoding:NSUTF8StringEncoding];
}


/** model -> jsonData */
- (NSData *)mk_jsonData{
    return [self mk_jsonDataWithPrettyPrint:YES];
}

- (NSData *)mk_jsonDataWithPrettyPrint:(BOOL)pretty{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([self isKindOfClass:[NSData class]]){
        return (NSData *)self;
    }
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:[self mk_jsonObject]
                                                       options:pretty ? NSJSONWritingPrettyPrinted : kNilOptions
                                                         error:&error];
    if (error) {
        ELog(@"jsonDate error: %@", error.localizedDescription);
        return nil;
    }
    return jsonData;

}

/** model -> jsonObject */
- (id)mk_jsonObject{
    if ([self isKindOfClass:[NSString class]]) {
        return [NSJSONSerialization JSONObjectWithData:[((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    } else if ([self isKindOfClass:[NSData class]]) {
        return [NSJSONSerialization JSONObjectWithData:(NSData *)self options:kNilOptions error:nil];
    }
    return [self mj_keyValues];
}
@end
