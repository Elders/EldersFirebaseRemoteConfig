//
//  RemoteConfig+Preview.swift
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

import Foundation
import FirebaseRemoteConfig

extension RemoteConfig {
    
    ///Creates a SwiftUI preview of the received that works with a given default values.
    ///- parameter defaults: A dictionary containing mapping of default values for keys.
    public class func preview(withDefaults defaults: [Key: NSObject]) -> RemoteConfig {
        
        return self.preview(withDefaults: defaults.map())
    }
}
