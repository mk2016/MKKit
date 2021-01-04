//
//  MKAlbumListCell.m
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "MKAlbumListCell.h"
#import "MKPhotoUtils.h"
#import "Masonry.h"
#import "MKPhotoModels.h"

@interface MKAlbumListCell ()
@property (nonatomic, strong) UIImageView *imgSelected;
@end

@implementation MKAlbumListCell

- (void)setModel:(MKAlbumModel *)model{
    _model = model;
    if (_model) {
        self.labTitle.text = model.title;
        self.labCount.text = [NSString stringWithFormat:@"(%@)",@(model.count)];
        MK_WEAK_SELF
        [[MKPhotoUtils sharedInstance] requestThumbnailWithAsset:model.coverAsset
                                                      targetSize:CGSizeMake([MKAlbumListCell cellHeight], [MKAlbumListCell cellHeight])
                                                      completion:^(UIImage * _Nonnull image, NSDictionary * _Nonnull info, BOOL isDegraded) {
            weakSelf.imgCover.image = image;
        }];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setIsSelected:(BOOL)isSelected{
    _isSelected = isSelected;
    self.imgSelected.hidden = !_isSelected;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    
    [self.imgCover mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.width.mas_equalTo(self.contentView.mas_height);
    }];
    
    [self.labTitle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.imgCover.mas_right).offset(8);
    }];
    
    [self.labCount mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.left.equalTo(self.labTitle.mas_right).offset(4);
    }];
    
    [self.imgSelected mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView);
        make.right.equalTo(self.contentView).offset(-20);
    }];
}

#pragma mark - ***** lazy ******
- (UIImageView *)imgSelected{
    if (!_imgSelected) {
        _imgSelected = [[UIImageView alloc] initWithImage:[MKPhotoUtils sharedInstance].ablumSelectedImage];
        [self.contentView addSubview:_imgSelected];
    }
    return _imgSelected;
}

- (UIImageView *)imgCover{
    if (!_imgCover) {
        _imgCover = [[UIImageView alloc] init];
        [self.contentView addSubview:_imgCover];
    }
    return _imgCover;
}

- (UILabel *)labTitle{
    if (!_labTitle) {
        _labTitle = [[UILabel alloc] init];
        _labTitle.textColor = MK_COLOR_HEX(0x333333);
        _labTitle.font = MK_FONT_SYS(16);
        [self.contentView addSubview:_labTitle];
    }
    return _labTitle;
}

- (UILabel *)labCount{
    if (!_labCount) {
        _labCount = [[UILabel alloc] init];
        _labCount.textColor = MK_COLOR_HEX(0x888888);
        _labCount.font = MK_FONT_SYS(14);
        [self.contentView addSubview:_labCount];
    }
    return _labCount;
}

+ (CGFloat)cellHeight{
    return 54;
}
@end
