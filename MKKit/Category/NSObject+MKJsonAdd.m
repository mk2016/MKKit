//
//  NSObject+MKJsonAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSObject+MKJsonAdd.h"
#import "MJExtension.h"
#import "MKConst.h"

@implementation NSObject (MKJsonAdd)

- (id)mk_copySelfPerfect{
    if (self) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }
    return nil;
}

/** model -> jsonString */
- (NSString *)mk_jsonString{
    return [self mk_jsonStringByPrettyPrint:YES];
}

- (NSString *)mk_jsonStringByPrettyPrint:(BOOL)pretty{
    if ([self isKindOfClass:[NSString class]]) {
        return (NSString *)self;
    }else if ([self isKindOfClass:[NSData class]]){
        return [[NSString alloc] initWithData:(NSData *)self encoding:NSUTF8StringEncoding];
    }
    return [[NSString alloc] initWithData:[self mk_jsonDataByPrettyPrint:pretty] encoding:NSUTF8StringEncoding];
}

/** model -> jsonData */
- (NSData *)mk_jsonData{
    return [self mk_jsonDataByPrettyPrint:YES];
}

- (NSData *)mk_jsonDataByPrettyPrint:(BOOL)pretty{
    if ([self isKindOfClass:[NSString class]]) {
        return [((NSString *)self) dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([self isKindOfClass:[NSData class]]){
        return (NSData *)self;
    }
    id jsonObject = [self mj_keyValues];
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:jsonObject
                                                       options:pretty ? NSJSONWritingPrettyPrinted : kNilOptions
                                                         error:&error];
    if (error) {
        ELog(@"jsonData error: %@", error.localizedDescription);
        return nil;
    }
    return jsonData;
}
@end



@implementation NSDictionary (MKJsonAdd)
/** json -> dictionary */
+ (NSDictionary *)mk_dictionaryWithJson:(id)json{
    if (!json || json == (id)kCFNull) {
        return nil;
    }
    if ([json isKindOfClass:[NSDictionary class]]) {
        return json;
    }
    
    NSData *jsonData = nil;
    if ([json isKindOfClass:[NSString class]]){
        if (((NSString *)json).length == 0){
            return nil;
        }
        jsonData = [(NSString *)json dataUsingEncoding:NSUTF8StringEncoding];
    }else if ([json isKindOfClass:[NSData class]]){
        jsonData = json;
    }
    
    NSDictionary *dic = nil;
    if (jsonData){
        NSError *error;
        dic = [NSJSONSerialization JSONObjectWithData:jsonData options:kNilOptions error:&error];   //NSJSONReadingMutableContainers
        if (error){
            dic = nil;
            ELog(@"json parsing fail : %@",error);
        }
    }
    if (dic && [dic isKindOfClass:[NSDictionary class]]){
        NSMutableDictionary *tempDic = dic.mutableCopy;
        NSArray *valueAry = [tempDic allKeys];
        for (NSString *key in valueAry) {
            if ([[tempDic objectForKey:key] isEqual:[NSNull null]]){
                [tempDic setObject:@"" forKey:key];
            }
        }
        return tempDic.copy;
    }
    return nil;
}
@end
