//
//  MKDeviceAuthorizationUtils.m
//  MKKit
//
//  Created by xiaomk on 16/5/15.
//  Copyright © 2016年 xiaomk. All rights reserved.
//

#import "MKDeviceAuthorizationUtils.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <CoreLocation/CoreLocation.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>
#import <CoreBluetooth/CoreBluetooth.h>
#import <EventKit/EventKit.h>
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <CoreTelephony/CTCellularData.h>

#import "MKAlertView.h"

@implementation MKDeviceAuthorizationUtils

#pragma mark - ***** assets lib ******
+ (void)assetsLibAuthorizationWithBlock:(MKBoolBlock)block{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                MK_BLOCK_EXEC(block, status == PHAuthorizationStatusAuthorized);
            }];
        }
            break;
        case PHAuthorizationStatusAuthorized:
            MK_BLOCK_EXEC(block, YES);
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            MK_BLOCK_EXEC(block, NO);
            break;
        default:
            MK_BLOCK_EXEC(block, NO);
            break;
    }
}

#pragma mark - ***** camera ******
+ (void)cameraAuthorizationWithBlock:(MKBoolBlock)block{
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
+ (void)contactsAuthorizationWithBlock:(MKBoolBlock)block{
    if (MK_iOS_IS_ABOVE(9.0)) {
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
    }else{
        ABAuthorizationStatus status = ABAddressBookGetAuthorizationStatus();
        switch (status) {
            case kABAuthorizationStatusNotDetermined:{
                ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
                ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
                    MK_BLOCK_EXEC(block, granted);
                    CFRelease(addressBookRef);
                });
            }
                break;
            case kABAuthorizationStatusAuthorized:
                MK_BLOCK_EXEC(block, YES);
                break;
            case kABAuthorizationStatusRestricted:
            case kABAuthorizationStatusDenied:
                MK_BLOCK_EXEC(block, NO);
                break;
            default:
                MK_BLOCK_EXEC(block, NO);
                break;
        }
    }
}

#pragma mark - ***** location ******
+ (void)locationAuthorizationWithBlock:(MKBoolBlock)block{
    if ([CLLocationManager locationServicesEnabled]){   //check system location Authorization is open
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
+ (void)getAuthorizationWithEntityType:(EKEntityType)type block:(MKBoolBlock)block{
    EKAuthorizationStatus authStatus = [EKEventStore authorizationStatusForEntityType:type];
    switch (authStatus) {
        case EKAuthorizationStatusNotDetermined:{
            EKEventStore *store = [[EKEventStore alloc] init];
            [store requestAccessToEntityType:type completion:^(BOOL granted, NSError * _Nullable error) {
                if (granted) {
                    MK_BLOCK_EXEC(block, granted);
                }
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
+ (void)bluetoothPeripheralAuthorizationWithBlock:(MKBoolBlock)block{
    CBPeripheralManagerAuthorizationStatus authStatus = [CBPeripheralManager authorizationStatus];
    switch (authStatus) {
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

#pragma mark - ***** record ******
+ (void)recordAuthorizationWithBlock:(MKBoolBlock)block{
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
+ (void)cellularAuthorizationWithBlock:(MKBlock)block{
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

+ (BOOL)getCellularAuthorization{
    if (MK_iOS_IS_ABOVE(9.0)) {
        return [[CTCellularData alloc] init].restrictedState == kCTCellularDataNotRestricted;
    }
    return YES;
}

#pragma mark - ***** notification ******
+ (BOOL)getNotifycationAuthorization{
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

+ (void)openAppAuthorizationSetPage{
    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    [[UIApplication sharedApplication] openURL:url];
}

#pragma mark - ***** author with type ******
+ (void)getAppAuthorizationWithType:(MKAppAuthorizationType)type block:(MKBoolBlock)block{
    [self getAppAuthorizationWithType:type showAlert:YES block:block];
}

+ (void)getAppAuthorizationWithType:(MKAppAuthorizationType)type showAlert:(BOOL)show block:(MKBoolBlock)block{
    if (MK_IS_SIMULATOR) {
        if (type == MKAppAuthorizationType_camera ||
            type == MKAppAuthorizationType_contacts){
            MK_BLOCK_EXEC(block, NO);
            return;
        }
    }
    MK_WEAK_SELF
    if (MK_iOS_IS_ABOVE(8.0)) {
        switch (type) {
            case MKAppAuthorizationType_assetsLib:{
                [self assetsLibAuthorizationWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showAuthorizationSetAlertWithType:MKAppAuthorizationType_assetsLib];
                    }
                }];
            }
                break;
            case MKAppAuthorizationType_camera:{
                [self cameraAuthorizationWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showAuthorizationSetAlertWithType:MKAppAuthorizationType_camera];
                    }
                }];
            }
                break;
            case MKAppAuthorizationType_contacts:{
                [self contactsAuthorizationWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showAuthorizationSetAlertWithType:MKAppAuthorizationType_contacts];
                    }
                }];
            }
                break;
            case MKAppAuthorizationType_location:{
                [self locationAuthorizationWithBlock:^(BOOL bRet) {
                    MK_BLOCK_EXEC(block, bRet);
                    if (!bRet && show) {
                        [weakSelf showAuthorizationSetAlertWithType:MKAppAuthorizationType_location];
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
/** open app authorization set page */
+ (void)showAuthorizationSetAlertWithType:(MKAppAuthorizationType)type{
    NSString *appName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
    NSString *str = nil;
    
    switch (type) {
        case MKAppAuthorizationType_assetsLib:
            str = @"照片";
            break;
        case MKAppAuthorizationType_camera:
            str = @"相机";
            break;
        case MKAppAuthorizationType_contacts:
            str = @"通讯录";
            break;
        case MKAppAuthorizationType_location:
            str = @"定位服务";
        default:
            break;
    }
    NSString *msg = [NSString stringWithFormat:@"请在”设置-隐私-%@“选项中，允许 %@ 访问你的%@", str,appName, str];
    MK_WEAK_SELF
    [MKAlertView alertWithTitle:@"提示" message:msg cancelTitle:@"取消" confirmTitle:@"确定" onViewController:nil block:^(NSInteger buttonIndex) {
        if (buttonIndex == 1){
            [weakSelf openAppAuthorizationSetPage];
        }
    }];
}



@end
