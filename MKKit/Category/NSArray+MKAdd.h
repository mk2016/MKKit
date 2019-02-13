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
- (NSArray *)mk_getNoRepeatSortLettersWithKey:(NSString *)letterKey;
@end

NS_ASSUME_NONNULL_END
