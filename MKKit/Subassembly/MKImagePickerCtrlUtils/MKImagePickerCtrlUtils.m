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
#import <CoreServices/CoreServices.h>
#import "UIImage+MKAdd.h"

@interface MKImagePickerCtrlUtils()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, weak) UIViewController *vc;
@property (nonatomic, assign) MKImagePickerType sourceType;
@property (nonatomic, copy) MKIPCBlock block;
@property (nonatomic, strong) UIImagePickerController *ipc;
@property (nonatomic, assign) NSInteger curBehavior;
@end

@implementation MKImagePickerCtrlUtils

MK_IMPL_SHAREDINSTANCE(MKImagePickerCtrlUtils);

- (void)showWithSourceType:(MKImagePickerType)sourceType onViewController:(UIViewController *)vc block:(MKIPCBlock)block{
    [self showWithSourceType:sourceType
               allowsEditing:NO
            onViewController:vc
                       block:block];
}

- (void)showWithSourceType:(MKImagePickerType)sourceType
             allowsEditing:(BOOL)allowsEditing
          onViewController:(UIViewController *)vc
                     block:(MKIPCBlock)block{
    
    if (@available(iOS 11.0, *)) {
        self.curBehavior = [UIScrollView appearance].contentInsetAdjustmentBehavior;
        if (self.curBehavior == UIScrollViewContentInsetAdjustmentNever) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentAutomatic];
        }
    }
    self.vc = vc;
    self.sourceType = sourceType?:MKImagePickerType_camera;
    self.block = block;
    
    if (self.vc == nil) {
        self.vc = [MKUtils topViewController];
    }
    
    self.ipc.allowsEditing = allowsEditing;

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
            [weakSelf callbackWith:nil];
        }
    }];
}

#pragma mark - ***** delegate ******
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = nil;
    if (picker.allowsEditing) {
        image = [info objectForKey:UIImagePickerControllerEditedImage];
        if (@available(iOS 11, *)) {
            if (picker.sourceType == UIImagePickerControllerSourceTypePhotoLibrary) {
                UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
                UIImage *oImage = [originalImage mk_fixOrientation];
                CGRect crop = [[info objectForKey:UIImagePickerControllerCropRect] CGRectValue];
                crop.origin.y = crop.origin.y + 132;
                image = [oImage mk_cropWith:crop];
            }
        }
    }else{
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
    }
    [self callbackWith:image];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [self.vc dismissViewControllerAnimated:YES completion:nil];
    [self callbackWith:nil];
}

- (void)callbackWith:(UIImage *)image{
    if (@available(iOS 11.0, *)) {
        if (self.curBehavior == UIScrollViewContentInsetAdjustmentNever) {
            [[UIScrollView appearance] setContentInsetAdjustmentBehavior:UIScrollViewContentInsetAdjustmentNever];
        }
    }
    MK_BLOCK_EXEC(self.block,image);
}

#pragma mark - ***** lazy ******
- (UIImagePickerController *)ipc{
    if (!_ipc) {
        _ipc = [[UIImagePickerController alloc] init];
        _ipc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        _ipc.navigationBar.translucent = NO;
        _ipc.delegate = self;
        if (@available(iOS 13.0, *)) {
            _ipc.modalPresentationStyle = UIModalPresentationFullScreen;
        }
    }
    return _ipc;
}

@end

