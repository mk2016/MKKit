//
//  UIImage+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/16.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MKAdd)
#pragma mark - ***** base64 <-> image ******
/** base64 string -> image */
+ (UIImage *)mk_imageWithDataURL:(NSString *)urlStr;

/** image -> base64 url string */
- (NSString *)mk_imageToDataURL;

/** has alpha */
- (BOOL)mk_hasAlpha;

#pragma mark - ***** image ******
/** image with color  size cornerRadius */
+ (UIImage *)mk_imageWithColor:(UIColor *)color;
+ (UIImage *)mk_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius;

/** create qrcode image  */
+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr imageWidth:(CGFloat)imgWidth;

+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr imageWidth:(CGFloat)imgWidth
                           margin:(CGFloat)margin
                             logo:(NSString *)logoImageName;

+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr
                       imageWidth:(CGFloat)imgWidth
                           margin:(CGFloat)margin
                             logo:(NSString *)logoImageName
                        logoWidth:(CGFloat)logoWidth;

- (NSString *)mk_detectorQRCode;

/** view -> image */
+ (UIImage *)mk_imageWithView:(UIView *)view;

//CIImage -> UIImage
+ (UIImage *)mk_imageWithCIImage:(CIImage *)ciImage size:(CGSize)size;

/** get video first frame image */
+ (UIImage *)mk_thumbnailImageWithVideo:(NSString *)urlString;

+ (UIImage *)mk_thumbnailImageWithVideoURL:(NSURL *)videoURL;

#pragma mark - ***** modify image ******
/** set image stretchable */
- (UIImage *)mk_setStretchableRatioLeft:(CGFloat)left top:(CGFloat)top;

- (UIImage *)mk_setStretchableMiddle;

/** image fill color */
- (UIImage *)mk_fillColor:(UIColor *)color;

/** crop image */
- (UIImage *)mk_cropWith:(CGRect)rect;
- (UIImage *)mk_cropWith:(CGRect)rect ignoreScale:(BOOL)ignoreScale;

/** scale image with size */
- (UIImage *)mk_scaleToSize:(CGSize)size;

/** fix image orientation */
- (UIImage *)mk_fixOrientation;

/** rotation image */
- (UIImage *)mk_rotation:(UIImageOrientation)orientation;

#pragma mark - ***** compress ******
- (NSData *)mk_compressLessThan1M;
- (NSData *)mk_compressLessThan500KB;
- (NSData *)mk_compressLessThan:(CGFloat)maxKB;
- (UIImage *)mk_imageByCompressLessThan:(CGFloat)maxKB;
- (UIImage *)mk_compressWithRatio:(CGFloat)ratio;
- (UIImage *)mk_compress;
- (CGFloat)mk_imageLength;

+ (UIImage *)mk_gradientWithColors:(NSArray <UIColor *> *)colors size:(CGSize)size;
+ (UIImage *)mk_gradientWithColors:(NSArray <UIColor *> *)colors size:(CGSize)size start:(CGPoint)start end:(CGPoint)end;
@end
