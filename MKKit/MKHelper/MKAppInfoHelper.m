//
//  MKAppInfoHelper.m
//  MKKit
//
//  Created by xmk on 2017/2/15.
//  Copyright © 2017年 mk. All rights reserved.
//

#import "MKAppInfoHelper.h"

@implementation MKAppInfoHelper

/** app URL schemes */
+ (NSArray *)appUrlSchemes{
    NSMutableArray *appUrlSchemes = [NSMutableArray array];
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    for (NSDictionary *dic in infoDictionary[@"CFBundleURLTypes"]) {
        NSString *appUrlScheme = dic[@"CFBundleURLSchemes"][0];
        [appUrlSchemes addObject:appUrlScheme];
    }
    return [appUrlSchemes copy];
}

@end
