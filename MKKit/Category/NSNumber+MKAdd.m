//
//  NSNumber+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2020/4/18.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSNumber+MKAdd.h"

@implementation NSNumber (MKAdd)
- (NSNumber *)mk_roundKeep2Decimal{
    if (self) {
        int i = roundf(self.floatValue * 100);
        return @(i/100.f);
    }
    return self;
}
@end
