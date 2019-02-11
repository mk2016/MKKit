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
@end
