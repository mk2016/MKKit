//
//  NSObject+MKPropertyAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSObject+MKPropertyAdd.h"
#import <objc/runtime.h>

static const int kMKPropertyKey;
static const int kMKTagObjKey;

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
    objc_setAssociatedObject(self, &kMKTagObjKey, aTagObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)mk_tagObj{
    return objc_getAssociatedObject(self, &kMKTagObjKey);
}

#pragma mark - ***** lazy *****
- (NSMutableDictionary *)_allProperties{
    NSMutableDictionary *allPropertiesDic = objc_getAssociatedObject(self, &kMKPropertyKey);
    
    if (!allPropertiesDic) {
        allPropertiesDic = [NSMutableDictionary new];
        objc_setAssociatedObject(self, &kMKPropertyKey, allPropertiesDic, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    return allPropertiesDic;
}

@end
