//
//  RemoteConfig+Update.h
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

@import FirebaseRemoteConfig;

NS_ASSUME_NONNULL_BEGIN

@interface FIRRemoteConfig (Update)

///A notification posted when an instance of `RemoteConfig` finish fetching. The notification contains the fetch `status` and an `error` if any.
@property(class, readonly) NSNotificationName didFetchNotification;

///A notification posted when an instance of `RemoteConfig` finish fetching. The notification contains the `changed` state and an `error` if any.
@property(class, readonly) NSNotificationName didActivateNotification;

///Calls fetchAndActivate without a completion handler
- (void)update;

@end

NS_ASSUME_NONNULL_END
