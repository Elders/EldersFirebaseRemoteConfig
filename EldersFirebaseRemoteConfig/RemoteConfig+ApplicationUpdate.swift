//
//  RemoteConfig+VAPT.swift
//  Pruvit
//
//  Created by Milen Halachev on 24.01.21.
//

import Foundation
import FirebaseRemoteConfig

extension RemoteConfig.Key {
    
    ///The key for a recommended update
    static var recommendedUpdate: Self = "ios_recommended_update"
    
    ///The key for a required update
    static var requiredUpdate: Self = "ios_required_update"
}

extension RemoteConfig {
    
    ///Returns the recommended update, if any.
    open var recommendedUpdate: ApplicationUpdate? {
        
        guard
        let jsonObject = self.configValue(for: .recommendedUpdate).jsonValue,
        let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
        let result = try? JSONDecoder().decode(ApplicationUpdate.self, from: data)
        else {
            
            return nil
        }
        
        return result
    }
    
    ///Returns the required update, if any.
    open var requiredUpdate: ApplicationUpdate? {
        
        guard
        let jsonObject = self.configValue(for: .requiredUpdate).jsonValue,
        let data = try? JSONSerialization.data(withJSONObject: jsonObject, options: []),
        let result = try? JSONDecoder().decode(ApplicationUpdate.self, from: data)
        else {
            
            return nil
        }
        
        return result
    }
}
