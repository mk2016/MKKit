//
//  UIViewController+MKAdd.m
//  MKKit
//
//  Created by MK on 2021/4/30.
//  Copyright © 2021 mk. All rights reserved.
//

#import "UIViewController+MKAdd.h"

@implementation UIViewController (MKAdd)

+ (id)mk_createWithStoryboard:(NSString *)storyboard identify:(NSString *)identify{
    return [[UIStoryboard storyboardWithName:storyboard bundle:nil] instantiateViewControllerWithIdentifier:identify];
}

@end
