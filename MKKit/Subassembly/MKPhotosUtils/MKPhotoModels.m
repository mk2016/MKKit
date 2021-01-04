//
//  MKAlbumModel.m
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "MKPhotoModels.h"
#import "MKPhotoUtils.h"
#import "MJExtension.h"

@implementation MKAlbumModel
@end

@implementation MKAssetModel
MJCodingImplementation
+ (NSArray *)mj_ignoredCodingPropertyNames{
    return @[@"asset"];
}

@end
