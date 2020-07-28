//
//  MKScanerSessionManager.h
//  MKKit
//
//  Created by xiaomk on 2019/5/27.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

NS_ASSUME_NONNULL_BEGIN
@class MKScanerSessionManager;

@protocol MKScanerSessionManagerDelegate <NSObject, AVCaptureMetadataOutputObjectsDelegate>
@optional
/**
 * set preview frame, default: screen bounds
 */
- (CGRect)previewFrame;

/*
 * set scan area rect
 */
- (CGRect)scanAreaRect;

/**
 * set AVCaptureMetadataOutput metadataObjectTypes,
 * default: @[AVMetadataObjectTypeQRCode,
 *              AVMetadataObjectTypeEAN13Code,
 *              AVMetadataObjectTypeEAN8Code,
 *              AVMetadataObjectTypeCode128Code
 *           ]
 */
- (NSArray<AVMetadataObjectType> * _Nullable)metadataObjectTypes;

/**
 * custom handle the scan result
 */
- (void)sessionManager:(MKScanerSessionManager *)manager obj:(AVMetadataMachineReadableCodeObject *)obj;

/**
 * scan qrcode result
 */
- (void)sessionManager:(MKScanerSessionManager *)manager qrcode:(NSString *)qrcode;
 
- (void)sessionManager:(MKScanerSessionManager *)manager error:(NSError *)error;
@end

@interface MKScanerSessionManager : NSObject
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *preview;

- (id)initWithDelegate:(id<MKScanerSessionManagerDelegate>)delegate;
- (void)start;
- (void)stop;

- (void)focusWithPoint:(CGPoint)point;
- (void)setTorch:(BOOL)torch;

@end

NS_ASSUME_NONNULL_END
