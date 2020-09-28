//
//  MKAlbumListCell.h
//  Fanmugua
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKAlbumListCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgCover;
@property (weak, nonatomic) IBOutlet UILabel *labTitle;
@property (weak, nonatomic) IBOutlet UILabel *labCount;
@property (nonatomic, assign) BOOL isSelected;
+ (CGFloat)cellHeight;
@end

NS_ASSUME_NONNULL_END
