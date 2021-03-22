//
//  RemoteConfig+Combine.swift
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

import Foundation
import FirebaseRemoteConfig

#if canImport(Combine)
import Combine
#else
protocol ObservableObject {}
#endif

@available(iOS 13.0, *)
extension RemoteConfig: ObservableObject {
    
    @available(iOS 13.0, *)
    @objc public func sendObjectWillChangeEvent() {
        
        DispatchQueue.main.async {
            
            #if canImport(Combine)
            self.objectWillChange.send()
            #endif
        }
    }
}

#if canImport(Combine)
@available(iOS 13.0, *)
extension RemoteConfig {

    ///Returns a `Publisher` that fetches Remote Config data.
    ///
    ///For more information see `RemoteConfig.fetch(completionHandler:)`
    public func fetchPublisher() -> Future<RemoteConfigFetchStatus, Error> {
        
        return Future { (promise) in
            
            self.fetch { (status, error) in
                
                if let error = error {
                    
                    promise(.failure(error))
                    return
                }
                
                promise(.success(status))
            }
        }
    }
    
    ///Returns a `Publisher` that fetches Remote Config data and sets a duration that specifies how long config data lasts.
    ///
    ///For more information see `RemoteConfig.fetch(withExpirationDuration:completionHandler:)`
    ///- parameter expirationDuration: Override the (default or optionally set minimumFetchInterval property) in FIRRemoteConfigSettings) minimumFetchInterval for only the current request, in seconds. Setting a value of 0 seconds will force a fetch to the backend.
    public func fetchPublisher(withExpirationDuration expirationDuration: TimeInterval) -> Future<RemoteConfigFetchStatus, Error> {
        
        return Future { (promise) in
            
            self.fetch(withExpirationDuration: expirationDuration) { (status, error) in
                
                if let error = error {
                    
                    promise(.failure(error))
                    return
                }
                
                promise(.success(status))
            }
        }
    }
    
    ///Returns a `Publisher` that applies Fetched Config data to the Active Config, causing updates to the behavior and appearance of the app to take effect (depending on how config data is used in the app).
    ///
    ///For more information see `RemoteConfig.activate(completion:)`
    public func activatePublisher() -> Future<Bool, Error> {
        
        return Future { (promise) in
            
            self.activate { (changed, error) in
             
                if let error = error {
                    
                    promise(.failure(error))
                    return
                }
                
                promise(.success(changed))
            }
        }
    }
    
    ///Returns a `Publisher` that fetches Remote Config data and if successful, activates fetched data.
    ///
    ///For more information see `RemoteConfig.fetchAndActivate(completionHandler:)`
    public func fetchAndActivatePublisher() -> Future<RemoteConfigFetchAndActivateStatus, Error> {
        
        return Future { (promise) in
            
            self.fetchAndActivate { (status, error) in
                
                if let error = error {
                    
                    promise(.failure(error))
                    return
                }
                
                promise(.success(status))
            }
        }
    }
}
#endif
