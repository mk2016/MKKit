//
//  MKOverView.h
//  MKKit
//
//  Created by xiaomk on 2019/6/6.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger, MKOverViewStyle) {
    MKOverViewStyle_corner = 0,
    MKOverViewStyle_solidLine,
    MKOverViewStyle_dashed,
};

@interface MKOverView : UIView
@property (assign, nonatomic) MKOverViewStyle style;    /*!< 是否只显示角标 default:NO */
@property (assign, nonatomic) CGFloat cornerLength;     /*!< Corner length，style == corner 有效  */
@property (assign, nonatomic) BOOL hollowOut;           /*!< 是否镂空 default:NO */

- (void)setFourPoints:(NSArray *)points;
- (void)hide;
@end

NS_ASSUME_NONNULL_END
