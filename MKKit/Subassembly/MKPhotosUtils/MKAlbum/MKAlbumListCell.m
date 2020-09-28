//
//  MKAlbumListCell.m
//  Fanmugua
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import "MKAlbumListCell.h"
#import "MKPhotoUtils.h"
#import "Masonry.h"

@interface MKAlbumListCell ()
@property (nonatomic, strong) UIImageView *imgSelected;
@end

@implementation MKAlbumListCell

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

- (UIImageView *)imgSelected{
    if (!_imgSelected) {
        _imgSelected = [[UIImageView alloc] initWithImage:[MKPhotoUtils sharedInstance].ablumSelectedImage];
        [self.contentView addSubview:_imgSelected];
        [_imgSelected mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.contentView);
            make.right.equalTo(self.contentView).offset(-20);
        }];
    }
    return _imgSelected;
}

+ (CGFloat)cellHeight{
    return 54;
}
@end
