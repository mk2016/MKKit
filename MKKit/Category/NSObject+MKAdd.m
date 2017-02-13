//
//  NSObject+MKAdd.m
//  MKKit
//
//  Created by xmk on 2017/2/13.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "NSObject+MKAdd.h"

@implementation NSObject (MKAdd)

- (id)copySelfPerfect{
    if (self) {
        return [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self]];
    }else{
        return nil;
    }
}

@end
