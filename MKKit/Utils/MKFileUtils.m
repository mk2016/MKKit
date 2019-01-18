//
//  MKFileUtils.m
//  MKKit
//
//  Created by xmk on 16/10/14.
//  Copyright © 2016年 mk. All rights reserved.
//

#import "MKFileUtils.h"

#ifndef ELog
    #ifdef DEBUG
    #   define ELog(fmt, ...)   NSLog((@"[Elog] " fmt), ##__VA_ARGS__);
    #else
    #   define ELog(...);
    #endif
#endif

#ifndef MK_FILEMANAGER
    #define MK_FILEMANAGER      [NSFileManager defaultManager]
#endif


@implementation MKFileUtils

#pragma mark - ***** read & write content ******
/** write */
+ (BOOL)writeString:(NSString *)string toFile:(NSString *)file{
    return [string writeToFile:file
                    atomically:YES
                      encoding:NSUTF8StringEncoding
                         error:nil];
}

/** read */
+ (NSString *)stringWithFile:(NSString *)file{
    if ([MK_FILEMANAGER fileExistsAtPath:file]) {
        return [NSString stringWithContentsOfFile:file
                                         encoding:NSUTF8StringEncoding
                                            error:nil];
    }
    return nil;
}

#pragma mark - ***** archiver ******
/** archiver object to file */
+ (BOOL)archiveObject:(id)obj toFile:(NSString *)file{
    return [NSKeyedArchiver archiveRootObject:obj toFile:file];
}

/** unarchiver object with file */
+ (id)unarchiverObjectWithFile:(NSString *)file{
    if ([MK_FILEMANAGER fileExistsAtPath:file]) {
        return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
    }
    return nil;
}

/** unarchiver clazz with file */
+ (id)unarchiverClass:(Class)clazz withFile:(NSString *)file{
    if ([MK_FILEMANAGER fileExistsAtPath:file]) {
        if ([[NSKeyedUnarchiver unarchiveObjectWithFile:file] isKindOfClass:clazz]) {
            return [NSKeyedUnarchiver unarchiveObjectWithFile:file];
        }
    }
    return nil;
}

#pragma mark - ***** operate file  ******
/** get file attriutes */
+ (NSDictionary *)fileAttriutesAtPath:(NSString *)path{
    return [MK_FILEMANAGER attributesOfItemAtPath:path error:nil];
}

/** home path */
+ (NSString *)homePath{
    return NSHomeDirectory();
}

/** documents path */
+ (NSString *)documentPath{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/** Cache path */
+ (NSString *)cachePath{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
}

/** Temp path */
+ (NSString *)tempPath{
    return NSTemporaryDirectory();
}

/** is dir */
+ (BOOL)isDirAtPath:(NSString *)path{
    BOOL isDir;
    return ([MK_FILEMANAGER fileExistsAtPath:path isDirectory:&isDir] && isDir);
}

/** file exists at path */
+ (BOOL)fileExistsAtPath:(NSString *)path{
    return [MK_FILEMANAGER fileExistsAtPath:path];
}

/** create dir */
+ (BOOL)createDirAtPath:(NSString *)path{
    if ([self isDirAtPath:path]) {
        return YES;
    }
    BOOL res = [MK_FILEMANAGER createDirectoryAtPath:path
                         withIntermediateDirectories:YES
                                          attributes:nil
                                               error:nil];
    ELog(@"MKFileUtils : create dir : '%@' - %@", path, res?@"success":@"fail");
    return res;
}

/** create file */
+ (BOOL)createFileAtPath:(NSString *)path{
    BOOL res = [MK_FILEMANAGER createFileAtPath:path contents:nil attributes:nil];
    ELog(@"MKFileUtils : create file : '%@' - %@", path, res?@"success":@"fail");
    return res;
}

/** delete file */
+ (BOOL)removeAtPath:(NSString *)path{
    if ([MK_FILEMANAGER fileExistsAtPath:path]) {
        BOOL res = [MK_FILEMANAGER removeItemAtPath:path error:nil];
        ELog(@"MKFileUtils : delete file : '%@' - %@", path, res?@"success":@"fail");
        return res;
    }else{
        ELog(@"MKFileUtils : delete file : '%@' - file nonexistent", path);
        return YES;
    }
}

+ (BOOL)moveItemAtPath:(NSString *)path1 toPath:(NSString *)path2 force:(BOOL)force{
    if ([self fileExistsAtPath:path1]) {
        if (force && [MKFileUtils fileExistsAtPath:path2]) {
            [MKFileUtils removeAtPath:path2];
        }
        BOOL res = [MK_FILEMANAGER moveItemAtPath:path1 toPath:path2 error:nil];
        ELog(@"MKFileUtils : move file : '%@' - %@", path2, res?@"success":@"fail");
        return res;
    }else{
        ELog(@"MKFileUtils : move file : '%@' - source file nonexistent", path1);
        return NO;
    }
}

+ (BOOL)copyItemAtPath:(NSString *)path1 toPath:(NSString *)path2 force:(BOOL)force{
    if ([self fileExistsAtPath:path1]) {
        if (force && [MKFileUtils fileExistsAtPath:path2]) {
            [MKFileUtils removeAtPath:path2];
        }
        BOOL res = [MK_FILEMANAGER copyItemAtPath:path1 toPath:path2 error:nil];
        ELog(@"MKFileUtils : copy file : '%@' - %@", path2, res?@"success":@"fail");
        return res;
    }else{
        ELog(@"MKFileUtils : copy file : '%@' - source file nonexistent", path1);
        return NO;
    }
}

+ (float)sizeAtPath:(NSString *)path{
    BOOL isDir = YES;
    if (![MK_FILEMANAGER fileExistsAtPath:path isDirectory:&isDir]) {
        return 0;
    }
    unsigned long long fileSize = 0;
    if (isDir) {
        NSDirectoryEnumerator *enumerator = [MK_FILEMANAGER enumeratorAtPath:path];
        while (enumerator.nextObject) {
            fileSize += enumerator.fileAttributes.fileSize;
        }
    }else{
        fileSize = [MK_FILEMANAGER attributesOfItemAtPath:path error:nil].fileSize;
    }
    return fileSize/1024.0/1024.0;;
}
@end
