//
//  MKDeviceUtils.h
//  MKKit
//
//  Created by xiaomk on 2016/5/15.
//  Copyright © 2016 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface MKDeviceUtils : NSObject

#pragma mark - ***** UUID ******
+ (NSString *)getUUID;

#pragma mark - ***** app info ******
+ (NSString *)appBundleIdentifier;
+ (NSString *)appBundleShortVersion;
+ (NSString *)appBundleVersion;
+ (NSString *)appName;
+ (int)appBundleIntVersion;

#pragma mark - ***** device info ******
+ (float)systemVersion;
+ (NSString *)systemVersionString;

+ (BOOL)isiOS7Later;
+ (BOOL)isiOS8Later;
+ (BOOL)isiOS9Later;
+ (BOOL)isiOS10Later;
+ (BOOL)isiOS11Later;

+ (NSString *)devicePlatform;
+ (NSString *)deviceType;
+ (BOOL)isSimulator;
+ (NSString *)deviceName;
/** get the phone model: iPhone, iPad, iPod ... */
+ (NSString *)deviceModel;

+ (float)screenBrightness;
+ (float)batteryLevel;
/** is on charging ? */
+ (BOOL)charging;
@end
