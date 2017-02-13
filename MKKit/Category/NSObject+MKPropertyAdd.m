//
//  NSObject+MKPropertyAdd.m
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "NSObject+MKPropertyAdd.h"
#import <objc/runtime.h>

static const int mk_property_key;
static const int mk_tagObj_key;

@implementation NSObject (MKPropertyAdd)

- (void)mk_bindPropertyWithKey:(NSString *)aKey value:(id)aValue{
    if (!aKey || !aKey.length || !aValue) {
        return;
    }
    NSMutableDictionary *dic = [self _allProperties];
    [dic setValue:aValue forKey:aKey];
}

- (id)mk_propertyValueForKey:(NSString *)aKey{
    if (!aKey || !aKey.length) {
        return nil;
    }
    NSMutableDictionary *dic = [self _allProperties];
    return [dic valueForKey:aKey];
}

- (void)mk_removePropertyWithKey:(NSString *)aKey{
    if (!aKey || !aKey.length) {
        return;
    }
    NSMutableDictionary *dic = [self _allProperties];
    [dic removeObjectForKey:aKey];
}

- (void)mk_removeAllBindProperty{
    NSMutableDictionary *dic = [self _allProperties];
    [dic removeAllObjects];
}

- (void)mk_setTagObj:(id)aTagObj{
    if (!aTagObj) {
        return;
    }
    objc_setAssociatedObject(self, &mk_tagObj_key, aTagObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)mk_tagObj{
    return objc_getAssociatedObject(self, &mk_tagObj_key);
}

#pragma mark - ***** lazy *****
- (NSMutableDictionary *)_allProperties{
    NSMutableDictionary *allPropertiesDic = objc_getAssociatedObject(self, &mk_property_key);
    
    if (!allPropertiesDic) {
        allPropertiesDic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &mk_property_key, allPropertiesDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return allPropertiesDic;
}
@end
