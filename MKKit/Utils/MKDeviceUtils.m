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
                              @"iPhone3,2": @"iPhone 4 GSM Rev A",
                              @"iPhone3,3": @"iPhone 4 CDMA",
                              @"iPhone4,1": @"iPhone 4S",
                              @"iPhone4,2": @"iPhone 4S",
                              @"iPhone4,3": @"iPhone 4S",
                              @"iPhone5,1": @"iPhone 5 (GSM)",
                              @"iPhone5,2": @"iPhone 5 (GSM+CDMA)",
                              @"iPhone5,3": @"iPhone 5C (GSM)",
                              @"iPhone5,4": @"iPhone 5C (GSM+CDMA)",
                              @"iPhone6,1": @"iPhone 5S (GSM)",
                              @"iPhone6,2": @"iPhone 5S (GSM+CDMA)",
                              @"iPhone7,1": @"iPhone 6 Plus",
                              @"iPhone7,2": @"iPhone 6",
                              @"iPhone8,1": @"iPhone 6S",
                              @"iPhone8,2": @"iPhone 6S Plus",
                              @"iPhone8,3": @"iPhone SE (GSM+CDMA)",
                              @"iPhone8,4": @"iPhone SE (GSM)",
                              @"iPhone9,1": @"iPhone 7",
                              @"iPhone9,2": @"iPhone 7 Plus",
                              @"iPhone9,3": @"iPhone 7",
                              @"iPhone9,4": @"iPhone 7 Plus",
                              @"iPhone10,1": @"iPhone 8 (A1863,A1906)",
                              @"iPhone10,2": @"iPhone 8 Plus (A1864,A1898)",
                              @"iPhone10,3": @"iPhone X (A1865,A1902)",
                              @"iPhone10,4": @"iPhone 8 (Global/A1905)",
                              @"iPhone10,5": @"iPhone 8 Plus ((Global/A1897))",
                              @"iPhone10,6": @"iPhone X (Global/A1901)",
                              @"iPhone11,2": @"iPhone XS",
                              @"iPhone11,4": @"iPhone XS Max China",
                              @"iPhone11,6": @"iPhone XS Max",
                              @"iPhone11,8": @"iPhone XR",
                              @"iPhone12,1": @"iPhone 11",
                              @"iPhone12,3": @"iPhone 11 Pro",
                              @"iPhone12,5": @"iPhone 11 Pro Max",

                              //iPad
                              @"iPad1,1": @"iPad",
                              @"iPad1,2": @"iPad 3G",
                              
                              @"iPad2,1": @"iPad 2 (WiFi)",
                              @"iPad2,2": @"iPad 2 (GSM)",
                              @"iPad2,3": @"iPad 2 (CDMA)",
                              @"iPad2,4": @"iPad 2 (WiFi)",
                              @"iPad2,5": @"iPad Mini 1(WiFi)",
                              @"iPad2,6": @"iPad Mini 1(GSM)",
                              @"iPad2,7": @"iPad Mini 1(GSM+CDMA)",
                              
                              @"iPad3,1": @"iPad 3 (WiFi)",
                              @"iPad3,2": @"iPad 3 (GSM+CDMA)",
                              @"iPad3,3": @"iPad 3 (GSM)",
                              @"iPad3,4": @"iPad 4 (WiFi)",
                              @"iPad3,5": @"iPad 4 (GSM)",
                              @"iPad3,6": @"iPad 4 (GSM+CDMA)",
                              
                              @"iPad4,1": @"iPad Air (WiFi)",
                              @"iPad4,2": @"iPad Air (Cellular)",
                              @"iPad4,3": @"iPad Air",
                              @"iPad4,4": @"iPad Mini 2 (WiFi)",
                              @"iPad4,5": @"iPad Mini 2 (Cellular)",
                              @"iPad4,6": @"iPad Mini 2",
                              @"iPad4,7": @"iPad Mini 3",
                              @"iPad4,8": @"iPad Mini 3",
                              @"iPad4,9": @"iPad Mini 3",
                              
                              @"iPad5,1": @"iPad Mini 4(WiFi)",
                              @"iPad5,2": @"iPad Mini 4(Cellular)",
                              @"iPad5,3": @"iPad Air 2",
                              @"iPad5,4": @"iPad Air 2(WiFi)",
                              @"iPad5,5": @"iPad Air 2(Cellular)",
                              
                              @"iPad6,3": @"iPad Pro(WiFi) 9.7-inch",
                              @"iPad6,4": @"iPad Pro(Cellular) 9.7-inch",
                              @"iPad6,7": @"iPad Pro(WiFi) 12.9-inch",
                              @"iPad6,8": @"iPad Pro(Cellular) 12.9-inch",
                              @"iPad6,11": @"iPad 5 (WiFi)",
                              @"iPad6,12": @"iPad 5 (Cellular)",
                              
                              @"iPad7,1": @"iPad Pro 12.9-inch 2nd gen (WiFi)",
                              @"iPad7,2": @"iPad Pro 12.9-inch 2nd gen (Cellular)",
                              @"iPad7,3": @"iPad Pro 10.5-inch (WiFi)",
                              @"iPad7,4": @"iPad Pro 10.5-inch (Cellular)",
                              @"iPad7,5": @"iPad 6th Gen (WiFi)",
                              @"iPad7,6": @"iPad 6th Gen (WiFi+Cellular)",

                              @"iPad8,1": @"iPad Pro 3rd Gen (11 inch, WiFi)",
                              @"iPad8,2": @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi)",
                              @"iPad8,3": @"iPad Pro 3rd Gen (11 inch, WiFi+Cellular)",
                              @"iPad8,4": @"iPad Pro 3rd Gen (11 inch, 1TB, WiFi+Cellular)",
                              @"iPad8,5": @"iPad Pro 3rd Gen (12.9 inch, WiFi)",
                              @"iPad8,6": @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi)",
                              @"iPad8,7": @"iPad Pro 3rd Gen (12.9 inch, WiFi+Cellular)",
                              @"iPad8,8": @"iPad Pro 3rd Gen (12.9 inch, 1TB, WiFi+Cellular)",
                              @"iPad11,1": @"iPad mini 5th Gen (WiFi)",
                              @"iPad11,2": @"iPad mini 5th Gen",
                              @"iPad11,3": @"iPad Air 3rd Gen (WiFi)",
                              @"iPad11,4": @"iPad Air 3rd Gen",
                              
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
                              
                              //apple TV
                              @"AppleTV2,1" : @"Apple TV 2",
                              @"AppleTV3,1" : @"Apple TV 3",
                              @"AppleTV3,2" : @"Apple TV 3",
                              @"AppleTV5,3" : @"Apple TV 4",
                              
                              //iPod
                              @"iPod1,1": @"1st Gen iPod",
                              @"iPod2,1": @"2nd Gen iPod",
                              @"iPod3,1": @"3rd Gen iPod",
                              @"iPod4,1": @"4th Gen iPod",
                              @"iPod5,1": @"5th Gen iPod",
                              @"iPod7,1": @"6th Gen iPod",
                              @"iPod9,1": @"7th Gen iPod",

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


