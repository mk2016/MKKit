//
//  UITextField+MKAdd.m
//  MKKit
//
//  Created by xmk on 2017/4/8.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "UITextField+MKAdd.h"

@implementation UITextField (MKAdd)


- (void)mk_setPlaceholder:(NSString *)text color:(UIColor *)color{
    if(@available(iOS 13.0, *)) {
        self.attributedPlaceholder = [[NSAttributedString alloc] initWithString:text attributes:@{NSForegroundColorAttributeName : color}];
    }else{
        [self setValue:color forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)mk_verifyPhoneNum{
    NSString *oStr = self.text;
    NSString *filterStr = [oStr stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [oStr length])];
    if (filterStr.length > 11) {
        filterStr = [filterStr substringToIndex:11];
    }
    self.text = filterStr;
}

- (void)mk_constraintMoneyByIntegerLimit:(NSInteger)length{
    if (self.text.length > 1) {
        NSString *frist = [self.text substringToIndex:1];
        NSString *second = [self.text substringWithRange:NSMakeRange(1, 1)];
        if ([frist isEqualToString:@"0"] && ![second isEqualToString:@"."]) {
            //remove first character "0"
            self.text = [self.text substringWithRange:NSMakeRange(1, self.text.length-1)];
        }
    }
    
    NSRange range = [self.text rangeOfString:@"."];
    if (range.location != NSNotFound) { // had "."
        if (self.text.length == 1) {
            self.text = @"0.";          //if first character is '.'   auto add "0" on front
            return;
        }
        if (self.text.length > range.location+1) {
            NSString *lastStr = [self.text substringFromIndex:self.text.length-1];
            if ([lastStr isEqualToString:@"."]) {   //if last character is '.'   remove last character
                self.text = [self.text substringToIndex:self.text.length-1];
            }
        }
        
        if (length > 0) {
            if (self.text.length > length + 3) {    //  x.00
                self.text = [self.text substringToIndex:length + 3];
            }
        }
        
        if (range.location < self.text.length - 2) {
            self.text = [self.text substringToIndex:range.location + 3];
        }
        self.text = [self.text stringByReplacingOccurrencesOfString:@".." withString:@"."];
        if ([self.text rangeOfString:@"."].location == 0) {
            self.text = [self.text stringByReplacingOccurrencesOfString:@"." withString:@""];
        }
    } else { // no '.'
        if (length > 0) {
            if (self.text.length > length) {
                self.text = [self.text substringToIndex:length];
            }
        }
    }
}
@end
