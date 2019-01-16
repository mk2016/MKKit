//
//  UITextField+MKAdd.h
//  MKToolsKit
//
//  Created by xmk on 2017/4/8.
//  Copyright © 2017年 mk. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (MKAdd)

/**
 * TextField input money max integer length limit
 */
- (void)mk_constraintMoneyByIntegerLimit:(NSInteger)length;

@end
