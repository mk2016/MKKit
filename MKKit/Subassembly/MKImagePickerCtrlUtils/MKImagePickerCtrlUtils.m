//
//  MKImagePickerCtrlUtils.m
//  MKKit
//
//  Created by xiaomk on 16/5/28.
//  Copyright © 2016年 tianchuang. All rights reserved.
//

#import "MKImagePickerCtrlUtils.h"
#import "MKDevicePermissionsUtils.h"
#import "MKUtils.h"

@interface MKImagePickerCtrlUtils()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) MKImagePickerType sourceType;
@property (nonatomic, copy) MKIPCBlock block;
@property (nonatomic, strong) UIImagePickerController *ipc;
@end

@implementation MKImagePickerCtrlUtils

MK_IMPL_SHAREDINSTANCE(MKImagePickerCtrlUtils);

- (void)showWithSourceType:(MKImagePickerType)sourceType onViewController:(UIViewController *)vc block:(MKIPCBlock)block{
    self.vc = vc;
    self.sourceType = sourceType;
    self.block = block;
    
    if (self.vc == nil) {
        self.vc = [MKUtils topViewController];
    }
    
    if (self.sourceType == MKImagePickerType_none) {
        self.sourceType = MKImagePickerType_camera;
    }
    
    MKAppPermissionsType authType = MKAppPermissionsType_camera;
    if (self.sourceType == MKImagePickerType_camera) {
        self.ipc.sourceType = UIImagePickerControllerSourceTypeCamera;
        authType = MKAppPermissionsType_camera;
    }else if (self.sourceType == MKImagePickerType_photoLibrary ){
        self.ipc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        authType = MKAppPermissionsType_assetsLib;
    }
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 8.0) {
        vc.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    }
    
    MK_WEAK_SELF
    [MKDevicePermissionsUtils getAppPermissionsWithType:authType block:^(BOOL bRet) {
        if (bRet) {
            double delayInSeconds = 0.1;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(delayInSeconds * NSEC_PER_SEC)),
                           dispatch_get_main_queue(), ^{
                [vc presentViewController:weakSelf.ipc animated:YES completion:nil];
            });
        }else{
            MK_BLOCK_EXEC(block, nil);
        }
    }];
}

#pragma mark - ***** delegate ******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    MK_BLOCK_EXEC(self.block, image);
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    MK_BLOCK_EXEC(self.block, nil);
}

#pragma mark - ***** lazy ******
- (UIImagePickerController *)ipc{
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.delegate = self;
        _ipc.allowsEditing = YES;
        _ipc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _ipc.navigationBar.translucent = NO;
    }
    return _ipc;
}

@end

