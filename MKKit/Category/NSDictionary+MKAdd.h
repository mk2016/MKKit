//
//  NSDictionary+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/2/11.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSDictionary (MKAdd)

- (BOOL)mk_containsObjectForKey:(NSString *)key;

@end

NS_ASSUME_NONNULL_END
