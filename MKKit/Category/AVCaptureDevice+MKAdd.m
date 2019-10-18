//
//  AVCaptureDevice+MKAdd.m
//  STIMProject
//
//  Created by xiaomk on 2019/7/12.
//  Copyright © 2019 mk. All rights reserved.
//

#import "AVCaptureDevice+MKAdd.h"

@implementation AVCaptureDevice (MKAdd)

/**
 * set torch
 */
- (void)mk_setTorch:(BOOL)torch{
    AVCaptureTorchMode torchMode = torch ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    if ([self isTorchModeSupported:torchMode]) {
        [self lockForConfiguration:nil];
        self.torchMode = torchMode;
        [self unlockForConfiguration];
    }
}

+ (void)mk_focusAtPoint:(CGPoint)point{
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    CGPoint pointOfInterst = CGPointMake(point.y / [UIScreen mainScreen].bounds.size.height,
                                         1.f - (point.x / [UIScreen mainScreen].bounds.size.width));
    if ([device isFocusPointOfInterestSupported] && [device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
        NSError *error;
        if ([device lockForConfiguration:&error]) {
            //白平衡
            if ([device isWhiteBalanceModeSupported:AVCaptureWhiteBalanceModeAutoWhiteBalance]) {
                device.whiteBalanceMode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
            }
            //对焦
            if ([device isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
                device.focusMode = AVCaptureFocusModeAutoFocus;
                device.focusPointOfInterest = pointOfInterst;
            }
            //曝光
            if ([device isExposurePointOfInterestSupported] &&
                [device isExposureModeSupported:AVCaptureExposureModeContinuousAutoExposure]) {
                device.exposureMode = AVCaptureExposureModeContinuousAutoExposure;
                device.exposurePointOfInterest = pointOfInterst;
            }
            [device unlockForConfiguration];
        }
    }
}

@end
