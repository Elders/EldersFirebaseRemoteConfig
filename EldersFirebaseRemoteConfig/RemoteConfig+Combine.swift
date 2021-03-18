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
