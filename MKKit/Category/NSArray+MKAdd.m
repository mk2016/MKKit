//
//  NSArray+MKAdd.m
//  MKKit
//
//  Created by xiaomk on 2019/2/13.
//  Copyright © 2019 mk. All rights reserved.
//

#import "NSArray+MKAdd.h"

@implementation NSArray (MKAdd)

- (NSArray *)mk_getNoRepeatSortLettersWithKey:(NSString *)letterKey{
    if (!self || self.count == 0 ) {
        return nil;
    }
    NSArray *letterArray = [self valueForKey:letterKey];
    NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
    for (NSString *letter in letterArray) {
        if (letter && ![letter isEqual:[NSNull null]]) {
            [tempDic setObject:letter.uppercaseString forKey:letter.uppercaseString];
        }
    }

    NSSortDescriptor *desc = [NSSortDescriptor sortDescriptorWithKey:nil ascending:YES];
    NSArray *descArray = [NSArray arrayWithObject:desc];
    NSArray *sortArray = [tempDic.allValues sortedArrayUsingDescriptors:descArray];
    return sortArray;

}
@end
