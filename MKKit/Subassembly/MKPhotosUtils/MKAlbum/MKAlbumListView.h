//
//  MKAlbumListView.h
//  MKKit
//
//  Created by xiaomk on 2020/9/14.
//  Copyright © 2020 taolang. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MKConst.h"

NS_ASSUME_NONNULL_BEGIN

@class MKAlbumModel;
@interface MKAlbumListView : UIView
@property (nonatomic, copy) MKIntegerBlock selectedBlock;
- (id)initWithY:(CGFloat)y;
- (void)setupUIWith:(NSArray *)datas;
- (void)showWithSelected:(NSInteger)index;
- (void)remove;
@end

NS_ASSUME_NONNULL_END
