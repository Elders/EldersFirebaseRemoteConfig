//
//  RemoteConfig+Combine.swift
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

import Foundation
import Firebase

@available(iOS 13.0, *)
extension RemoteConfig: ObservableObject {
    
    @available(iOS 13.0, *)
    @objc public func sendObjectWillChangeEvent() {
        
        DispatchQueue.main.async {
            
            self.objectWillChange.send()
        }
    }
}
