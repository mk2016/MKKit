//
//  NSMutableURLRequest+MKAdd.h
//  Taoqicar
//
//  Created by xmk on 2017/4/13.
//  Copyright © 2017年 taoqicar. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AdSupport/AdSupport.h>
#import "HappyDNS.h"

@interface NSMutableURLRequest (MKAdd)

- (void)mk_switchToIp;
- (NSString *)mk_getIp;

@end
