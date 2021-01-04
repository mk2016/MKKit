//
//  MKAlbumListCell.h
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class MKAlbumModel;
@interface MKAlbumListCell : UITableViewCell
@property (nonatomic, strong) UIImageView *imgCover;
@property (nonatomic, strong) UILabel *labTitle;
@property (nonatomic, strong) UILabel *labCount;
@property (nonatomic, assign) BOOL isSelected;
@property (nonatomic, strong) MKAlbumModel *model;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
