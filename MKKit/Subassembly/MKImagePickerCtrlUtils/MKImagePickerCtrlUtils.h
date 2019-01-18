//
//  MKImagePickerCtrlUtils.h
//  MKKit
//
//  Created by xiaomk on 16/5/28.
//  Copyright © 2016年 tianchuang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKImagePickerType) {
    MKImagePickerType_none      = 0,
    MKImagePickerType_camera,
    MKImagePickerType_photoLibrary,
};

typedef void (^MKIPCBlock)(UIImage *result);

@interface MKImagePickerCtrlUtils : NSObject

+ (instancetype)sharedInstance;
- (void)showWithSourceType:(MKImagePickerType)sourceType onViewController:(UIViewController *)vc block:(MKIPCBlock)block;
@end
