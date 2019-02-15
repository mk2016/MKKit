//
//  NSMutableURLRequest+MKAdd.m
//  MKKit
//
//  Created by xmk on 2017/4/13.
//  Copyright © 2017年 taoqicar. All rights reserved.
//

#import "NSMutableURLRequest+MKAdd.h"
#import "HappyDNS.h"

@implementation NSMutableURLRequest (MKAdd)

- (void)mk_switchToIp{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[QNResolver systemResolver]];
    if([QNDnsManager needHttpDns]){
        [array addObject:[[QNResolver alloc] initWithAddress:@"119.29.29.29"]];
    }else{
        [array addObject:[[QNResolver alloc] initWithAddress:@"8.8.8.8"]];
    }
    QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];;
    NSURL *oUrl = self.URL;
    NSURL *ipUrl = [dns queryAndReplaceWithIP:oUrl];
    if (ipUrl){
        self.URL = ipUrl;
        [self setValue:oUrl.host forHTTPHeaderField:@"host"];
    }
}

- (NSString *)mk_getIp{
    NSURLComponents *urlComponents = [[NSURLComponents alloc] initWithURL:self.URL resolvingAgainstBaseURL:YES];
    if (!urlComponents) {
        return nil;
    }
    NSString *host = urlComponents.host;
    
    NSMutableArray *array = [[NSMutableArray alloc] init];
    [array addObject:[QNResolver systemResolver]];
    if([QNDnsManager needHttpDns]){
        [array addObject:[[QNResolver alloc] initWithAddress:@"119.29.29.29"]];
    }else{
        [array addObject:[[QNResolver alloc] initWithAddress:@"8.8.8.8"]];
    }
    QNDnsManager *dns = [[QNDnsManager alloc] init:array networkInfo:[QNNetworkInfo normal]];
    NSArray *ips = [dns query:host];
    if (ips && ips.count) {
        return ips.firstObject;
    }
    return nil;
}
@end
