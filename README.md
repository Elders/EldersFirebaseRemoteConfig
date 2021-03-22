#  EldersFirebaseRemoteConfig

[![Build Status](https://app.bitrise.io/app/726f7ba5e34d6569/status.svg?token=xI0FV7w4uC0r3jjpbWOYFw&branch=master)](https://app.bitrise.io/app/726f7ba5e34d6569)

This library provides the following convenience extensions to the firebase remote config library:

1. Strongly typed keys 
2. Posting notifications upon fetch and activate
3. Combine support
4. SwiftUI support
5. Predefined keys and values for required and recommended updates

## Installation

#### [Cocoapods](https://cocoapods.org)

Add `pod 'EldersFirebaseRemoteConfig'` to your  `Podfile`

## Usage

#### Strongly typed keys 

You can leverage from strongly typed keys by extending the RemoteConfig.Key structure.

```
extension RemoteConfig.Key {

    static let myCustomKey: Self = "myCustomKey"
}
```

Then  you can set defaults.

```
RemoteConfig.remoteConfig().setDefaults([.myCustomKey: "my amazing value"])
```

And get values by using the defined key.

```
let value = RemoteConfig.remoteConfig().configValue(for: .myCustomKey)
```

#### Notifications

The library swizzles the RemoteConfig object and posts notifications when calls to **fetch** and **activate** completes.
The following notifications are defined, so you can observe them.

- **`RemoteConfig.didFetchNotification`** - This notification is posted when a **fetch** call completes. It contains a userInfo with the following parameters:
	- **`status`** -  an `NSNumber` value of `FIRRemoteConfigFetchStatus`
        - **`error`** - an `Error` object, if the fetch has failed

- **`RemoteConfig.didActivateNotification`** - This notification is posted when an **activate** call completes. It contains a userInfo with the following parameters:
        - **`changed`** -  a `BOOL` value wrapped in `NSNumber` that is `YES` if there were changes to the remote config. Otherwise `NO`.
        - **`error`** - an `Error` object, if the fetch has failed

#### Combine Support

The library adds support for Combine Publishers by extending the `RemoteConfig` type with the following functions

- `fetchPublisher(withExpirationDuration:)` - corresponds to `fetch(withExpirationDuration:completionHandler:)`
- `fetchPublisher()` - corresponds to `fetch(completionHandler:)`
- `activatePublisher()` - corresponds to `activate(completion:)`
- `fetchAndActivatePublisher()` - corresponds to `fetchAndActivate(completionHandler:)`

#### SwiftUI support

The library makes `RemoteConfig` conforming to  `ObservableObject` protocol and publish changes upon fetch.
Now you can directly use `RemoteConfig` as `@ObservedObject` or as `@EnvironmentObject` in your SwiftUI project.

If you use  `RemoteConfig`  in your SwiftUI views, you can pass `RemoteConfig.preview(withDefaults:)` to your SwiftUI Previews. 
This works by moking the  `RemoteConfig`  behaviour and allows it to work with the supplied default arguments.

#### Predefined keys and values for required and recommended updates

The library defines a common structure and config access for requried and recommended updates. These are just an optional interface that you can leverage on to quickly implement a force update mechanism in your app.

-  `RemoteConfig.recommendedUpdate` - represents an update of the app that is recommended for install.
-  `RemoteConfig.requiredUpdate` - represents an update of the app that is required to install.

Both returns an instance of `ApplicationUpdate`. You can check whenever an update should be applied trough the `isApplicable` property.

This functionality basically compares your application version and delivers the defined updates from firebase remote config console.
It is wrapped around the convention that your app's `CFBundleVersion` is structured as `X.Y.Z.a` where:
- **X** is the major number
- **Y** is the minor number
- **Z** is the patch number
- **a** is the build number

**How to make use of it?**

Assuming your application's `CFBundleVersion` is `1.2.3.400`

Go to firebase console and define a new remote config with one of the following keys:

- **ios_required_update** - use this key if you wish to publish a required update
- **ios_recommended_update** - use this key if you wish to publish a recommended update

The predefined keys are variables so you can override them if you wish to.

Then put the following value for the desired key.

```
{
    "version": "1.2.3.500"
    "download": "https://your.appstore.link/"
}
```

The `download` is a URL from where the update should be download. This is typically the AppStore link of your production app.

The `version` is the target version based on which the update is reported to be applicable.
In this example, the build number `500` is greater than the application's build number `400`, so the update's `isApplicable` property will return `true`.

You can ommit the build number in the remote config.
For example if you supply `1.2.3`  - this will make `isApplicable` property will return `false`.
For example if you supply `1.2.4`  - this will make `isApplicable` property will return `true`.
