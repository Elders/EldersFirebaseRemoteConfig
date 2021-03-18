//
//  RemoteConfig+Update.m
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

#import "RemoteConfig+Update.h"
#import <objc/runtime.h>
#import <EldersFirebaseRemoteConfig/EldersFirebaseRemoteConfig-Swift.h>

@implementation FIRRemoteConfig (Update)

+ (NSNotificationName)didFetchNotification {
    
    return @"RemoteConfig.didFetchNotification";
}

+ (NSNotificationName)didActivateNotification {
    
    return @"RemoteConfig.didActivateNotification";
}

+ (void)load {
    
    Method oldFetch = class_getInstanceMethod([self class], @selector(fetchWithCompletionHandler:));
    Method newFetch = class_getInstanceMethod([self class], @selector(swizzled_fetchWithCompletionHandler:));
    method_exchangeImplementations(oldFetch, newFetch);
    
    Method oldActivate = class_getInstanceMethod([self class], @selector(activateWithCompletion:));
    Method newActivate = class_getInstanceMethod([self class], @selector(swizzled_activateWithCompletion:));
    method_exchangeImplementations(oldActivate, newActivate);
}

- (void)swizzled_fetchWithCompletionHandler:(void (^)(FIRRemoteConfigFetchStatus, NSError * _Nullable))completionHandler {
    
    [self swizzled_fetchWithCompletionHandler:^(FIRRemoteConfigFetchStatus status, NSError * _Nullable error) {
        
        if (completionHandler) {
        
            completionHandler(status, error);
        }
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        userInfo[@"status"] = @(status);
        userInfo[@"error"] = error;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] didFetchNotification] object:self userInfo:userInfo];
    }];
}

- (void)swizzled_activateWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    
    [self swizzled_activateWithCompletion:^(BOOL changed, NSError * _Nullable error) {
       
        if (completion) {
            
            completion(changed, error);
        }
        
        NSMutableDictionary *userInfo = [[NSMutableDictionary alloc] init];
        userInfo[@"changed"] = @(changed);
        userInfo[@"error"] = error;
        
        [[NSNotificationCenter defaultCenter] postNotificationName:[[self class] didActivateNotification] object:self userInfo:userInfo];
        
        if (@available(iOS 13.0, *)) {
            [self sendObjectWillChangeEvent];
        }
    }];
}

- (void)update {
    
    [self fetchAndActivateWithCompletionHandler:nil];
}

@end
