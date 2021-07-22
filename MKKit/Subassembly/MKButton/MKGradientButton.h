//
//  MKGradientButton.h
//  Huaya
//
//  Created by MK on 2021/7/22.
//  Copyright © 2021 taolang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface MKGradientButton : UIButton
- (void)setStartColors:(NSArray <UIColor *> *)colors;
- (void)setBackgroundImageWithColors:(NSArray<UIColor *> *)colors forState:(UIControlState)state;
@end

NS_ASSUME_NONNULL_END
