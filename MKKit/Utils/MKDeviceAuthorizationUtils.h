//
//  MKDeviceAuthorizationUtils.h
//  MKKit
//
//  Created by xiaomk on 16/5/15.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <EventKit/EventKit.h>
#import "MKConst.h"

typedef NS_ENUM(NSInteger, MKAppAuthorizationType) {
    MKAppAuthorizationType_assetsLib    = 1,
    MKAppAuthorizationType_camera,
    MKAppAuthorizationType_contacts,
    MKAppAuthorizationType_location,
};

@interface MKDeviceAuthorizationUtils : NSObject

+ (void)assetsLibAuthorizationWithBlock:(MKBoolBlock)block;
+ (void)cameraAuthorizationWithBlock:(MKBoolBlock)block;
+ (void)contactsAuthorizationWithBlock:(MKBoolBlock)block;
+ (void)locationAuthorizationWithBlock:(MKBoolBlock)block;

+ (void)getAuthorizationWithEntityType:(EKEntityType)type block:(MKBoolBlock)block;
+ (void)bluetoothPeripheralAuthorizationWithBlock:(MKBoolBlock)block;
+ (void)recordAuthorizationWithBlock:(MKBoolBlock)block;
+ (void)cellularAuthorizationWithBlock:(MKBlock)block;
+ (BOOL)getCellularAuthorization;
+ (BOOL)getNotifycationAuthorization;

+ (BOOL)isCameraAvailable;
+ (BOOL)isFrontCameraAvailable;
+ (BOOL)isRearCameraAvailable;
+ (void)openAppAuthorizationSetPage;

+ (void)getAppAuthorizationWithType:(MKAppAuthorizationType)type block:(MKBoolBlock)block;

+ (void)getAppAuthorizationWithType:(MKAppAuthorizationType)type
                          showAlert:(BOOL)show
                              block:(MKBoolBlock)block;
@end
