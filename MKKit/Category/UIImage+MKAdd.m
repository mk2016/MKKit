//
//  UIImage+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/1/16.
//  Copyright © 2019 mk. All rights reserved.
//

#import "UIImage+MKAdd.h"
#import <AVFoundation/AVFoundation.h>

@implementation UIImage (MKAdd)

#pragma mark - ***** base64 <-> image ******
/** base64 string -> image */
+ (UIImage *)mk_imageWithDataURL:(NSString *)urlStr{
    if (urlStr) {
        return [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
    }
    return nil;
}

/** image -> base64 url string */
- (NSString *)mk_imageToDataURL{
    NSData *imageData = nil;
    NSString *mimeType = nil;
    if ([self mk_hasAlpha]) {
        imageData = UIImagePNGRepresentation(self);
        mimeType = @"image/png";
    } else {
        imageData = UIImageJPEGRepresentation(self, 1.0f);
        mimeType = @"image/jpeg";
    }
    return [NSString stringWithFormat:@"data:%@;base64,%@", mimeType, [imageData base64EncodedStringWithOptions: 0]];
}

/** has alpha */
- (BOOL)mk_hasAlpha{
    CGImageAlphaInfo alpha = CGImageGetAlphaInfo(self.CGImage);
    return (alpha == kCGImageAlphaFirst ||
            alpha == kCGImageAlphaLast ||
            alpha == kCGImageAlphaPremultipliedFirst ||
            alpha == kCGImageAlphaPremultipliedLast);
}

#pragma mark - ***** image ******
/** image with color */
+ (UIImage *)mk_imageWithColor:(UIColor *)color{
    return [self mk_imageWithColor:color size:CGSizeMake(1, 1) cornerRadius:0];
}

+ (UIImage *)mk_imageWithColor:(UIColor *)color size:(CGSize)size cornerRadius:(CGFloat)radius{
    CGRect rect = CGRectMake(0.0f, 0.0f, size.width, size.height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, [UIScreen mainScreen].scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:rect cornerRadius:radius];
    CGContextAddPath(context, path.CGPath);
    CGContextFillPath(context);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** create qrcode image  */
+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr imageWidth:(CGFloat)imgWidth{
    return [self mk_imageWithQRString:qrStr
                           imageWidth:imgWidth
                               margin:0
                                 logo:nil];
}

+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr imageWidth:(CGFloat)imgWidth margin:(CGFloat)margin logo:(NSString *)logoImageName{
    return [self mk_imageWithQRString:qrStr
                           imageWidth:imgWidth
                               margin:margin
                                 logo:logoImageName
                            logoWidth:28];
}

+ (UIImage *)mk_imageWithQRString:(NSString *)qrStr imageWidth:(CGFloat)imgWidth margin:(CGFloat)margin logo:(NSString *)logoImageName logoWidth:(CGFloat)logoWidth{
    
    CGFloat qrImageW = imgWidth - margin*2;
    NSData *stringData = [qrStr dataUsingEncoding:NSUTF8StringEncoding];
    //create filter
    CIFilter *qrFilter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // set content & CorrectionLevel
    [qrFilter setDefaults];
    [qrFilter setValue:stringData forKey:@"inputMessage"];
    [qrFilter setValue:@"H" forKey:@"inputCorrectionLevel"];
    CIImage *ciImage = qrFilter.outputImage;
    
    CGRect extent = CGRectIntegral(ciImage.extent);
    CGFloat scale = MIN(qrImageW/CGRectGetWidth(extent), qrImageW/CGRectGetHeight(extent));
    
    // create bitmap;
    size_t width = CGRectGetWidth(extent)* scale;
    size_t height = CGRectGetHeight(extent)* scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:@{kCIContextUseSoftwareRenderer : @(YES)}];
    CGImageRef bitmapImage = [context createCGImage:ciImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // save bitmap to image
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGColorSpaceRelease(cs);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    
    UIImage *qrImage = [UIImage imageWithCGImage:scaledImage];
    CGImageRelease(scaledImage);
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(imgWidth, imgWidth), NO, [UIScreen mainScreen].scale);
    [qrImage drawInRect:CGRectMake(margin, margin, qrImageW, qrImageW)];
    if (logoImageName) {
        UIImage *logoImg = [UIImage imageNamed:logoImageName];
        CGFloat xyPostion = (imgWidth-logoWidth)/2.f;
        [logoImg drawInRect:CGRectMake(xyPostion, xyPostion, logoWidth, logoWidth)];
    }
    qrImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return qrImage;
}

- (NSString *)mk_detectorQRCode{
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode
                                              context:nil
                                              options:@{CIDetectorAccuracy:CIDetectorAccuracyHigh}];
    if (detector) {
        NSArray *features = [detector featuresInImage:[CIImage imageWithCGImage:self.CGImage]];
        if (features && features.count > 0) {
            CIQRCodeFeature *feature = [features objectAtIndex:0];
            NSString *qrcode = feature.messageString;
            return qrcode;
        }
    }
    return nil;
}

/** view -> image */
+ (UIImage *)mk_imageWithView:(UIView *)view{
    UIImage *imageRet = nil;
    UIGraphicsBeginImageContextWithOptions(view.frame.size, YES, [UIScreen mainScreen].scale);
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    imageRet = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();    
    return imageRet;
}

//CIImage -> UIImage
+ (UIImage *)mk_imageWithCIImage:(CIImage *)ciImage size:(CGSize)size{
    if (ciImage == nil) {
        return nil;
    }
    if (size.width == 0 ) {
        size = ciImage.extent.size;
    }
    UIGraphicsBeginImageContext(size);
    [[UIImage imageWithCIImage:ciImage
                         scale:1.f
                   orientation:UIImageOrientationUp] drawInRect:CGRectMake(0,0, size.width,size.height)];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

/** get video first frame image */
+ (UIImage *)mk_thumbnailImageWithVideo:(NSString *)urlString{
    NSURL *url = [NSURL URLWithString:urlString];
    return [self mk_thumbnailImageWithVideoURL:url];
}

+ (UIImage *)mk_thumbnailImageWithVideoURL:(NSURL *)videoURL{
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoURL options:nil];
    AVAssetImageGenerator *generator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    generator.appliesPreferredTrackTransform = YES;
    generator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CMTime time = CMTimeMake(1,60);
    CMTime actualTime;
    NSError *error = nil;
    CGImageRef imageRef = [generator copyCGImageAtTime:time actualTime:&actualTime error:&error];
    if (!imageRef) {
        NSLog(@"thumbnailImageGenerationError %@", error);
    }
    UIImage *image = imageRef ? [[UIImage alloc] initWithCGImage:imageRef] : nil;
    CGImageRelease(imageRef);
    return image;
}

#pragma mark - ***** modify image ******
/** set image stretchable */
- (UIImage *)mk_setStretchableRatioLeft:(CGFloat)left top:(CGFloat)top{
    if (self) {
        return [self stretchableImageWithLeftCapWidth:self.size.width*left topCapHeight:self.size.height*top];
    }
    return nil;
}

- (UIImage *)mk_setStretchableMiddle{
    return [self mk_setStretchableRatioLeft:0.5 top:0.5];
}

/** image fill color */
- (UIImage *)mk_fillColor:(UIColor *)color{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextTranslateCTM(context, 0, self.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
    CGContextClipToMask(context, rect, self.CGImage);
    [color setFill];
    CGContextFillRect(context, rect);
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

- (UIImage *)mk_cropWith:(CGRect)rect{
    return [self mk_cropWith:rect ignoreScale:NO];
}

/** crop image */
- (UIImage *)mk_cropWith:(CGRect)rect ignoreScale:(BOOL)ignoreScale{
    if (!ignoreScale) {
        rect = CGRectMake(rect.origin.x * self.scale,
                          rect.origin.y * self.scale,
                          rect.size.width * self.scale,
                          rect.size.height * self.scale);
    }
    
    CGImageRef imageRef = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *result = [UIImage imageWithCGImage:imageRef scale:self.scale orientation:self.imageOrientation];
    CGImageRelease(imageRef);
    return result;
}

/** scale image with size */
- (UIImage *)mk_scaleToSize:(CGSize)size{
    // create a bitmap context
    // Determine whether the screen is retina
    if([[UIScreen mainScreen] scale] == 2.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 2.0);
    }else if([[UIScreen mainScreen] scale] == 3.0){
        UIGraphicsBeginImageContextWithOptions(size, NO, 3.0);
    }else{
        UIGraphicsBeginImageContext(size);
    }
    // draw image
    [self drawInRect:CGRectMake(0, 0, size.width, size.height)];
    // create a change image from context
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return scaledImage;
}

// 修正图片转向
- (UIImage *)mk_fixOrientation{
    if (!self) {
        return nil;
    }
    // No-op if the orientation is already correct
    if (self.imageOrientation == UIImageOrientationUp){
        return self;
    }
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform = CGAffineTransformIdentity;
    switch (self.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, self.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
                
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
                
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, self.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
        
    switch (self.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, self.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
        
    // Now we draw the underlying CGImage into a new context, applying the transform
     // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, self.size.width, self.size.height,
                                                    CGImageGetBitsPerComponent(self.CGImage), 0,
                                                    CGImageGetColorSpace(self.CGImage),
                                                    CGImageGetBitmapInfo(self.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (self.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
             // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.height,self.size.width), self.CGImage);
            break;
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,self.size.width,self.size.height), self.CGImage);
            break;
     }
     
     // And now we just create a new UIImage from the drawing context
     CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
     UIImage *img = [UIImage imageWithCGImage:cgimg];
     CGContextRelease(ctx);
     CGImageRelease(cgimg);
     return img;
     
//     UIGraphicsBeginImageContextWithOptions(self.size, NO, self.scale);
//     [self drawInRect:(CGRect){0, 0, self.size}];
//     UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
//     UIGraphicsEndImageContext();
//     return normalizedImage;
}

- (UIImage *)mk_rotation:(UIImageOrientation)orientation{
    UIImage *newImage = [UIImage imageWithCGImage:self.CGImage scale:self.scale orientation:orientation];
    return newImage;
//    CGFloat angle;
    
//    if ( fmod(angle, 360) == 0 ){
//        return self;
//    }
    
    
//    UIGraphicsBeginImageContext(self.size);
//
//
//    CGRect rect = CGRectMake(0, 0, self.size.width, self.size.height);
//    CGFloat radian = angle/180*M_PI;
//    CGAffineTransform transform = CGAffineTransformRotate(<#CGAffineTransform t#>, <#CGFloat angle#>)
//
//    long double rotate = 0.5;
//
//    float translateX = 0;
//    float translateY = 0;
//    float scaleX = 1.0;
//    float scaleY = 1.0;
//    CGRect rect;
//
//    switch (orientation) {
//        case UIImageOrientationLeft:
//            rotate = M_PI_2;
//            rect = CGRectMake(0, 0, self.size.height, self.size.width);
//            translateX = 0;
//            translateY = -rect.size.width;
//            scaleX = rect.size.height/rect.size.width;
//            scaleY = rect.size.width/rect.size.height;
//            break;
//        case UIImageOrientationRight:
//            rotate = 33 * M_PI_2;
//            rect = CGRectMake(0, 0, self.size.height, self.size.width);
//            translateX = -rect.size.height;
//            translateY = 0;
//            scaleX = rect.size.height/rect.size.width;
//            scaleY = rect.size.width/rect.size.height;
//            break;
//        case UIImageOrientationDown:
//            rotate = M_PI;
//            rect = CGRectMake(0, 0, self.size.width, self.size.height);
//            translateX = -rect.size.width;
//            translateY = -rect.size.height;
//            break;
//        default:
//            rotate = 0.0;
//            rect = CGRectMake(0, 0, self.size.width, self.size.height);
//            translateX = 0;
//            translateY = 0;
//            break;
//    }
//
//    UIGraphicsBeginImageContext(rect.size);
//    CGContextRef context = UIGraphicsGetCurrentContext();
//    //做CTM变换
//    CGContextTranslateCTM(context, 0.0, rect.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
//    CGContextRotateCTM(context, rotate);
//    CGContextTranslateCTM(context, translateX, translateY);
//    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), self.CGImage);
//    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
//    return newPic;
}

#pragma mark - ***** compress ******
- (NSData *)mk_compressLessThan1M{
    return [self mk_compressLessThan:1000.f];
}

- (NSData *)mk_compressLessThan500KB{
    return [self mk_compressLessThan:500.f];
}

- (NSData *)mk_compressLessThan:(CGFloat)maxKB{
    NSData *imgData = nil;
    CGFloat resizeRate = 1.0;
    CGFloat sizeOriginKB = 0;
    do {
        imgData = UIImageJPEGRepresentation(self, resizeRate);
        sizeOriginKB = imgData.length / 1000.f;
        resizeRate -= 0.1;
    } while (sizeOriginKB > maxKB && resizeRate > 0.1);
    
    UIImage *image = [UIImage imageWithData:imgData];
    while (sizeOriginKB > maxKB) {
        CGFloat fixelW = CGImageGetWidth(image.CGImage);
        CGFloat fixelH = CGImageGetHeight(image.CGImage);
        CGSize size = CGSizeMake(fixelW*0.8, fixelH*0.8);
        //通过图片上下文进行处理图片
        UIGraphicsBeginImageContext(size);
        [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
             //获取处理后图片的大小
        imgData = UIImageJPEGRepresentation(image, 1);
        sizeOriginKB = imgData.length / 1000.f;
    }
    return imgData;
}

- (UIImage *)mk_imageByCompressLessThan:(CGFloat)maxKB{
    NSData *data = [self mk_compressLessThan:maxKB];
    UIImage *img = [UIImage imageWithData:data];
    return img;
}

- (UIImage *)mk_compressWithRatio:(CGFloat)ratio{
    NSData *imgData = UIImageJPEGRepresentation(self, ratio);
    UIImage *result = [UIImage imageWithData:imgData];
    return result;
}

- (UIImage *)mk_compress{
    NSData *imgData = UIImageJPEGRepresentation(self, 1.0);
    CGFloat ratio = 1;
    if (imgData.length > 10000000) {
        ratio = 0.2;
    }else if (imgData.length > 5000000){
        ratio = 0.4;
    }else if (imgData.length > 3000000){
        ratio = 0.5;
    }else if (imgData.length > 2000000){
        ratio = 0.6;
    }else if (imgData.length > 1000000){
        ratio = 0.7;
    }
    imgData = UIImageJPEGRepresentation(self, ratio);
    UIImage *result = [UIImage imageWithData:imgData];
    return result;
}

- (CGFloat)mk_imageLength{
    NSData *data = UIImageJPEGRepresentation(self, 1);
    return data.length/1000.f;
}

+ (UIImage *)mk_gradientWithColors:(NSArray <UIColor *> *)colors size:(CGSize)size{
    return [self mk_gradientWithColors:colors size:size start:CGPointMake(0.0, 0.0) end:CGPointMake(1.0, 0.0)];
}

+ (UIImage *)mk_gradientWithColors:(NSArray <UIColor *> *)colors size:(CGSize)size start:(CGPoint)start end:(CGPoint)end{
    if (CGSizeEqualToSize(size, CGSizeZero)) {
        size = CGSizeMake(1, 1);
    }
    
    NSMutableArray *cgColors = @[].mutableCopy;
    for(UIColor *color in colors) {
        [cgColors addObject:(id)color.CGColor];
    }
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, size.width, size.height);
    gradientLayer.startPoint = start;
    gradientLayer.endPoint = end;
    gradientLayer.colors = cgColors;
    UIGraphicsBeginImageContext(size);
    [gradientLayer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end
