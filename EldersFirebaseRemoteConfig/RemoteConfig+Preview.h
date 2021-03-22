//
//  RemoteConfig+Preview.h
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

@import FirebaseRemoteConfig;

NS_ASSUME_NONNULL_BEGIN

@interface FIRRemoteConfig (Preview)

///Creates a SwiftUI preview of the received that works with a given default values.
///@param defaults A dictionary containing mapping of default values for keys.
+ (FIRRemoteConfig*)previewWithDefaults:(NSDictionary<NSString*, NSObject*> *)defaults;

@end

NS_ASSUME_NONNULL_END
