//
//  RemoteConfig+Defaults.m
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

#import "RemoteConfig+Defaults.h"
#import <objc/runtime.h>
#import <EldersFirebaseRemoteConfig/EldersFirebaseRemoteConfig-Swift.h>

@implementation FIRRemoteConfig (Defaults)

+ (void)load {
    
    Method old = class_getInstanceMethod([self class], @selector(setDefaults:));
    Method new = class_getInstanceMethod([self class], @selector(swizzled_setDefaults:));
    method_exchangeImplementations(old, new);
}

- (void)swizzled_setDefaults:(nullable NSDictionary<NSString*, NSObject *>*)defaultConfig {
    
    //inject custom librabry defaults here
    NSMutableDictionary<NSString*, NSObject *> *defaults = [[[self class] eldersDefaults] mutableCopy];
    [defaults addEntriesFromDictionary:defaultConfig];

    [self swizzled_setDefaults:defaults];
}

@end
