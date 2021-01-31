//
//  MKDevicePermissionsUtils.h
//  MKKit
//
//  Created by xiaomk on 2016/5/15.
//  Copyright © 2016 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import <Photos/Photos.h>
#import "MKConst.h"

typedef NS_ENUM(NSInteger, MKAppPermissionsType) {
    MKAppPermissionsType_assetsLib    = 1,
    MKAppPermissionsType_camera,
    MKAppPermissionsType_contacts,
    MKAppPermissionsType_location,
};

@interface MKDevicePermissionsUtils : NSObject
#pragma mark - ***** openAppPermissionsSetPage ******
+ (void)openAppPermissionsSetPage;
#pragma mark - ***** IDFA ******
+ (void)getIDFAWith:(MKStringBlock)block;
#pragma mark - ***** photo lib ******
+ (void)photoLibraryPermissionsWithBlock:(void(^)(BOOL bRet, PHAuthorizationStatus status))block;
#pragma mark - ***** camera ******
+ (void)cameraPermissionsWithBlock:(MKBoolBlock)block;
#pragma mark - ***** contacts ******
+ (void)contactsPermissionsWithBlock:(MKBoolBlock)block;


+ (void)locationPermissionsWithBlock:(MKBoolBlock)block;

#pragma mark - ***** Event 、Reminder ******
+ (void)getPermissionsWithEntityType:(EKEntityType)type block:(MKBoolBlock)block;
#pragma mark - ***** bluetooth ******
+ (void)bluetoothPermissionsWithBlock:(MKBoolBlock)block;

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
