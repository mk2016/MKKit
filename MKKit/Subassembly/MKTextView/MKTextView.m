//
//  MKTextView.m
//  TQMapAbility
//
//  Created by xmk on 2017/5/22.
//  Copyright © 2017年 taoqi. All rights reserved.
//

#import "MKTextView.h"
#import "Masonry.h"
#import "MKConst.h"

@interface MKTextView ()
@property (nonatomic, strong) UILabel *labPlaceholder;
@end

@implementation MKTextView

- (void)awakeFromNib{
    [super awakeFromNib];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name:UITextViewTextDidChangeNotification object:nil];
    }
    return self;
}

- (void)textChanged:(NSNotification *)notification{
    self.labPlaceholder.alpha = self.text.length == 0 ? 1 : 0;

    if (self.text.length > 0) {
        UITextRange *selectedRange = [self markedTextRange];
        NSString *newText = [self textInRange:selectedRange];
        if (newText.length > 0) return;
    }
    
    if (self.maxLenth > 0 && self.text.length > self.maxLenth) {
        self.text = [self.text substringToIndex:self.maxLenth];
    }
    MK_BLOCK_EXEC(self.didChangeBlock,self);
}

- (void)setText:(NSString *)text{
    [super setText:text];
    [self textChanged:nil];
}

- (void)setPlaceholder:(NSString *)placeholder{
    _placeholder = placeholder;
    self.labPlaceholder.text = _placeholder;
    
    if (self.text.length == 0 && _placeholder.length > 0) {
        self.labPlaceholder.alpha = 1;
    }else{
        self.labPlaceholder.alpha = 0;
    }
    [self layoutIfNeeded];
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_labPlaceholder) {
        [_labPlaceholder mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).offset(4);
            make.top.equalTo(self).offset(8);
            if (self.frame.size.width > 0) {
                make.width.mas_equalTo(self.frame.size.width-8);
            }
        }];
    }
}

- (void)dealloc{
    DLog(@"♻️ dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (UILabel *)labPlaceholder{
    if (!_labPlaceholder) {
        _labPlaceholder = [[UILabel alloc] init];
        _labPlaceholder.lineBreakMode = NSLineBreakByWordWrapping;
        _labPlaceholder.numberOfLines = 0;
        _labPlaceholder.font = self.font;
        _labPlaceholder.backgroundColor = [UIColor clearColor];
        _labPlaceholder.textColor = self.placeholderColor;
        [_labPlaceholder sizeToFit];
        _labPlaceholder.alpha = 0;
        [self addSubview:_labPlaceholder];
        [self sendSubviewToBack:_labPlaceholder];
    }
    return _labPlaceholder;
}

- (UIColor *)placeholderColor{
    if (!_placeholderColor) {
        _placeholderColor = [UIColor lightGrayColor];
    }
    return _placeholderColor;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
