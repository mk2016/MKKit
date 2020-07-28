//
//  MKFileUtils.h
//  MKKit
//
//  Created by xiaomk on 2016/10/14.
//  Copyright © 2016 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MKFileUtils : NSObject

#pragma mark - ***** read & write content ******
+ (BOOL)writeString:(NSString *)string toFile:(NSString *)file;
+ (NSString *)stringWithFile:(NSString *)file;

#pragma mark - ***** archiver ******
+ (BOOL)archiveObject:(id)obj toFile:(NSString *)file;
+ (id)unarchiverObjectWithFile:(NSString *)file;
+ (id)unarchiverClass:(Class)clazz withFile:(NSString *)file;

#pragma mark - ***** operate file  ******
/** get file attriutes */
+ (NSDictionary *)fileAttriutesAtPath:(NSString *)path;

+ (NSString *)homePath;
+ (NSString *)documentPath;
+ (NSString *)cachePath;
+ (NSString *)tempPath;

+ (BOOL)isDirAtPath:(NSString *)path;
+ (BOOL)fileExistsAtPath:(NSString *)path;
+ (BOOL)createDirAtPath:(NSString *)path;
+ (BOOL)createFileAtPath:(NSString *)path;

+ (BOOL)removeAtPath:(NSString *)path;
+ (BOOL)moveItemAtPath:(NSString *)path1 toPath:(NSString *)path2 force:(BOOL)force;
+ (BOOL)copyItemAtPath:(NSString *)path1 toPath:(NSString *)path2 force:(BOOL)force;

/** return size(MB) at path */
+ (float)sizeAtPath:(NSString *)path;

@end
