//
//  UITextField+MKAdd.h
//  MKKit
//
//  Created by xiaomk on 2017/4/8.
//  Copyright © 2017 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MKAdd)


- (void)mk_setPlaceholder:(NSString *)text color:(UIColor *)color;
    
- (void)mk_verifyPhoneNum;

/**
 * TextField input money max integer length limit
 */
- (void)mk_constraintMoneyByIntegerLimit:(NSInteger)limit;

@end
