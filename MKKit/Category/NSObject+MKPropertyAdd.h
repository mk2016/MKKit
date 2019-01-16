//
//  NSObject+MKPropertyAdd.h
//  MKKit
//
//  Created by xiaomk on 2019/1/15.
//  Copyright © 2019 mk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (MKPropertyAdd)

- (void)mk_bindPropertyWithKey:(NSString *)aKey value:(id)aValue;
- (id)mk_propertyValueForKey:(NSString *)aKey;

- (void)mk_removePropertyWithKey:(NSString *)aKey;
- (void)mk_removeAllBindProperty;

- (void)mk_setTagObj:(id)aTagObj;
- (id)mk_tagObj;

@end
