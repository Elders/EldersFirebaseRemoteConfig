//
//  RemoteConfig+Preview.swift
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

import Foundation
import Firebase

extension RemoteConfig {
    
    public class func preview(withDefaults defaults: [Key: NSObject]) -> RemoteConfig {
        
        return self.preview(withDefaults: defaults.map())
    }
}
