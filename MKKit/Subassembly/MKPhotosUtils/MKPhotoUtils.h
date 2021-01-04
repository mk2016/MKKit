//
//  MKPhotoUtils.h
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MKConst.h"
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum {
    MKPHFetchAssetTypeImage     = 1 << 1,
    MKPHFetchAssetTypeVideo     = 1 << 2,
    MKPHFetchAssetTypeAll       = ~0UL
}MKPHFetchAssetType;

@class MKAlbumModel,MKAssetModel;
@interface MKPhotoUtils : NSObject
@property (nonatomic, assign) MKPHFetchAssetType showAssetType; /** 可选资源类型 */
@property (nonatomic, assign) CGSize minSize;           /** 过滤小于 minSize 的图片  */
@property (nonatomic, assign) BOOL fixOrientation;      /** 是否修正方向 */
@property (nonatomic, assign) BOOL showSelectedIndex;   /** 显示选择序号 */

@property (nonatomic, strong) UIImage *assetNormalImage;    //未选中icon
@property (nonatomic, strong) UIImage *assetSelectedImage;  //选中icon
@property (nonatomic, strong) UIImage *ablumSelectedImage;  //相册选中icon

MK_INSTANCETYPE

/** 检查相册权限 */
- (void)checkPhotoLibraryAuthWithBlock:(MKBoolBlock)block;

#pragma mark - ***** 获取所有相册 ******
- (void)getAblumListCompletion:(void (^)(NSArray<MKAlbumModel *> *albums))completion;

- (void)getAblumListByAssetType:(MKPHFetchAssetType)assetType
                ascendingByDate:(BOOL)ascending
                     completion:(void (^)(NSArray<MKAlbumModel *> *albums))completion;

- (void)getAssetsFromFetchResult:(PHFetchResult<PHAsset *> *)result
                      completion:(void (^)(NSArray<MKAssetModel *> *assetModels))completion;

#pragma mark - ***** request image with asset ******
/** 获取封面图 */
- (PHImageRequestID)requestThumbnailWithAsset:(PHAsset *)asset
                                   targetSize:(CGSize)targetSize
                                   completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion;

/** 根据 asset 获取图片  不从 iCloud 下载 */
- (PHImageRequestID)requestImageWithAsset:(PHAsset *)asset
                               targetSize:(CGSize)targetSize
                              resizeModel:(PHImageRequestOptionsResizeMode)resizeMode
                              contentMode:(PHImageContentMode)contentMode
                               completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion;

/**
 * requestImageWithAsset
 *
 * @param asset PHAsset
 * @param targetSize 要获取的尺寸
 * @param resizeMode 对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
 * @param contentMode  展示模式 fit：展示全部   fill:铺满
 * @param networkAccessAllowed   是否允许从iCloud 下载
 * @param completion   获取图片回调
 * @param progressHandler  如果从iCloud下载  下载进度
 * @return PHImageRequestID
 */
- (PHImageRequestID)requestImageWithAsset:(PHAsset *)asset
                               targetSize:(CGSize)targetSize
                              resizeModel:(PHImageRequestOptionsResizeMode)resizeMode
                              contentMode:(PHImageContentMode)contentMode
                     networkAccessAllowed:(BOOL)networkAccessAllowed
                               completion:(void (^)(UIImage *image, NSDictionary *info,BOOL isDegraded))completion
                          progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler;

/** 根据 asset 获取 imageData  */
- (PHImageRequestID)requestImageDataWithAsset:(PHAsset *)asset
                                  resizeModel:(PHImageRequestOptionsResizeMode)resizeMode
                         networkAccessAllowed:(BOOL)networkAccessAllowed
                                   completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion
                              progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler;

/** 获取原图 */
- (PHImageRequestID)requestOriginalPhotoWithAsset:(PHAsset *)asset
                                       completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion;

- (void)getPhotosBytesWithArray:(NSArray<MKAssetModel *> *)models completion:(MKStringBlock)block;

@end

NS_ASSUME_NONNULL_END
