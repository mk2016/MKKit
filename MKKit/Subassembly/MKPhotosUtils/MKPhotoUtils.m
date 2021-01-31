//
//  MKPhotoUtils.m
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "MKPhotoUtils.h"
#import <Photos/Photos.h>
#import "MKPhotoModels.h"
#import "UIImage+MKAdd.h"

@interface MKPhotoUtils ()
@property (nonatomic, strong) PHCachingImageManager *cachingImageManager;
@end

@implementation MKPhotoUtils

MK_IMPL_SHAREDINSTANCE(MKPhotoUtils)
- (id)init{
    if (self = [super init]) {
        [self config];
    }
    return self;
}

- (void)config{
    _showAssetType = MKPHFetchAssetTypeImage;
    _minSize = CGSizeMake(0, 0);
    _fixOrientation = NO;
    _showSelectedIndex = YES;
    
    NSString *bundle = [[NSBundle bundleForClass:self.class] pathForResource:@"MKPhotosUtils" ofType:@"bundle"];
    NSString *path1 = [bundle stringByAppendingPathComponent:@"img_selected_0.png"];
    self.assetNormalImage = [UIImage imageWithContentsOfFile:path1];
    
    if (_showSelectedIndex) {
        self.assetSelectedImage = [UIImage mk_imageWithColor:MK_COLOR_RGB(31, 185, 34) size:CGSizeMake(24, 24) cornerRadius:12];
    }else{
        NSString *path2 = [bundle stringByAppendingPathComponent:@"img_selected_1.png"];
        self.assetSelectedImage = [UIImage imageWithContentsOfFile:path2];
    }
    self.ablumSelectedImage = [UIImage imageWithContentsOfFile:[bundle stringByAppendingPathComponent:@"icon_selected.png"]];
}

/** 检查相册权限 */
- (void)checkPhotoLibraryAuthWithBlock:(void(^)(BOOL ret, PHAuthorizationStatus status))block{
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    switch (status) {
        case PHAuthorizationStatusNotDetermined:{
            [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
                MK_BLOCK_EXEC(block,
                              status == PHAuthorizationStatusAuthorized ||
                              status == PHAuthorizationStatusLimited,
                              status);
            }];
        }
            break;
        case PHAuthorizationStatusLimited:
        case PHAuthorizationStatusAuthorized:
            MK_BLOCK_EXEC(block, YES, status);
            break;
        case PHAuthorizationStatusRestricted:
        case PHAuthorizationStatusDenied:
            MK_BLOCK_EXEC(block, NO, status);
            break;
        default:
            MK_BLOCK_EXEC(block, NO, status);
            break;
    }
}

#pragma mark - ***** 获取所有相册 ******
- (void)getAblumListCompletion:(void (^)(NSArray<MKAlbumModel *> *albums))completion{
    [self getAblumListByAssetType:self.showAssetType ascendingByDate:NO completion:completion];
}

- (void)getAblumListByAssetType:(MKPHFetchAssetType)assetType ascendingByDate:(BOOL)ascending completion:(void (^)(NSArray<MKAlbumModel *> *albums))completion{
    NSMutableArray *albumArr = @[].mutableCopy;

    PHFetchResult *smartAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    PHFetchResult *userAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeSmartAlbumUserLibrary options:nil];
//    PHFetchResult *myPhotoStreamAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumMyPhotoStream options:nil];
//    PHFetchResult *syncedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumSyncedAlbum options:nil];
//    PHFetchResult *sharedAlbums = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumCloudShared options:nil];

    NSArray *allAlbums = @[smartAlbums,userAlbums];
    for (PHFetchResult *fetchResult in allAlbums) {
        for (PHAssetCollection *collection in fetchResult) {
            if (![collection isKindOfClass:[PHAssetCollection class]]) continue;
            if (collection.estimatedAssetCount <= 0) continue;
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumAllHidden) continue;
            if (collection.assetCollectionSubtype == 1000000201) continue; //最近删除 相册

            PHFetchResult<PHAsset *> *assets = [self fetchAssetsFromCollection:collection assetsType:assetType ascendingByDate:NO];
            if (assets.count < 1) continue;
//            if ([delegate respondsToSelector:@selector(isAlbumCanSelect:result:)]) {
//                if (![delegate isAlbumCanSelect:collection.localizedTitle result:fetchResult]) {
//                    continue;
//                }
//            }
            MKAlbumModel *model = [[MKAlbumModel alloc] init];
            model.title = collection.localizedTitle;
            model.count = assets.count;
            model.coverAsset = assets.firstObject;
            model.assets = assets;
            model.collection = collection;
            [self getAssetsFromFetchResult:assets completion:^(NSArray<MKAssetModel *> * _Nonnull assetModels) {
                model.assetModels = assetModels;
            }];
            if (collection.assetCollectionSubtype == PHAssetCollectionSubtypeSmartAlbumUserLibrary) {
                [albumArr insertObject:model atIndex:0];
            }else{
                [albumArr addObject:model];
            }
        }
    }
    MK_BLOCK_EXEC(completion,albumArr);
}

//获取相册内的所有资源
- (PHFetchResult *)fetchAssetsFromCollection:(PHAssetCollection *)collection
                                  assetsType:(MKPHFetchAssetType)assetsType
                             ascendingByDate:(BOOL)ascending{
    PHFetchOptions *option = [[PHFetchOptions alloc] init];
    if (!(assetsType & MKPHFetchAssetTypeImage)){
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %@", @(PHAssetMediaTypeVideo)];
    }
    if (!(assetsType & MKPHFetchAssetTypeVideo)){
        option.predicate = [NSPredicate predicateWithFormat:@"mediaType == %@", @(PHAssetMediaTypeImage)];
    }
    // 对照片排序，按修改时间升序，默认是YES。如果设置为NO,最新的照片会显示在最前面，内部的拍照按钮会排在第一个
    if (!ascending) {
        option.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:ascending]];
    }
    PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:collection options:option];
    return result;
}

//相册 PHAsset 数组 转 MKAssetModel
- (void)getAssetsFromFetchResult:(PHFetchResult<PHAsset *> *)result
                      completion:(void (^)(NSArray<MKAssetModel *> *assetModels))completion{
    NSMutableArray *photoArray = @[].mutableCopy;
    [result enumerateObjectsUsingBlock:^(PHAsset * _Nonnull asset, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([[MKPhotoUtils sharedInstance] checkPhotoSize:asset]) {
            MKAssetModel *model = [[MKAssetModel alloc] init];
            model.asset = asset;
            model.isSelected = NO;
            model.type = [self getAssetType:asset];
            if (asset.mediaType == PHAssetMediaTypeVideo) {
                NSString *timeStr = [NSString stringWithFormat:@"%0.0f",asset.duration];
                model.videoTime = [self getTimeByDurationSecond:timeStr.integerValue];
            }
            [photoArray addObject:model];
        }
    }];
    MK_BLOCK_EXEC(completion, photoArray);
}

- (BOOL)checkPhotoSize:(PHAsset *)asset{
    CGSize photoSize = CGSizeMake(asset.pixelWidth, asset.pixelHeight);
    if (self.minSize.width > photoSize.width || self.minSize.height > photoSize.height) {
        return NO;
    }
    return YES;
}

- (MKAssetMediaType)getAssetType:(PHAsset *)asset{
    MKAssetMediaType type = MKAssetMediaTypeUnkonw;
    if (asset.mediaType == PHAssetMediaTypeVideo) {
        type = MKAssetMediaTypeVideo;
    }else if (asset.mediaType == PHAssetMediaTypeAudio){
        type = MKAssetMediaTypeAudio;
    }else if (asset.mediaType == PHAssetMediaTypeImage){
        if ([[asset valueForKey:@"filename"] hasSuffix:@"GIF"]) {
            type = MKAssetMediaTypePhotoGif;
        }else{
            type = MKAssetMediaTypePhoto;
        }
    }
    return type;
}

#pragma mark - ***** request image with asset ******
/** 获取封面图 */
- (PHImageRequestID)requestThumbnailWithAsset:(PHAsset *)asset
                                   targetSize:(CGSize)targetSize
                                   completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion{
    targetSize = CGSizeMake(targetSize.width*3, targetSize.height*3);
    if (targetSize.width > asset.pixelWidth) {
        targetSize.width = asset.pixelWidth;
    }
    if (targetSize.height > asset.pixelHeight) {
        targetSize.height = asset.pixelHeight;
    }
    return [self requestImageWithAsset:asset
                            targetSize:targetSize
                           resizeModel:PHImageRequestOptionsResizeModeFast
                           contentMode:PHImageContentModeAspectFill
                            completion:completion];
}

/** 根据 asset 获取图片  不从 iCloud 下载 */
- (PHImageRequestID)requestImageWithAsset:(PHAsset *)asset
                               targetSize:(CGSize)targetSize
                              resizeModel:(PHImageRequestOptionsResizeMode)resizeMode
                              contentMode:(PHImageContentMode)contentMode
                               completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion{
    return [self requestImageWithAsset:asset
                            targetSize:targetSize
                           resizeModel:resizeMode
                           contentMode:contentMode
                  networkAccessAllowed:NO
                            completion:completion
                       progressHandler:nil];
}

/**
 * request image with asset
 *
 * @param asset PHAsset
 * @param targetSize 要获取的尺寸
 * @param resizeMode 对请求的图像怎样缩放。有三种选择：None，默认加载方式；Fast，尽快地提供接近或稍微大于要求的尺寸；Exact，精准提供要求的尺寸。
 * @param contentMode  展示模式 fit：展示全部   fill:铺满
 * @param networkAccessAllowed   是否允许从iCloud 下载
 * @param completion   获取图片回调
 * @param progressHandler  如果从iCloud下载  下载进度
 * @return PHImageRequestID
 *
 * deliveryMode 图像质量。
 *        有三种值：Opportunistic，在速度与质量中均衡；HighQualityFormat，不管花费多长时间，提供高质量图像；FastFormat，以最快速度提供好的质量。
 *        这个属性只有在 synchronous 为 true 时有效。
 *
 * info字典提供请求状态信息:
 * PHImageResultIsInCloudKey：图像是否必须从iCloud请求
 * PHImageResultIsDegradedKey：当前UIImage是否是低质量的，这个可以实现给用户先显示一个预览图
 * PHImageResultRequestIDKey和PHImageCancelledKey：请求ID以及请求是否已经被取消
 * PHImageErrorKey：如果没有图像，字典内的错误信息
 */
- (PHImageRequestID)requestImageWithAsset:(PHAsset *)asset
                               targetSize:(CGSize)targetSize
                              resizeModel:(PHImageRequestOptionsResizeMode)resizeMode
                              contentMode:(PHImageContentMode)contentMode
                     networkAccessAllowed:(BOOL)networkAccessAllowed
                               completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion
                          progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler{
    
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.resizeMode = resizeMode;
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:targetSize contentMode:contentMode options:option resultHandler:^(UIImage * _Nullable image, NSDictionary * _Nullable info) {
        BOOL finined = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (finined && image) {
            if (self.fixOrientation) {
                image = [image mk_fixOrientation];
            }
            MK_BLOCK_EXEC(completion, image, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
        }
        if ([info objectForKey:PHImageResultIsInCloudKey] && !image && networkAccessAllowed) {
            [self requestImageDataWithAsset:asset
                                resizeModel:PHImageRequestOptionsResizeModeFast
                       networkAccessAllowed:YES completion:^(NSData * _Nonnull imageData, NSString * _Nonnull dataUTI, UIImageOrientation orientation, NSDictionary * _Nonnull info) {
                UIImage *resultImage = [UIImage imageWithData:imageData];
                [resultImage mk_scaleToSize:targetSize];
                if (self.fixOrientation) {
                    [resultImage mk_fixOrientation];
                }
                mk_dispatch_async_on_main_queue(^{
                    MK_BLOCK_EXEC(completion, resultImage, info, [[info objectForKey:PHImageResultIsDegradedKey] boolValue]);
                });
            } progressHandler:progressHandler];
        }
    }];
    return requestId;
}

/** 根据 asset 获取 imageData  */
- (PHImageRequestID)requestImageDataWithAsset:(PHAsset *)asset
                                  resizeModel:(PHImageRequestOptionsResizeMode)resizeMode
                         networkAccessAllowed:(BOOL)networkAccessAllowed
                                   completion:(void (^)(NSData *imageData, NSString *dataUTI, UIImageOrientation orientation, NSDictionary *info))completion
                              progressHandler:(PHAssetImageProgressHandler _Nullable)progressHandler{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.progressHandler = progressHandler;
    option.networkAccessAllowed = networkAccessAllowed;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageDataForAsset:asset
                                                                                   options:option
                                                                             resultHandler:^(NSData * _Nullable imageData, NSString * _Nullable dataUTI, UIImageOrientation orientation, NSDictionary * _Nullable info) {
        mk_dispatch_async_on_main_queue(^{
            MK_BLOCK_EXEC(completion, imageData, dataUTI, orientation, info);
        });
    }];
    return requestId;
}


/** 获取原图 */
- (PHImageRequestID)requestOriginalPhotoWithAsset:(PHAsset *)asset completion:(void (^)(UIImage *image, NSDictionary *info, BOOL isDegraded))completion{
    PHImageRequestOptions *option = [[PHImageRequestOptions alloc] init];
    option.networkAccessAllowed = YES;
    option.resizeMode = PHImageRequestOptionsResizeModeFast;
    PHImageRequestID requestId = [[PHImageManager defaultManager] requestImageForAsset:asset
                                                                            targetSize:PHImageManagerMaximumSize
                                                                           contentMode:PHImageContentModeAspectFill
                                                                               options:option
                                                                         resultHandler:^(UIImage *image, NSDictionary *info) {
        //PHImageCancelledKey：取消   PHImageErrorKey：错误
        BOOL finish = (![[info objectForKey:PHImageCancelledKey] boolValue] && ![info objectForKey:PHImageErrorKey]);
        if (finish && image) {
            if (self.fixOrientation) {
                image = [image mk_fixOrientation];
            }
            BOOL isDegraded = [[info objectForKey:PHImageResultIsDegradedKey] boolValue];   //是否低清
            mk_dispatch_async_on_main_queue(^{
                MK_BLOCK_EXEC(completion, image, info, isDegraded);
            });
        }
    }];
    return requestId;
}

- (void)getPhotosBytesWithArray:(NSArray<MKAssetModel *> *)models completion:(MKStringBlock)block{
    if (!models || models.count == 0) {
        MK_BLOCK_EXEC(block, @"0B");
        return;
    }
    __block NSInteger assetCount = 0;
    __block NSInteger dataLength = 0;
    for (NSInteger i = 0; i < models.count; i++) {
        MKAssetModel *model = models[i];
        [self requestImageDataWithAsset:model.asset resizeModel:PHImageRequestOptionsResizeModeFast
                   networkAccessAllowed:YES
                             completion:^(NSData * _Nonnull imageData, NSString * _Nonnull dataUTI, UIImageOrientation orientation, NSDictionary * _Nonnull info) {
            dataLength += imageData.length;
            assetCount ++;
            if (assetCount >= models.count) {
                NSString *str = [self getBytesFromDataLength:dataLength];
                MK_BLOCK_EXEC(block, str);
            }
        } progressHandler:nil];
    }
}

- (NSString *)getBytesFromDataLength:(NSInteger)dataLength {
    NSString *bytes;
    if (dataLength >= 0.1 * (1024 * 1024)) {
        bytes = [NSString stringWithFormat:@"%0.1fM",dataLength/1024/1024.0];
    } else if (dataLength >= 1024) {
        bytes = [NSString stringWithFormat:@"%0.0fK",dataLength/1024.0];
    } else {
        bytes = [NSString stringWithFormat:@"%zdB",dataLength];
    }
    return bytes;
}

#pragma mark - ***** Other ******
/** 视频时间 转换  00:00 */
- (NSString *)getTimeByDurationSecond:(NSInteger)duration {
    NSString *newTime;
    NSInteger min = duration / 60;
    NSInteger sec = duration % 60;;
    if (sec < 10) {
        newTime = [NSString stringWithFormat:@"%@:0%@",@(min),@(sec)];
    } else {
        newTime = [NSString stringWithFormat:@"%@:%@",@(min),@(sec)];
    }
    return newTime;
}
@end
