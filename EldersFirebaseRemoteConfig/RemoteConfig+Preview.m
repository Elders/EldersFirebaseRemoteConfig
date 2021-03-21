//
//  RemoteConfig+Preview.m
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

#import "RemoteConfig+Preview.h"
#import "RemoteConfig+Defaults.h"
#import <EldersFirebaseRemoteConfig/EldersFirebaseRemoteConfig-Swift.h>

@interface PreviewRemoteConfig : FIRRemoteConfig
@property(nonatomic, strong) NSDictionary<NSString*, NSObject*> *defaults;
@end

@implementation PreviewRemoteConfig

- (NSDictionary<NSString *,NSObject *> *)defaults {
    
    if (!_defaults) {
        
        _defaults = @{};
    }
    
    return _defaults;
}

- (FIRRemoteConfigValue *)configValueForKey:(NSString *)key {

    return [self defaultValueForKey:key];
}

- (FIRRemoteConfigValue *)configValueForKey:(NSString *)key source:(FIRRemoteConfigSource)source {

    return [self defaultValueForKey:key];
}

- (FIRRemoteConfigValue *)defaultValueForKey:(NSString *)key {
    
    NSObject *value = self.defaults[key];
    NSData *valueData;
    if ([value isKindOfClass:[NSData class]]) {
        
      valueData = (NSData *)value;
    }
    else if ([value isKindOfClass:[NSString class]]) {
        
      valueData = [(NSString *)value dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([value isKindOfClass:[NSNumber class]]) {
        
      NSString *strValue = [(NSNumber *)value stringValue];
      valueData = [(NSString *)strValue dataUsingEncoding:NSUTF8StringEncoding];
    }
    else if ([value isKindOfClass:[NSDate class]]) {
        
      NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
      [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
      NSString *strValue = [dateFormatter stringFromDate:(NSDate *)value];
      valueData = [(NSString *)strValue dataUsingEncoding:NSUTF8StringEncoding];
    }
    
    FIRRemoteConfigValue *v = [[FIRRemoteConfigValue alloc] init];
    [v setValue:valueData forKey:@"_data"];
    return v;
}

- (void)fetchWithCompletionHandler:(void (^)(FIRRemoteConfigFetchStatus, NSError * _Nullable))completionHandler {
    
    if (completionHandler) {
        
        completionHandler(FIRRemoteConfigFetchStatusSuccess, nil);
    }
}

- (void)fetchWithExpirationDuration:(NSTimeInterval)expirationDuration completionHandler:(void (^)(FIRRemoteConfigFetchStatus, NSError * _Nullable))completionHandler {
    
    if (completionHandler) {
        
        completionHandler(FIRRemoteConfigFetchStatusSuccess, nil);
    }
}

- (void)activateWithCompletion:(void (^)(BOOL, NSError * _Nullable))completion {
    
    if (completion) {
        
        completion(YES, nil);
    }
}

- (void)fetchAndActivateWithCompletionHandler:(void (^)(FIRRemoteConfigFetchAndActivateStatus, NSError * _Nullable))completionHandler {
    
    if (completionHandler) {
        
        completionHandler(FIRRemoteConfigFetchAndActivateStatusSuccessUsingPreFetchedData, nil);
    }
}

@end

@implementation FIRRemoteConfig (Preview)

+ (FIRRemoteConfig*)previewWithDefaults:(NSDictionary<NSString*, NSObject*> *)previewDefaults {
    
    PreviewRemoteConfig *remoteConfig = [[PreviewRemoteConfig alloc] init];
    NSMutableDictionary<NSString*, NSObject *> *defaults = [[self eldersDefaults] mutableCopy];
    [defaults addEntriesFromDictionary:previewDefaults];
    remoteConfig.defaults = defaults;
    return remoteConfig;
}

@end
