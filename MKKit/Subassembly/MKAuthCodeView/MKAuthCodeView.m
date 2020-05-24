//
//  MKAuthCodeView.m
//  STIMProject
//
//  Created by xiaomk on 2019/6/19.
//  Copyright © 2019 mk. All rights reserved.
//

#import "MKAuthCodeView.h"
#import "MKConst.h"
#import "Masonry.h"

@interface MKAuthCodeView ()<UITextViewDelegate>
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UITextView *textView;
@property (nonatomic, strong) NSMutableArray *gridArr;
@property (nonatomic, strong) NSMutableArray *labelArr;
@property (nonatomic, strong) NSMutableArray *cursorArr;
@property (nonatomic, strong) NSMutableArray *lineArr;
@property (nonatomic, assign) BOOL inputing;
@property (nonatomic, copy) MKAuthCodeViewBlock inputBlock;
@end

@implementation MKAuthCodeView

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = UIColor.clearColor;
        self.keyBoardType = UIKeyboardTypeNumberPad;
        self.maxLenght = 6;
        self.gridBgColor = MK_COLOR_HEX(0xEFEFEF);
        self.selectedColor = MK_COLOR_HEX(0xEFEFEF);
        self.font = [UIFont boldSystemFontOfSize:24];
        self.padding = 0;
        self.space = 4;
        self.style = MKAuthCodeViewStyle_space;
    }
    return self;
}

- (void)setupUIWithBlock:(MKAuthCodeViewBlock)block{
    self.inputBlock = block;
    
    if (self.maxLenght <= 0) {
        return;
    }
    if (self.containerView) {
        [self.containerView removeFromSuperview];
    }
    self.containerView = [[UIView alloc] init];
    self.containerView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.containerView];
    
    [self.containerView addSubview:self.textView];

    [self.gridArr removeAllObjects];
    [self.labelArr removeAllObjects];
    [self.cursorArr removeAllObjects];
    [self.lineArr removeAllObjects];
    
    if (self.style == MKAuthCodeViewStyle_grille) {
        self.space = 0;
    }
    
    for (NSInteger i = 0; i < self.maxLenght; i ++) {
        UIView *grid = [[UIView alloc] init];
        if (self.style == MKAuthCodeViewStyle_space) {
            grid.layer.cornerRadius = 4;
            grid.layer.masksToBounds = YES;
            grid.layer.borderWidth = 1;
            grid.layer.borderColor = self.gridBgColor.CGColor;
        }
        grid.userInteractionEnabled = NO;
        [self.containerView addSubview:grid];
        
        UILabel *label = [[UILabel alloc] init];
        label.font = self.font;
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = self.selectedColor;
        [grid addSubview:label];
        
        CAShapeLayer *cursor = [CAShapeLayer layer];
        cursor.hidden = YES;
        [grid.layer addSublayer:cursor];

        [self.gridArr addObject:grid];
        [self.labelArr addObject:label];
        [self.cursorArr addObject:cursor];
        
        if (self.style == MKAuthCodeViewStyle_grille && i != 0) {
            CALayer *line = [[CALayer alloc] init];
            [grid.layer addSublayer:line];
            [self.lineArr addObject:line];
        }
    }
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.containerView);
    }];
    
    CGFloat gridW = (CGRectGetWidth(self.frame)-self.padding*2-(self.maxLenght-1)*self.space)/self.maxLenght;
    CGFloat gridH = CGRectGetHeight(self.frame)-self.padding*2;
    
    for (NSInteger i = 0; i < self.maxLenght; i++) {
        CGFloat x = self.padding+(gridW+self.space)*i;
        
        UIView *grid = self.gridArr[i];
        grid.frame = CGRectMake(x, self.padding, gridW, gridH);
        grid.backgroundColor = self.gridBgColor;

        UILabel *label = self.labelArr[i];
        label.frame = grid.bounds;
        label.textColor = self.selectedColor;

        if (i != 0 && i-1 < self.lineArr.count) {
            CALayer *line = self.lineArr[i-1];
            line.frame = CGRectMake(0, 0, 1, gridH);
            line.backgroundColor = MK_COLOR_HEX(0xEFEFEF).CGColor;
        }
        
        UIBezierPath *path = [UIBezierPath bezierPathWithRect:CGRectMake(CGRectGetWidth(grid.frame)/2, 10, 1, CGRectGetHeight(grid.frame)-20)];
        CAShapeLayer *cursor = self.cursorArr[i];
        cursor.path = path.CGPath;
        cursor.fillColor = self.selectedColor.CGColor;
    }
}

- (void)refreshGridWith:(NSInteger)index selected:(BOOL)selected{
    if (self.style == MKAuthCodeViewStyle_space) {
        UIView *grid = self.gridArr[index];
        grid.layer.borderColor = selected ? self.selectedColor.CGColor : self.gridBgColor.CGColor;
    }
    CAShapeLayer *cursor = self.cursorArr[index];
    cursor.hidden = !selected;
    if (!cursor.hidden) {
        [cursor addAnimation:[self opacityAnimation] forKey:@"kOpacityAnimation"];
    }else{
        [cursor removeAnimationForKey:@"kOpacityAnimation"];
    }
}

#pragma mark - ***** UITextView delegate ******
- (void)textViewDidBeginEditing:(UITextView *)textView{
    self.inputing = YES;
    NSString *codeText = textView.text;
    if (codeText.length == self.maxLenght){
        codeText = @"";
    }
    [self refreshUIWithText:codeText];
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    self.inputing = NO;
    [self refreshUIWithText:textView.text];
    MK_BLOCK_EXEC(self.inputBlock, textView.text);
}

- (void)textViewDidChange:(UITextView *)textView{
    NSString *codeText = textView.text;
    [self refreshUIWithText:codeText];
}

- (void)refreshUIWithText:(NSString *)codeText{
    codeText = [codeText stringByReplacingOccurrencesOfString:@" " withString:@""];
    self.textView.text = codeText;
    if (codeText.length >= self.maxLenght) {
        codeText = [codeText substringToIndex:self.maxLenght];
    }
    
    for (NSInteger i = 0; i < self.maxLenght; i++) {
        UILabel *label = self.labelArr[i];
        if ( i < codeText.length){
            label.text = [codeText substringWithRange:NSMakeRange(i, 1)];
            [self refreshGridWith:i selected:NO];
        }else{
            label.text = @"";
            [self refreshGridWith:i selected:(i == codeText.length && self.inputing)];
        }
        if (i == 0 && (!codeText || codeText.length == 0)) {
            [self refreshGridWith:0 selected:self.inputing];
        }
    }
    
    if (codeText.length == self.maxLenght && [self.textView isFirstResponder]) {
        [self.textView resignFirstResponder];
    }
}


#pragma mark - ***** method ******
- (void)startInput{
    [self.textView becomeFirstResponder];
}

- (void)setCode:(NSString *)code{
    [self refreshUIWithText:code];
}

#pragma mark - ***** lazy ******
- (CABasicAnimation *)opacityAnimation{
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = @(1.0);
    opacityAnimation.toValue = @(0.0);
    opacityAnimation.duration = 0.9;
    opacityAnimation.repeatCount = HUGE_VALF;
    opacityAnimation.removedOnCompletion = YES;
    opacityAnimation.fillMode = kCAFillModeForwards;
    opacityAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    return opacityAnimation;
}

- (UITextView *)textView{
    if (!_textView) {
        _textView = [[UITextView alloc] init];
        _textView.backgroundColor = [UIColor clearColor];
        _textView.tintColor = [UIColor clearColor];
        _textView.textColor = [UIColor clearColor];
        _textView.delegate = self;
        _textView.keyboardType = self.keyBoardType;
    }
    return _textView;
}

- (NSMutableArray *)gridArr{
    if (!_gridArr) {
        _gridArr = [NSMutableArray new];
    }
    return _gridArr;
}

- (NSMutableArray *)labelArr{
    if (!_labelArr) {
        _labelArr = [NSMutableArray new];
    }
    return _labelArr;
}

- (NSMutableArray *)cursorArr{
    if (!_cursorArr) {
        _cursorArr = [NSMutableArray new];
    }
    return _cursorArr;
}

- (NSMutableArray *)lineArr{
    if (!_lineArr) {
        _lineArr = [NSMutableArray new];
    }
    return _lineArr;
}


@end
