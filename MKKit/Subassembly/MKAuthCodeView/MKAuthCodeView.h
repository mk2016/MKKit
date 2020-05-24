//
//  MKAuthCodeView.h
//  STIMProject
//
//  Created by xiaomk on 2019/6/19.
//  Copyright © 2019 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, MKAuthCodeViewStyle) {
    MKAuthCodeViewStyle_space = 0,
    MKAuthCodeViewStyle_grille,
};

NS_ASSUME_NONNULL_BEGIN
typedef void(^MKAuthCodeViewBlock)(NSString *text);

@interface MKAuthCodeView : UIView
@property (nonatomic, assign) NSInteger maxLenght;      //格子数
@property (nonatomic, assign) UIKeyboardType keyBoardType;  //键盘类型，默认 数字类型
@property (nonatomic, strong) UIColor *gridBgColor;     //格子色
@property (nonatomic, strong) UIColor *selectedColor;   //选中色
@property (nonatomic, strong) UIFont *font;
@property (nonatomic, assign) CGFloat padding;      //边距
@property (nonatomic, assign) CGFloat space;        //间隔
@property (nonatomic, assign) NSInteger style;      //space | grille

- (void)setupUIWithBlock:(MKAuthCodeViewBlock)block;
- (void)startInput;
- (void)setCode:(NSString *)code;
@end

NS_ASSUME_NONNULL_END
