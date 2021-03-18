//
//  RemoteConfig+Update.h
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

@import Firebase;

NS_ASSUME_NONNULL_BEGIN

@interface FIRRemoteConfig (Update)

@property(class, readonly) NSNotificationName didFetchNotification;
@property(class, readonly) NSNotificationName didActivateNotification;

///Calls fetchAndActivate without a completion handler
- (void)update;

@end

NS_ASSUME_NONNULL_END
