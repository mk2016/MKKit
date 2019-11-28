//
//  MKTextView.h
//  TQMapAbility
//
//  Created by xmk on 2017/5/22.
//  Copyright © 2017年 taoqi. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MKTextViewDidChangeBlock)(UITextView *textView);

@interface MKTextView : UITextView
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, assign) NSInteger maxLenth;
@property (nonatomic, copy) MKTextViewDidChangeBlock didChangeBlock;
@end
