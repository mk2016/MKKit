//
//  MKScanerSessionManager.m
//  MKKit
//
//  Created by xiaomk on 2019/5/27.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKScanerSessionManager.h"
#import <Vision/Vision.h>
#import "AVCaptureDevice+MKAdd.h"
#import "MKConst.h"

@interface MKScanerSessionManager()<AVCaptureMetadataOutputObjectsDelegate>{
    dispatch_queue_t _sessionQueue;
}
@property (nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, strong) AVCaptureDevice *device;
@property (nonatomic, weak) id<MKScanerSessionManagerDelegate> delegate;
@end

@implementation MKScanerSessionManager

- (id)initWithDelegate:(id<MKScanerSessionManagerDelegate>)delegate{
    if (self = [super init]) {
        self.delegate = delegate;
        [self createSession];
    }
    return self;
}

- (void)createSession{
    
    CGRect previewFrame = [UIScreen mainScreen].bounds;
    if ([self.delegate respondsToSelector:@selector(previewFrame)]){
        previewFrame = [self.delegate previewFrame];
    }
    
    if (!_sessionQueue) {
        _sessionQueue = dispatch_queue_create("com.mk.qrcode.session", NULL);
    }
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session setSessionPreset:AVCaptureSessionPresetHigh];
    
    [self.session beginConfiguration];
    NSError *error;
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
    if (!input && [self.delegate respondsToSelector:@selector(sessionManager:error:)]) {
        [self.delegate sessionManager:self error:error];
        ELog(@"error:%@", [error localizedDescription]);
        return ;
    }
    
    AVCaptureMetadataOutput *output = [[AVCaptureMetadataOutput alloc] init];
    [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    //添加 输入 输出流
    if ([self.session canAddInput:input]) {
        [self.session addInput:input];
    }
    if ([self.session canAddOutput:output]) {
        [self.session addOutput:output];
    }
    // 设置元数据类型 支持条形码 和 二维码
    if ([self.delegate respondsToSelector:@selector(metadataObjectTypes)]) {
        [output setMetadataObjectTypes:[self.delegate metadataObjectTypes]];
    }else{
        [output setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode,
                                         AVMetadataObjectTypeEAN13Code,
                                         AVMetadataObjectTypeEAN8Code,
                                         AVMetadataObjectTypeCode128Code]];
    }
    
    // 设置扫描范围
    if ([self.delegate respondsToSelector:@selector(scanAreaRect)]) {
        output.rectOfInterest = [self getInterestRectWith:[self.delegate scanAreaRect] previewSize:previewFrame.size];
    }
    [self.session commitConfiguration];
    
    
    //创建预览图层
    self.preview = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    [self.preview setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    self.preview.frame = previewFrame;
    
}

- (void)start{
//    dispatch_async(dispatch_get_main_queue(), ^{
    dispatch_async(_sessionQueue, ^{
        if (self.session) {
            [self.session startRunning];
        }
    });
}

- (void)stop{
//    dispatch_async(dispatch_get_main_queue(), ^{
    dispatch_async(_sessionQueue, ^{
        if ([self.session isRunning]) {
            [self.session stopRunning];
        }
    });
}

/** focus with touch position */
- (void)focusWithPoint:(CGPoint)point{
    [AVCaptureDevice mk_focusAtPoint:point];
}

- (void)setTorch:(BOOL)torch{
    [self.device mk_setTorch:torch];
}

- (CGRect)getInterestRectWith:(CGRect)scanRect previewSize:(CGSize)size{
    return CGRectMake(scanRect.origin.y/size.height,
                      scanRect.origin.x/size.width,
                      scanRect.size.height/size.height,
                      scanRect.size.width/size.width);
}

#pragma mark - ***** AVCaptureMetadataOutputObjectsDelegate ******
- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection{
    if ([self.delegate respondsToSelector:@selector(captureOutput:didOutputMetadataObjects:fromConnection:)]) {
        [self.delegate captureOutput:output didOutputMetadataObjects:metadataObjects fromConnection:connection];
    }else{
        if (metadataObjects && metadataObjects.count > 0) {
            AVMetadataMachineReadableCodeObject *metadataObj = [metadataObjects objectAtIndex:0];
            if ([[metadataObj type] isEqualToString:AVMetadataObjectTypeQRCode] && [self.delegate respondsToSelector:@selector(sessionManager:qrcode:)]){
                [self.delegate sessionManager:self qrcode:[metadataObj stringValue]];
            }else if ([self.delegate respondsToSelector:@selector(sessionManager:obj:)]){
                [self.delegate sessionManager:self obj:metadataObj];
            }
        }
    }
}

- (void)dealloc{
    DLog(@"♻️");
    if (_device && _device.torchMode){
        [self setTorch:NO];
    }
    _session = nil;
    _device = nil;
    _preview = nil;
}
@end

