//
//  MKCacheUtils.h
//  GameWelfare
//
//  Created by xiaomk on 2020/3/16.
//  Copyright © 2020 outer. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKCacheUtils : NSObject
+ (void)saveByKeyedArchiverWith:(id)data fileName:(NSString *)fileName canClear:(BOOL)canClear;
+ (id)getByKeyedUnarchiver:(NSString *)fileName withClass:(Class)clazz canClear:(BOOL)canClear;
+ (NSString *)getFullPathByFileName:(NSString *)fileName isPlist:(BOOL)isPlist canClear:(BOOL)canClear;
+ (NSString *)getCanClearPath;
@end

NS_ASSUME_NONNULL_END
