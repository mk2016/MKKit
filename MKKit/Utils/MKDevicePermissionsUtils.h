//
//  MKDevicePermissionsUtils.h
//  MKKit
//
//  Created by xiaomk on 16/5/15.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "MKConst.h"

typedef NS_ENUM(NSInteger, MKAppPermissionsType) {
    MKAppPermissionsType_assetsLib    = 1,
    MKAppPermissionsType_camera,
    MKAppPermissionsType_contacts,
    MKAppPermissionsType_location,
};

@interface MKDevicePermissionsUtils : NSObject

+ (void)assetsLibPermissionsWithBlock:(MKBoolBlock)block;
+ (void)cameraPermissionsWithBlock:(MKBoolBlock)block;
+ (void)contactsPermissionsWithBlock:(MKBoolBlock)block;
+ (void)locationPermissionsWithBlock:(MKBoolBlock)block;

+ (void)getPermissionsWithEntityType:(EKEntityType)type block:(MKBoolBlock)block;
+ (void)bluetoothPeripheralPermissionsWithBlock:(MKBoolBlock)block;
+ (void)recordPermissionsWithBlock:(MKBoolBlock)block;
+ (void)cellularPermissionsWithBlock:(MKBlock)block;
+ (BOOL)getCellularPermissions;
+ (BOOL)getNotifycationPermissions;

+ (BOOL)isCameraAvailable;
+ (BOOL)isFrontCameraAvailable;
+ (BOOL)isRearCameraAvailable;
+ (void)openAppPermissionsSetPage;

+ (void)getAppPermissionsWithType:(MKAppPermissionsType)type block:(MKBoolBlock)block;

+ (void)getAppPermissionsWithType:(MKAppPermissionsType)type
                          showAlert:(BOOL)show
                              block:(MKBoolBlock)block;
@end
