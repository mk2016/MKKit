//
//  MKImagePickerCtrlUtils.h
//  MKKit
//
//  Created by xiaomk on 2016/5/28.
//  Copyright © 2016 mk. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKImagePickerType) {
    MKImagePickerType_camera        = 1,
    MKImagePickerType_photoLibrary  = 2,
};

typedef void (^MKIPCBlock)(UIImage *result);

@interface MKImagePickerCtrlUtils : NSObject

+ (instancetype)sharedInstance;
- (void)showWithSourceType:(MKImagePickerType)sourceType
          onViewController:(UIViewController *)vc
                     block:(MKIPCBlock)block;

- (void)showWithSourceType:(MKImagePickerType)sourceType
             allowsEditing:(BOOL)allowsEditing
          onViewController:(UIViewController *)vc
                     block:(MKIPCBlock)block;
@end
