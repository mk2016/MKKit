//
//  MKDevicePermissionsUtils.m
//  MKKit
//
//  Created by xiaomk on 2016/5/15.
//  Copyright © 2016 mk. All rights reserved.
//

#import "MKDevicePermissionsUtils.h"
#import <AdSupport/AdSupport.h>
#import <AppTrackingTransparency/AppTrackingTransparency.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <CoreBluetooth/CBManager.h>


#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

#import <EventKit/EventKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreTelephony/CTCellularData.h>

#import "MKAlertView.h"

@implementation MKDevicePermissionsUtils

#pragma mark - ***** openAppPermissionsSetPage ******
+ (void)openAppPermissionsSetPage{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - ***** IDFA ******
+ (void)getIDFAWith:(MKStringBlock)block {
    if (@available(iOS 14, *)) {
        [ATTrackingManager requestTrackingAuthorizationWithCompletionHandler:^(ATTrackingManagerAuthorizationStatus status) {
            if (status == ATTrackingManagerAuthorizationStatusAuthorized) {
                MK_BLOCK_EXEC(block, [self getIDFA]);
            }
        }];
    }else{
        MK_BLOCK_EXEC(block, [self getIDFA]);
    }
}

+ (NSString *)getIDFA{
    NSString *idfa = [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];
    return idfa;
}

#pragma mark - ***** photo lib ******
+ (void)photoLibraryPermissionsWithBlock:(void(^)(BOOL bRet, PHAuthorizationStatus status))block{
    PHAuthorizationStatus status;
    if (@available(iOS 14, *)) {
        status = [PHPhotoLibrary authorizationStatusForAccessLevel:PHAccessLevelReadWrite];
    }else{
        status = [PHPhotoLibrary authorizationStatus];
    }
    switch (status) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                BOOL b = NO;
                if (@available(iOS 14, *)) {
                    b = status == PHAuthorizationStatusAuthorized || status == PHAuthorizationStatusLimited;
                } else {
                    b = status == PHAuthorizationStatusAuthorized;
                }
                MK_BLOCK_EXEC(block,b,status);
            }];
        }
            break;
        case PHAuthorizationStatusLimited:
        case PHAuthorizationStatusAuthorized:
            MK_BLOCK_EXEC(block, YES, status);
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            MK_BLOCK_EXEC(block, NO, status);
            break;
        default:
            MK_BLOCK_EXEC(block, NO, status);
            break;
    }
}

#pragma mark - ***** camera ******
+ (void)cameraPermissionsWithBlock:(MKBoolBlock)block{
    AVAuthorizationStatus status = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    switch (status) {
        case AVAuthorizationStatusNotDetermined:{
            [AVCaptureDevice requestAccessForMediaType:AVMediaTypeVideo completionHandler:^(BOOL granted) {
                MK_BLOCK_EXEC(block, granted);
            }];
        }
            break;
        case AVAuthorizationStatusAuthorized:
            MK_BLOCK_EXEC(block, YES);
            break;
        case AVAuthorizationStatusRestricted:
        case AVAuthorizationStatusDenied:
            MK_BLOCK_EXEC(block, NO);
            break;
        default:
            MK_BLOCK_EXEC(block, NO);
            break;
    }
}

#pragma mark - ***** contacts ******
+ (void)contactsPermissionsWithBlock:(MKBoolBlock)block{
//    if (@available(iOS 9.0, *)) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        switch (status) {
            case CNAuthorizationStatusNotDetermined:{
                [[[CNContactStore alloc] init] requestAccessForEntityType:CNEntityTypeContacts
                                                        completionHandler:^(BOOL granted, NSError *error) {
                    MK_BLOCK_EXEC(block, granted);
                }];
            }
                break;
            case CNAuthorizationStatusAuthorized:
                MK_BLOCK_EXEC(block, YES);
                break;
            case CNAuthorizationStatusRestricted:
            case CNAuthorizationStatusDenied:
                MK_BLOCK_EXEC(block, NO);
                break;
            default:
                MK_BLOCK_EXEC(block, NO);
                break;
        }
//    }else{
//        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
//        switch (status) {
//            case kABAuthorizationStatusNotDetermined:{
//                ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
//                ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
//                    MK_BLOCK_EXEC(block, granted);
//                    CFRelease(addressBookRef);
//                });
//            }
//                break;
//            case kABAuthorizationStatusAuthorized:
//                MK_BLOCK_EXEC(block, YES);
//                break;
//            case kABAuthorizationStatusRestricted:
//            case kABAuthorizationStatusDenied:
//                MK_BLOCK_EXEC(block, NO);
//                break;
//            default:
//                MK_BLOCK_EXEC(block, NO);
//                break;
//        }
//    }
}

#pragma mark - ***** location ******
+ (void)locationPermissionsWithBlock:(MKBoolBlock)block{
    if ([CLLocationManager locationServicesEnabled]){   //check system location Permissions is open
        CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
        switch (status) {
            case kCLAuthorizationStatusNotDetermined:{
                CLLocationManager *location = [[CLLocationManager alloc] init];
                if ([location respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
                    [location requestWhenInUseAuthorization];
                }else if ([location respondsToSelector:@selector(requestAlwaysAuthorization)]){
                    [location requestAlwaysAuthorization];
                }
            }
                break;
            case kCLAuthorizationStatusAuthorizedAlways:
            case kCLAuthorizationStatusAuthorizedWhenInUse:
                MK_BLOCK_EXEC(block, YES);
                break;
            case kCLAuthorizationStatusRestricted:
            case kCLAuthorizationStatusDenied:
                MK_BLOCK_EXEC(block, NO);
                break;
            default:
                MK_BLOCK_EXEC(block, NO);
                break;
        }
    }else{
        MK_BLOCK_EXEC(block, NO);
    }
}

#pragma mark - ***** Event 、Reminder ******
+ (void)getPermissionsWithEntityType:(EKEntityType)type block:(MKBoolBlock)block{
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:{
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                MK_BLOCK_EXEC(block, granted);
            }];
        }
            break;
        case EKAuthorizationStatusAuthorized:
            MK_BLOCK_EXEC(block, YES);
            break;
        case EKAuthorizationStatusRestricted:
        case EKAuthorizationStatusDenied:
            MK_BLOCK_EXEC(block, NO);
            break;
        default:
            MK_BLOCK_EXEC(block, NO);
            break;
    }
}


#pragma mark - ***** bluetooth ******
+ (void)bluetoothPermissionsWithBlock:(MKBoolBlock)block{
    if (@available(iOS 13.1, *)) {
        CBManagerAuthorization status = CBManager.authorization;
        switch (status) {
            case CBManagerAuthorizationNotDetermined:
                break;
            case CBManagerAuthorizationAllowedAlways:
                MK_BLOCK_EXEC(block, YES);
                break;
            case CBManagerAuthorizationRestricted:
            case CBManagerAuthorizationDenied:
                MK_BLOCK_EXEC(block, NO);
                break;
            default:
                MK_BLOCK_EXEC(block, NO);
                break;
        }
    }else{
        CBPeripheralManagerAuthorizationStatus status = [CBPeripheralManager authorizationStatus];
        switch (status) {
            case CBPeripheralManagerAuthorizationStatusNotDetermined:
                break;
            case CBPeripheralManagerAuthorizationStatusAuthorized:
                MK_BLOCK_EXEC(block, YES);
                break;
            case CBPeripheralManagerAuthorizationStatusRestricted:
            case CBPeripheralManagerAuthorizationStatusDenied:
                MK_BLOCK_EXEC(block, NO);
                break;
            default:
                MK_BLOCK_EXEC(block, NO);
                break;
        }
    }
}

#pragma mark - ***** record ******
+ (void)recordPermissionsWithBlock:(MKBoolBlock)block{
    AVAudioSessionRecordPermission authStatus = [[AVAudioSession sharedInstance] recordPermission];
    switch (authStatus) {
        case AVAudioSessionRecordPermissionUndetermined:
            break;
        case AVAudioSessionRecordPermissionDenied:
            MK_BLOCK_EXEC(block, NO);
            break;
        case AVAudioSessionRecordPermissionGranted:
            MK_BLOCK_EXEC(block, YES);
            break;
        default:
            break;
    }
};

#pragma mark - ***** cellular ******
+ (void)cellularPermissionsWithBlock:(MKBlock)block{
    if (MK_iOS_IS_ABOVE(9.0)) {
        CTCellularData *cellularData = [[CTCellularData alloc] init];
        cellularData.cellularDataRestrictionDidUpdateNotifier = ^(CTCellularDataRestrictedState state) {
            switch (state) {
                case kCTCellularDataRestricted:
                    MK_BLOCK_EXEC(block, @(kCTCellularDataRestricted));
                    ELog(@"MKCellularAuth=== Restricted");
                    break;
                case kCTCellularDataNotRestricted:
                    MK_BLOCK_EXEC(block, @(kCTCellularDataNotRestricted));
                    ELog(@"MKCellularAuth=== kCTCellularDataNotRestricted");
                    break;
                case kCTCellularDataRestrictedStateUnknown:
                    MK_BLOCK_EXEC(block, @(kCTCellularDataRestrictedStateUnknown));
                    ELog(@"MKCellularAuth=== kCTCellularDataRestrictedStateUnknown");
                    break;
                default:
                    break;
            }
        };
    }
}

+ (BOOL)getCellularPermissions{
    if (MK_iOS_IS_ABOVE(9.0)) {
        return [[CTCellularData alloc] init].restrictedState == kCTCellularDataNotRestricted;
    }
    return YES;
}

#pragma mark - ***** notification ******
+ (BOOL)getNotifycationPermissions{
    return [[UIApplication sharedApplication] currentUserNotificationSettings].types != UIUserNotificationTypeNone;
}

#pragma mark - ***** Camera ******
/** camera is available */
+ (BOOL)isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

/** front camera is available */
+ (BOOL)isFrontCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/** back camera is available */
+ (BOOL)isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}


#pragma mark - ***** author with type ******
+ (void)getAppPermissionsWithType:(MKAppPermissionsType)type block:(MKBoolBlock)block{
    [self getAppPermissionsWithType:type showAlert:YES block:block];
}

+ (void)getAppPermissionsWithType:(MKAppPermissionsType)type showAlert:(BOOL)show block:(MKBoolBlock)block{
    if (MK_IS_SIMULATOR) {
        if (type == MKAppPermissionsType_camera ||
            type == MKAppPermissionsType_contacts){
            MK_BLOCK_EXEC(block, NO);
            return;
        }
    }
    MK_WEAK_SELF
    if (MK_iOS_IS_ABOVE(8.0)) {
        switch (type) {
            case MKAppPermissionsType_assetsLib:{
                [self photoLibraryPermissionsWithBlock:^(BOOL bRet, PHAuthorizationStatus status) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showPermissionsSetAlertWithType:MKAppPermissionsType_assetsLib];
                    }
                }];
            }
                break;
            case MKAppPermissionsType_camera:{
                [self cameraPermissionsWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showPermissionsSetAlertWithType:MKAppPermissionsType_camera];
                    }
                }];
            }
                break;
            case MKAppPermissionsType_contacts:{
                [self contactsPermissionsWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showPermissionsSetAlertWithType:MKAppPermissionsType_contacts];
                    }
                }];
            }
                break;
            case MKAppPermissionsType_location:{
                [self locationPermissionsWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showPermissionsSetAlertWithType:MKAppPermissionsType_location];
                    }
                }];
            }
                break;
            default:
                break;
        }
    }
}


#pragma mark - ***** other ******
/** open app Permissions set page */
+ (void)showPermissionsSetAlertWithType:(MKAppPermissionsType)type{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = nil;
    
    switch (type) {
        case MKAppPermissionsType_assetsLib:
            str = @"照片";
            break;
        case MKAppPermissionsType_camera:
            str = @"相机";
            break;
        case MKAppPermissionsType_contacts:
            str = @"通讯录";
            break;
        case MKAppPermissionsType_location:
            str = @"定位服务";
        default:
            break;
    }
    NSString *msg = [NSString stringWithFormat:@"请在”设置-隐私-%@“选项中，允许 %@ 访问你的%@", str,appName, str];
    MK_WEAK_SELF
    [MKAlertView alertWithTitle:@"提示" message:msg cancelTitle:@"取消" confirmTitle:@"确定" onViewController:nil block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1){
            [weakSelf openAppPermissionsSetPage];
        }
    }];
}



@end
