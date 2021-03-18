//
//  RemoteConfig+Preview.h
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface FIRRemoteConfig (Preview)

+ (FIRRemoteConfig*)previewWithDefaults:(NSDictionary<NSString*, NSObject*> *)defaults;

@end

NS_ASSUME_NONNULL_END
