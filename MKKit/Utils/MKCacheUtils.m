//
//  MKCacheUtils.m
//  MKKit
//
//  Created by xiaomk on 2020/3/16.
//  Copyright © 2020 mk. All rights reserved.
//

#import "MKCacheUtils.h"
#import "MKFileUtils.h"

static const NSString * kMKCacheFilePlistSuffix = @"_mk.plist";

@implementation MKCacheUtils

#pragma mark - NSKeyedUnarchiver 归档
+ (void)saveByKeyedArchiverWith:(id)data fileName:(NSString *)fileName canClear:(BOOL)canClear{
    NSString *filePath = [self getFullPathByFileName:fileName isPlist:NO canClear:canClear];
    [MKFileUtils archiveObject:data toFile:filePath];
}

+ (id)getByKeyedUnarchiver:(NSString *)fileName withClass:(Class)clazz canClear:(BOOL)canClear{
    NSString *filePath = [self getFullPathByFileName:fileName isPlist:NO canClear:canClear];
    return [MKFileUtils unarchiverClass:clazz withFile:filePath];
}

+ (NSString *)getFullPathByFileName:(NSString *)fileName isPlist:(BOOL)isPlist canClear:(BOOL)canClear{
    NSString *mainPath = [MKFileUtils documentPath];
    NSString *folderPath;
    if (canClear) {
        folderPath = [mainPath stringByAppendingPathComponent:@"appData"];  //清理
    }else{
        folderPath = [mainPath stringByAppendingPathComponent:@"userData"]; //不清理
    }
    [MKFileUtils createDirAtPath:folderPath];
    
    NSString *filePath;
    if (isPlist) {
        filePath = [folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@%@",fileName,kMKCacheFilePlistSuffix]];
    }else{
        filePath = [folderPath stringByAppendingPathComponent:fileName];
    }
    return filePath;
}

+ (NSString *)getCanClearPath{
    NSString *path = [[MKFileUtils documentPath] stringByAppendingPathComponent:@"appData"];
    return path;
}
@end
