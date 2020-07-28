//
//  MKTextView.h
//  TQMapAbility
//
//  Created by xiaomk on 2017/5/22.
//  Copyright © 2017 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^MKTextViewDidChangeBlock)(UITextView *textView);

@interface MKTextView : UITextView
@property (nonatomic, strong) UIColor *placeholderColor;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, assign) NSInteger maxLenth;
@property (nonatomic, copy) MKTextViewDidChangeBlock didChangeBlock;
@end
