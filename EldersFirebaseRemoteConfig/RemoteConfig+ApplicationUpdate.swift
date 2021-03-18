//
//  RemoteConfig+VAPT.swift
//  Pruvit
//
//  Created by Milen Halachev on 24.01.21.
//

import Foundation
import Firebase

extension RemoteConfig.Key {
    
    static let recommendedUpdate: Self = "ios_recommended_update"
    static let requiredUpdate: Self = "ios_required_update"
}

extension RemoteConfig {
    
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
