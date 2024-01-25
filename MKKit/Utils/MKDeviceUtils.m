//
//  MKDeviceUtils.m
//  MKKit
//
//  Created by xiaomk on 2016/5/15.
//  Copyright © 2016 mk. All rights reserved.
//

#import "MKDeviceUtils.h"
#include <sys/types.h>
#include <sys/sysctl.h>
#import <AVFoundation/AVFoundation.h>
#import <sys/utsname.h>

#import "SAMKeychain.h"

@implementation MKDeviceUtils

#pragma mark - ***** UUID ******
+ (NSString *)getUUID{
    NSString *bundleId = [[NSBundle mainBundle] bundleIdentifier];
    NSString *uuid = [SAMKeychain passwordForService:bundleId account:@"mk_user"];
    if (uuid == nil || uuid == NULL || uuid.length == 0) {
        CFUUIDRef uuidRef = CFUUIDCreate(kCFAllocatorDefault);
        CFStringRef uuidStr = CFUUIDCreateString(kCFAllocatorDefault, uuidRef);
        uuid = [NSString stringWithFormat:@"%@", uuidStr];
        [SAMKeychain setPassword:uuid forService:bundleId account:@"mk_user"];
        CFRelease(uuidRef);
        CFRelease(uuidStr);
    }
    return uuid;
}

#pragma mark - ***** app info ******
+ (NSString *)appBundleIdentifier{
    return [[NSBundle mainBundle] bundleIdentifier];
}

+ (NSString *)appBundleShortVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
}

+ (NSString *)appBundleVersion{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"];
}

+ (NSString *)appName{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (int)appBundleIntVersion{
    NSString *nowShotV = [self appBundleVersion];
    NSArray *numArray = [nowShotV componentsSeparatedByString:@"."];
    int versionInt = 0;
    if (numArray.count > 0) {
        for (NSInteger i = 0; i < numArray.count; i++) {
            NSString *numStr = numArray[i];
            versionInt = versionInt*10 + numStr.intValue;
        }
    }
    return versionInt;
}

#pragma mark - ***** device info ******
+ (float)systemVersion{
    return [[[UIDevice currentDevice] systemVersion] floatValue];
}

+ (NSString *)systemVersionString{
    return [[UIDevice currentDevice] systemVersion];
}

+ (BOOL)isiOS7Later{
    return [self systemVersion] >= 7.0;
}

+ (BOOL)isiOS8Later{
    return [self systemVersion] >= 8.0;
}

+ (BOOL)isiOS9Later{
    return [self systemVersion] >= 9.0;
}

+ (BOOL)isiOS10Later{
    return [self systemVersion] >= 10.0;
}

+ (BOOL)isiOS11Later{
//    return [self systemVersion] >= 11.0;
    if (@available(iOS 11.0, *)) {
        return YES;
    }else{
        return NO;
    }
}

+ (NSString *)devicePlatform{
    static NSString *platform;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        size_t size;
        sysctlbyname("hw.machine", NULL, &size, NULL, 0);
        char *machine = malloc(size);
        sysctlbyname("hw.machine", machine, &size, NULL, 0);
        platform = [NSString stringWithUTF8String:machine];
        free(machine);
    });
    return platform;
}

+ (NSString *)deviceType{
    NSString *platform = [self devicePlatform];
    if (!platform) return nil;
    
    static NSString *name;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSDictionary *dic = @{
                              //iPhone
                              @"iPhone1,1": @"iPhone 1G",
                              @"iPhone1,2": @"iPhone 3G",
                              @"iPhone2,1": @"iPhone 3GS",
                              @"iPhone3,1": @"iPhone 4",
                              @"iPhone3,2": @"iPhone 4",
                              @"iPhone3,3": @"iPhone 4",
                              @"iPhone4,1": @"iPhone 4S",
                              @"iPhone4,2": @"iPhone 4S",
                              @"iPhone4,3": @"iPhone 4S",
                              @"iPhone5,1": @"iPhone 5",
                              @"iPhone5,2": @"iPhone 5",
                              @"iPhone5,3": @"iPhone 5C",
                              @"iPhone5,4": @"iPhone 5C",
                              @"iPhone6,1": @"iPhone 5S",
                              @"iPhone6,2": @"iPhone 5S",
                              @"iPhone7,1": @"iPhone 6 Plus",
                              @"iPhone7,2": @"iPhone 6",
                              @"iPhone8,1": @"iPhone 6S",
                              @"iPhone8,2": @"iPhone 6S Plus",
                              @"iPhone8,3": @"iPhone SE",
                              @"iPhone8,4": @"iPhone SE 1st",
                              @"iPhone9,1": @"iPhone 7",
                              @"iPhone9,2": @"iPhone 7 Plus",
                              @"iPhone9,3": @"iPhone 7",
                              @"iPhone9,4": @"iPhone 7 Plus",
                              @"iPhone10,1": @"iPhone 8",
                              @"iPhone10,2": @"iPhone 8 Plus",
                              @"iPhone10,3": @"iPhone X",
                              @"iPhone10,4": @"iPhone 8",
                              @"iPhone10,5": @"iPhone 8 Plus",
                              @"iPhone10,6": @"iPhone X",
                              @"iPhone11,2": @"iPhone XS",
                              @"iPhone11,4": @"iPhone XS Max",
                              @"iPhone11,6": @"iPhone XS Max",
                              @"iPhone11,8": @"iPhone XR",
                              @"iPhone12,1": @"iPhone 11",
                              @"iPhone12,3": @"iPhone 11 Pro",
                              @"iPhone12,5": @"iPhone 11 Pro Max",
                              @"iPhone12,8": @"iPhone SE 2nd",
                              @"iPhone13,1": @"iPhone 12 mini",
                              @"iPhone13,2": @"iPhone 12",
                              @"iPhone13,3": @"iPhone 12 Pro",
                              @"iPhone13,4": @"iPhone 12 Pro Max",
                              @"iPhone14,2": @"iPhone 13 Pro",
                              @"iPhone14,3": @"iPhone 13 Pro Max",
                              @"iPhone14,4": @"iPhone 13 mini",
                              @"iPhone14,5": @"iPhone 13",
                              @"iPhone14,6": @"iPhone SE 3rd",
                              @"iPhone14,7": @"iPhone 14",
                              @"iPhone14,8": @"iPhone 14 Plus",
                              @"iPhone15,2": @"iPhone 14 Pro",
                              @"iPhone15,3": @"iPhone 14 Pro Max",

                              //iPad
                              @"iPad1,1": @"iPad",
                              @"iPad1,2": @"iPad 3G",
                              @"iPad2,1": @"iPad 2",
                              @"iPad2,2": @"iPad 2",
                              @"iPad2,3": @"iPad 2",
                              @"iPad2,4": @"iPad 2",
                              @"iPad2,5": @"iPad Mini",
                              @"iPad2,6": @"iPad Mini",
                              @"iPad2,7": @"iPad Mini",
                              @"iPad3,1": @"iPad 3rd",
                              @"iPad3,2": @"iPad 3rd",
                              @"iPad3,3": @"iPad 3rd",
                              @"iPad3,4": @"iPad 4th",
                              @"iPad3,5": @"iPad 4th",
                              @"iPad3,6": @"iPad 4th",
                              @"iPad4,1": @"iPad Air",
                              @"iPad4,2": @"iPad Air",
                              @"iPad4,3": @"iPad Air",
                              @"iPad4,4": @"iPad Mini 2",
                              @"iPad4,5": @"iPad Mini 2",
                              @"iPad4,6": @"iPad Mini 2",
                              @"iPad4,7": @"iPad Mini 3",
                              @"iPad4,8": @"iPad Mini 3",
                              @"iPad4,9": @"iPad Mini 3",
                              @"iPad5,1": @"iPad Mini 4",
                              @"iPad5,2": @"iPad Mini 4",
                              @"iPad5,3": @"iPad Air 2",
                              @"iPad5,4": @"iPad Air 2",
                              @"iPad6,3": @"iPad Pro (9.7-inch)",
                              @"iPad6,4": @"iPad Pro (9.7-inch)",
                              @"iPad6,7": @"iPad Pro (12.9-inch)",
                              @"iPad6,8": @"iPad Pro (12.9-inch)",
                              @"iPad6,11": @"iPad 5",
                              @"iPad6,12": @"iPad 5",
                              @"iPad7,1": @"iPad Pro 2nd (12.9-inch)",
                              @"iPad7,2": @"iPad Pro 2nd (12.9-inch)",
                              @"iPad7,3": @"iPad Pro (10.5-inch)",
                              @"iPad7,4": @"iPad Pro (10.5-inch)",
                              @"iPad7,5": @"iPad 6th",
                              @"iPad7,6": @"iPad 6th",
                              @"iPad7,11": @"iPad 7th",
                              @"iPad7,12": @"iPad 7th",
                              @"iPad8,1": @"iPad Pro (11-inch)",
                              @"iPad8,2": @"iPad Pro (11-inch)",
                              @"iPad8,3": @"iPad Pro (11-inch)",
                              @"iPad8,4": @"iPad Pro (11-inch)",
                              @"iPad8,5": @"iPad Pro 3rd (12.9-inch)",
                              @"iPad8,6": @"iPad Pro 3rd (12.9-inch)",
                              @"iPad8,7": @"iPad Pro 3rd (12.9-inch)",
                              @"iPad8,8": @"iPad Pro 3rd (12.9-inch)",
                              @"iPad8,9": @"iPad Pro 2nd (11-inch)",
                              @"iPad8,10": @"iPad Pro 2nd (11-inch)",
                              @"iPad8,11": @"iPad Pro 4th (12.9-inch)",
                              @"iPad8,12": @"iPad Pro 4th (12.9-inch)",
                              @"iPad11,1": @"iPad mini 5th",
                              @"iPad11,2": @"iPad mini 5th",
                              @"iPad11,3": @"iPad Air 3rd",
                              @"iPad11,4": @"iPad Air 3rd",
                              @"iPad11,6": @"iPad 8th",
                              @"iPad11,7": @"iPad 8th",
                              @"iPad12,1": @"iPad 9th",
                              @"iPad12,2": @"iPad 9th",
                              @"iPad13,1": @"iPad Air 4th",
                              @"iPad13,2": @"iPad Air 4th",
                              @"iPad13,4": @"iPad Pro 3rd (11-inch)",
                              @"iPad13,5": @"iPad Pro 3rd (11-inch)",
                              @"iPad13,6": @"iPad Pro 3rd (11-inch)",
                              @"iPad13,7": @"iPad Pro 3rd (11-inch)",
                              @"iPad13,8": @"iPad Pro 5th (12.9-inch)",
                              @"iPad13,9": @"iPad Pro 5th (12.9-inch)",
                              @"iPad13,10": @"iPad Pro 5th (12.9-inch)",
                              @"iPad13,11": @"iPad Pro 5th (12.9-inch)",
                              @"iPad13,16": @"iPad Air 5th",
                              @"iPad13,17": @"iPad Air 5th",
                              @"iPad13,18": @"iPad 10th",
                              @"iPad13,19": @"iPad 10th",

                              

                              //watch
                              @"Watch1,1" : @"Apple Watch 38mm",
                              @"Watch1,2" : @"Apple Watch 42mm",
                              @"Watch2,3" : @"Apple Watch Series 2 38mm",
                              @"Watch2,4" : @"Apple Watch Series 2 42mm",
                              @"Watch2,6" : @"Apple Watch Series 1 38mm",
                              @"Watch2,7" : @"Apple Watch Series 1 42mm",
                              @"Watch3,1" : @"Apple Watch Series 3 38mm case (GPS+Cellular)",
                              @"Watch3,2" : @"Apple Watch Series 3 42mm case (GPS+Cellular)",
                              @"Watch3,3" : @"Apple Watch Series 3 38mm case (GPS)",
                              @"Watch3,4" : @"Apple Watch Series 3 42mm case (GPS)",
                              @"Watch4,1" : @"Apple Watch Series 4 40mm case (GPS)",
                              @"Watch4,2" : @"Apple Watch Series 4 44mm case (GPS)",
                              @"Watch4,3" : @"Apple Watch Series 4 40mm case (GPS+Cellular)",
                              @"Watch4,4" : @"Apple Watch Series 4 44mm case (GPS+Cellular)",
                              
                              //iPod
                              @"iPod1,1": @"iPod touch 1st",
                              @"iPod2,1": @"iPod touch 2nd",
                              @"iPod3,1": @"iPod touch 3rd",
                              @"iPod4,1": @"iPod touch 4th",
                              @"iPod5,1": @"iPod touch 5th",
                              @"iPod7,1": @"iPod touch 6th",
                              @"iPod9,1": @"iPod touch 7th",
                              
                              //apple TV
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",

                              //Simulator
                              @"i386"   : @"iPhone Simulator",
                              @"x86_64" : @"iPhone Simulator",
                              };
        name = dic[platform];
    });
    if (name) return name;
    if ([platform hasPrefix:@"iPad"])   return @"iPad";
    if ([platform hasPrefix:@"iPod"])   return @"iPod";
    if ([platform hasPrefix:@"iPhone"]) return @"iPhone";
    return platform;
}

+ (BOOL)isSimulator{
#if TARGET_OS_SIMULATOR
    return YES;
#else
    return NO;
#endif
}

+ (NSString *)deviceName{
    return [[UIDevice currentDevice] name];
}

/** get the phone model: iPhone, iPad, iPod ... */
+ (NSString *)deviceModel{
    return [[UIDevice currentDevice] model];
}

+ (float)screenBrightness{
    return [UIScreen mainScreen].brightness;
}

+ (float)batteryLevel{
    [UIDevice currentDevice].batteryMonitoringEnabled = YES;
    float level = [UIDevice currentDevice].batteryLevel;
    if (level >= 0.0f) {
        return level * 100;
    }
    return -1;
}

/** is on charging ? */
+ (BOOL)charging{
    UIDevice *device = [UIDevice currentDevice];
    device.batteryMonitoringEnabled = YES;
    
    // Check the battery state
    if ([device batteryState] == UIDeviceBatteryStateCharging || [device batteryState] == UIDeviceBatteryStateFull) {
        return true;
    } else {
        return false;
    }
}

@end


