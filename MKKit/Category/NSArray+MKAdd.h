//
//  NSArray+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/2/13.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSArray (MKAdd)
- (NSArray<NSString *> * __nullable)mk_getNoRepeatSortLettersWithKey:(NSString *)letterKey;
- (NSArray<NSString *> * __nullable)mk_getNoRepeatSortLettersWithKey:(NSString *)letterKey ascending:(BOOL)ascending;
@end

NS_ASSUME_NONNULL_END
