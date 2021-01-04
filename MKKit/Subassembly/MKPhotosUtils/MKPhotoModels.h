//
//  MKAlbumModel.h
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

NS_ASSUME_NONNULL_BEGIN

typedef enum : NSUInteger {
    MKAssetMediaTypeUnkonw      = 0,
    MKAssetMediaTypePhoto       = 1 << 1,
    MKAssetMediaTypeLivePhoto   = 1 << 2,
    MKAssetMediaTypePhotoGif    = 1 << 3,
    MKAssetMediaTypeVideo       = 1 << 4,
    MKAssetMediaTypeAudio       = 1 << 5,
    MKAssetMediaTypeAll         = ~0UL
} MKAssetMediaType;



@class MKAssetModel;

//相册
@interface MKAlbumModel : NSObject
@property (nonatomic, copy) NSString *title;        
@property (nonatomic, assign) NSInteger count;
@property (nonatomic, strong) PHAsset *coverAsset;  //封面
@property (nonatomic, strong) PHFetchResult<PHAsset *> *assets;     //资源数组
@property (nonatomic, strong) PHAssetCollection *collection;        //资源集合

@property (nonatomic, copy) NSArray <MKAssetModel *> *assetModels;  //资源数组
@property (nonatomic, copy) NSArray <MKAssetModel *> *selectedInfos;//选中数组
@property (nonatomic, assign) NSUInteger selectedCount;             //选中数量
@property (nonatomic, assign) BOOL isCameraRoll;
@end

@interface MKAssetModel : NSObject
@property (nonatomic, strong) PHAsset *asset;
@property (nonatomic, strong) UIImage *coverImage;  //缩略图
@property (nonatomic, strong) UIImage *HDImage;     //高清原图，原图按比例缩放到 手机屏幕大小
@property (nonatomic, strong) UIImage *originImage; //原图，实际图片像素尺寸
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, assign) MKAssetMediaType type;
@property (nonatomic, copy) NSString *videoTime;
@property (nonatomic, assign) BOOL needOscillatoryAnimation;
@property (nonatomic, assign) BOOL loading;
@end
NS_ASSUME_NONNULL_END
