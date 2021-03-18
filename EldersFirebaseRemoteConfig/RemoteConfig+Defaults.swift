//
//  RemoteConfig+Defaults.swift
//  EldersFirebaseRemoteConfig
//
//  Created by Milen Halachev on 18.03.21.
//

import Foundation
import FirebaseRemoteConfig

extension RemoteConfig {
    
    class func eldersDefaults() -> [Key: NSObject] {

        var eldersDefaults: [Key: NSObject] = [:]

        if ProcessInfo.processInfo.arguments.contains("UNIT_TESTS") {

            eldersDefaults["eldersDefaultsTestValue1"] = "da ve" as NSString
            eldersDefaults["eldersDefaultsTestValue2"] = NSNumber(7)
        }

        return eldersDefaults
    }
    
    @objc public class func eldersDefaults() -> [String: NSObject]  {
        
        let eldersDefaults: [Key: NSObject] = self.eldersDefaults()
        return eldersDefaults.map()
    }
}
